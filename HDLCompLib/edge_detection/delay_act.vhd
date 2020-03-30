-- -------------------------------------------------------------------------------
-- This file has been automatically generated by the Caph compiler (version 2.8.4d)
-- from file main.cph, on 2018-05-11 at 12:39:30, by <unknown>
-- For more information, see : http://caph.univ-bpclermont.fr
-- -------------------------------------------------------------------------------

library ieee,caph,work;
use ieee.std_logic_1164.all;
use caph.core.all;
use caph.data_types.all;
use ieee.numeric_std.all;
use work.all;
use work.edgeDetectionOk_globals.all;

entity delay is
   port (
    in_pel_empty: in std_logic;
    in_pel: in std_logic_vector(7 downto 0);
    in_pel_rd: out std_logic;
    out_pel_full: in std_logic;
    out_pel: out std_logic_vector(7 downto 0);
    out_pel_wr: out std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end delay;

architecture FSM of delay is
    signal data : unsigned(7 downto 0);
    signal n_data : unsigned(7 downto 0);
    signal en_data : boolean;
begin
  comb: process(in_pel, in_pel_empty, out_pel_full, data)
    variable p_pel : unsigned(7 downto 0);
  begin
    -- in_pel.rdy, out_pel.rdy / p_pel=in_pel, wr(out_pel,data), data:=p_pel
    if in_pel_empty='0' and out_pel_full='0' then
      p_pel := from_std_logic_vector(in_pel,8);
      in_pel_rd <= '1';
      out_pel <= std_logic_vector(data);
      out_pel_wr <= '1';
      n_data <= p_pel;
      en_data <= true;
    else
      in_pel_rd <= '0';
      out_pel_wr <= '0';
      out_pel <= (others => 'X');
      en_data <= false;
      n_data <= data;
    end if;
  end process;
  seq: process(clock, reset)
  begin
    if (reset='0') then
      data <= "00000000";
    elsif rising_edge(clock) then
      if ( en_data ) then
        data <= n_data after 1 ns;
      end if;
    end if;
  end process;
end FSM;
