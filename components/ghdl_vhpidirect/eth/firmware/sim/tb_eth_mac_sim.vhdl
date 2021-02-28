library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_eth_mac_sim is
end entity tb_eth_mac_sim;

architecture bench of tb_eth_mac_sim is

  constant MULTI_PACKET: boolean := false;

  signal clk      : std_logic; -- 125MHz clock for GBE
  signal rst      : std_logic; -- Synchronous reset
  signal tx_data  : std_logic_vector(7 downto 0);
  signal tx_valid : std_logic;
  signal tx_last  : std_logic;
  signal tx_error : std_logic; -- Ignored in this design
  signal tx_ready : std_logic;
  signal rx_data  : std_logic_vector(7 downto 0);
  signal rx_valid : std_logic;
  signal rx_last  : std_logic;
  signal rx_error : std_logic; -- Not used in this design

begin

  uut: entity work.eth_mac_sim
    generic map (
      MULTI_PACKET => MULTI_PACKET
    )
    port map (
      clk      => clk,
      rst      => rst,
      tx_data  => tx_data,
      tx_valid => tx_valid,
      tx_last  => tx_last,
      tx_error => tx_error,
      tx_ready => tx_ready,
      rx_data  => rx_data,
      rx_valid => rx_valid,
      rx_last  => rx_last,
      rx_error => rx_error
    );

  clocking: process begin
    clk <= '0';
    wait for 4 ns;
    clk <= '1';
    wait for 4 ns;
  end process clocking;

  testproc: process
  begin
    rst <= '1';
    tx_data <= X"00";
    tx_valid <= '0';
    tx_last <= '0';
    tx_error <= '0';
    wait for 80 ns;
    rst <= '0';
    -- start test frame
    tx_valid <= '1';
    -- dest MAC
    for i in 0 to 5 loop
      tx_data <= X"FF";
      wait for 8 ns;
    end loop;
    -- src MAC
    for i in 0 to 5 loop
      tx_data <= X"00";
      wait for 8 ns;
    end loop;
    -- payload length
    tx_data <= X"00";
    wait for 8 ns;
    tx_data <= X"40";
    wait for 8 ns;
    -- payload
    for i in 0 to 63 loop
      tx_data <= std_logic_vector(to_unsigned(i+16#40#, 8));
      wait for 8 ns;
    end loop;
    -- end test frame
    tx_valid <= '0';
    tx_last <= '1';
    wait for 8 ns;
    tx_last <= '0';
    rst <= '1';
    wait;
  end process testproc;

end architecture bench;
