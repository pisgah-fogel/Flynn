/*
 * @file alu.v
 * @brief Arithmetic-logic unit
 */

`timescale 1us/1ns

module alu
	#(parameter SLOW = 1'b0)
	(
	input wire [7:0] i_s1,
	input wire [7:0] i_s2,
	input wire [0:0] i_en,
	input wire [2:0] i_func,
	output reg [7:0] o_result = 8'h0,
	output reg [0:0] o_zero = 1'b0,
	output reg [0:0] o_negative = 1'b0,
	output reg [0:0] o_overflow = 1'b0
	);


	integer ii = 0;
	reg [8:1] r_carry = 0;
function func_add;
	input wire [7:0] op1, op2;
begin
//	o_result <= op1[0] xor op2[0];
//	r_carry[1] <= op1[0] and op2[0];
//	for (ii = 1; ii < 7; ii = ii+1) begin
//		o_result <= op1[ii] xor op2[ii] xor r_carry[ii];
//		r_carry[ii+1] <= (op1[ii] and op2[ii]) or (r_carry[ii] and (op1[ii] xor op2[ii]));
//	end
end
endfunction

always @ (*)
case (i_func)
	3'b000: // ADD
		o_result <= i_s1 + i_s2;
	3'b001: // UADD
		o_result <= 8'hA;
	3'b010: // SUB
		o_result <= 8'hA;
	3'b011: // USUB
		o_result <= 8'hA;
	3'b100: // AND
		o_result <= 8'hA;
	3'b101: // OR
		o_result <= 8'hA;
	3'b110: // XOR
		o_result <= 8'hA;
	3'b111: // TODO
		o_result <= 8'h0;
endcase

endmodule // alu
