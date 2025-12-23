library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.atm_pkg.ALL; -- Butuh tipe state dari sini

-- [Module 9] Microcode ROM: Control Store buat nyimpen sinyal kendali
-- Memetakan 'State' (Input) menjadi 'Control Signals' (Output)
entity rom_microcode is
    Port ( 
        state_in    : in  t_atm_state;
        control_out : out STD_LOGIC_VECTOR(3 downto 0) 
    );
end rom_microcode;

architecture Behavioral of rom_microcode is
begin 
    -- Logic Look-Up Table (LUT) sederhana
    process(state_in)
    begin
        case state_in is
            when IDLE         => control_out <= "0000"; -- Mati semua
            when CHECK_PIN    => control_out <= "0010"; -- Bit 1 nyala (Biru/Wait)
            when SHOW_BALANCE => control_out <= "0100"; -- Bit 2 nyala (Hijau/Sukses)
            when ERROR_STATE  => control_out <= "1000"; -- Bit 3 nyala (Merah/Gagal)
            when others       => control_out <= "1111"; -- Error Trap
        end case;
    end process;
end Behavioral;