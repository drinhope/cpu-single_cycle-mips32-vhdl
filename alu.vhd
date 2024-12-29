library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity alu is
    port(
        a, b: in STD_LOGIC_VECTOR(31 downto 0);
        alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
        result: out STD_LOGIC_VECTOR(31 downto 0);
        zero: out STD_LOGIC
    );
end entity;

architecture synth of alu is
    signal S, Bout: STD_LOGIC_VECTOR(31 downto 0);
begin
    -- Inversão de bits de b se o controle de ALU (alucontrol(2)) for '1', senão, usa b diretamente
    Bout <= (not b) when (alucontrol(2) = '1') else b;
    
    -- Soma a, Bout e o bit de carry do controle de ALU
    S <= a + Bout + alucontrol(2);

    process(all) 
    begin
        case alucontrol(1 downto 0) is
            when "00" =>
                result <= a and Bout;  -- AND
            when "01" =>
                result <= a or Bout;   -- OR
            when "10" =>
                result <= S;           -- Soma (com carry)
            when "11" =>
                result <= ("0000000000000000000000000000000" & S(31));  -- Deslocamento à direita lógico
            when others =>
                result <= X"00000000";  -- Valor padrão
        end case;

        -- Define o sinal zero com base na igualdade de a e b
        if (a = b) then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end synth;
