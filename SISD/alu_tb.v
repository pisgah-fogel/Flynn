`include "alu.v"

`timescale 1us/1ns

module alu_tb;

	integer i, z = 0;

	parameter c_CLOCK_PERIOD_NS = 40; // 25MHz clock
	reg r_clk = 1'b0;

	reg [7:0] r_s1 = 8'h00;
	reg [7:0] r_s2 = 8'h00;
	reg r_en = 1'b0;
	reg [2:0] r_func = 3'b000;
	wire [7:0] w_result;
	wire w_zero;
	wire w_negative;
	wire w_overflow;

	task test_alu;
	begin
		$display("Complete ALU test...");
		for (i = 0; i< 255; i = i+1) begin
			for (z = 0; z< 255; z = z+1) begin
				r_s2 <= z;
				r_s1 <= i;
				#5;
				if (w_result != r_s2 + r_s1)
				begin
					$display("%m Error %d x %d != %d", r_s1, r_s2, w_result);
					$finish;
				end
				#5;
			end
		end
		$display("Success on ALU Test");
	end
	endtask

	alu uut
		(
		.i_s1(r_s1),
		.i_s2(r_s2),
		.i_en(r_en),
		.i_func(r_func),
		.o_result(w_result),
		.o_zero(w_zero),
		.o_negative(w_negative),
		.o_overflow(w_overflow)
		);

	always #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;
	
	initial begin
	$dumpfile("mydump.vcd");
	$dumpvars(0, uut);
	$display("Start simulation");
	r_func <= 3'b000;
	#10;
	test_alu();
	#10;
	$display("Finished");
	$finish;
	end

endmodule
