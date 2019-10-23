#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "obj_dir/Vram.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define DURATION (100000)
#define CLK_PER_SEC (100000000) // 100MHz

static unsigned long int ticks = 0;
static unsigned long int last_log = 0;
static unsigned long int fails = 0;
static Vram *tb;
static VerilatedVcdC* tfp;

void tick() {
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

void log() {
	printf("%d: ", ticks);
	printf("(%.2fns) ", 1000000000*(ticks-last_log)/(float)CLK_PER_SEC);
	printf("addr = %d, ", tb->addr);
	printf("DO = %d, ", tb->DO);
	printf("DI = %d, ", tb->DI);
	printf("EN = %d, ", tb->EN);
	printf("WE = %d, ", tb->WE);
	printf("RE = %d\n", tb->RE);
	last_log = ticks;
}

/*
 * Random operations with the design not enabled
 * DO should always eguals 0
 */
void rand_test_disable() {
	fails = 0;
	tb->EN = 0;
	tb->WE = 0;
	tb->RE = 0;
	tb->DI = 0;
	tb->addr = 0;
	for (int i = 0; i<DURATION; i++) {
		tick();
		if (tb->DO != 0) {
			fails ++;
			printf("Error: The design is not enabled, it should not drive anything");
			log();
		}
		tb->WE = rand() & 1;
		if (rand()%100 > 49) {
			tb->RE = 0;
		} else {
			tb->RE = !tb->WE;
		}
		if (tb->WE == 1 && tb->RE == 1) {
			printf("VError: In the verification program, WE and RE should never be up in the same time");
			log();
		}
		tb->DI = rand();
		tb->addr = rand();
	}

	printf("Random test with disabled ram - ");
	if (fails == 0) {
		printf("Passed\n");
	} else {
		printf("%d Error(s)\n", fails);
	}
}

int main (int argc, char **argv)
{
	unsigned int seed;
#ifdef SEED
	seed = SEED;
#else
	seed = time(NULL);
#endif
	printf("seed = %d\n", seed);
	srand(seed);
	Verilated::commandArgs(argc, argv);

	tb = new Vram;

	// Generate a trace
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("ramtrace.vcd");

	rand_test_disable();
	return 0;
}
