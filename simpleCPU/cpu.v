`timescale 1ns/10ps

// Instruction set (9b):
// LD  | V V V V V V V V 1 | R0 <- V
// MOV | A A A B B B 1 0 0 | A <- B
// CMP | A A A B B B 1 1 0 | CMP A and B
// JE  | 0 0 0 0 0 1 0 0 0 | PC <- R1, R0 if FE=1 (flag equals)
// JG  | 0 0 0 0 1 1 0 0 0 | PC <- R1, R0 if FG=1 (flag greater)
// JL  | 0 0 0 1 0 1 0 0 0 | PC <- R1, R0 if FL=1 (flag lower)
// JMP | 0 0 0 1 1 1 0 0 0 | PC <- R1, R0
// ADD | 0 0 1 0 0 1 0 0 0 | R0 <- R0 + R1
// AND | 0 0 1 0 1 1 0 0 0 | R0 <- R0 & R1
// OR  | 0 0 1 1 0 1 0 0 0 | R0 <- R0 | R1
// NOT | 0 0 1 1 1 1 0 0 0 | R0 <- ! R0
// XOR | 0 1 0 0 0 1 0 0 0 | R0 <- R0 ^ R1
// LDR | 0 1 0 0 1 1 0 0 0 | R0 <- RAM[R2, R1]
// STR | 0 1 0 1 0 1 0 0 0 | RAM[R2, R1] <- R0
// NOP | 0 1 0 1 1 1 0 0 0 | 

module cpu
	#(
	parameter g_ROM_WIDTH = 9,
	parameter g_ROM_ADDR = 11,
	parameter g_RAM_WIDTH = 9,
	parameter g_RAM_ADDR = 11
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

	// alias
	wire [8:0] w_instruction;

	// Registers
	reg [15:0] r_pc; // program counter
	reg [7:0] r_gpr[7:0]; // 8 general purpose registers
	reg r_FE = 1'b0;
	reg r_FG = 1'b0;
	reg r_FL = 1'b0;
	reg r_C = 1'b0;

	assign o_rom_addr = r_pc; //[g_ROM_ADDR-1:0]
	assign w_instruction = i_rom_data;

	// instruction decoder
	always @ (posedge i_clk or i_rst)
	begin
		if (i_rst == 1'b1)
		begin
			o_ram_en <= 1'b0;
			o_rom_en <= 1'b0;
		end
		else
		begin
			o_ram_en <= 1'b1;
			o_rom_en <= 1'b1;
			casex(w_instruction)
				9'bxxxxxxxx_1: // LD
				begin
					r_gpr[0] <= w_instruction[9:1];
				end
				9'bxxx_xxx_100: // MOV
				begin
					r_gpr[w_instruction[9:7]] <= r_gpr[w_instruction[6:4]];
				end
				9'bxxx_xxx_110: // CMP
				begin
					if (r_gpr[w_instruction[9:7]] == r_gpr[w_instruction[6:4]])
						r_FE <= 1'b1;
					else
						r_FE <= 1'b0;
					if (r_gpr[w_instruction[9:7]] > r_gpr[w_instruction[6:4]])
						r_FG <= 1'b1;
					else
						r_FG <= 1'b0;
					if (r_gpr[w_instruction[9:7]] < r_gpr[w_instruction[6:4]])
						r_FL <= 1'b1;
					else
						r_FL <= 1'b0;
				end
				9'b0000_0100_0: // JE
				begin
					if (r_FE == 1'b1)
						r_pc <= {r_gpr[1], r_gpr[0]};
				end
				9'b0000_1100_0: // JG
				begin
					if (r_FG == 1'b1)
						r_pc <= {r_gpr[1], r_gpr[0]};
				end
				9'b0001_0100_0: // JL
				begin
					if (r_FL == 1'b1)
						r_pc <= {r_gpr[1], r_gpr[0]};
				end
				9'b0001_1100_0: // JMP
				begin
					r_pc <= {r_gpr[1], r_gpr[0]};
				end
				9'b0010_0100_0: // ADD
				begin
					{r_C, r_gpr[0]} <= r_gpr[0] + r_gpr[1];
				end
				9'b0010_1100_0: // AND
				begin
					r_gpr[0] <= r_gpr[0] & r_gpr[1];
				end
				9'b0011_0100_0: // OR
				begin
					r_gpr[0] <= r_gpr[0] | r_gpr[1];
				end
				9'b0011_1100_0: // NOT
				begin
					r_gpr[0] <= ! r_gpr[0];
				end
				9'b0100_0100_0: // XOR
				begin
					r_gpr[0] <= r_gpr[0] ^ r_gpr[1];
				end
				9'b0100_1100_0: // LDR
				begin
				end
				9'b0101_0100_0: // STR
				begin
				end
				9'b0101_1100_0: // NOP
				begin
				end
				default:
				begin
				end
			endcase
			
		end
	end

endmodule
