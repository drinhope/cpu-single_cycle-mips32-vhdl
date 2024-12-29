cd /home/runner
export PATH=/usr/bin:/bin:/tool/pandora64/bin:/usr/share/Riviera-PRO/bin:/usr/local/bin
export RIVIERA_HOME=/usr/share/Riviera-PRO
export CPLUS_INCLUDE_PATH=/usr/share/Riviera-PRO/interfaces/include
export ALDEC_LICENSE_FILE=27009@10.116.0.5
export HOME=/home/runner
vlib work && vcom '-2019' '-o' dataMemory.vhd InstructionMemory.vhd controladora.vhd datapath.vhd mips.vhd mainDecoder.vhd aluDecoder.vhd registerFile.vhd somador.vhd shiftLeftLogic.vhd signalExtension.vhd flipFlop.vhd multiplexor.vhd alu.vhd design.vhd top.vhd testbench.vhd  && vsim -c -do "vsim testbench; run -all; exit"  ; echo 'Creating result.zip...' && zip -r /tmp/tmp_zip_file_123play.zip . && mv /tmp/tmp_zip_file_123play.zip result.zip