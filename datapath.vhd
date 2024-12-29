library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

/* Aqui é feita toda a lógica do caminho de dados, juntamente com a lógica dos componentes e do PC */

entity datapath is
   port(
      clk, reset: in STD_LOGIC;
      memtoreg, pcsrc: in STD_LOGIC;
      alusrc, regdst: in STD_LOGIC;
      regwrite, jump, jumpRegister: in STD_LOGIC;
      alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
      zero: out STD_LOGIC;
      pc: buffer STD_LOGIC_VECTOR(31 downto 0);
      instr: in STD_LOGIC_VECTOR(31 downto 0);
      aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
      readdata: in STD_LOGIC_VECTOR(31 downto 0);
   );
end entity;

architecture struct of datapath is
   -- Declaração de componentes
   component alu
      port(
         a, b: in STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
         result: buffer STD_LOGIC_VECTOR(31 downto 0);
         zero: out STD_LOGIC
      );
   end component;

   component registerFile
      port(
         clk: in STD_LOGIC;
         we3: in STD_LOGIC;
         ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
         wd3: in STD_LOGIC_VECTOR(31 downto 0);
         rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component somador
      port(
         a, b: in STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component shiftLeftLogic
      port(
         a: in STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component signalExtension
      port(
         a: in STD_LOGIC_VECTOR(15 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0)
      );
   end component;

   component flipFlop
      generic(width: integer);
      port(
         clk, reset: in STD_LOGIC;
         d: in STD_LOGIC_VECTOR(width-1 downto 0);
         q: out STD_LOGIC_VECTOR(width-1 downto 0)
      );
   end component;

   component multiplexor
      generic(width: integer);
      port(
         d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
         s: in STD_LOGIC;
         y: out STD_LOGIC_VECTOR(width-1 downto 0)
      );
   end component;

   -- Sinais intermediários
   signal writereg, writeJAL: STD_LOGIC_VECTOR(4 downto 0);
   signal pcjump, pcnext, pcnextbr, pcplus4, pcbranch, pcNextBeforeJR, JALorResult: STD_LOGIC_VECTOR(31 downto 0);
   signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
   signal srca, srcb, result: STD_LOGIC_VECTOR(31 downto 0);

begin
   -- Lógica do próximo PC
   pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
   pcreg: flipFlop generic map(32) port map(clk, reset, pcnext, pc);
   pcadd1: somador port map(pc, X"00000004", pcplus4);
   immsh: shiftLeftLogic port map(signimm, signimmsh);
   pcadd2: somador port map(pcplus4, signimmsh, pcbranch);
   pcbrmux: multiplexor generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);
   pcmux: multiplexor generic map(32) port map(pcnextbr, pcjump, jump, pcNextBeforeJR);
   pcJumpRegisterMux: multiplexor generic map(32) port map (pcNextBeforeJR, srca, jumpRegister, pcnext);

   -- Lógica do registrador
   rf: registerFile port map(clk, regwrite, instr(25 downto 21), instr(20 downto 16), writeJAL, JALorResult, srca, writedata);
   wrmux: multiplexor generic map(5) port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg);
   resmux: multiplexor generic map(32) port map(aluout, readdata, memtoreg, result);
   muxjalres : multiplexor generic map(32) port map(result, pcplus4, jump, JALorResult);
   muxjalra : multiplexor generic map(5) port map(writereg, "11111", jump, writeJAL);
   se: signalExtension port map(instr(15 downto 0), signimm);

   -- Lógica da ALU
   srcbmux: multiplexor generic map(32) port map(writedata, signimm, alusrc, srcb);
   mainalu: alu port map(srca, srcb, alucontrol, aluout, zero);

end;
