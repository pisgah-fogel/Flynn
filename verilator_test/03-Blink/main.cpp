#include <stdio.h>
#include <stdlib.h>
#include "obj_dir/Vblink.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define DURATION (100000)
#define CLK_PER_SEC (1000000)

#define ACTIVATE_LOGGING 0
#define LOG (1000)

static unsigned long int ticks = 0;
static unsigned long int last_log = 0;

void tick(Vblink *tb, VerilatedVcdC *tfp) {
	tb->eval();
	if (tfp)
		tfp->dump(ticks);
	ticks ++;
	tb->i_clk = 0;
	tb->eval();
	if (tfp) {
		tfp->dump(ticks);
		tfp->flush();
	}
	ticks ++;
	tb->i_clk = 1;
	tb->eval(); // return on rising edge
}

int main (int argc, char **argv)
{
	int last_led = 0;
	Verilated::commandArgs(argc, argv);

	Vblink *tb = new Vblink;

	// Generate a trace
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("blinktrace.vcd");

	while (ticks<DURATION) {

		tick(tb, tfp);
#if ACTIVATE_LOGGING
		if ((ticks % LOG == 0) || (last_led != tb->o_led)) {
			last_led = tb->o_led;
			printf("%10d: ", ticks);
			printf("k = %7d, ", k);
			printf("led = %d\n", tb->o_led);
		}
#else
		if (last_led != tb->o_led) {
			last_led = tb->o_led;
			printf("%10d: ", ticks);
			printf("(%.2fms) ", 1000*(ticks-last_log)/(float)CLK_PER_SEC);
			printf("counter = %7d, ", tb->blink__DOT__r_counter);
			printf("led = %d\n", tb->o_led);
			last_log = ticks;
		}
#endif
	}
}
