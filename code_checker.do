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

#set defaults for signals
force {input_value} 0
force {store_value} 0
force {input_reset} 1
force {system_reset} 1
force {compare} 0
run 10ns

#######
#LOAD SYSTEM PASSWORD (3212)
#######
# reset to clear input and system registers
force {system_reset} 0 
run 10ns
force {system_reset} 1
run 10ns

# set pw_in[0]
force {bits[1]} 1
force {bits[0]} 1
run 10ns
force {store_value} 1
run 10ns
force {store_value} 0
run 10ns

# set pw_in[1]
force {bits[1]} 1
force {bits[0]} 0
run 10ns
force {store_value} 1
run 10ns
force {store_value} 0
run 10ns

# set pw_in[2]
force {bits[1]} 0
force {bits[0]]} 1
run 10ns
force {store_value} 1
run 10ns
force {store_value} 0
run 10ns

# set pw_in[3]
force {bits[1]} 1
force {bits[0]} 0
run 10ns
force {store_value} 1
run 10ns
force {store_value} 0
run 10ns

#######
#LOAD INPUT PASSWORD (3012)
#######

# reset to clear input register
force {input_reset} 0 
run 10ns
force {input_reset} 1
run 10ns

# set pw_in[0]
force {bits[1]} 1
force {bits[0]} 1
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[1]
force {bits[1]} 0
force {bits[0]} 0
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[2]
force {bits[1]} 0
force {bits[0]]} 1
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[3]
force {bits[1]} 1
force {bits[0]} 0
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# PERFORM COMPARE
force {compare} 1
run 10ns
force {compare} 0
run 10ns

# reset to clear input register
force {input_reset} 0 
run 10ns
force {input_reset} 1
run 10ns

#######
#LOAD INPUT PASSWORD (3212)
#######

# reset to clear input register
force {input_reset} 0 
run 10ns
force {input_reset} 1
run 10ns

# set pw_in[0]
force {bits[1]} 1
force {bits[0]} 1
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[1]
force {bits[1]} 1
force {bits[0]} 0
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[2]
force {bits[1]} 0
force {bits[0]]} 1
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# set pw_in[3]
force {bits[1]} 1
force {bits[0]} 0
run 10ns
force {input_value} 1
run 10ns
force {input_value} 0
run 10ns

# PERFORM COMPARE
force {compare} 1
run 10ns
force {compare} 0
run 10ns

# reset to clear entire system
force {system_reset} 0 
run 10ns
force {system_reset} 1
run 10ns


