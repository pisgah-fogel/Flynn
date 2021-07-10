module button (
	input i_clk,
	input i_btn,
	output reg o_led
	);
	always @(posedge i_clk)
	begin
		o_led <= i_btn;
	end
endmodule
