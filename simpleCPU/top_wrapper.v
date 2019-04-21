`include "cpu.v"
`include "ram.v"
`include "rom.v"

`timescale 1ns/10ps

module top_wrapper
	(
	 input wire [0:0] i_clk,
	 output wire [7:0] o_led,
	 input wire [4:0] i_btn,
	 //input wire [0:0] i_rx,
	 //output wire [0:0] o_tx,
	 input wire [7:0] i_sw
	);
	
	wire w_rom_en;
	wire [10:0] w_rom_addr;
	wire [8:0] w_rom_data;
	wire w_ram_en;
	wire w_ram_we;
	wire w_ram_re;
	wire [10:0] w_ram_addr;
	wire [8:0] w_ram_data_o;
	wire [8:0] w_ram_data_i;

	reg [7:0] r_led = 8'b10011001;

	assign o_led = r_led;

	cpu #(
		.g_ROM_WIDTH(9),
		.g_ROM_ADDR(11),
		.g_RAM_WIDTH(9),
		.g_RAM_ADDR(11)
		)
		CPU_INST
		(
		.i_clk(i_clk),
		.i_rst(i_btn[0]),
		.o_rom_en(w_rom_en),
		.o_rom_addr(w_rom_addr),
		.i_rom_data(w_rom_data),
		.o_ram_en(w_ram_en),
		.o_ram_we(w_ram_we),
		.o_ram_re(w_ram_re),
		.o_ram_addr(w_ram_addr),
		.o_ram_data(w_ram_data_o),
		.i_ram_data(w_ram_data_i)
		);

	rom #(
		.AddrSize(11),
		.WordSize(9)
		)
		ROM_INST
		(
		.clk(i_clk),
		.addr(w_rom_addr),
		.DO(w_rom_data),
		.EN(w_rom_en)
		);

	ram #(
		.AddrSize(11),
		.WordSize(9)
		)
		RAM_INST
		(
		.clk(i_clk),
		.addr(w_ram_addr),
		.DO(w_ram_data_i),
		.DI(w_ram_data_o),
		.EN(w_ram_en),
		.WE(w_ram_we),
		.RE(w_ram_re)
		);

endmodule
