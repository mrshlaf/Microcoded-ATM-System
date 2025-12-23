library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- [Module 2] Memory Bank: Simulasi database saldo nasabah
entity bank_ram is
    Port ( 
        clk      : in  STD_LOGIC;
        addr     : in  STD_LOGIC_VECTOR (3 downto 0); -- Input alamat nasabah
        data_out : out STD_LOGIC_VECTOR (7 downto 0)  -- Output data saldo
    );
end bank_ram;

architecture RTL of bank_ram is
    -- Array memori 16 slot x 8 bit
    type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);

    -- Inisialisasi saldo awal nasabah
    signal RAM : ram_type := (
        0 => "00001001", -- User 0: Saldo 9 (Dipotong fee 1 -> Tampil 8)
        1 => "00001000", -- User 1: Saldo 8 (Dipotong fee 1 -> Tampil 7)
        others => (others => '0')
    );
begin
    -- Proses pembacaan data sinkron
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= RAM(to_integer(unsigned(addr)));
        end if;
    end process;
end RTL;