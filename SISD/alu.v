/*
 * @file alu.v
 * @brief Arithmetic-logic unit
 */
`include "alu_uadd.v"
`timescale 1us/1ns

module alu
	#(parameter SLOW = 1'b0)
	(
	input wire [7:0] i_s1,
	input wire [7:0] i_s2,
	input wire [0:0] i_en,
	input wire [2:0] i_func,
	output wire [7:0] o_result,
	output [0:0] o_zero = 1'b0,
	output [0:0] o_negative = 1'b0,
	output  wire [0:0] o_overflow
	);
	
	alu_uadd #(.SIZE(8)) inst_uadd (
		.i_s1(i_s1),
		.i_s2(i_s2),
		.o_result(o_result),
		.o_carry(o_overflow)
		);


endmodule // alu
