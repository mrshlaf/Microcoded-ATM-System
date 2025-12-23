library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- [Module 3] Behavioral Style: Logic clock divider pake process sekuensial
entity clk_divider is
    Port ( clk_in : in STD_LOGIC; reset : in STD_LOGIC; clk_out : out STD_LOGIC );
end clk_divider;

architecture Behavioral of clk_divider is
    signal count : integer := 0;
    signal temp  : std_logic := '0';
begin
    -- Logic utama dideskripsikan step-by-step dalam process (Behavioral)
    process(clk_in, reset)
    begin
        if reset = '1' then
            count <= 0; temp <= '0';
        elsif rising_edge(clk_in) then
            -- Angka 1 cuma buat simulasi biar cepet (di Real FPGA ganti 25juta)
            if count = 1 then 
                temp <= not temp; count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    clk_out <= temp;
end Behavioral;