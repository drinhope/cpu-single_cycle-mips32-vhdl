library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
use STD.TEXTIO.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity registerFile is
   port(
      clk: in STD_LOGIC;
      we3: in STD_LOGIC;
      ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
      wd3: in STD_LOGIC_VECTOR(31 downto 0);
      rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture behave of registerFile is
   -- Definição do tipo para representar o conteúdo do banco de registradores
   type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   -- Declaração de uma variável para armazenar o banco de registradores
   signal mem: ramtype;
   -- Declaração de um arquivo para saída dos resultados
   file file_RESULTS : text;
begin
   -- Processo sensível à borda de subida do sinal de clock (clk)
   process(clk) 
   begin
      -- Verifica se a escrita está habilitada (we3 = '1')
      if rising_edge(clk) then
         if we3 = '1' then
            -- Escreve no banco de registradores na posição especificada por wa3
            mem(to_integer(wa3)) <= wd3;
         end if;
      end if;
   end process;

   -- Processo sensível a todas as entradas (all)
   process(all) begin
      -- Leitura do banco de registradores na posição especificada por ra1
      if to_integer(ra1) = 0 then
         rd1 <= X"00000000"; -- Se ra1 for 0, retorna zero (registrador 0)
      else
         rd1 <= mem(to_integer(ra1));
      end if;

      -- Leitura do banco de registradores na posição especificada por ra2
      if to_integer(ra2) = 0 then
         rd2 <= X"00000000"; -- Se ra2 for 0, retorna zero (registrador 0)
      else
         rd2 <= mem(to_integer(ra2));
      end if;
   end process;
	
   -- Processo para escrever o conteúdo do banco de registradores em um arquivo
   process(mem) is
      variable v_OLINE: line;
   begin 
      -- Abre o arquivo de resultados para escrita
      file_open(file_RESULTS, "regoutput.txt", write_mode);
      -- Loop sobre todos os registradores e escreve seus conteúdos no arquivo
      for i in 0 to 31 loop
         write(v_OLINE, i);
         write(v_OLINE, " : ");
         write(v_OLINE, mem(i));
         writeline(file_RESULTS, v_OLINE);
      end loop;
      -- Fecha o arquivo após escrever todos os dados
      file_close(file_RESULTS);
   end process;
end behave;
