`include "top_wrapper.v"

`timescale 1ns/10ps

module top_wrapper_tb ();

	parameter c_CLOCK_PERIOD_NS = 100;

	reg r_clk = 0;
	wire [7:0] w_led;
	reg [4:0] r_btn = 5'b00001;
	reg [7:0] r_sw = 0;
	integer f, i;

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

		f = $fopen("log.txt","w");

		#1000;
		r_btn <= 5'b00000;
		$fwrite(f,"r0,r1,r2,r3,r4,r5,r6,r7,FE,FG,FL,C,PC\n");
		for (i = 0; i<2048; i=i+1) begin
			@(posedge r_clk);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r0);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r1);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r2);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r3);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r4);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r5);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r6);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.w_r7);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.r_FE);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.r_FG);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.r_FL);
			$fwrite(f,"%x,", WRAPPER_INST.CPU_INST.r_C);
			$fwrite(f,"%x\n", WRAPPER_INST.CPU_INST.r_pc);
		end
		#10000;

		$fclose(f);
		$finish;
	end

endmodule
