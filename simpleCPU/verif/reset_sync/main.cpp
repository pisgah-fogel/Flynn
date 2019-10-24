#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "obj_dir/Vreset_sync.h"
#include <verilated.h>
#include <verilated_vcd_c.h>


static unsigned long int ticks = 0;
static unsigned long int errors = 0;
static Vreset_sync *tb;
static VerilatedVcdC* tfp;

void tick() {
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

void log()
{
    printf("i_rst:%d, o_rst_1:%d, o_rst_2:%d\n", tb->i_rst, tb->o_rst_1, tb->o_rst_2);
}

/*
 * print a message if o_rst_1 or o_rst_2 are not as expected
 */
void must_be(unsigned int reset_1, unsigned int reset_2)
{
    tick();
    if (tb->o_rst_1 == reset_1 || tb->o_rst_2 == reset_2) {
        errors ++;
        printf("Error, resets should be %d and %d\n", reset_1, reset_2);
        log();
    }
}

void model(unsigned int* rst_1, unsigned int* rst_2, unsigned int rst)
{
	static unsigned int array[] = [0, 0];
	*rst_2 = *rst_1;
	if (*rst_1 == 0) {
		*rst_1 = array[0] & array[1] & rst;
	}
	else {
		*rst_1 = array[0] | array[1] | rst;
	}
	array[0] = rst;
	array[1] = array[0];
}

void simu_one_cycle(unsigned int rst)
{

	unsigned int expected_1, expected_2;
	tb->i_rst = rst;
	model(*expected_1, *expected_2, rst);
	tick();
	must_be(expected_1, expected_2);
}

/*
 * Check that reset_1 goes up only if the reset in longer that 2 clock cycle
 * Check that reset_2 is the same as reset_1 one clock cycle delayed
 * Reset_1 goes down is the input reset is down for more than 2 cycle
 */
int main (int argc, char **argv)
{
	Verilated::commandArgs(argc, argv);
	tb = new Vreset_sync;

	// Generate a trace
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("reset_synctrace.vcd");

	tb->i_clk = 0;
	simu_one_cycle(0);
	simu_one_cycle(0);
	simu_one_cycle(0);

	if (errors == 0) {
		printf("Test passed\n");
	} else {
		printf("Test failed\n");
	}

	return 0;
}
