library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity flipFlop is
   generic (
      width: integer
   );
   port(
      clk, reset: in STD_LOGIC;
      d: in STD_LOGIC_VECTOR(width-1 downto 0);
      q: out STD_LOGIC_VECTOR(width-1 downto 0)
   );
end entity;

architecture assincrono of flipFlop is
begin
   process(clk, reset) begin
      -- Se o sinal de reset estiver ativo, zera a saída q
      if reset then
         q <= (others => '0');
      -- Caso contrário, na borda de subida do clock, copia a entrada d para a saída q
      elsif rising_edge(clk) then
         q <= d;
      end if;
   end process;
end assincrono;
