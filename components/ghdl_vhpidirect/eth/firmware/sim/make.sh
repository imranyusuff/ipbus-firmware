#!/usr/bin/env sh

set -e

cd $(dirname "$0")

gcc -g -D TAP_DEV=tap0 -c mac_vhpidirect.c -o mac_vhpidirect.o
ghdl -a eth_mac_sim.vhd tb_eth_mac_sim.vhdl
ghdl -e -Wl,-g -Wl,mac_vhpidirect.o tb_eth_mac_sim
