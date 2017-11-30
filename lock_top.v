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
	
	wire[3:0] reg0, reg1, reg2, reg3;
//instantiate hex decoder modules: note that HEX0 corresponds to reg3, since the reg array is in reverse order of HEXes
	hexCode h0( .hex(HEX0), .sw(reg3));
	hexCode h1( .hex(HEX1), .sw(reg2));
	hexCode h2( .hex(HEX2), .sw(reg1));
	hexCode h3( .hex(HEX3), .sw(reg0));
	
	
//instantiate controller module
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
		
	.reg3(reg3), //rightmost char of password
	.reg2(reg2), 
	.reg1(reg1), 
	.reg0(reg0), // leftmost char of password
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

//HEX MOdULE
module hexCode(output [7:0]hex, input [3:0]sw);
  
  assign hex[0] = (~sw[3] & ~sw[1]) & ((~sw[2] & sw[0]) | (sw[2] & ~sw[0])) |
              (sw[3] & sw[0]) & ((sw[2] & ~sw[1]) | (~sw[2] & sw[1]));
  
  assign hex[1] = (~sw[3] & sw[2]) & ((~sw[1] & sw[0]) | (sw[1] & ~sw[0])) |
              (sw[3]) & ((sw[2] & ~sw[0]) | (sw[1] & sw[0]));
  
  assign hex[2] = (~sw[3] & ~sw[2] & sw[1] & ~sw[0]) |
              (sw[3] & sw[2]) & ((~sw[1] & ~sw[0]) | sw[1]);
  
  assign hex[3] = (~sw[3] & ~sw[1]) & ((sw[2] & ~sw[0]) | (~sw[2] & sw[0])) |
              (sw[1]) & ((sw[2] & sw[0]) | (sw[3] & ~sw[2] & ~sw[0]));
  
  assign hex[4] = (~sw[3]) & (sw[0] | (sw[2] & ~sw[1] & ~sw[0])) | 
              (sw[3] & ~sw[2] & ~sw[1] & sw[0]);
  
  assign hex[5] = (~sw[3] & ~sw[2]) & (sw[1] | (~sw[1] & sw[0])) |
              (sw[3] & sw[2] & ~sw[1] & sw[0]);
  
  assign hex[6] = ~sw[3] & ((~sw[2] & ~sw[1]) | (sw[2] & sw[1] & sw[0])) |
              (sw[3] & sw[2] & ~sw[1] & ~sw[0]);
endmodule

