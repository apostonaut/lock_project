# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns Controller.v	

# Load simulation using rate_divider as the top level simulation module.
vsim Controller

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
# Controller(storeButton, inputButton, submitButton, system_reset, *compareSignal, *resetSignal, pass_len, *out_hex, doneCompare, *ld_input, *ld_pass);
force {system_reset} 0
run 10ns

force {doneCompare} 0
force {system_reset} 1
# password is size 4
force {pass_len[0]} 0
force {pass_len[1]} 0
force {pass_len[2]} 1

force inputButton 0 0, 1 10 -repeat 20
run 80ns

force {submitButton} 1
run 10ns
# should output compareSignal = 1

force {doneCompare} 1
run 10ns


force {doneCompare} 0
run 10ns

force inputButton 0 0, 1 10 -repeat 20
run 100ns