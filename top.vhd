library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

--add, sub, and, or, slt, addi, lw, sw, beq, j

entity top is -- design top-level para testes
   port(
      clk, reset: in STD_LOGIC;
      writedata, dataadr: buffer STD_LOGIC_VECTOR(31 downto 0);
      memwrite: buffer STD_LOGIC;
      stop: out STD_LOGIC
   );
end entity;

architecture test of top is
   component mips
      port(
         clk, reset: in STD_LOGIC;
         pc: out STD_LOGIC_VECTOR(31 downto 0);
         instr: in STD_LOGIC_VECTOR(31 downto 0);
         memwrite: out STD_LOGIC;
         aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
         readdata: in STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component InstructionMemory
      port(
         a: in STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component dataMemory
      port(
         clk, we: in STD_LOGIC;
         a, wd: in STD_LOGIC_VECTOR(31 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0);
         bytectrl: in STD_LOGIC
      );
   end component;

   signal pc, instr, readdata: STD_LOGIC_VECTOR(31 downto 0);
   signal bytectrl: STD_LOGIC;

begin
   -- Instanciação do processador e memórias
   mips1: mips port map(
      clk, reset, pc, instr, memwrite,
      dataadr, writedata, readdata
   );

   InstructionMemory1: InstructionMemory port map(
      pc(7 downto 2), instr
   );

   dataMemory1: dataMemory port map(
      clk, memwrite, dataadr, writedata, readdata, bytectrl
   );
   
   -- Lógica para parar a simulação quando encontrar a instrução específica
   process (instr)
   begin
   
      stop <= '0';
      if instr = "00000000000000000000000000001100" then
         stop <= '1';
      end if;
      
      --Lógica para seleção da instrução LB/SB ou LW/SW
      if instr(27 downto 26) = "00" then
      	bytectrl <='1';
      else
      	bytectrl <='0';
      end if;
      
   end process;
   
end architecture;
