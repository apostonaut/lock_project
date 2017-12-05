module dec_lock (LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX5, HEX4, KEY, CLOCK_50);
	input [3:0] KEY;
	// SW[9] to toggle between displaying the inputted password and the stored password
	// SW[3:0] for pw character input
	input [9:0] SW;
	output [9:0] LEDR;
	input CLOCK_50;
	//HEX display 4-char password
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	

//wires for connections between modules go here:
	wire compare, store_value, input_value, correct_pw, invalid_pw,
	sleep, end_sleep, input_reset, system_reset;
	
	wire[1:0] reg0, reg1, reg2, reg3; 
	wire[3:0] currentState;
	
//instantiate hex decoder modules: note that HEX0 corresponds to reg3, since the reg array is in reverse order of HEXes
	hexCode h0( .hex(HEX0), .sw(reg3));
	hexCode h1( .hex(HEX1), .sw(reg2));
	hexCode h2( .hex(HEX2), .sw(reg1));
	hexCode h3( .hex(HEX3), .sw(reg0));
	
	hexCode h5( .hex(HEX5), .sw(currentState));
	
	
//instantiate controller module
controller_working controller	(	
				.storeButton(~KEY[3]), 
				.inputButton(~KEY[2]), 
				.submitButton(~KEY[1]), 
				.system_reset(~KEY[0]),
				.input_reset(input_reset),
			 	.clk(CLOCK_50),
			 	.correct_password(~correct_pw),
			 	.invalid_password(~invalid_pw),
				 .end_sleep(end_sleep),
				 .cur_state(currentState),
				 
			 /*OUTPUTS*/
				 .input_value(input_value),
				 .store_value(store_value),
				 .compare(compare),
				 .unlock(LEDR[9]),
				 .sleep(sleep)

			 //.pass_len(2'd3), NEED TO ADD THIS FEATURE 
					);
	
code_checker c0( 
	
	.input_value(input_value), //signal from Controller, store value in input register
	.store_value(store_value), //signal from Controller, store value in system register
	.compare(compare), 	// activates compare operation on posedge compare
	.input_reset(input_reset), //high when done comparing
	.system_reset(~KEY[0]), //two different reset signals from Controller
	.display_pw(SW[9]),
	.bits(SW[1:0]),
	
	.hex(HEX4), //
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
	
rate_divider sleep_module (
	.clk(CLOCK_50), 
	.sleep(sleep),
	.end_sleep(end_sleep)
	);
	
	assign LEDR[5] = correct_pw;
	assign LEDR[4] = invalid_pw;
	assign LEDR[3] = compare;
	assign LEDR[8] = input_value;
	assign LEDR[7] = store_value;
endmodule

module rate_divider(
	input clk, sleep,
	
	output reg end_sleep
		);
		
	reg [3:0] counter;	

	always @(posedge clk) begin
		// as long as sleep signal is 0, values stay at 0
		if (!sleep) begin
			counter <= 0;
			end_sleep <= 0;
		end
		// once counter reaches a certain value, send controller end_sleep signal
		else if (counter == 4'b1111) begin
			end_sleep <= 1;
		end
		// once sleep goes high, counter begins counting
		else if (sleep) begin
			counter <= counter + 1'b1;
		end
		// on next clock edge, reset back to 0
		else if (end_sleep == 1) begin
			end_sleep <= 0;
			counter <= 0;
		end

	end
	
endmodule

module controller_working
(
	input storeButton, inputButton, submitButton, system_reset, clk, 
			correct_password, invalid_password, end_sleep,
			
	output reg input_value, store_value, compare, unlock, sleep, input_reset,
	output [3:0] cur_state
);

	// Declare state register
	reg		[4:0]currentState;
	reg 		[1:0]num_attempts;
	
	// Declare states
	parameter 	
					max_attempts = 1,
					
					nothingState = 0, inputState = 1,
					waitInputState = 2,
					compareState = 3, storeState = 4,
					waitStoreState = 5, storePasswordState = 6,
					successOrFailureState = 7, unlockState = 10,
					checkAttemptsState = 8, sleepState = 9;
	
	assign cur_state = currentState;
	
	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge system_reset) begin
		if (system_reset)
		begin
			currentState <= nothingState;
			num_attempts <= 2'b0;
		end
		else
			case (currentState)
				nothingState: begin
						if (inputButton)
						begin
							currentState <= inputState;
						end
						else if (storeButton)
						begin
							currentState <= storeState;
						end
						else
						begin
							currentState <= nothingState;
						end
					end
				inputState:
					if (inputButton)
					begin
						currentState <= inputState;
					end
					else
					begin
						currentState <= waitInputState;
					end
						
				waitInputState:
						if (submitButton)
						begin
							currentState <= compareState;
						end
						else if (inputButton)
						begin
							currentState <= inputState;
						end
						else
							currentState <= waitInputState;
							
				compareState:
						if (submitButton)
						begin
							currentState <= compareState;
						end
						else
						begin
							currentState <= successOrFailureState;
						end
						
				//waits for signal from code checker saying whether p/w matches
				successOrFailureState: 
					begin
						if (correct_password)
						begin
							currentState <= unlockState;
						end
						else if(invalid_password)
						begin
							currentState <= checkAttemptsState;
							num_attempts <= num_attempts + 1'b1;
						end
						else
						begin
							currentState <= successOrFailureState;
						end
					end
				//code_checker needs to send a pulse of correct_password
				unlockState:
					if (correct_password)
					begin
						currentState <= unlockState;
					end
					else
					begin
						currentState <= nothingState;
					end
					
					
				checkAttemptsState:
					if (num_attempts == max_attempts)
					begin
						currentState <= sleepState;
					end
					else
					begin
						currentState <= nothingState;
					end
				
				sleepState:
					if (end_sleep)
					begin
						currentState <= nothingState;
					end
					else
					begin
						currentState <= sleepState;
					end
						
				storeState:
					if (storeButton)
					begin
						currentState <= storeState;
					end
					else
					begin
						currentState <= waitStoreState;
					end
					
				waitStoreState:
					if (storeButton)
					begin
						currentState <= storeState;
					end
					else if (submitButton)
					begin
						currentState <= storePasswordState;
					end
					else
					begin
						currentState <= waitStoreState;
					end
					
				storePasswordState:
					if (submitButton)
					begin
						currentState <= storePasswordState;
					end
					else
					begin
						currentState <= nothingState;
					end
				
				default:
					currentState <= nothingState;
			endcase
	end
	
	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (currentState or inputButton or storeButton)
	begin
		case (currentState)
		
			nothingState: 
				begin
					input_reset = 0;
					if (inputButton)
					begin
						input_value = 0;
					end
					else if (storeButton)
					begin
						store_value = 0;
					end
					else
					begin
						input_value = 0;
						store_value = 0;
						compare = 0;
						unlock = 0;
						sleep = 0;
					end
				end
			
			inputState:	
				begin
					input_value = 1;
				end
				
			waitInputState:
				begin
					input_value = 0;
				end
				
			compareState:
				begin
					compare = 1;
				end
			successOrFailureState:
				begin
					compare = 1;
				end
			
			unlockState:
				begin
					input_reset = 1;
					compare = 0;
					unlock = 1;
				end
				
			checkAttemptsState:
				begin
					input_reset = 1;
					compare = 0;
				end
			sleepState:
				begin
					sleep = 1;
				end
			
			storeState:
				begin
					store_value = 1;
				end
				
			waitStoreState:
				begin
					store_value = 0;
				end
				
			default: 
				begin
					input_value = 0;
					store_value = 0;
					compare = 0;
				end
		endcase
	end
endmodule

module code_checker(
		input 
		input_value, //signal from Controller, store value in input register
		store_value, //signal from Controller, store value in system register
		compare, 	// activates compare operation on posedge compare
		input_reset, system_reset, //two different reset signals from Controller
		display_pw,	//input from SW[9] that signals to display either user p/w or sys p/w
		input [3:0]bits, 
		
		/*output [1:0]in_test0, in_test1, in_test2, in_test3, 
		sys_test0, sys_test1, sys_test2, sys_test3,*/
		output reg [3:0] reg3, reg2, reg1, reg0,   
		output hex,
		output reg correct_password, incorrect_password //result of compare operation
		);
	
	
	hexCode h4( .hex(hex), .sw(num_inputs));
	
	
	reg [1:0] num_inputs;
	reg [3:0] pw_length;
	//integer max_pw_length = 3;
	integer index;
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	reg [3:0] pw_in0, pw_in1,pw_in2,pw_in3;
	reg [3:0] pw_sys0, pw_sys1, pw_sys2, pw_sys3;
	
	//ASSIGN VALUES OF pw_in
	always @(posedge input_value or posedge input_reset or posedge system_reset or posedge store_value or posedge compare) begin
		//MUST begin by resetting system in order for this to work!!
		if (input_reset) begin
			num_inputs <= 0;
			correct_password <= 0;
			incorrect_password <= 0;

			pw_in0 <= 4'd0;
			pw_in1 <= 4'd0;
			pw_in2 <= 4'd0;
			pw_in3 <= 4'd0;
		end
		
		else if (system_reset) begin
			num_inputs <= 0;
			correct_password <= 0;
			incorrect_password <= 0;
			pw_length <= 0;

			pw_sys0 <= 4'd0;
			pw_sys1 <= 4'd0;
			pw_sys2 <= 4'd0;
			pw_sys3 <= 4'd0;

			pw_in0 <= 4'd0;
			pw_in1 <= 4'd0;
			pw_in2 <= 4'd0;
			pw_in3 <= 4'd0;
		end
		
		else if (input_value) begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			if (num_inputs == 4'd0) begin
			num_inputs <= num_inputs + 1'b1;		
			pw_in0 <= bits;
			end
			else if (num_inputs == 4'd1)begin
			num_inputs <= num_inputs + 1'b1;		
			pw_in1 <= bits;
			end
			else if (num_inputs == 4'd2)begin
			num_inputs <= num_inputs + 1'b1;		
			pw_in2 <= bits;
			end
			else begin
			num_inputs <= num_inputs + 1'b1;		
			pw_in3 <= bits;
			end
			
		end
		
		else if (store_value) begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			if (pw_length == 4'd0) begin
				pw_sys0 <= bits;
				pw_length <= pw_length + 1'b1;
			end
			
			else if (pw_length == 4'd1) begin
				pw_sys1 <= bits;
				pw_length <= pw_length + 1'b1;
			end
			
			else if (pw_length == 4'd2) begin
				pw_sys2 <= bits;
				pw_length <= pw_length + 1'b1;
			end	
			
			else begin
				pw_sys3 <= bits;
				pw_length <= pw_length + 1'b1;
			end
		
		end
		
		else begin		
			// ASSIGN VALUES FOR RESULT OF PASSWORD COMPARE
			if ({pw_in0,pw_in1,pw_in2,pw_in3} == {pw_sys0,pw_sys1,pw_sys2,pw_sys3})
				begin
					correct_password <= 1;
					incorrect_password <= 0;
				end
			else
				begin
					correct_password <= 0;
					incorrect_password <= 1;
				end
		end
	end
	
	//output reg[3:0] reg3, reg2, reg1, reg0
	always @ (*) begin
		if(display_pw)begin
			{reg0, reg1, reg2, reg3} = {pw_in0,pw_in1,pw_in2,pw_in3};
		end
		else begin
			{reg0, reg1, reg2, reg3} = {pw_sys0,pw_sys1,pw_sys2,pw_sys3};
		end
		
	end

	always @(posedge compare) begin
		{pw_in0,pw_in1,pw_in2,pw_in3} == {pw_sys0,pw_sys1,pw_sys2,pw_sys3};
	end

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

