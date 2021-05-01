`include "ff-rtl.v"

`timescale 1us/1ns

`ifndef SYNTHESIS

module alu_tb;

	reg r_clk = 1'b0;

	reg d = 1'b0;
	wire q;

	ff uut (
		.d(d),
		.q(q),
		.clk(r_clk)
		);
	
	initial begin
	$dumpfile("mydump.vcd");
	$dumpvars(0, uut);
	$display("Start simulation");
	r_clk = 1'b0;
	d = 1'b0;
	#3;
	d = 1'b1;
	#3;
	r_clk = 1'b1;
	#3;
	r_clk = 1'b0;
	#3;
	d = 1'b0;
	#3;
	r_clk = 1'b1;
	#3;
	r_clk = 1'b0;
	#3;
	r_clk = 1'b1;
	#3;
	r_clk = 1'b0;
	#3;
	$display("Finished");
	$finish;
	end

endmodule
`endif
