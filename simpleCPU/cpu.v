`timescale 1ns/10ps

module cpu
	#(
	parameter g_ROM_WIDTH = 11,
	parameter g_ROM_ADDR = 9,
	parameter g_RAM_WIDTH = 11,
	parameter g_RAM_ADDR = 9
	)
	(
	input i_clk,
	input i_rst,

	output reg o_rom_en,
	output wire [g_ROM_ADDR-1:0] o_rom_addr,
	input [g_ROM_WIDTH-1:0] i_rom_data,

	output reg o_ram_en,
	output reg o_ram_we,
	output reg o_ram_re,
	output reg [g_RAM_ADDR-1:0] o_ram_addr,
	output reg [g_RAM_WIDTH-1:0] o_ram_data,
	input [g_RAM_WIDTH-1:0] i_ram_data
	);

	// Registers
	reg [15:0] r_pc; // program counter
	reg [7:0] r_gpr[15:0]; // 16 general purpose registers

	reg [g_ROM_ADDR-1:0] r_rom_addr;

	assign o_rom_addr = r_rom_addr;

	always @ (posedge i_clk or i_rst)
	begin
		if (i_rst == 1'b1)
		begin
			r_rom_addr <= 0;
		end
		else
		begin
			r_rom_addr <= r_rom_addr + 1;
			o_ram_en <= 1'b1;
			o_rom_en <= 1'b1;
		end
	end

endmodule
