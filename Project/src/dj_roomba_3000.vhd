-- Kushal Malhotra
-- Lab 9: DJ Roomba 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dj_roomba_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(9 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

architecture beh of dj_roomba_3000 is
  -- instruction memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (9 DOWNTO 0)
    );
  end component;
  
  component rising_edge_synchronizer
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
  end component;
  
  component next_state_logic_rom
    port (
    clk           : in std_logic;
    reset         : in std_logic;
    execute       : in std_logic;
    addr          : out std_logic_vector(4 downto 0)
  );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (15 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;
  
constant max_data_ch0           : std_logic_vector(15 downto 0) := "0111111111111111";
constant max_data_ch1           : std_logic_vector(15 downto 0) := "1111111111111111";
signal data_address_ch0         : std_logic_vector(15 downto 0);
signal data_address_ch1         : std_logic_vector(15 downto 0) := "1000000000000000";
signal ch0_audio                : std_logic_vector(15 downto 0);
signal ch1_audio                : std_logic_vector(15 downto 0);
signal execute_sync             : std_logic;
signal q_instruc                : std_logic_vector(9 downto 0);
signal instruction_address      : std_logic_vector(4 downto 0);
signal op                       : std_logic_vector(1 downto 0);

begin
op <= q_instruc(9) & q_instruc(8);

-- data instantiation
u_rom_data_inst_ch0 : rom_data
  port map (
    address    => data_address_ch0,
    clock      => clk,
    q          => ch0_audio
  );
  
u_rom_data_inst_ch1 : rom_data
  port map (
    address    => data_address_ch1,
    clock      => clk,
    q          => ch1_audio
  );
    
  res : rising_edge_synchronizer
  port map (
    clk        => clk,
    reset      => reset,
    input      => execute_btn,
    edge       => execute_sync
  );

nsl_rom : next_state_logic_rom
  port map (
    clk        => clk,
    reset      => reset,
    execute    => execute_sync,
    addr       => instruction_address
  );
    
u_rom_instructions : rom_instructions
  port map (
    address    => instruction_address,
    clock      => clk,
    q          => q_instruc
  );
    
  -- loop audio file
  process(clk,reset)
  begin 
    if (reset = '1') then 
      data_address_ch0 <= (others => '0');
    elsif (rising_edge(clk)) then
     case op is
 --------------------------------------- Play -------------------------------------------------------
       when "00" =>
 --------------------------------------- CH0 -------------------------------------------------------
      if (q_instruc(6) = '1') then 
         ---------------------------- Don't Repeat ---------------------------------------
         if (q_instruc(5) = '0') then 
            if (sync = '1') then
               if (data_address_ch0 = max_data_ch0) then -- check for max data value 
                 data_address_ch0 <= data_address_ch0; 
                end if;
                if (data_address_ch0 /= max_data_ch0) then
                 data_address_ch0 <= std_logic_vector(unsigned(data_address_ch0) + 1 );
                end if;
            end if;
         end if;
         ------------------------------- Repeat ---------------------------------------
         if (q_instruc(5) = '1') then
            if (sync = '1') then
               if (data_address_ch0 = max_data_ch0) then -- check for max data value 
                 data_address_ch0 <= (others => '0'); 
                end if;
                if (data_address_ch0 /= max_data_ch0) then
                 data_address_ch0 <= std_logic_vector(unsigned(data_address_ch0) + 1 );
                end if;
            end if;
         end if;
      end if;
 --------------------------------------- Pause -------------------------------------------------------
        when "01" =>    
            data_address_ch0 <= data_address_ch0;
 --------------------------------------- Seek -------------------------------------------------------
        when "10" =>
 --------------------------------------- CH0 -------------------------------------------------------
          if (q_instruc(6) = '1') then 
            data_address_ch0 <= q_instruc(4 downto 0) & "00000000000";
              if (sync = '1') then
                 if (data_address_ch0 = max_data_ch0) then -- check for max data value 
                   data_address_ch0 <= q_instruc(4 downto 0) & "00000000000"; 
                 end if;
                 if (data_address_ch0 /= max_data_ch0) then
                   data_address_ch0 <= std_logic_vector(unsigned(data_address_ch0) + 1 );
                 end if;             
              end if;
          end if;
 --------------------------------------- Stop -------------------------------------------------------
        when "11" =>
            data_address_ch0 <= (others => '0');
        when others =>
            data_address_ch0 <= data_address_ch0;
            end case;
      end if;
  end process;
  
    process(clk,reset)
  begin 
    if (reset = '1') then 
      data_address_ch1 <= "1000000000000000";
    elsif (rising_edge(clk)) then
     case op is
 --------------------------------------- Play -------------------------------------------------------
       when "00" =>
 --------------------------------------- CH1 -------------------------------------------------------
      if (q_instruc(7) = '1') then 
         ---------------------------- Don't Repeat ---------------------------------------
         if (q_instruc(5) = '0') then 
            if (sync = '1') then
               if (data_address_ch1 = max_data_ch1) then -- check for max data value 
                 data_address_ch1 <= data_address_ch1; 
                end if;
                if (data_address_ch1 /= max_data_ch1) then
                 data_address_ch1 <= std_logic_vector(unsigned(data_address_ch1) + 1 );
                end if;
            end if;
         end if;
         ------------------------------- Repeat ---------------------------------------
         if (q_instruc(5) = '1') then
            if (sync = '1') then
              if (data_address_ch1 = max_data_ch1) then -- check for max data value 
                 data_address_ch1 <= "1000000000000000"; 
                end if;
                if (data_address_ch1 /= max_data_ch1) then
                 data_address_ch1 <= std_logic_vector(unsigned(data_address_ch1) + 1 );
                end if;
            end if;
         end if;
      end if;
 --------------------------------------- Pause -------------------------------------------------------
        when "01" =>    
            data_address_ch1 <= data_address_ch1;
 --------------------------------------- Seek -------------------------------------------------------
        when "10" =>
 --------------------------------------- CH1 -------------------------------------------------------
          if (q_instruc(7) = '1') then 
           data_address_ch1 <= std_logic_vector(unsigned(q_instruc(4 downto 0) & "00000000000") + "1000000000000000" );
              if (sync = '1') then
               if (data_address_ch1 = max_data_ch1) then -- check for max data value 
                 data_address_ch1 <= data_address_ch1; 
                end if;
                if (data_address_ch1 /= max_data_ch1) then
                 data_address_ch1 <= std_logic_vector(unsigned(data_address_ch1) + 1 );
                end if;
              end if;
          end if;
 --------------------------------------- Stop -------------------------------------------------------
        when "11" =>
            data_address_ch1 <= "1000000000000000";
        when others =>
            data_address_ch1 <= data_address_ch1;
            end case;
      end if;
  end process;

  led <= q_instruc;
  audio_out <= std_logic_vector(unsigned(ch0_audio) + unsigned(ch1_audio));----- ask professor???----------- ask professor???------
end beh;