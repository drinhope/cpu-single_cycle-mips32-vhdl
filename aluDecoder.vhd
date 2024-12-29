library IEEE;
use IEEE.STD_LOGIC_1164.all;

/*Decodifica a operação para a ALU*/

entity aluDecoder is
   port(
      funct: in STD_LOGIC_VECTOR(5 downto 0);
      aluop: in STD_LOGIC_VECTOR(1 downto 0);
      jumpRegister: out STD_LOGIC;
      alucontrol: out STD_LOGIC_VECTOR(2 downto 0)
   );
end entity;

architecture behave of aluDecoder is
begin
   process(all) begin
      case aluop is
         when "00" =>
            alucontrol <= "010"; -- add (para lw/sw/addi)
         when "01" =>
            alucontrol <= "110"; -- sub (para beq)
         when others =>
            case funct is -- Instruções do tipo R
               when "100000" => alucontrol <= "010"; -- add
               when "100010" => alucontrol <= "110"; -- sub
               when "100100" => alucontrol <= "000"; -- and
               when "100101" => alucontrol <= "001"; -- or
               when "101010" => alucontrol <= "111"; -- slt
               when others    => alucontrol <= "---"; -- ??? (caso não reconhecido)
            end case;
            case funct is -- Jump Register
               when "001000" => jumpRegister <= '1';
               when others   => jumpRegister <= '0';
            end case;
      end case;
   end process;
end architecture;
