library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;  

entity next_state_logic_rom is 
  port (
    clk           : in std_logic;
    reset         : in std_logic;
    execute       : in std_logic;
    addr          : out std_logic_vector(4 downto 0)
  );
end next_state_logic_rom;

architecture beh of next_state_logic_rom is

constant idle_st            :std_logic_vector(4 DOWNTO 0)  :="00001";
constant fetch_st           :std_logic_vector(4 DOWNTO 0)  :="00010";
constant decode_st          :std_logic_vector(4 DOWNTO 0)  :="00100";
constant execute_st         :std_logic_vector(4 DOWNTO 0)  :="01000";
constant decode_error_st    :std_logic_vector(4 DOWNTO 0)  :="10000";

signal  state_reg,state_next :std_logic_vector(4 DOWNTO 0);
signal address_sig  : std_logic_vector(4 downto 0) := "00000";

begin 

process(clk,reset)
begin
    if reset = '1' then
      state_reg <= idle_st;
    elsif rising_edge(clk) then
     state_reg <= state_next;
    end if;
end process;

nextstatelogic :process(execute,state_reg)
  begin
    state_next <= state_reg;
    case state_reg is
      when idle_st => 
        if execute = '1' then
          state_next <= fetch_st;
        end if;
      when fetch_st => 
          state_next <= decode_st;
      when decode_st => 
          state_next <= execute_st;
      when execute_st => 
          state_next <= decode_error_st;
      when decode_error_st => 
          state_next <= idle_st;
      when others => 
           state_next <= idle_st;
      end case;
end process;

 -- execute_out :process(state_reg)
  -- begin 
    -- case state_reg is
       -- when fetch_st =>
        -- if ((q(11) = '0') AND (q(10) = '0')) then
          -- execute_blip <= '1';
        -- end if;
      -- when execute_st =>
        -- if((q(11) = '1') OR (q(10) = '1')) then
          -- execute_blip <= '0';
          -- mr_blip <= q(11);
          -- ms_blip <= q(10);
        -- end if;
      -- when decode_st => 
        -- if ((q(7) = '0') AND (q(6) = '0')) then
            -- if (q(5) = '0') then 
      -- when others =>
          -- execute_blip <= '0';
          -- mr_blip      <= '0';
          -- ms_blip      <= '0';
      -- end case;
 -- end process;
 
 addr_out :process(state_reg,clk)
  begin 
   if reset = '1' then
      address_sig <= (others => '0');
   elsif rising_edge(clk) then
    case state_reg is
      when fetch_st =>    -- CHANGING IT TO EXECUTE_ST
          address_sig <= std_logic_vector(unsigned(address_sig) + 1 );
      when others =>
          address_sig <= address_sig;
      end case;
    end if;
 end process;
 
 addr <= address_sig;
 
 end architecture;