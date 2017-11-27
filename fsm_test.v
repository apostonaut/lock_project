//Based off the mealy machine on Altera website

// 4-State Mealy state machine

// A Mealy machine has outputs that depend on both the state and 
// the inputs.  When the inputs change, the outputs are updated
// immediately, without waiting for a clock edge.  The outputs
// can be written more than once per state or per clock cycle.
//

module fsm_test
(
	input storeButton, inputButton, submitButton, system_reset, clk, 
			correct_password, invalid_password, end_sleep,
			
	output reg input_value, store_value, compare
);

	// Declare state register
	reg		[4:0]currentState;
	reg 		[1:0]num_attempts;
	
	// Declare states
	parameter 	
					max_attempts = 3,
					
					nothingState = 0, inputState = 1,
					waitInputState = 2,
					compareState = 3, storeState = 4,
					waitStoreState = 5, storePasswordState = 6,
					successOrFailureState = 7, checkAttemptsState = 8,
					sleepState = 9;
	
	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge system_reset) begin
		if (system_reset)
			currentState <= nothingState;
		else
			case (currentState)
				nothingState:
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
					if (correct_password)
					begin
						currentState <= nothingState;
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
						currentState <= sleepState;
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
				if (inputButton)
				begin
					input_value = 1;
				end
				else if (storeButton)
				begin
					store_value = 1;
				end
				else
				begin
					input_value = 0;
					store_value = 0;
					compare = 0;
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
