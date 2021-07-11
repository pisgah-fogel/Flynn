module button (
	input wire i_clk,
	input wire i_btn,
	output wire o_led
	);

	reg [24:0] r_counter;
	initial
		r_counter <= 0;

	assign o_led = !r_counter[24];

	always @(posedge i_clk) // or negedge i_btn
	begin
		if (i_btn == 1'b0)
			r_counter <= 0;
		else
			r_counter <= r_counter + 1;
	end
endmodule
