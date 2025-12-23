library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.atm_pkg.ALL; -- Pake library buatan sendiri

-- Top Level Entity: Wrapper utama System-on-Chip (SoC) kita
entity atm_top is
    Port ( 
        CLOCK_50 : in  STD_LOGIC;                    -- Clock bawaan board 50MHz
        SW       : in  STD_LOGIC_VECTOR(9 downto 0); -- Input: PIN (3-0) & User ID (7-4)
        KEY      : in  STD_LOGIC_VECTOR(1 downto 0); -- Tombol Reset & Enter
        LEDR     : out STD_LOGIC_VECTOR(9 downto 0)  -- Output: Saldo & Status
    );
end atm_top;

-- [Module 5] Gaya Structural: Cuma instansiasi komponen & sambung kabel
architecture Structural of atm_top is
    -- Deklarasi sinyal internal (kabel penghubung antar modul)
    signal sys_clk, sys_reset, auth_ok : std_logic;
    signal raw_balance : std_logic_vector(7 downto 0);
    signal final_balance : std_logic_vector(7 downto 0);
    signal enter_button : std_logic;
    
    -- Sinyal internal buat nampung status FSM sebelum ke LED
    signal fsm_status : std_logic_vector(2 downto 0);

begin
    -- Balik logika tombol board (Active Low jadi Active High)
    sys_reset    <= not KEY(0);
    enter_button <= not KEY(1);

    -- 1. Clock Divider: Nurunin clock biar state kelihatan mata
    U_CLK: entity work.clk_divider
        port map (clk_in => CLOCK_50, reset => sys_reset, clk_out => sys_clk);

    -- 2. Auth Accelerator: Hardware khusus buat cek PIN (Module 6 inside)
    U_AUTH: entity work.auth_accelerator
        port map (input_pin => SW(3 downto 0), stored_pin => "1010", auth_valid => auth_ok);

    -- 3. RAM Bank: Modul memori buat simpen saldo (Module 2 inside)
    -- Alamat diambil dari SW 7-4 buat simulasi ganti user/saldo berkurang
    U_RAM: entity work.bank_ram
        port map (clk => sys_clk, addr => SW(7 downto 4), data_out => raw_balance);

    -- 4. FSM Controller: Otak utama pengatur alur & state (Module 9 inside)
    U_FSM: entity work.fsm_controller
        port map (
            clk        => sys_clk, 
            reset      => sys_reset,
            auth_valid => auth_ok, 
            btn_enter  => enter_button,
            state_led  => fsm_status -- Masuk ke sinyal internal dulu
        );
        
    -- [Module 7] Panggil function hitung biaya admin dari package
    final_balance <= calc_dummy_fee(to_integer(unsigned(raw_balance)));
    
    -- Logika Display Cerdas: Saldo cuma muncul kalau status SUKSES (Bit 1 nyala)
    -- Kalau error atau idle, saldo dipaksa 0 biar gak bocor
    LEDR(9 downto 6) <= final_balance(3 downto 0) when fsm_status(1) = '1' else "0000";

    -- Matiin LED tengah (3-5) biar sinyal gak floating
    LEDR(5 downto 3) <= "000"; 
    
    -- Terusin status FSM ke LED fisik bagian bawah
    LEDR(2 downto 0) <= fsm_status;

end Structural;