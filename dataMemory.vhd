library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity dataMemory is
   port(
      clk, we: in STD_LOGIC;
      a, wd: in STD_LOGIC_VECTOR (31 downto 0);
      rd: out STD_LOGIC_VECTOR (31 downto 0);
      bytectrl: in STD_LOGIC
   );
end entity;

architecture behave of dataMemory is

   file file_RESULTS : text;

begin
   process is
      -- Definindo um tipo para a RAM e uma variável para armazenar a memória
      type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
      variable mem: ramtype;
      variable v_OLINE: line;
      variable num: integer;
   begin
      -- Abrindo o arquivo de saída para escrita
      file_open(file_RESULTS, "memoutput.txt", write_mode);

      loop
         -- Verificando a borda de subida do clock
         if rising_edge(clk) then
            -- Verificando se é uma operação de escrita
            if (we = '1') then
               -- Escrevendo dados na posição de memória especificada pelo endereço
               if bytectrl = '1' then
               	num := to_integer(a(1 downto 0));
               	mem(to_integer(a(7 downto 2)))(7+8*num downto 8*num) := wd(7 downto 0);
               else
               	mem(to_integer(a(7 downto 2))) := wd;
               end if;
               
               -- Abrindo o arquivo novamente para escrever as alterações
               file_open(file_RESULTS, "memoutput.txt", write_mode);
               
               -- Escrevendo todas as posições de memória no arquivo
               for i in 0 to 63 loop
                  write(v_OLINE, i);
                  write(v_OLINE, " : ");
                  write(v_OLINE, mem(i));
                  writeline(file_RESULTS, v_OLINE);
               end loop;
               
               -- Fechando o arquivo após a escrita
               file_close(file_RESULTS);
            end if;
         end if;

         -- Lendo dados da posição de memória especificada pelo endereço
         if bytectrl = '1' then
         	num := to_integer(a(1 downto 0));
         	rd <= "000000000000000000000000"&mem(to_integer(a(7 downto 2)))(7+8*num downto 8*num);
         else
           rd <= mem(to_integer(a(7 downto 2)));
         end if;

         -- Aguardando mudanças no clock ou no endereço
         wait on clk, a;
      end loop;
   end process;

end behave;