`timescale 1ns/10ps
 
`include "spi_master.v"
 
module spi_master_tb ();

  reg r_rst = 1;
 
  parameter c_CLOCK_PERIOD_NS = 20; // 50MHz
  reg r_clock = 0;
  always
    #(c_CLOCK_PERIOD_NS/2) r_clock <= !r_clock;

  wire w_spi_miso;
  reg r_spi_ss = 1'b1;
  reg r_spi_mosi = 1'b0;
  reg r_spi_clk = 1'b0;
  reg [c_SPI_SIZE-1:0] r_miso_data = 0;
  reg [c_SPI_SIZE-1:0] r_tx_data = 0
  wire [c_SPI_SIZE-1:0] w_rx_data = 0;

  parameter c_SPI_HALF_PERIOD = 1000; // 1MHz
  parameter c_delay = 7; // SPI doesn't have to be sync on r_clock
  parameter c_SPI_SIZE = 8; // number of bits
  task SPI_WRITE_BYTE;
    input wire [c_SPI_SIZE-1:0] i_tx_data;
    integer     ii;
    // output reg r_spi_ss;
    // output reg r_spi_mosi;
    // output reg r_spi_clk;
    begin
      #(c_delay);
      r_spi_clk <= 1'b0;
      r_spi_mosi <= 1'b0;
      r_spi_ss <= 1'b0;
      #(c_SPI_HALF_PERIOD);

      // send data
      for (ii=0; ii<c_SPI_SIZE; ii=ii+1)
      begin
        r_spi_mosi <= i_tx_data[ii];
        #(c_SPI_HALF_PERIOD);
        r_spi_clk <= 1'b1; // Slave is supposed to read now
        r_miso_data[ii] <= w_spi_miso;
        #(c_SPI_HALF_PERIOD);
        r_spi_clk <= 1'b0;
      end

      #(c_SPI_HALF_PERIOD);
      r_spi_ss <= 1'b1;
      $display("%0t SPI WRITE done W:0x%0h R:0x%0h", $time, i_tx_data, r_miso_data);
      #(c_SPI_HALF_PERIOD); // minimum between two transferts
     end
  endtask
   
   
  spi_slave #(.c_SPI_SIZE(c_SPI_SIZE)) SPI_SLAVE_INST
    (.i_clock(r_clock),
     .i_rst(r_rst),
     .i_spi_clk(r_spi_clk),
     .i_spi_ss(r_spi_ss),
     .i_spi_mosi(r_spi_mosi),
     .i_tx_data(r_tx_data),
     .o_spi_miso(w_spi_miso),
     .o_rx_data(w_rx_data)
     );

  initial
    begin
      r_rst = 1;

      #(200);
      r_rst = 0;
      r_tx_data = 8'h64;
      #(200);

      SPI_WRITE_BYTE(8'h3F);

      @(posedge r_clock);
      if (w_rx_data == 8'h3F)
        $display("RX Passed - Correct Byte Received");
      else
        $display("RX Failed - Incorrect Byte Received");
      if (r_tx_data == r_miso_data)
        $display("TX Passed - Correct Byte Received");
      else
        $display("TX Failed - Incorrect Byte Received");
      
      $finish;
    end
   
endmodule
