`timescale 1ns/10ps

module test_module
	(
		in,
		out
	);
	
	input wire [3:0] in;
	output wire [3:0] out;

	assign out = in;

endmodule // test_module
