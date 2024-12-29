library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity multiplexor is
   generic(
      width: integer := 8  -- Largura padrão de 8 bits se não especificada
   );
   port(
      d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);  -- Entradas do MUX
      s: in STD_LOGIC;  -- Sinal de seleção
      y: out STD_LOGIC_VECTOR(width-1 downto 0)  -- Saída do MUX
   );
end entity;

architecture behave of multiplexor is
begin
   -- Se o sinal de seleção (s) estiver ativo, a saída (y) é d1, senão é d0
   y <= d1 when s else d0;
end behave;
