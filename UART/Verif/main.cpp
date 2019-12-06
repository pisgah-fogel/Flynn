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

void wait_cycle(unsigned int nb) {
	unsigned int i;
	for(i=0; i<nb; i++) {
		tb->eval();
		if (tfp)
			tfp->dump(ticks);
		ticks ++;
		tb->clk = 0;
		tb->eval();
		if (tfp) {
			tfp->dump(ticks);
			tfp->flush();
		}
		ticks ++;
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

	printf("UART: write %d\n", data);

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
	tb->sw = 0b01111111 & 0;

	printf("Wait 1 ms\n");
	wait_ms(1);

	uart_write(0x42);

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
