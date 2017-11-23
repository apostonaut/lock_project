module Controller(storeButton, inputButton, submitButton, system_reset, compareSignal, resetSignal, pass_len, out_hex, doneCompare, ld_input, ld_pass);
	input submitButton;
	input storeButton;
	input inputButton;
	input system_reset; // reset the system??
	input doneCompare; // determines if codeChecker is done comparing
	input pass_len; // setup Panel needs to send in the size of the password

	
	output reg resetSignal; // active low reset which resets all the registers
	output out_hex; // display onto hex
	output reg ld_input; // active high which tells the code checker that you are inputting
	output reg ld_pass; // active high which tells the setup panel that you are creating a password
	output reg compareSignal; 
	
	reg [1:0]num_attempts;
	reg [4:0]currentState;
	reg [4:0]nextState;
	
	localparam 	nothingState = 4'd0,
	
					inputState = 4'd1,
					waitInputState = 4'd2,
					
					submitState = 4'd3,
					
					storeState = 4'd5,
					waitStoreState = 4'd6,
					
					compareState = 4'd7,
					
					noCompareState = 4'd8,
					
					sleepState = 4'd9;
	
	// IF THE READ BUTTON IS PRESSED
	always@(*)
	begin
		case (currentState)
		nothingState: nextState = inputButton ? inputState : (storeButton ? storeState : nothingState);
		
		inputState: nextState = submitButton ?  waitInputState : inputState;
		waitInputState: nextState = submitButton ?  waitInputState : submitState;
		
		submitState: nextState = (pass_len == num_attempts) ? compareState : noCompareState;
		
		storeState: nextState = submitButton ? waitStoreState : storeState;
		waitStoreState: nextState = submitButton ? waitStoreState : nothingState; 
		
		compareState: nextState = doneCompare ? nothingState : compareState;
		
		noCompareState: nextState = (num_attempts == 2'd3) ? sleepState : nothingState;
		
		sleepState: nextState = submitButton ? nothingState : sleepState;
		// sleepState still needs correct implementation
		endcase
	end
	
	// do the current State stuff
	always @(*)
	begin
		case (currentState)
			inputState: begin 
				ld_input = 1'b1;
				ld_pass = 1'b0;
				compareSignal = 1'b0;
				resetSignal = 1'b1;
				end
				
			storeState: begin 
				ld_input = 1'b0;
				ld_pass = 1'b1;
				compareSignal = 1'b0;
				resetSignal = 1'b1;
				end
				
			noCompareState: begin 
				ld_input = 1'b0;
				ld_pass = 1'b0;
				compareSignal = 1'b0;
				resetSignal = 1'b1;
				num_attempts = num_attempts + 1'b1;
				end
				
			compareState: begin
				compareSignal = 1'b1;
				ld_input = 1'b0;
				ld_pass = 1'b0;
				resetSignal = 1'b1;
				end
				
			nothingState: begin
				ld_input = 1'b0;
				ld_pass = 1'b0;
				compareSignal = 1'b0;
				resetSignal = 1'b0;
				end
			// need to include somethign that happens insdie sleep
		endcase
	end
	
	always @(*)
	begin
		// we may want to change what the system reset will do
		if (!system_reset)
		begin
			currentState <= nothingState;
		end
		
		// assign the nextstate to be the currentState
		else 
			currentState <= nextState;
	end
	
	assign out_hex = currentState;
	
	
endmodule
