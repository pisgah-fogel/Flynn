`timescale 1ns/10ps

module reset_sync
	(
	 input wire [0:0] i_clk,
	 input wire [0:0] i_rst,
	
	 // = 1b'0 if i_rst if 1b'0 at least 2
	 // i_clk periods
	 output reg [0:0] o_rst_1 = 1'b0,
	 // change 1 i_clk period after o_rst_1
	 output reg [0:0] o_rst_2 = 1'b0
	);

	// can be higher to debounce a button
	reg [1:0] r_rst = 2'b00;

	wire w_rst_1;
	reg r_rst_1 = 1'b0;
	
	always @ (posedge i_clk)
	begin
		r_rst[0] <= i_rst;
		r_rst[1] <= r_rst[0];
	end

	assign w_rst_1 = (o_rst_1 & (i_rst | r_rst[1] | r_rst[0])) | (i_rst & r_rst[0] & r_rst[1]);

	always @ (posedge i_clk)
	begin
		o_rst_1 <= w_rst_1;
		r_rst_1 <= o_rst_1;
		o_rst_2 <= r_rst_1;
	end

endmodule
