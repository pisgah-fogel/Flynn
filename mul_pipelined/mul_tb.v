timescale 1ns/1ps

module mult_piped_8x8_2sC_tb;

  reg clock, reset; // reset = active HIGH
  reg [7:0] a_in, b_in;
  wire [15:0] y_out;

  // stimulus

  // response checking

  // DUT
  mult_piped_8x8_2sC DUT (a_in, b_in, clock, reset, y_out);

endmodule
