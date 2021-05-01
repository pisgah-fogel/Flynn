`timescale 1ns/10ps

module ram (
	clk,
	addr,
	DO, // data out
	DI, // data in
	EN, // chip select (enable)
	WE, // write enable
	RE // read enable
	);

parameter AddrSize = 11;
parameter WordSize = 9;

input wire clk;
input wire [AddrSize-1:0] addr;
output reg [WordSize-1:0] DO;
input wire [WordSize-1:0] DI;
input wire EN, WE, RE;

reg [WordSize-1:0] Mem [0:(1<<AddrSize)-1];

always @ (posedge clk)
begin
	if (EN && RE)
		DO <= Mem[addr];
	else
		DO <= {WordSize{1'bx}};
end

initial begin
	$display("Loading ram.");
	$readmemb("ram.mem", Mem);
end

always @ (posedge clk)
	if (EN && WE)
		Mem[addr] <= DI;

always @(WE or RE)
	if (WE && RE)
		$display("Operational error in RamChip: RE and WE both active");
endmodule
