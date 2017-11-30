module lock_top (LEDR, SW, HEX0, HEX1, HEX2, HEX3, KEY, CLOCK_50);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	//HEX display 4-char password
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;

	//IDEA:perhaps we can use SW[9] to toggle between displaying the inputted password and the stored password
	
//wires for connections between modules go here:
	wire compare, store_value, input_value, correct_pw, invalid_pw,
	sleep, end_sleep, input_reset, system_reset;
	


//instantiate modules
controller_working controller	(	
				.storeButton(~KEY[3]), 
				.inputButton(~KEY[2]), 
				.submitButton(~KEY[1]), 
				.system_reset(~KEY[0]),
			 	.clk(CLOCK_50),
			 	.correct_password(correct_pw),
			 	.invalid_password(invalid_pw),
				 .end_sleep(end_sleep),
				 
			 /*OUTPUTS*/
				 .input_value(input_value),
				 .store_value(store_value),
				 .compare(compare),
				 .unlock(unlock),
				 .sleep(sleep)

			 //.pass_len(2'd3), NEED TO ADD THIS FEATURE 
					);
	
code_checker c0( 
	
	.input_value(input_value), //signal from Controller, store value in input register
	.store_value(store_value), //signal from Controller, store value in system register
	.compare(compare), 	// activates compare operation on posedge compare
	.input_reset(input_reset), //high when 
	.system_reset(system_reset), //two different reset signals from Controller
	.bits(SW[1:0]), 
		
		.HEX0(), //display 4th char of password
		.HEX1(), 
		.HEX2(), 
		.HEX3(), // display 1st char of password
		/* 
		.sys_test0(), 
		.sys_test1(), 
		.sys_test2(), 
		.sys_test3(),*/
		.correct_password(correct_pw), 
		.incorrect_password(invalid_pw) //result of compare operation
		);
	
rate_divider sleep (
	.clk(CLOCK_50), 
	.sleep(sleep),
	.end_sleep(end_sleep)
	);

endmodule

