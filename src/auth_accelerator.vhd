library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- [Module 6] Hardware Accelerator buat validasi PIN (pake Looping)
entity auth_accelerator is
    Port ( 
        input_pin  : in  STD_LOGIC_VECTOR (3 downto 0);
        stored_pin : in  STD_LOGIC_VECTOR (3 downto 0);
        auth_valid : out STD_LOGIC
    );
end auth_accelerator;

architecture Behavioral of auth_accelerator is
begin
    process(input_pin, stored_pin)
        variable match_count : integer;
    begin
        match_count := 0; -- Reset counter dulu
        
        -- [Module 6] Cek kecocokan bit per bit pake For Loop
        for i in 0 to 3 loop
            if input_pin(i) = stored_pin(i) then
                match_count := match_count + 1;
            end if;
        end loop;

        -- Kalo 4 bit sama semua, berarti PIN valid
        if match_count = 4 then
            auth_valid <= '1';
        else
            auth_valid <= '0';
        end if;
    end process;
end Behavioral;