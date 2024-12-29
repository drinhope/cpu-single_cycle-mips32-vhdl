library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Componente responsável por realizar o deslocamento. No caso,
-- este está configurado para deslocar 2 bits

entity shiftLeftLogic is
   port(
      a: in STD_LOGIC_VECTOR(31 downto 0);
      y: out STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture behave of shiftLeftLogic is
begin
   -- Operação de deslocamento lógico à esquerda de 2 bits
   y <= a(29 downto 0) & "00";
end behave;