`timescale 1ns/10ps

module rom (
	addr,
	DO, // data out
	EN, // enable
	);

parameter AddrSize = 11;
parameter WordSize = 9;

input [AddrSize-1:0] addr;
output [WordSize-1:0] DO;
input EN;

reg [WordSize-1:0] Mem [0:(1<<AddrSize)-1];

assign DO = (EN) ? Mem[addr] : {WordSize{1'bz}};

initial begin
	$display("Loading rom.");
	$readmemb("rom.mem", Mem);
end

endmodule
