#!/bin/bash

# Navigate to the script directory
cd "$(dirname "$0")"

# Compile CPU components
ghdl -a CPU_components/*.vhd

# Compile CPU testbench
ghdl -a Testbenches/CPU_TB.vhd

# Elaborate testbench
ghdl -e CPU_TB

# Run simulation and generate waveform
ghdl -r CPU_TB --vcd=cpu_wave.vcd

echo "Simulation complete. Waveform saved to cpu_wave.vcd"
echo "You can view it with GTKWave: gtkwave cpu_wave.vcd"
