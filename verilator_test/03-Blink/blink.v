`default_nettype none

module blink(i_clk, o_led);
	input wire i_clk;
	output wire o_led;

	parameter WIDTH = 27;
	reg [WIDTH-1:0] r_counter = 0;

	always @(posedge i_clk)
		r_counter <= r_counter + 1'b1;

	assign o_led = r_counter[WIDTH-1];
endmodule
