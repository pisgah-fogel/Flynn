#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "obj_dir/Vtop_wrapper.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define UNIT_TEST // Uncomment this line to run debugger's unit tests

#include "compiler.hpp"

static VerilatedVcdC* tfp;
static Vtop_wrapper* tb;
static unsigned long int ticks = 0;

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

#ifndef UNIT_TEST
int main (int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
	tb = new Vtop_wrapper;

    // Generate a trace
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("top_wrapper_synctrace.vcd");

    tb->i_clk = 0; // 1 bit
    // tb->o_led = 0; // 8 bits
    tb->i_btn = 0x01; // 5 bits - Reset ON
    tb->i_sw = 0; // 8 bits

    for (size_t i = 0; i < 100; i++)
        tick();
    
    tb->i_btn = tb->i_btn & 0xfe; // Reset OFF

    for (size_t i = 0; i < 100; i++)
        tick();

    delete(tfp);
    delete(tb);
    return 0;
}
#endif