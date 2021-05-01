// This module drives a ST7735S based LCD display

module st7735s 
#(
    parameter c_CLOCK_PER_SPI_HALF_BIT = 100 // 100MHz => 1MHz SPI
)
(
    input wire i_nrst, // active low reset
    input wire i_clk, // default is 50MHz

    input wire i_ncommand, // 1 => display memory, 0 => command
    input wire [7:0] i_data, // data to be send
    input wire i_data_rdy, // i_data is fetch on the rising of i_data_rdy

    output wire o_waiting, // 1 => ready do send command

    output reg o_spi_clk = 0, // also called SCL
    output wire o_spi_mosi, // also called SDA
    output reg o_spi_dc = 0, // also called D/CX
    output wire o_spi_ss // also called CSX
);

parameter c_COUNTER_SIZE = $clog2(c_CLOCK_PER_SPI_HALF_BIT*2);

reg [c_COUNTER_SIZE-1:0] r_low_freq_counter = 0;

reg [3-1:0] r_bit_counter = 0; // 8 bits to send

reg [7:0] r_buffer = 0;

reg r_tx_en = 1'b0;

    // increase counter r_low_freq_counter when r_tx_en=1
    // r_low_freq_counter is used low frequency clock
    always @(posedge i_clk or negedge i_nrst)
    begin
        if (~i_nrst) // async reset
            r_low_freq_counter <= 0;
        else
        begin
            if (r_tx_en)
                r_low_freq_counter <= r_low_freq_counter + 1;
            else
                r_low_freq_counter <= 0;
        end
    end

    // count bits
    always @(posedge i_clk or negedge i_nrst)
    begin
        if (~i_nrst) // async reset
            r_bit_counter <= 0;
        else
        begin
            if (r_tx_en)
                if (r_low_freq_counter == c_CLOCK_PER_SPI_HALF_BIT*2-1) // TODO: is it c_CLOCK_PER_SPI_HALF_BIT*2 ?
                    r_bit_counter <= r_bit_counter + 1;
                else
                    r_bit_counter <= r_bit_counter;
            else
                r_bit_counter <= 0;
        end
    end

    // setting r_tx_en when i_data_rdy and until transmission's end
    always @(posedge i_clk or negedge i_nrst)
    begin
        if (~i_nrst) // async reset
            r_tx_en <= 0; // idle state
        else
        begin
            if (~r_tx_en)
                if (i_data_rdy)
                    r_tx_en <= 1; // start transmitting
                else
                    r_tx_en <= 0; // do nothing until i_data_rdy = 1
            else
                if (r_bit_counter == 8-1 & r_low_freq_counter == c_CLOCK_PER_SPI_HALF_BIT*2-1)
                    r_tx_en <= 0; // back to idle state
                else
                    r_tx_en <= 1; // continue until every bit is sent
        end
    end
    assign o_waiting = ~r_tx_en;
    assign o_spi_ss = ~r_tx_en; // We turn on slave select when we start transmitting

    // shifting register
    always @(posedge i_clk)
    begin
        if (i_data_rdy) // TODO: only on rising edge ?
            r_buffer <= i_data;
        else
            if (r_low_freq_counter == c_CLOCK_PER_SPI_HALF_BIT*2-1)
                r_buffer <= {r_buffer[6:0], 1'b0}; // MSB first
            else
                r_buffer <= r_buffer;
    end
    assign o_spi_mosi = r_buffer[7]; // MSB first

    // latch i_ncommand on i_data_rdy
    always @(posedge i_clk)
    begin
        if (i_data_rdy) // TODO: only on rising edge ?
            o_spi_dc <= i_ncommand;
        else
            o_spi_dc <= o_spi_dc;
    end

    // generate spi_clock
    always @(posedge i_clk or negedge i_nrst)
    begin
        if (~i_nrst) // async reset
            o_spi_clk <= 0;
        else
        begin
            if (r_low_freq_counter == c_CLOCK_PER_SPI_HALF_BIT | r_low_freq_counter == c_CLOCK_PER_SPI_HALF_BIT*2-1)
                o_spi_clk <= ~o_spi_clk;
            else
                o_spi_clk <= o_spi_clk;
        end
    end

endmodule