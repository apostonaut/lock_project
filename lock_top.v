module lock_top (LEDR, SW, HEX1, KEY);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [7:0] HEX1;

//wires for connections between modules go here:
	wire compare, store_value, input_value, correct_pw, invalid_pw,
	sleep, end_sleep, input_reset, system_reset;
	


//instantiate modules
controller_working controller	(	.storeButton(~KEY[3]), 
				.inputButton(~KEY[2]), 
				.submitButton(~KEY[1]), 
				.system_reset(~KEY[0]),
			 .clk(CLOCK_50),
			 .correct_password(correct_pw),
			 .invalid_password(invalid_pw),
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
	
	/*
	wire compare, store_value, input_value, correct_pw, invalid_pw,
	sleep, end_sleep, input_reset, system_reset;*/
module code_checker( 
	.input_value(input_value), //signal from Controller, store value in input register
	.store_value(store_value), //signal from Controller, store value in system register
	.compare(compare), 	// activates compare operation on posedge compare
	.input_reset(input_reset), //high when 
	.system_reset(system_reset), //two different reset signals from Controller
	.bits(SW[1:0]), 
		/*.in_test0(), 
		.in_test1(), 
		.in_test2(), 
		.in_test3(), 
		.sys_test0(), 
		.sys_test1(), 
		.sys_test2(), 
		.sys_test3(),*/
		.correct_password(correct_pw), 
		.incorrect_password(invalid_pw) //result of compare operation
		);
					
code_checker c0();

setup_panel s0();

endmodule

