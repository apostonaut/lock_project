module Controller(submit, system_reset, num_inputs, compare_out, reset, pass_len, out_hex);
	input submit;
	input system_reset;
	input num_inputs;
	input pass_len;
	
	output reg reset;
	output out_hex;
	output reg compare_out;
	
	reg num_attempts;
	reg [4:0]currentState;
	reg [4:0]nextState;
	
	localparam 	noInput = 4'd0, 
					oneInput = 4'd1, 
					twoInput = 4'd2, 
					threeInput = 4'd3, 
					fourInput = 4'd4, 
					fiveInput = 4'd5, 
					sixInput = 4'd6, 
					sevenInput = 4'd7, 
					eightInput = 4'd8, 
					nineInput = 4'd9, 
					tenInput = 4'd10,
					compare = 4'd12;
	
	
	// Get next State
	always@(*)
	begin
		case (currentState)
			noInput: nextState = oneInput;
			oneInput: nextState = twoInput;
			twoInput: nextState = threeInput;
			threeInput: nextState = fourInput;
			fourInput: nextState = fiveInput;
			fiveInput: nextState = sixInput;
			sixInput: nextState = sevenInput;
			sevenInput: nextState = eightInput;
			eightInput: nextState = nineInput;
			nineInput: nextState = tenInput; 
			tenInput: nextState = tenInput; //keep looping
		endcase
	end
	
	// IF THE BUTTON IS PRESSED
	always@(posedge )
	
	// Check if the length is the same as the pass_len
	always @(*)
	begin
		if (submit)
		begin
			if (system_reset) //RESET
				begin
					compare_out = 1'b0;
					reset = 0;
					num_attempts = num_attempts + 1;
					currentState = noInput;
				end
			else if (currentState == pass_len) //SAME LENGTH DO COMPARISON
				begin
					compare_out = 1'b1;
					reset = 0;
				end
			else //NOT SAME LENGTH BASICALLY RESET
				begin
					compare_out = 1'b0;
					reset = 1'b1;
					num_attempts = num_attempts + 1;
					currentState = noInput;
				end
		end
		else //IF YOU AREN'T DONE TYPING IN THE PASSWORD
		begin
			compare_out = 1'b0;
		end
	end
	
	assign out_hex = compare_out;
	
	
endmodule
