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
}

int main (int argc, char **argv)
{
	printf("Work in progress\n");
	printf("Nothing to do\n");
	return 0;
}
