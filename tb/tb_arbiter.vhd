----------------------------------------------------------------------------------
-- Company:  FPGA'er
-- Engineer: Claudio Avi Chami - FPGA'er Website
--           http://fpgaer.tech
-- Create Date: 25.09.2022 
-- Module Name: tb_arbiter.vhd
-- Description: testbench for round-robin arbiter
--              
-- Dependencies: arbiter_rr.vhd
-- 
-- Revision: 1
-- Revision  1 - Initial version
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_arbiter is
end entity;

architecture test of tb_arbiter is

  constant PERIOD : time := 20 ns;
  constant ARBITER_W : natural := 3;

  signal clk : std_logic := '0';
  signal rstn : std_logic := '0';
  signal req : std_logic_vector(ARBITER_W - 1 downto 0) := (others => '0');
  signal gnt : std_logic_vector(ARBITER_W - 1 downto 0);
  signal endSim : boolean := false;

  component arbiter_rr is
    port (
      clk  : in  std_logic;
      rstn : in  std_logic;

      -- inputs
      req  : in  std_logic_vector;

      -- outputs
      gnt  : out std_logic_vector
    );
  end component;
begin
  clk <= not clk after PERIOD/2;
  rstn <= '1' after PERIOD * 10;

  -- Main simulation process
  process
  begin
    req <= "000";

    wait until (rstn = '1');
    wait until (rising_edge(clk));

    wait until (rising_edge(clk));
    req <= "100";
    for I in 0 to 5 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "010";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "001";
    for I in 0 to 2 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "110";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "001";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "110";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "001";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    req <= "110";
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;
    endSim <= true;
  end process;

  -- End the simulation
  process
  begin
    if (endSim) then
      assert false
      report "End of simulation."
        severity failure;
    end if;
    wait until (rising_edge(clk));
  end process;

  arb_inst : arbiter_rr
  port map(
    clk  => clk,
    rstn => rstn,

    req  => req,
    gnt  => gnt
  );

end architecture;