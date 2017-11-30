# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns rate_divider.v

# Load simulation and define top level module
vsim rate_divider

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# start with setting to 0
force {clk} 0
force {sleep} 0
run 5ns

# simulate one clock edge to set counter and end_sleep to 0
force {clk} 1
run 5ns
force {clk} 0
run 5ns

# send sleep signal from controller to start counting
force {sleep} 1

# run clock freely to fill up counter to max value
force clk 0 0, 1 1 -repeat 2
run 50ns
force {clk} 0

# force sleep to 0 to reset divider
force {sleep} 0
run 5ns
