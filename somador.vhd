library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity somador is
   port(
      a, b: in STD_LOGIC_VECTOR(31 downto 0);
      y: out STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture behave of somador is
begin
   -- Somador de 32 bits
   y <= a + b;
end behave;
