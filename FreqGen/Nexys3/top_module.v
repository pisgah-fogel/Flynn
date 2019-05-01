`timescale 1ns/10ps

module top_module
	(
	 clk,
	 Led,
	 btn,
	 Rx,
	 Tx,
	 sw
	);

	 input wire [0:0] clk;
	 output wire [7:0] Led;
	 input wire [4:0] btn;
	 input wire [0:0] Rx;
	 output wire [0:0] Tx;
	 input wire [7:0] sw;
	
	
	parameter g_MAX_COUNT = 10; // 10 MHz
	parameter g_MAX_COUNT_LED = 50_000_000;

	reg [31:0] r_count = 0;
	reg [31:0] r_count_led = 0;
	reg r_tx = 1'b0;
	reg r_led = 1'b0;

	assign Tx = r_tx & r_led;
	assign Led[0] = r_led;
	assign Led[1] = r_led;
	assign Led[2] = r_led;
	assign Led[3] = r_led;
	assign Led[4] = r_led;
	assign Led[5] = r_led;
	assign Led[6] = r_led;
	assign Led[7] = r_led;

	always @(posedge clk)
	begin
		if (r_count > g_MAX_COUNT)
		begin
			r_tx <= !r_tx;
			r_count <= 0;
		end
		else
			r_count <= r_count+1;
	end

	always @(posedge clk)
	begin
		if (r_count_led > g_MAX_COUNT_LED)
		begin
			r_led <= !r_led;
			r_count_led <= 0;
		end
		else
			r_count_led <= r_count_led+1;
	end

endmodule // top_module
