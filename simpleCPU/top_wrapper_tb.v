`include "top_wrapper.v"

`timescale 1ns/10ps

module top_wrapper_tb ();

	parameter c_CLOCK_PERIOD_NS = 100;

	reg r_clk = 0;
	wire [7:0] w_led;
	reg [4:0] r_btn = 0;
	reg [7:0] r_sw = 0;

	always
	#(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;

	top_wrapper WRAPPER_INST
		(
		.i_clk(r_clk),
		.o_led(w_led),
		.i_btn(r_btn),
		//.i_rx(),
		//.o_tx(),
		.i_sw(r_sw)
		);

	initial
	begin
		$dumpfile("mydump.vcd");
		$dumpvars(0, WRAPPER_INST);
		$display("Start simulation");
		#1000;
		r_btn <= 5'b00001;
		#10000;
		$finish;
	end

endmodule
