library IEEE;
use IEEE.STD_LOGIC_1164.all;

/* Junção dos sinais de controle de cada componente já definidos dentros dos seus respectivos decoders*/

entity controladora is
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
end entity;

architecture struct of controladora is
   -- Declaração dos componentes principais (maindec e aluDecoder)
   component mainDecoder
      port(
         op: in STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch,branchNotEqual, alusrc: out STD_LOGIC;
         regdst, regwrite: out STD_LOGIC;
         jump: out STD_LOGIC;
         aluop: out STD_LOGIC_VECTOR(1 downto 0)
      );
   end component;

   component aluDecoder
      port(
         funct: in STD_LOGIC_VECTOR(5 downto 0);
         aluop: in STD_LOGIC_VECTOR(1 downto 0);
     	 jumpRegister: out STD_LOGIC;
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0)
      );
   end component;

   -- Declaração de sinais intermediários
   signal aluop: STD_LOGIC_VECTOR(1 downto 0);
   signal branch, branchNotEqual: STD_LOGIC;

begin
   -- Instanciação dos componentes maindec e aludec
   md: mainDecoder port map(
      op, memtoreg, memwrite, branch,branchNotEqual,
      alusrc, regdst, regwrite, jump, aluop
   );

   ad: aluDecoder port map(
      funct, aluop, jumpRegister, alucontrol
   );

   -- Lógica de controle para a seleção do próximo valor do PC (Program Counter)

   pcsrc <= (branch and zero) or (branchNotEqual and (not zero));

end architecture;
