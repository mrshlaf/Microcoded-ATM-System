library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.atm_pkg.ALL; -- Import tipe state dari package

-- Controller utama: Menggabungkan FSM (State) & Microcode ROM (Output)
entity fsm_controller is
    Port ( 
        clk, reset : in STD_LOGIC;
        auth_valid : in STD_LOGIC;
        btn_enter  : in STD_LOGIC;
        state_led  : out STD_LOGIC_VECTOR(2 downto 0)
    );
end fsm_controller;

architecture Behavioral of fsm_controller is
    signal current_state, next_state : t_atm_state;
    signal micro_code : STD_LOGIC_VECTOR(3 downto 0);
    
    -- [Module 7] Procedure: Sub-program buat mapping bits (Logic Reusability)
    procedure map_output(
        signal code_in    : in  STD_LOGIC_VECTOR(3 downto 0);
        signal target_led : out STD_LOGIC_VECTOR(2 downto 0)
    ) is
    begin
        target_led <= code_in(3 downto 1); -- Ambil 3 bit teratas
    end procedure;

begin
    -- [Module 9] Microprogramming: Output dikontrol via ROM (Control Store), bukan hardcode
    U_ROM: entity work.rom_microcode
        port map ( state_in => current_state, control_out => micro_code );

    -- Process 1: Update State sinkron sama clock
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Process 2: Logika perpindahan state (Next State Logic)
    process(current_state, auth_valid, btn_enter)
    begin
        next_state <= current_state; -- Default biar ga latch
        case current_state is
            when IDLE =>
                if btn_enter = '1' then next_state <= CHECK_PIN; end if;
            when CHECK_PIN =>
                if auth_valid = '1' then next_state <= SHOW_BALANCE;
                else next_state <= ERROR_STATE; end if;
            when SHOW_BALANCE =>
                if btn_enter = '1' then next_state <= IDLE; end if;
            when ERROR_STATE =>
                if btn_enter = '1' then next_state <= IDLE; end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Process 3: Update Output pake Procedure tadi
    process(micro_code)
    begin 
        map_output(micro_code, state_led); 
    end process;
    
end Behavioral;