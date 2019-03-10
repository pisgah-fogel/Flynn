`timescale 1us/1ns

//Number of wires:                 13
//Number of wire bits:             65
//Number of public wires:          12
//Number of public wire bits:      56
//Number of memories:               0
//Number of memory bits:            0
//Number of processes:              0
//Number of cells:                 17
// SB_CARRY                        8
// SB_LUT4                         9

module alu_uadd
	(
	i_s1,
	i_s2,
	o_result,
	o_carry
	);
	parameter SIZE = 8;
	input wire [SIZE-1:0] i_s1;
	input wire [SIZE-1:0] i_s2;
	output wire [SIZE-1:0] o_result;
	output wire [0:0] o_carry;

	assign {o_carry, o_result} = i_s1 + i_s2;
endmodule

