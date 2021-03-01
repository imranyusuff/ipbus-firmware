This is the reimplementation of ModelSim's FLI code so that it will work on
open-sourced GHDL's VHPIDIRECT interface.

GHDL must be compiled with GCC (or LLVM, but not tested) backend.

Refer to make.sh on how it is usually compiled. This bash script will make the
corresponding testbench tb_eth_mac_sim.vhdl.

Please refer to the original readme on modelsim_fli for how to use this module.

