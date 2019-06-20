`timescale 1ns/10ps

module ram (
	addr,
	DO, // data out
	DI, // data in
	EN, // chip select (enable)
	WE, // write enable
	RE // read enable
	);

parameter AddrSize = 11;
parameter WordSize = 9;

input [AddrSize-1:0] addr;
output [WordSize-1:0] DO;
input [WordSize-1:0] DI;
input EN, WE, RE;

reg [WordSize-1:0] Mem [0:(1<<AddrSize)-1];

assign DO = (EN && RE) ? Mem[addr] : {WordSize{1'bz}};

initial begin
	$display("Loading rom.");
	$readmemb("ram.mem", Mem);
end

always @(EN or WE)
	if (EN && WE)
		Mem[addr] = DI;

always @(WE or RE)
	if (!WE && !RE)
		$display("Operational error in RamChip: RE and WE both active");

endmodule
