module Controller(LEDR, SW, HEX1, KEY);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [7:0] HEX1;
	
	wire [9:0] wires;
	
	temp	(	.storeButton(~KEY[3]), 
				.inputButton(~KEY[2]), 
				.submitButton(~KEY[1]), 
				.system_reset(~KEY[0]), 
				.compareSignal(wires[0]), 
				.resetSignal(wires[1]), 
				.pass_len(2'd3), 
				.HEX1(HEX1), 
				.doneCompare(SW[0]), 
				.ld_input(wires[3]), 
				.ld_pass(wires[4]),
				.LEDR(LEDR));
	
	
endmodule



module temp (HEX1, LEDR, storeButton, inputButton, submitButton, system_reset, compareSignal, resetSignal, pass_len, out_hex, doneCompare, ld_input, ld_pass);
	input submitButton;
	input storeButton;
	input inputButton;
	input system_reset; // reset all registers in Setup Panel
	input doneCompare; // signal sent from codeChecker when done comparing
	input pass_len; // setup Panel needs to send in the size of the password

	
	output reg resetSignal; // active low reset which resets all the registers
	output out_hex; // display onto hex
	output reg ld_input; // active high which tells the code checker that you are inputting from Keyboard
	output reg ld_pass; // active high which tells the setup panel that you are creating a password
	output reg compareSignal; 
	output HEX1; //outputs current FSM state
	output [9:0]LEDR;
	
	reg [1:0]num_attempts;
	reg [4:0]currentState;
	reg [4:0]nextState;
	
	localparam 			nothingState = 4'd0,
	
					inputState = 4'd1,
					waitInputState = 4'd2,
					
					submitState = 4'd3,
					
					storeState = 4'd4,
					waitStoreState = 4'd5,
					
					compareState = 4'd6,
					
					noCompareState = 4'd7,
					
					sleepState = 4'd8;
	
	// IF THE READ BUTTON IS PRESSED which read button????
	always@(*)
	begin
		case (currentState)
			nothingState:
			inputState = 4'd1,
			waitInputState = 4'd2,
	
			submitState = 4'd3,
					
			storeState = 4'd4,
			waitStoreState = 4'd5,
					
			compareState = 4'd6,
					
			noCompareState = 4'd7,
					
			sleepState = 4'd8;
				
		nothingState: begin 
			if (inputButton/*KEY[2] pressed*/)
				nextState = inputState;
				
			else if (storeButton/*KEY[3] pressed*/)
				nextState = storeState;
				
			else
				nextState = nothingState;
		end 
		
		inputState: nextState = inputButton ?  inputState : waitInputState;
		
		waitInputState: begin
			if (inputButton)
				nextState = inputState;
			
			else if (submitButton)
				nextState = submitState;
			
			else
				nextState = waitInputState;
		end
		
		submitState: nextState = (pass_len == num_attempts) ? compareState : noCompareState;
		
		storeState: nextState = storeButton ? storeState : waitStoreState;
		
		waitStoreState: begin
			if (storeButton)
				nextState = storeState;
			
			else if (submitButton)
				nextState = nothingState;
			
			else
				nextState = waitStoreState;
		end
		
		compareState: nextState = doneCompare ? nothingState : compareState;
		
		noCompareState: nextState = (num_attempts == 2'd3) ? sleepState : nothingState;
		
		sleepState: nextState = submitButton ? nothingState : sleepState;
		// sleepState still needs correct implementation
		default: nextState = nothingState;
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
				//num_attempts = num_attempts + 1'b1;
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
			
			default: begin
				ld_input = 1'b0;
				ld_pass = 1'b0;
				compareSignal = 1'b0;
				resetSignal = 1'b1;
			end
			// need to include somethign that happens insdie sleep
		endcase
	end
	
	always @(*)
	begin
		// we may want to change what the system reset will do
		if (system_reset)
		begin
			currentState <= nothingState;
			num_attempts <= 1'b0;
		end
		
		// assign the nextstate to be the currentState
		else 
			currentState <= nextState;
	end
	
	assign out_hex = currentState;

	assign LEDR[9:0] = currentState;
//	    hex_decoder H1(
//        .hex_digit(currentState), 
//        .segments(HEX1)
//        );
	
	
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
