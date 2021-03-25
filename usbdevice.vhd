----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:12:51 12/21/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ulpi_serial;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity usbdevice is
    Port (  clk50_i       : in  std_logic;

            ulpi_clk60_i  : in  std_logic;
            ulpi_data_io  : inout  std_logic_vector(7 downto 0);
            ulpi_dir_i    : in  std_logic;
            ulpi_nxt_i    : in  std_logic;
            ulpi_stp_o    : out std_logic := '1';
            ulpi_rst_o    : out std_logic := '1';

            led_o       : out std_logic_vector(7 downto 0)	 -- 8 LEDs on MiniSpartan6+ board
        );
end usbdevice;

architecture Behavioral of usbdevice is

    signal rxval_s : std_logic;
    signal rxrdy_s : std_logic;
    signal rxdat_s : std_logic_vector(7 downto 0);
    signal txval_s : std_logic;
    signal txrdy_s : std_logic;
    signal txdat_s : std_logic_vector(7 downto 0);

    signal count   : unsigned(25 downto 0);

    signal clk60_buf : std_logic;

begin

    inst_bufg_ulpi_clk : BUFG
        port map (
            O => clk60_buf,    -- 1-bit output: Clock buffer output
            I => ulpi_clk60_i  -- 1-bit input: Clock buffer input
        );

    inst_ulpi_serial: entity ulpi_serial
	    port map (
		    ulpi_data   => ulpi_data_io,
            ulpi_dir    => ulpi_dir_i,
		    ulpi_nxt    => ulpi_nxt_i,
		    ulpi_stp    => ulpi_stp_o,
            ulpi_reset  => ulpi_rst_o,
            ulpi_clk60  => clk60_buf,
		
		    rxval       => rxval_s,
            rxrdy       => rxrdy_s,
            txval       => txval_s,
            txrdy       => txrdy_s,
            rxdat       => rxdat_s,
            txdat       => txdat_s,

            LED         => led_o(6)
        );

    rxrdy_s <= txrdy_s;
    txval_s <= rxval_s;
    txdat_s <= rxdat_s;

    process (clk60_buf)
    begin
        if rising_edge(clk60_buf) then
            count <= count + 1;
        end if;
    end process;

    led_o(7) <= count(count'high);
    
    led_o(5 downto 0) <= rxdat_s(5 downto 0);

end Behavioral;