`include "UART-nandland.v"

`timescale 1ns/10ps

module top_module
	(
	 clk,
	 Led,
	 btn,
	 Rx,
	 Tx,
	 sw
	);

	 input wire [0:0] clk;
	 output wire [7:0] Led;
	 input wire [4:0] btn;
	 input wire [0:0] Rx;
	 output wire [0:0] Tx;
	 input wire [7:0] sw;
	
	
	// Tx interaction
	reg r_Tx_DV = 1'b0;
	wire [7:0] w_Tx_Byte;
	wire w_Tx_Active;
	wire w_Tx_Serial;
	wire w_Tx_Done;

	// Rx interaction
	wire w_Rx_Serial;
	wire w_Rx_DV;
	wire [7:0] w_Rx_Byte;

	parameter CLKS_PER_BIT = 868;
	parameter s_IDLE = 2'b00;
	parameter s_A = 2'b01;
	parameter s_B = 2'b10;
	parameter s_C = 2'b11;

	reg [2:0] r_state = s_IDLE;
	reg [3:0] int_led = 4'b0000;

	reg [25:0] r_count = 0;

  uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(clk),
     .i_Rx_Serial(w_Rx_Serial),
     .o_Rx_DV(w_Rx_DV),
     .o_Rx_Byte(w_Rx_Byte)
     );
   
  uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST
    (.i_Clock(clk),
     .i_Tx_DV(r_Tx_DV),
     .i_Tx_Byte(w_Tx_Byte),
     .o_Tx_Active(w_Tx_Active),
     .o_Tx_Serial(w_Tx_Serial),
     .o_Tx_Done(w_Tx_Done)
     );

	always @(posedge clk)
	begin
		if (r_count > 50_000_000)
		begin
			int_led[3] <= !int_led[3];
			r_count <= 0;
		end
		else
			r_count <= r_count+1;
	end

	always @(posedge clk)
	begin

		if (w_Rx_DV == 1'b1)
			int_led[1] <= !int_led[1];

		int_led[2] <= 1'b0;
		case (r_state)
			s_IDLE:
			begin
				int_led[2] <= 1'b1;
				r_Tx_DV <= 1'b0;
				if (btn[0]==1'b1)
					r_state <= s_A;
				else
					r_state <= s_IDLE;
			end
			s_A:
			begin
				r_Tx_DV <= 1'b1;
				r_state <= s_IDLE;
				int_led[0] <= !int_led[0];
			end
			s_B:
			begin
				r_Tx_DV <= 1'b0;
				r_state <= s_IDLE;
			end
			s_C:
			begin
				r_Tx_DV <= 1'b0;
				r_state <= s_IDLE;
			end
			default:
			begin
				r_Tx_DV <= 1'b0;
				r_state <= s_IDLE;
			end
		endcase
	end	

	assign w_Tx_Byte = sw;
	assign Led[4] = int_led[2];
	assign Led[5] = int_led[3];
	assign Led[6] = int_led[0];
	assign Led[7] = int_led[1];
	assign Led[3:0] = w_Rx_Byte[3:0];
	assign w_Rx_Serial = Rx;
	assign Tx = w_Tx_Serial;

endmodule // top_module
