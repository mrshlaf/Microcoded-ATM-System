library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- [Module 4] Testbench: Simulasi skenario ATM (Multi-User)
entity tb_atm_top is
    -- Testbench gak punya port input/output
end tb_atm_top;

architecture Sim of tb_atm_top is
    -- Sinyal penghubung ke UUT
    signal tb_clk   : std_logic := '0';
    signal tb_sw    : std_logic_vector(9 downto 0) := (others => '0');
    signal tb_key   : std_logic_vector(1 downto 0) := "11"; -- Active Low
    signal tb_ledr  : std_logic_vector(9 downto 0);

    -- Konstanta waktu
    constant CLK_PERIOD : time := 20 ns; 
    constant PIN_BENAR  : std_logic_vector(3 downto 0) := "1010";
    constant PIN_SALAH  : std_logic_vector(3 downto 0) := "1111";

begin
    -- Instansiasi Unit Under Test (UUT)
    UUT: entity work.atm_top
    port map ( CLOCK_50 => tb_clk, SW => tb_sw, KEY => tb_key, LEDR => tb_ledr );

    -- Pembangkit Clock 50 MHz
    clk_process : process
    begin
        tb_clk <= '0'; wait for CLK_PERIOD/2;
        tb_clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- [Module 4] Skenario Testing (Stimulus)
    stim_proc: process
    begin
        report "=== MULAI SIMULASI ATM ===";

        -- 1. Reset Awal
        tb_key(0) <= '0'; wait for 100 ns; 
        tb_key(0) <= '1'; wait for 100 ns; 
        
        -- 2. Transaksi Gagal (PIN Salah)
        report "[TEST 1] Percobaan PIN Salah...";
        tb_sw(3 downto 0) <= PIN_SALAH; -- Input PIN
        tb_sw(7 downto 4) <= "0000";    -- Pilih User 0
        wait for 50 ns;
        
        tb_key(1) <= '0'; wait for 200 ns; tb_key(1) <= '1'; -- Enter
        
        -- Tunggu 300ns (Safe margin karena clock divider udah cepat)
        wait for 300 ns; 
            
        -- Validasi: Pastikan Indikator Error (Bit 2) nyala
        assert tb_ledr(2) = '1'
            report "GAGAL: Indikator Error tidak menyala!" severity error;
            
        report ">> Status: Indikator Error Valid.";

        -- Reset Sistem
        tb_key(0) <= '0'; wait for 50 ns; tb_key(0) <= '1'; wait for 50 ns;

        -- 3. Transaksi Sukses 1 (User 0 -> Saldo 8)
        report "[TEST 2] Login User 0 (Harusnya Saldo 8)...";
        tb_sw(3 downto 0) <= PIN_BENAR; 
        tb_sw(7 downto 4) <= "0000"; -- User 0
        wait for 50 ns;

        tb_key(1) <= '0'; wait for 200 ns; tb_key(1) <= '1'; 
        wait for 300 ns;

        -- Validasi: Pastikan Saldo 8 tampil
        assert tb_ledr(9 downto 6) = "1000"
            report "GAGAL: Saldo User 0 salah!" severity error;
            
        report ">> Status: Saldo User 0 (8) Tampil Valid.";

        -- Reset Sistem
        tb_key(0) <= '0'; wait for 50 ns; tb_key(0) <= '1'; wait for 50 ns;

        -- 4. Transaksi Sukses 2 (Ganti User -> Saldo 7)
        report "[TEST 3] Login User 1 (Harusnya Saldo 7)...";
        tb_sw(3 downto 0) <= PIN_BENAR;
        tb_sw(7 downto 4) <= "0001"; -- Ganti ke User 1
        wait for 50 ns;

        tb_key(1) <= '0'; wait for 200 ns; tb_key(1) <= '1'; 
        wait for 300 ns;

        -- Validasi: Pastikan Saldo 7 tampil (Berkurang)
        assert tb_ledr(9 downto 6) = "0111"
            report "GAGAL: Saldo User 1 salah!" severity error;

        report ">> Status: Saldo User 1 (7) Tampil Valid.";
        report "=== SIMULASI SELESAI: SEMUA SKENARIO SUKSES ===";
        wait; 
    end process;

end Sim;