#include <stdio.h>
#include <stdlib.h>
#include "obj_dir/Vthruwire.h"
#include <verilated.h>

int main (int argc, char **argv)
{
	// main simulator driver:
	// Command Args
	Verilated::commandArgs(argc, argv);

	// Instantiate our design
	Vthruwire *tb = new Vthruwire;

	for (int k=0; k<20; k++) {
		// Toggle the switch
		tb->i_sw = k&1;
		tb->eval();

		printf("k = %2d, ", k);
		printf("sw = %d, ", tb->i_sw);
		printf("led = %d\n", tb->o_led);
	}

}
