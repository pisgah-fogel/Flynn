// This testbench emulate a ST7735S based LCD display

`timescale 1ns/10ps
 
`include "st7735s.v"

module st7735s_tb ();

parameter c_CLOCK_PERIOD_NS = 20; // 50MHz
parameter c_CLOCK_PER_SPI_HALF_BIT = 50; // 50MHz => 1MHz SPI

reg r_clk = 1'b0;
reg r_nrst = 1'b0;
reg r_ncommand = 1'b0;
reg [7:0] r_data = 8'h00;
reg r_data_rdy = 1'b0;

wire w_waiting;
wire w_spi_clk;
wire w_spi_mosi;
wire w_spi_dc;
wire w_spi_ss;

reg v_dc = 1'b0;
reg [7:0] v_mosi = 0;
integer ii;

// generate clock
always
    #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;

st7735s 
    #(
        .c_CLOCK_PER_SPI_HALF_BIT(c_CLOCK_PER_SPI_HALF_BIT)
    )
    ST7735S_INST
    (
        .i_clk(r_clk),
        .i_nrst(r_nrst),
        .i_ncommand(r_ncommand),
        .i_data(r_data),
        .i_data_rdy(r_data_rdy),
        .o_waiting(w_waiting),
        .o_spi_clk(w_spi_clk),
        .o_spi_mosi(w_spi_mosi),
        .o_spi_dc(w_spi_dc),
        .o_spi_ss(w_spi_ss)
     );

     // SPI slave
     always
     begin
        @(~w_spi_ss);
        @(posedge w_spi_clk);
        v_dc <= w_spi_dc;
        v_mosi[7] <= w_spi_mosi;
        for (ii=6; ii>=0; ii=ii-1)
        begin
            @(posedge w_spi_clk);
            v_mosi[ii] <= w_spi_mosi;
        end

        #1;
        if (v_dc == 1'b0)
            $display("\n%0t Command 0x%0h", $time, v_mosi);
        else
            $display("%0t Argument 0x%0h", $time, v_mosi);
     end

    // main test sequence
    initial
    begin
        $dumpfile("testbench.vcd");
        $dumpvars;
        r_nrst <= 0;

        #(200);
        r_nrst <= 1;
        #(10000);

        // Send command sequence
        @(posedge r_clk);
        r_ncommand <= 1'b0;
        r_data <= 8'h95;
        r_data_rdy <= 1'b1;
        @(posedge r_clk);
        r_data_rdy <= 1'b0;
        
        // Either just wait for transmission to finish and check the VCD
        @(posedge w_waiting);

        #(10000);
        $display("Simulation finished");
        $finish;
    end
endmodule