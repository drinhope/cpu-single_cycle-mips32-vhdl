library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity InstructionMemory is
   port(
      a: in STD_LOGIC_VECTOR(5 downto 0);
      rd: out STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture behave of InstructionMemory is
begin
   process is
      -- Declaração de variáveis para leitura de arquivo e manipulação de dados
      file mem_file: TEXT;
      variable L: line;
      variable ch: character;
      variable i, index, result: integer;
      
      -- Definição do tipo de RAM e variável para armazenamento da memória
      type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
      variable mem: ramtype;
   begin
      -- Inicialização da memória com todos os valores em '0'
      for i in 0 to 63 loop
         mem(i) := (others => '0');
      end loop;

      index := 0;
      
      -- Abertura do arquivo de memória para leitura
      FILE_OPEN(mem_file, "instrucoes.txt", READ_MODE);
      
      -- Loop de leitura do arquivo
      while not endfile(mem_file) loop
         readline(mem_file, L);
         result := 0;

         -- Loop para processar cada caractere da linha
         for i in 1 to 8 loop
            read(L, ch);

            -- Conversão de caracteres hexadecimais para inteiro
            if '0' <= ch and ch <= '9' then
               result := character'pos(ch) - character'pos('0');
            elsif 'a' <= ch and ch <= 'f' then
               result := character'pos(ch) - character'pos('a') + 10;
            else
               -- Relatório de erro em caso de formato incorreto
               report "Format error on line" & integer'image(index) severity error;
            end if;

            -- Armazenamento dos dados convertidos na posição correta da memória
            mem(index)(35 - i * 4 downto 32 - i * 4) := to_std_logic_vector(result, 4);
         end loop;

         index := index + 1;
      end loop;

      -- Loop de leitura da memória com base no endereço 'a'
      loop
         rd <= mem(to_integer(a));
         wait on a;
      end loop;
   end process;
end behave;
