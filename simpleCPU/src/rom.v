`timescale 1ns/10ps

module rom (
	clk,
	addr,
	DO, // data out
	EN, // enable
	);

parameter AddrSize = 11;
parameter WordSize = 9;

input clk;
input [AddrSize-1:0] addr;
output reg [WordSize-1:0] DO;
reg [WordSize-1:0] r_DO;
input EN;

reg [WordSize-1:0] Mem [0:(1<<AddrSize)-1];

always @ (posedge clk)
	r_DO <= DO;

always @ (posedge clk)
begin
	if (EN)
		DO <= Mem[addr];
	else
		DO <= {WordSize{1'bz}};
end

initial begin
	$display("Loading rom.");
	$readmemb("rom.mem", Mem);
end

endmodule
