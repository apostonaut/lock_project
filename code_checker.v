/*The purpose of this module is to receive input signals from the keypad, store input
values in 
*/
module code_checker(clk, correct_password, input_value, store_value, incorrect_password, compare, bits, resetn);
	input clk;
	input input_value; // coming from the Controller, tellign the program to store the data values in input
	input store_value; // coming from the Controller, tellign the program to store the data values in password
	input compare; // coming from Controller, telling the program to compare password and input
	input [1:0] bits; // comng from the switches
	input resetn; // should reset the entire program
	
	//output done_compare
	
	/*IS THIS VALID?? being sent from setup_panel 
	so can be compared to user-inputted password */
	output reg correct_password; // goes to controller
	output reg incorrect_password;
	
	//register to keep track of the number of characters the user has inputted
	integer num_inputs;
	integer num_password;
	integer index;
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	//register array with 8 2-bit registers
	reg [1:0] pw_in [3:0]; // input 
	reg [1:0] pw_sys [3:0]; // actual password
	
	integer counter;
	
	always @(~compare) begin //maybe use clock???
		
		//MUST begin by resetting system in order for this to work!!
		if (!resetn) begin
			num_inputs <= 0;
			num_password <= 0;
		
			for (counter = 0; counter < 4 /* max size of the passwword*/; counter = counter + 1) begin
				pw_sys[counter] <= 2'b00;
				pw_in[counter] <= 2'b00;
			end
		end
	end
	
	/*
	always @(*) begin
		
		// if input_value
		if (input_value)
		begin
			/assign password_input[num_inputs] to value in 'bits' 
			//need to confirm that this array indexing is correct
			pw_in[num_inputs] <= bits;
			num_inputs <= num_inputs + 1;
		end
		
		else if (store_value)
		begin
			//assign password[num_inputs] to value in 'bits' 
			//need to confirm that this array indexing is correct
			pw_sys[num_password] <= bits;
			num_password <= num_password + 1;
		end
	end
	*/
	
	// comparing
	
	always @(posedge compare) begin
		
		for (index = 0; index < 4; index = index + 1) begin
			if (pw_sys[index] == pw_in[index])
			begin
				correct_password <= 1'b1;
				pw_in[index] <= 2'b00;
			end
		end
		/*
		if (correct_password == 1'b0)
			incorrect_password <= 1'b1;
		// reset the entire system
		num_inputs <= 0;
		*/
	end
	
	
endmodule
