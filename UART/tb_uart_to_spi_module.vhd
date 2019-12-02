
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.std_logic_textio.all;

library std;
use     std.textio.all;


use     work.uart_pkg.all;

use     work.util_pkg.all;
 
-- ------------------------------------------------------------------------------------------
-- Entity 
-- ------------------------------------------------------------------------------------------
entity tb_uart_handler is
end    tb_uart_handler;

-- ------------------------------------------------------------------------------------------
-- Architecture 
-- ------------------------------------------------------------------------------------------
architecture rtl of tb_uart_handler is

-- ------------------------------------------------------------------------------------------
-- Constant Declarations
-- ------------------------------------------------------------------------------------------
constant SIM                  : boolean := false;
constant CLOCK_FREQ           : integer := 100_000_000;
constant CLOCK_PERIOD         : time := (1.0/real(CLOCK_FREQ))* 1 sec; 
constant BAUD_RATE            : integer := 115200;
constant BIT_PERIOD           : time := (1.0/real(BAUD_RATE))* 1 sec;

-- CLOCK_PERIOD/BAUD_RATE
constant SAMPLE_FULL_BIT      : integer := (CLOCK_FREQ / BAUD_RATE);
constant SAMPLE_HALF_BIT      : integer := (SAMPLE_FULL_BIT / 2);

-- ------------------------------------------------------------------------------------------
-- Type Declarations
-- ------------------------------------------------------------------------------------------
type state_type is ( IDLE, START, DATA, STOP );

-- ------------------------------------------------------------------------------------------
-- Signal Declarations
-- ------------------------------------------------------------------------------------------  
-- General
signal Clk                   : std_logic := '0';
signal Rst                   : std_logic := '1';

-- UART Transmit
signal tx                    : std_logic := '1';

-- UART Receive
signal rx                    : std_logic := '1';
signal state                 : state_type := IDLE;
signal sample_cnt            : integer := 0;
signal data_cnt              : integer := 0;
signal sample                : std_logic := '0';
signal rx_data               : std_logic_vector(7 downto 0) := (others => '0');

signal monitor               : std_logic := '0';

signal  Tx_data_uart_next       : std_logic;
signal  Tx_data_uart           : std_logic_vector(7 downto 0);
signal  Tx_data_uart_rdy       : std_logic;
  
signal  Rx_data_uart           : std_logic_vector(7 downto 0);
signal  Rx_data_uart_rdy       : std_logic;

signal led                    : std_logic_vector(3 downto 0);

signal MOSI : std_logic := '0';
signal MISO : std_logic := '0';
signal SS : std_logic_vector(3 downto 0) := (others => '0');
signal SCLK : std_logic := '0';

begin
  
  -- ----------------------------------------------------------------------------------------   
  -- UUT
  -- ----------------------------------------------------------------------------------------  
  UUT : entity work.wrapper
  port map
  ( 
  
    i_clk => Clk,
    i_rst => Rst,
    
    i_rx => tx,
    o_tx => rx,
    
    o_mosi => MOSI,
    i_miso => MISO,
    o_ss => SS,
    o_SCLK => SCLK,
    
    o_led => led,
    o_io => open
  );
  
  -- ----------------------------------------------------------------------------------------   
  -- 100MHz clock
  -- ---------------------------------------------------------------------------------------- 
  --
  process
  begin
    Clk <= '0';
    wait for CLOCK_PERIOD*0.5; 
    Clk <= '1';
    wait for CLOCK_PERIOD*0.5; 
  end process;
   
  -- ----------------------------------------------------------------------------------------   
  -- UART Receive
  -- ----------------------------------------------------------------------------------------    
  -- 
  -- TX ---+   +---+---+---+---+---+---+---+---+---+-----
  --       |   |D0 |D1 |D2 |D3 |D4 |D5 |D6 |D7 |    
  --       +---+---+---+---+---+---+---+---+---+   
  --        S1                                   S2
  --         
  --       |<->|
  --         T1
  --
  -- BAUDRATE   = 115200
  --
  -- S1 - Start-bit
  -- S2 - Stop-bit
  --
  -- T1 - Bit-period
  --      1/BAUDRATE = 8.680us
  --
  process (Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '0' then
        state <= IDLE after 1 ns;
        sample_cnt <= 0 after 1 ns;
      else 
        sample <= '0' after 1 ns;
        case state is
          when IDLE => 
            if rx = '0' then
              state <= START after 1 ns;         
            end if;
          when START =>
            if sample_cnt = SAMPLE_HALF_BIT then
              sample <= '1' after 1 ns;
              sample_cnt <= 0 after 1 ns;
              if rx = '0' then
                state <= DATA after 1 ns;
              else
                state <= IDLE after 1 ns;
              end if;
            else
              sample_cnt <= sample_cnt + 1 after 1 ns;
            end if;
          when DATA =>
            if sample_cnt = SAMPLE_FULL_BIT then
              sample <= '1' after 1 ns;
              sample_cnt <= 0 after 1 ns;
              rx_data <= rx & rx_data(7 downto 1);
              if data_cnt = 7 then
                data_cnt <= 0;
                state <= STOP after 1 ns;
              else
                data_cnt <= data_cnt + 1 after 1 ns;
              end if;
            else
              sample_cnt <= sample_cnt + 1 after 1 ns;
            end if;
          when STOP =>
            if sample_cnt = SAMPLE_FULL_BIT then
              print ("Info : UART Receive => Data = h'" & hstr(std_logic_vector(rx_data)) );
              sample <= '1' after 1 ns;
              sample_cnt <= 0 after 1 ns;
              state <= IDLE after 1 ns;
            else
              sample_cnt <= sample_cnt + 1 after 1 ns;
            end if;
          when others =>
            state <= IDLE after 1 ns;
        end case;
      end if;
    end if;
  end process;
  -- ----------------------------------------------------------------------------------------   
    -- SPI slave Receive _SS
    -- --------------------------------------------------------------------------------------
    -- 
    -- MOSI ----+---+---+---+---+---+---+---+---+----
    --          |D0 |D1 |D2 |D3 |D4 |D5 |D6 |D7 |    
    --          +---+---+---+---+---+---+---+---+   
    --            +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+      
    --            | | | | | | | | | | | | | | | |      
    -- SCLK ------+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +----
    --
    --        +------------------------------------+    
    --        |                                    |    
    -- SS   --+                                    +----
    process (SCLK, SS)
    variable rx_reg : std_logic_vector(256 downto 0);
    variable count  : integer := 0;
    begin
      if SS(0) = '0' AND count>0 then
        print ("SPI slave _SS received (PE64102) h'" & str(count) & " BITS: h'" & hstr(rx_reg(count-1 downto 0)) );
        count := 0;
      elsif rising_edge(SCLK) AND SS(0) = '1' then
          rx_reg := rx_reg(rx_reg'left-1 downto 0) & MOSI;
          count := count+1;
      end if;
    end process;
    
    -- ----------------------------------------------------------------------------------------   
    -- SPI slave Receive
    -- ----------------------------------------------------------------------------------------    
    -- 
    -- MOSI ----+---+---+---+---+---+---+---+---+----
    --          |D0 |D1 |D2 |D3 |D4 |D5 |D6 |D7 |    
    --          +---+---+---+---+---+---+---+---+   
    --            +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+      
    --            | | | | | | | | | | | | | | | |      
    -- SCLK ------+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +----
    --
    -- SS   --+                                    +----
    --        |                                    |    
    --        +------------------------------------+    
    process (SCLK, SS)
    variable rx_reg : std_logic_vector(256 downto 0);
    variable count  : integer := 0;
    begin
      if SS(0) = '1' AND count>0 then
        print ("SPI slave normal received h'" & str(count) & " BITS: h'" & hstr(rx_reg(count-1 downto 0)) );
        count := 0;
      elsif rising_edge(SCLK) AND SS(0) = '0' then
          rx_reg := rx_reg(rx_reg'left-1 downto 0) & MOSI;
          count := count+1;
      end if;
    end process;
    
    -- Slave
--    process (SCLK, SS)
--    variable tx_reg : std_logic_vector(63 downto 0) := X"48cbad5fe6f8c4f1";
--    begin
--      if falling_edge(SCLK) AND SS = '0' then
--          tx_reg := tx_reg(tx_reg'left-1 downto 0) & tx_reg(tx_reg'left);
--          MISO <= tx_reg(tx_reg'left);
--      end if;
--    end process;

  -- ----------------------------------------------------------------------------------------   
  -- Main
  -- ----------------------------------------------------------------------------------------    
  -- 
  process
    -- --------------------------------------------------------------------------------------   
    -- UART Transmit
    -- --------------------------------------------------------------------------------------  
    -- 
    -- TX ---+   +---+---+---+---+---+---+---+---+---+-----
    --       |   |D0 |D1 |D2 |D3 |D4 |D5 |D6 |D7 |    
    --       +---+---+---+---+---+---+---+---+---+   
    --        S1                                   S2
    --         
    --       |<->|
    --         T1
    --
    -- BAUDRATE   = 115200
    --
    -- S1 - Start-bit
    -- S2 - Stop-bit
    --
    -- T1 - Bit-period
    --      1/BAUDRATE = 8.680us
    --
    procedure UART_Tx 
    ( 
      data         : in unsigned (7 downto 0)
    ) is    
    begin
      print ("Info : UART Send => Data = h'" & hstr(std_logic_vector(data)) );
      -- Start-bit
      tx <= '0' after 1 ns;
      wait for BIT_PERIOD;

      -- Data
      for I in 0 to 7 loop
        tx <= data(I) after 1 ns;
        wait for BIT_PERIOD;
      end loop;
   
      -- Stop-bit
      tx <= '1' after 1 ns;
      wait for BIT_PERIOD;
    end;
    
    -- SS = '0' normal
        -- DATA = '1' normal
        -- noinv = '0' normal
        -- Length = '00 1000' pour 8bits
        procedure PARAM_spi ( SS, DATA, noinv: in std_logic; Length1: in integer; Length128 : in integer) is
        variable buff:  std_logic_vector(7 downto 0);
        begin
            wait for 150 ns;
            print("Param spi with SS=" & str(SS) & " DATA=" & str(DATA) & " Length:" & str(Length1+128*Length128) & "bits");
            UART_Tx("0000000" & SS );
            wait for 150 ns;
            UART_Tx("0000001" & DATA);
            wait for 100 ns;
            UART_Tx("0000010" & noinv); -- no inv
            wait for 100 ns;
            UART_Tx(X"0b"); -- param size
            wait for 100 ns;
            buff := std_logic_vector(to_unsigned(Length128,8));
            UART_Tx(unsigned(buff));
            wait for 100 ns;
            buff := std_logic_vector(to_unsigned(Length1,8));
            UART_Tx(unsigned(buff));
            wait for 100 ns;
            UART_Tx(X"1f");
            wait for 100 ns;
        end;
    
    procedure Test_1 is
    file fichier : text is in "commandes.txt";
    variable ligne : line;
    variable commande : std_logic_vector (7 downto 0);
    begin
            print("Reset input");
            tx_data_uart_rdy <= '0';
            Rst<='0';
            tx_data_uart <= "00000000";
            wait for 1 us;
            Rst<='1';

            wait for 100 us;
            while not endfile(fichier) loop
                readline(fichier, ligne);
                hread(ligne, commande);
                UART_Tx(unsigned(commande)); -- 8
                wait for 100 us;
            end loop;
    end procedure Test_1;

    procedure Test_2 is
		file fichier : text is in "commandes.txt";
		variable ligne : line;
		variable commande : std_logic_vector (7 downto 0);
		variable I : integer;
	begin
		print("Reset input");
		tx_data_uart_rdy <= '0';
		Rst<='0';
		tx_data_uart <= "00000000";
		wait for 1 us;
		Rst<='1';
		wait for 100 us;

		PARAM_spi('0', '1', '1', 16, 0);
		wait for 10 ns;
		UART_Tx(X"0a");
		wait for 100 us;
		for I in 0 to 1 loop
			readline(fichier, ligne);
			hread(ligne, commande);
			UART_Tx(unsigned(commande));
			wait for 100 us;
		end loop;

		while not endfile(fichier) loop
			readline(fichier, ligne);
			hread(ligne, commande);
			UART_Tx(unsigned(commande)); -- 8
			wait for 100 us;
		end loop;
    end procedure Test_2;

  begin
        Test_1;
        assert false
        report "Info : Simulation complete"
        severity failure;
        wait;
  end process;
  
  process (Rx_data_uart_rdy)
  begin
    if rising_edge(Rx_data_uart_rdy) then
        print("FPGA received: " & hstr(std_logic_vector(Rx_data_uart)));
    end if;
  end process;
  
  MISO <= MOSI;
  
-- ------------------------------------------------------------------------------------------
end rtl;
