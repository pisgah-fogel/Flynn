`timescale 1us/1ns

//Number of wires:                 22
//Number of wire bits:             80
//Number of public wires:          14
//Number of public wire bits:      72
//Number of memories:               0
//Number of memory bits:            0
//Number of processes:              0
//Number of cells:                 17
// SB_LUT4                        17

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

	reg [SIZE:1] r_carry = 0;
	reg [SIZE-1:0] r_result = 0;

	assign o_carry = r_carry[SIZE];
	//assign o_carry = r_carry[SIZE] != r_carry[SIZE-1];
	assign o_result = r_result;

	integer ii;
	always @ (*)
	begin
		r_result[0] = i_s1[0] ^ i_s2[0];
		r_carry[1] = i_s1[0] & i_s2[0];
		for (ii=1; ii<SIZE; ii = ii+1) begin
			r_result[ii] = i_s1[ii] ^ i_s2[ii] ^ r_carry[ii];
			r_carry[ii+1] = (i_s1[ii] & i_s2[ii]) | (r_carry[ii] & (i_s1[ii] ^ i_s2[ii]));
		end
	end
endmodule

