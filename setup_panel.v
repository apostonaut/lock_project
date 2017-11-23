/*The purpose of this module is to receive input signals from the keypad, store input
values in 
*/
module setup_panel(pw_length, store_pw, compare, bits);

	input store_pw;
	input compare;
	//bits are the bits of the character being inputted
	input [1:0] bits;
	input reset;
	
	output reg pw_length;
	
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	//register array with 4 2-bit registers
	output reg [1:0] pw_set [3:0]; 
	
	//for early testing, assign all array elements with constants  (3210)
	assign {pw_in[0], pw_set[1], pw_set[2],pw_set[3]} = {2'd3, 2'd2, 2'd1, 2'd0};
	
	//this always block will NOT BE USED for early testing
	always @(posedge store_pw) begin
		//MUST begin by resetting system in order for this to work!!
		if (!resetn) begin
			pw_length <= 8'b0;
		end
		
		else begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			password_input[pw_length] <= bits;
			pw_length <= pw_length + 1;
		
		end
	end
	
	
	
endmodule
