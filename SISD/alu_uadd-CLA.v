`timescale 1us/1ns

//Number of wires:                 24
//Number of wire bits:             82
//Number of public wires:          14
//Number of public wire bits:      72
//Number of memories:               0
//Number of memory bits:            0
//Number of processes:              0
//Number of cells:                 19
// SB_LUT4                        19

module alu_uadd
  (
   input [SIZE-1:0] i_s1,
   input [SIZE-1:0] i_s2,
   output [SIZE-1:0]  o_result,
   output [0:0] o_carry
   );
  parameter integer SIZE = 8;
     
  wire [SIZE:1]     w_C;
  wire [SIZE-1:0]   w_G, w_P, w_SUM;
 
  genvar             ii;
  generate
	assign w_SUM[0] = i_s1[0] ^ i_s2[0];
	assign w_C[1] = i_s1[0] & i_s2[0];
    for (ii=1; ii<SIZE; ii=ii+1) 
      begin
			assign w_SUM[ii] = i_s1[ii] ^ i_s2[ii] ^ w_C[ii];
			assign w_C[ii+1] = ((i_s1[ii] ^ i_s2[ii]) & w_C[ii]) | (i_s1[ii] & i_s2[ii]);
      end
  endgenerate
 
  genvar             jj;
  generate
	assign w_G[0]   = i_s1[0] & i_s2[0];
	assign w_P[0]   = i_s1[0] | i_s2[0];
	assign w_C[1] = w_G[0];
    for (jj=1; jj<SIZE; jj=jj+1) 
      begin
        assign w_G[jj]   = i_s1[jj] & i_s2[jj];
        assign w_P[jj]   = i_s1[jj] | i_s2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign o_result = w_SUM;
  assign o_carry = w_C[SIZE];
 
endmodule
