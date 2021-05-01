#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "obj_dir/Vtop_module.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define TICKS_PER_SEC 100000000 // 100MHz clocks

static unsigned long int ticks = 0;
static unsigned long int errors = 0;
static Vtop_module *tb;
static VerilatedVcdC* tfp;


static bool uart_read_is_recv = false;
static unsigned long int uart_read_count= 0;
static unsigned long int uart_read_bit= 0;
static unsigned int uart_read_data= 0;

void uart_read() {
	const unsigned long int clock_freq = 100000000; // 100MHz
	const unsigned long int baud_rate = 115200;
	const unsigned long int bit_period_cycles = 2*clock_freq/baud_rate; // 868
	const unsigned long int half_period_cycles = bit_period_cycles/2; // 434

	if (!uart_read_is_recv) {
		if (tb->Tx == 0 && ticks > 1) {
			uart_read_is_recv = true;
			uart_read_count = 1;
			uart_read_data = 0;
			uart_read_bit = 0;
			printf("UART: Start bit received (tick %ld)\n", ticks);
		}
	} else {
		uart_read_count++;
		if (uart_read_count == bit_period_cycles) {
			uart_read_count = 0;
			uart_read_bit++;
			if (uart_read_bit == 1 + 8 + 1) { // One start bit, 8 data, 1 stop
				printf("UART: End of reception (%ld), data=0x%x\n", ticks, uart_read_data);
				uart_read_is_recv = false;
				if (uart_read_data&0xff != tb->sw&0xff) {
					printf("UART: Error, Switches are 0x%x, UART should receive the same\n", tb->sw&0xff);
					errors++;
				}
				else {
					printf("UART: Switches OK 0x%x\n", tb->sw&0xff);
				}
			}
		} else if (uart_read_bit == 0 && uart_read_count == half_period_cycles) {
			if (tb->Tx != 0) {
				printf("UART: Error tick %ld : Start bit should be 0 (Tx: %d)\n", ticks, tb->Tx);
				errors++;
				uart_read_is_recv = false;
			} else {
				printf("UART: Tick %ld : Start bit OK( Tx: %d)\n", ticks, tb->Tx);
			}
		} else if (uart_read_bit == 9 && uart_read_count == half_period_cycles) {
			if (tb->Tx != 1) {
				printf("UART: Error tick %ld : Stop bit should be 1 (Tx: %d)\n", ticks, tb->Tx);
				errors++;
			} else {
				printf("UART: Tick %ld : Stop bit OK( Tx: %d)\n", ticks, tb->Tx);
			}
		} else if (uart_read_count == half_period_cycles) {
			uart_read_data = uart_read_data>>1;
			uart_read_data += tb->Tx<<7;
			printf("- %d\n", tb->Tx);
		}
	}
}

void wait_cycle(unsigned int nb) {
	unsigned int i;
	for(i=0; i<nb; i++) {
		tb->eval();
		uart_read();
		if (tfp)
			tfp->dump(ticks);
		ticks ++;
		tb->clk = 0;
		tb->eval();
		uart_read();
		if (tfp) {
			tfp->dump(ticks);
			tfp->flush();
		}
		tb->clk = 1;
		tb->eval(); // return on rising edge
	}
}

void wait_ms(unsigned int nb) {
	wait_cycle(nb*TICKS_PER_SEC/1000);
}

void uart_write(const unsigned int data) {
	const unsigned int clock_freq = 100000000; // 100MHz
	const unsigned int baud_rate = 115200;
	const unsigned int bit_period_cycles = clock_freq/baud_rate;

	unsigned int buffer = data;

	printf("UART: write 0x%x\n", data);

	// Start bit
	tb->Rx = 0;
	wait_cycle(bit_period_cycles);

	// Send data
	for (size_t i=0; i<8; i++) {
		tb->Rx = buffer & 0x0001;
		printf("-: %d\n", buffer & 0x0001);
		buffer = buffer >> 1;
		wait_cycle(bit_period_cycles);
	}
	
	tb->Rx = 1;
	wait_cycle(bit_period_cycles);
}

int main (int argc, char **argv)
{
	Verilated::commandArgs(argc, argv);
	tb = new Vtop_module;

	// Generated a trace
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("top_moduletrace.vcd");

	printf("Initialize outputs\n");
	tb->clk = 0;
	tb->btn = 0b00001111 & 0;
	tb->Rx = 1;
	tb->sw = 0xff & 0x46;

	printf("Wait 1 ms\n");
	wait_ms(1);

	unsigned int data_to_send = 0x46;
	uart_write(data_to_send);

	if (tb->Led&0x0f != data_to_send&0x0f) {
		printf("LED[0:3]: Error: Should be 0x%x, not 0x%x\n", data_to_send&0x0f, tb->Led&0x0f);
		errors++;
	} else {
		printf("LED[0:3]: OK 0x%x\n", tb->Led&0x0f);
	}

	printf("Wait 1 ms\n");
	wait_ms(1);

	printf("Push button 0\n");
	tb->btn = 0b00001111 & 1; // Push button 0: start receiving SW
	wait_cycle(200);

	printf("Release button 0\n");
	tb->btn = 0b00001111 & 0; // Release button 0
	wait_ms(1);

	printf("Ticks %ld\n", ticks);
	printf("Errors %ld\n", errors);
	return 0;
}
