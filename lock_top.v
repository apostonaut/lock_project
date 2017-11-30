module lock_top (LEDR, SW, HEX1, KEY);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [7:0] HEX1;

//wires for connections between modules go here:
	wire compare, store_value, input_value, correct_pw, invalid_pw,
	sleep, end_sleep;
	


//instantiate modules
controller_working controller	(	.storeButton(~KEY[3]), 
				.inputButton(~KEY[2]), 
				.submitButton(~KEY[1]), 
				.system_reset(~KEY[0]),
			 .clk(CLOCK_50),
			 .correct_password(),
			 .invalid_password(),
			 .end_sleep(),
			 /*OUTPUTS*/
			 .input_value(),
			 .store_value(),
			 .compare(),
			 .unlock(),
			 .sleep()

			 //.pass_len(2'd3), NEED TO ADD THIS FEATURE 
				);
	
/*
module fsm_test
(
	input storeButton, inputButton, submitButton, system_reset, clk, 
			correct_password, invalid_password, end_sleep,
			
	output reg input_value, store_value, compare, unlock, sleep
);
*/
module code_checker( 
	.input_value(), //signal from Controller, store value in input register
	.store_value(), //signal from Controller, store value in system register
	.compare(), 	// activates compare operation on posedge compare
	.input_reset(), //high when 
		.system_reset(), //two different reset signals from Controller
		.bits(), 
		/*.in_test0(), 
		.in_test1(), 
		.in_test2(), 
		.in_test3(), 
		.sys_test0(), 
		.sys_test1(), 
		.sys_test2(), 
		.sys_test3(),*/
		.correct_password(), 
		.incorrect_password() //result of compare operation
		);
					
code_checker c0();

setup_panel s0();

endmodule

