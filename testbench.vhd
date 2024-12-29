library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity testbench is
end;

architecture test of testbench is
   -- Instanciação do componente top (seu design MIPS)
   component top
      port(
         clk, reset: in STD_LOGIC;
         writedata, dataadr: out STD_LOGIC_VECTOR(31 downto 0);
         memwrite: out STD_LOGIC;
         stop: out STD_LOGIC
      );
   end component;

   -- Sinais de entrada/saída para o testbench
   signal writedata, dataadr: STD_LOGIC_VECTOR(31 downto 0);
   signal clk, reset, memwrite, stop: STD_LOGIC;

begin
   -- Instanciando o design (MIPS) como "dut" (Device Under Test)
   dut: top port map(clk, reset, writedata, dataadr, memwrite, stop);

   -- Gerando um sinal de clock com período de 10 ns
   process
   begin
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
   end process;

   -- Gerando um sinal de reset nos primeiros dois ciclos de clock
   process
   begin
      reset <= '1';
      wait for 22 ns;
      reset <= '0';
      wait;
   end process;

   -- Verificando se o sinal "stop" foi ativado (indica o fim da execução do programa)
   process(clk)
   begin
      -- Se o sinal "stop" estiver ativo, a simulação é considerada bem-sucedida
      if (stop = '1') then
         report "NO ERRORS: Simulation succeeded" severity failure;
      end if;
      
   end process;

end architecture;
