#include <stdio.h>
#include <stdlib.h>
#include "obj_dir/Vblink.h"
#include <verilated.h>

#define DURATION (2000000)
#define CLK_PER_SEC (2000000)

#define ACTIVATE_LOGGING 0
#define LOG (1000)

static unsigned long int ticks = 0;
static unsigned long int last_log = 0;

void tick(Vblink *tb) {
	tb->eval();
	tb->i_clk = 0;
	tb->eval();
	ticks ++;
	tb->i_clk = 1;
	tb->eval(); // return on rising edge
}

int main (int argc, char **argv)
{
	int last_led = 0;
	Verilated::commandArgs(argc, argv);

	Vblink *tb = new Vblink;

	for (int k=0; k<DURATION; k++) {

		tick(tb);
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
			printf("(%.2fms)", 1000*(ticks-last_log)/(float)CLK_PER_SEC);
			printf("k = %7d, ", k);
			printf("led = %d\n", tb->o_led);
			last_log = ticks;
		}
#endif
	}
}
