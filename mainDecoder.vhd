library IEEE;
use IEEE.STD_LOGIC_1164.all;

/* Pega o OPCODE da função e transforma num sinal de controle baseado nos parametros do final do código*/

entity mainDecoder is
   port(
      op: in STD_LOGIC_VECTOR(5 downto 0);
      memtoreg, memwrite: out STD_LOGIC;
      branch, branchNotEqual, alusrc: out STD_LOGIC;
      regdst, regwrite: out STD_LOGIC;
      jump: out STD_LOGIC;
      aluop: out STD_LOGIC_VECTOR(1 downto 0)
   );
end entity;

architecture behave of mainDecoder is
   -- Sinais internos para armazenar os controles derivados da operação
   signal controls: STD_LOGIC_VECTOR(8 downto 0);
begin
   process(all) begin
      -- Decodificação da operação (opcode) para gerar sinais de controle
      case op is
         when "000000" => controls <= "110000010"; -- TIPO-R
         when "100011" => controls <= "101001000"; -- LW
         when "101011" => controls <= "001010000"; -- SW
         when "000100" => controls <= "000100001"; -- BEQ
         when "001000" => controls <= "101000000"; -- ADDI
         when "000010" => controls <= "000000100"; -- J
         when "000011" => controls <= "100000100"; -- JAL
         when "100000" => controls <= "101001000"; -- LB
         when "101000" => controls <= "001010000"; -- SB
         when "000101" => controls <= "000000001"; -- BNE
         when others   => controls <= "---------";  -- operação ilegal
      end case;

   case controls is
   	when "000000001" => branchNotEqual <= '1';
    when others => branchNotEqual <= '0'; 
    end case;
    
   end process;
   -- Atribuição dos sinais de controle derivados aos sinais de saída
   (regwrite, regdst, alusrc, branch, memwrite,
    memtoreg, jump, aluop(1 downto 0)) <= controls;
end architecture;
