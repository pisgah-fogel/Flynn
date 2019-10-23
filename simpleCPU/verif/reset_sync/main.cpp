#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "obj_dir/Vreset_sync.h"
#include <verilated.h>
#include <verilated_vcd_c.h>


static unsigned long int ticks = 0;
static unsigned long int errors = 0;
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

void log()
{
    printf("i_rst:%d, o_rst_1:%d, o_rst_2:%d\n", tb->i_rst, tb->o_rst_1, tb->o_rst_2);
}

void must_be_down()
{
    tick();
    if (tb->o_rst_1 == 1 || tb->o_rst_2 == 1) {
        errors ++;
        printf("Error, resets should be down");
        log();
    }
}

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
    tb->i_rst = 0;
    must_be_down();
    tb->i_rst = 1;
    must_be_down();
    tb->i_rst = 0;
    must_be_down();
    tb->i_rst = 1;
    must_be_down();
    tick();
    if (tb->o_rst_1 == 0 || tb->o_rst_2 == 1) {
        errors ++;
        printf("Error, o_rst_1 should be up and o_rst_2 should be down");
        log();
    }
    tick();
    if (tb->o_rst_1 == 0 || tb->o_rst_2 == 0) {
        errors ++;
        printf("Error, resets should be up");
        log();
    }

    if (errors == 0) {
        printf("Test passed");
    } else {
        printf("Test failed");
    }

    return 0;
}