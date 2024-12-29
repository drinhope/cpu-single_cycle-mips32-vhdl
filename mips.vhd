library IEEE;
use IEEE.STD_LOGIC_1164.all;

/* Esse arquivo é basicamente a junção de todo componente estrutural do
processador, nele são unidos o caminho de dados, a controladora e seus sinais*/

entity mips is
   port(
      clk, reset: in STD_LOGIC;
      pc: out STD_LOGIC_VECTOR(31 downto 0);
      instr: in STD_LOGIC_VECTOR(31 downto 0);
      memwrite: out STD_LOGIC;
      aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
      readdata: in STD_LOGIC_VECTOR(31 downto 0)
   );
end entity;

architecture struct of mips is
   -- Instanciação do componente Controladora
   component controladora
      port(
         op, funct: in STD_LOGIC_VECTOR(5 downto 0);
         zero: in STD_LOGIC;
         memtoreg, memwrite: out STD_LOGIC;
         pcsrc, alusrc: out STD_LOGIC;
         regdst, regwrite: out STD_LOGIC;
         jump: out STD_LOGIC;
         jumpRegister: out STD_LOGIC;
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0)
      );
   end component;

   -- Instanciação do componente datapath
   component datapath
      port(
         clk, reset: in STD_LOGIC;
         memtoreg, pcsrc, alusrc, regdst, regwrite, jump, jumpRegister: in STD_LOGIC;
         alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
         zero: out STD_LOGIC;
         pc: buffer STD_LOGIC_VECTOR(31 downto 0);
         instr: in STD_LOGIC_VECTOR(31 downto 0);
         aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
         readdata: in STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   -- Sinais de controle
   signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc, jumpRegister: STD_LOGIC;
   signal zero: STD_LOGIC;
   signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);

begin
   -- Instanciação do controlador
   cont: controladora port map(
      instr(31 downto 26),
      instr(5 downto 0),
      zero,
      memtoreg,
      memwrite,
      pcsrc,
      alusrc,
      regdst,
      regwrite,
      jump,
      jumpRegister,
      alucontrol
   );

   -- Instanciação do datapath
   dp: datapath port map(
      clk,
      reset,
      memtoreg,
      pcsrc,
      alusrc,
      regdst,
      regwrite,
      jump,
      jumpRegister,
      alucontrol,
      zero,
      pc,
      instr,
      aluout,
      writedata,
      readdata
   );

end architecture;
