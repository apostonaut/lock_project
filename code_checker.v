/*The purpose of this module is to receive input signals from the keypad, store input
values in 
*/
module code_checker(/*pw_is_correct (outpu)t*/test, input_value, compare, bits, pw_length, resetn);//, pw_sys);

	input input_value;
	input compare;
	input [1:0] bits;
	input resetn;
	//output pw_is_correct;
	//output done_compare
	
	/*IS THIS VALID?? being sent from setup_panel 
	so can be compared to user-inputted password */
	//input [1:0] pw_sys [3:0]; 
	input pw_length;
	output [1:0]test;
	
	//register to keep track of the number of characters the user has inputted
	integer num_inputs;
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	//register array with 8 2-bit registers
	reg [1:0] pw_in [3:0];
	
	
	always @(posedge input_value) begin
		//MUST begin by resetting system in order for this to work!!
		if (!resetn) begin
			num_inputs <= 0;
			pw_in[0] <= 2'd0;
			pw_in[1] <= 2'd0;
			pw_in[2] <= 2'd0;
			pw_in[3] <= 2'd0;
		end
		
		else begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			pw_in[num_inputs] <= bits;
			num_inputs <= num_inputs + 1;
			
		
		end
	end
	
	assign test = pw_in[0];
	
	//COMPARE CODE WHEN 'compare' SIGNAL SENT FROM CONTROLLER
	//always @(compare) begin
	//code for comparing the two registers goes here
	//end
	
endmodule
