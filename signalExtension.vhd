library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity signalExtension is
   port(
      a: in STD_LOGIC_VECTOR(15 downto 0);
      y: out STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture behave of signalExtension is
begin
   -- Extensão de sinal: se o bit de sinal (MSB) for 1, preenche com 1s, senão preenche com 0s
   y <= X"ffff" & a when a(15) else X"0000" & a;
end behave;
