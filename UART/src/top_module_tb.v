`include "../src/top_module.v"

`timescale 1ns/10ps

module top_module_tb ();


  parameter c_CLOCK_PERIOD_NS = 50;
  parameter c_CLKS_PER_BIT    = 868;
  parameter c_BIT_PERIOD      = 43400;

  reg r_Clock = 0;
  reg r_Rx_Serial = 1;
  wire w_Tx_Serial;
  wire [7:0] w_led;
  reg [4:0] r_btn;
  reg [7:0] r_sw;

	// input w_Tx_Serial
	reg [7:0] r_tmp_rx = 0;
	reg r_rst_uartrx_n = 1'b0;
	parameter s_IDLE = 2'b00;
	parameter s_START = 2'b01;
	parameter s_DATA = 2'b11;
	parameter s_STOP = 2'b10;
	parameter CLOCK_FREQ = 100_000_000;
	parameter BAUD_RATE = 115_200;
	parameter SAMPLE_FULL_BIT = (CLOCK_FREQ / BAUD_RATE);
	parameter SAMPLE_HALF_BIT = (SAMPLE_FULL_BIT / 2);
	reg [2:0] r_uartrx_state = s_IDLE;
	integer uartrx_cnt = 0;
	integer data_cnt = 0;
	// UART_READ_BYTE
	always @ (posedge r_Clock or r_rst_uartrx_n)
	begin
		if (r_rst_uartrx_n==1'b0) begin // reset
			r_uartrx_state <= s_IDLE;
			uartrx_cnt <= 0;
		end else begin
			case (r_uartrx_state)
				s_IDLE:
				begin
					if (w_Tx_Serial==1'b0) begin // drove to 0 then start
						//$display("%t TB: UART start receive", $time);
						r_uartrx_state <= s_START;
						uartrx_cnt <= 0;
					end
				end
				s_START:
				begin
					if (uartrx_cnt == SAMPLE_HALF_BIT) begin
						uartrx_cnt <= 0;
						if (w_Tx_Serial==1'b0) begin
							//$display("%t TB: Start long enough Ok", $time);
							r_uartrx_state <= s_DATA;
						end else begin
							//$display("%t TB: Error Start bit too short", $time);
							r_uartrx_state <= s_IDLE;
						end
					end else begin
						uartrx_cnt <= uartrx_cnt + 1;
					end
				end
				s_DATA:
				begin
					if (uartrx_cnt == SAMPLE_FULL_BIT) begin
						uartrx_cnt <= 0;
						r_tmp_rx <= {w_Tx_Serial, r_tmp_rx[7:1]};
						if (data_cnt == 7) begin
							data_cnt <= 0;
							r_uartrx_state <= s_STOP;
						end else begin
							#1 data_cnt <= data_cnt + 1;
							//$display("TB: UART bit %d received", data_cnt);
						end
					end else begin
						#1 uartrx_cnt <= uartrx_cnt + 1;
					end
				end
				s_STOP:
				begin
					if (uartrx_cnt == SAMPLE_FULL_BIT) begin
						$display("TB: UART Received %d", r_tmp_rx);
						#1 uartrx_cnt <= 0;
						r_uartrx_state <= s_IDLE;
					end else begin
						#1 uartrx_cnt <= uartrx_cnt + 1;
					end
				end
				default:
				begin
					#1 r_uartrx_state <= s_IDLE;
				end
			endcase
		end // Not reset
	end

  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin
	$display("TB: UART Send => Data = %d", i_Data);
	// Send Start Bit
	#1 r_Rx_Serial <= 1'b0;
	#(c_BIT_PERIOD);
	#1000;
	// Send Data Byte
	for (ii=0; ii<8; ii=ii+1)
	begin
		#1 r_Rx_Serial <= i_Data[ii];
		#(c_BIT_PERIOD);
	end
	// Send Stop Bit
	#1 r_Rx_Serial <= 1'b1;
	#(c_BIT_PERIOD);
	end
  endtask // UART_WRITE_BYTE

	top_module #(.CLKS_PER_BIT(868)) UUT
	(
	 .clk(r_Clock),
	 .Led(w_led),
	 .btn(r_btn),
	 .Rx(r_Rx_Serial),
	 .Tx(w_Tx_Serial),
	 .sw(r_sw)
	);

  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

  initial
    begin
	$dumpfile("mydump.vcd");
	$dumpvars(0, UUT);
	$display("Start simulation");

	  r_btn = 5'b10010;
	  r_sw = 8'hAB;
	  r_rst_uartrx_n = 1'b1;

      // Tell UART to send a command (exercise Tx)
	  #9000000
	  r_btn[0] = 1'b1;
      @(posedge r_Clock);
      @(posedge r_Clock);
	  r_btn[0] = 1'b0;
       
      // Send a command to the UART (exercise Rx)
	  #9000000
      UART_WRITE_BYTE(8'h3F);
	  #9000000
             
	  $finish;
    end
endmodule
