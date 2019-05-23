
---------------------------------------------------------------------------------
--
--   Copyright 2017 - Rutherford Appleton Laboratory and University of Bristol
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--
--                                     - - -
--
--   Additional information about ipbus-firmare and the list of ipbus-firmware
--   contacts are available at
--
--       https://ipbus.web.cern.ch/ipbus
--
---------------------------------------------------------------------------------


-- Top-level design for ipbus demo
--
-- This version is for the HiTech Global K800 board, using the PCIe interface
--
-- Tom Williams, July 2018


library IEEE;
use IEEE.std_logic_1164.all;

use work.ipbus_v3.all;

library UNISIM;
use UNISIM.VComponents.all;


entity top is
  port(
    -- PCIe clock and reset
    pcie_sys_clk_p : in std_logic;
    pcie_sys_clk_n : in std_logic;
    pcie_sys_rst   : in std_logic;  -- active high reset derived from the
                                    -- active low reset from the pcie edge connector
    -- PCIe lanes
    pcie_rx_p : in std_logic_vector(0 downto 0);
    pcie_rx_n : in std_logic_vector(0 downto 0);
    pcie_tx_p : out std_logic_vector(0 downto 0);
    pcie_tx_n : out std_logic_vector(0 downto 0);

    -- External oscillator
    osc_clk_p : in std_logic;
    osc_clk_n : in std_logic;

    -- status LEDs
    leds: out std_logic_vector(3 downto 0)
  );

end top;

architecture rtl of top is

  signal ipb_clk, ipb_rst, nuke, soft_rst, userled: std_logic;
  signal pcie_sys_rst_n : std_logic;
  
  signal ipb_out: ipb_wbus;
  signal ipb_in: ipb_rbus;


begin

-- Infrastructure

  pcie_sys_rst_n <= not pcie_sys_rst;
  
  infra: entity work.k800_infra
    port map(
      pcie_sys_clk_p => pcie_sys_clk_p,
      pcie_sys_clk_n => pcie_sys_clk_n,
      pcie_sys_rst_n => pcie_sys_rst_n,
      pcie_rx_p      => pcie_rx_p,
      pcie_rx_n      => pcie_rx_n,
      pcie_tx_p      => pcie_tx_p,
      pcie_tx_n      => pcie_tx_n,
      osc_clk_p      => osc_clk_p,
      osc_clk_n      => osc_clk_n,
      ipb_clk        => ipb_clk,
      ipb_rst        => ipb_rst,
      nuke           => nuke,
      soft_rst       => soft_rst,
      leds           => leds(1 downto 0),
      ipb_in         => ipb_in,
      ipb_out        => ipb_out
      );
      
  leds(3 downto 2) <= '0' & userled;

-- ipbus slaves live in the entity below, and can expose top-level ports.
-- The ipbus fabric is instantiated within.

  slaves: entity work.ipbus_v3_example
    port map(
      ipb_clk => ipb_clk,
      ipb_rst => ipb_rst,
      ipb_in => ipb_out,
      ipb_out => ipb_in,
      nuke => nuke,
      soft_rst => soft_rst,
      userled => userled
      );


end rtl;
