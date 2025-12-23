library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Package buat nyimpen tipe data global & helper function ATM
package atm_pkg is
    -- Definisi state FSM biar bisa dipake rame-rame (Controller & Microcode)
    type t_atm_state is (IDLE, CHECK_PIN, SHOW_BALANCE, ERROR_STATE);

    -- [Module 7] Deklarasi function hitung biaya admin (input int -> output vector)
    function calc_dummy_fee(saldo_awal : integer) return std_logic_vector;
end package atm_pkg;

package body atm_pkg is

    -- [Module 7] Isi logic function-nya disini (Pure Function)
    function calc_dummy_fee(saldo_awal : integer) return std_logic_vector is
        variable temp : integer; -- Buat nyimpen itungan sementara
    begin
        -- Logic potong saldo 1 perak buat admin fee
        if saldo_awal > 0 then
            temp := saldo_awal - 1;
        else
            temp := 0; -- Jaga-jaga biar saldo gak minus (underflow protection)
        end if;
        
        -- Balikin hasil yang udah diconvert jadi vector 8-bit
        return std_logic_vector(to_unsigned(temp, 8));
    end function;

end package body atm_pkg;