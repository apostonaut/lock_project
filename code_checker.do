# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns code_checker.v

# Load simulation using datapath as top level module
vsim code_checker

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# reset to load defaults
force {resetn} 0 
run 10ns

force {input_value} 0
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

force {resetn} 1
run 10ns

# set 4 registers to password 3210
force {bits[1]} 1
force {bits[0]} 1
run 10ns

force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

force {bits[1]} 1
force {bits[0]} 0
run 10ns

force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

force {bits[1]} 0
force {bits[0]]} 1
run 10ns

force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

force {bits[1]} 0
force {bits[0]} 0
run 10ns

force {input_value} 1
run 10ns
force {input_value} 0
run 10ns


#force clk 0 0, 1 10 -repeat 20
#run 200ns




