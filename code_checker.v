/*The purpose of this module is to receive input signals from the keypad, store input
values in 
*/
module code_checker();

	input input_value;
	input compare;
	input [1:0] bits;
	
	/*IS THIS VALID?? being sent from setup_panel 
	so can be compared to user-inputted password */
	input reg [1:0] pw_set [3:0]; 
	input pw_length;
	
	
	reg num_inputs;
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	//register array with 8 2-bit registers
	reg [1:0] password_input [7:0];
	
	
	always @(posedge input_value) begin
		//MUST begin by resetting system in order for this to work!!
		if (!resetn) begin
			num_inputs <= 8'b0;
		end
		
		else begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			password_input[num_inputs] <= bits;
			num_inputs <= num_inputs + 1;
		
		end
	end
	
	//COMPARE CODE WHEN 'compare' SIGNAL SENT FROM CONTROLLER
	always @(compare) begin
	//code for comparing the two registers goes here
	
	
	end
	
	
	
	
endmodule
