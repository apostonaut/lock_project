# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns fsm_test.v

# Load simulation and define top level module
vsim fsm_test

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# force all buttons to be off (i.e. not pressed)
force {inputButton} 0
force {submitButton} 0
force {storeButton} 0
force {clk} 0
run 10ns

# reset to load defaults on posedge system_reset
force {system_reset} 1
run 10ns
force {system_reset} 0
run 10ns

# TEST to make sure we stay in nothingState
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# nothingState --> inputState
force {inputButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# inputState --> wainputState
#run 10ns
force {inputButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# waitInputState --> inputState
force {inputButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# inputState --> waitInputState
force {inputButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# waitInputState --> submitState
force {submitButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# submitState --> nothingState
force {submitButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# nothingState --> storeState
force {storeButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# storeState --> waitStoreState
force {storeButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# waitStoreState --> storeState
force {storeButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# storeState --> waitStoreState
force {storeButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns


# waitStoreState --> storePasswordState
force {submitButton} 1
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns

# storePasswordState --> nothingState
force {submitButton} 0
run 10ns
force {clk} 1
run 10ns
force {clk} 0
run 10ns


#force clk 0 0, 1 10 -repeat 20
#run 20ns