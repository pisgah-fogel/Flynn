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
	tb->Rx = 0;
	tb->sw = 0b01111111 & 0;

	printf("Wait 1 ms\n");
	wait_ms(1);

	printf("Ticks %ld\n", ticks);
	printf("Errors %ld\n", errors);
	return 0;
}
