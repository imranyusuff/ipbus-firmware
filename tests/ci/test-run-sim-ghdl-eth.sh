#!/usr/bin/env bash
#-------------------------------------------------------------------------------
#
#   Copyright 2017 - Rutherford Appleton Laboratory and University of Bristol
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#                                     - - -
#
#   Additional information about ipbus-firmare and the list of ipbus-firmware
#   contacts are available at
#
#       https://ipbus.web.cern.ch/ipbus
#
#-------------------------------------------------------------------------------


function print_log_on_error {
  set +x
  echo " ----------------------------------------------------"
  echo " ----------------------------------------------------"
  echo "ERROR occurred. Printing simulation output before bailing"
  #cat ${SIM_LOGFILE}
  tail -n 20 ${SIM_LOGFILE}
}


SH_SOURCE=${BASH_SOURCE}
IPBUS_PATH=$(cd $(dirname ${SH_SOURCE})/../.. && pwd)
WORK_ROOT=$(cd ${IPBUS_PATH}/../.. && pwd)

SIM_LOGFILE=sim_output.txt

PROJ=ci_sim_ghdl_eth
cd ${WORK_ROOT}
rm -rf proj/${PROJ}
echo "#------------------------------------------------"
echo "Building Project ${PROJ}"
echo "#------------------------------------------------"

ipbb proj create sim ${PROJ} ipbus-firmware:projects/example top_sim_ghdl_eth.dep
cd proj/${PROJ}
#ipbb sim setup-simlib
#ipbb sim ipcores
ipbb sim ghdl-vhpidirect-eth
ipbb sim generate-project -t ghdl -s analyze.sh

set -x
mkdir work
source analyze.sh
#ghdl -e --workdir=work -Wl,mac_vhpidirect.so -gIP_ADDR='X"c0a8e709"' top
ghdl -e --workdir=work -Wl,mac_vhpidirect.so top
#./top --stop-time=60sec -gIP_ADDR='X"c0a8e709"' > ${SIM_LOGFILE} 2>&1 &
./top --stop-time=60sec > ${SIM_LOGFILE} 2>&1 &
SIM_PID=$!
SIM_PGRP=$(ps -p ${SIM_PID} -o pgrp=)
trap print_log_on_error EXIT

# ait for the simulation to start
sleep 10
# tickle the simulation
#ping 192.168.231.9 -c 5
ping 192.168.231.128 -c 5
# Cleanup, send SIGINT to the vsimk process in the current process group
#pkill -SIGINT -g ${SIM_PGRP} vsimk
kill $SIM_PID
set +x
# fi

exit 0
