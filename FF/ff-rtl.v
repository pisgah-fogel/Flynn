`timescale 1us/1ns

module ff
	(
	input wire [0:0] clk,
	input wire [0:0] d,
	output reg [0:0] q = 1'b0
	);

	always @ (posedge clk) q <= d;
	
endmodule // ff
