/*The purpose of this module is to receive input signals from the keypad, store input
values in 
*/
module code_checker(
		input 
		input_value, //signal from Controller, store value in input register
		store_value, //signal from Controller, store value in system register
		compare, 	// activates compare operation on posedge compare
		input_reset, system_reset, //two different reset signals from Controller
		input [1:0]bits, 
		
		/*output [1:0]in_test0, in_test1, in_test2, in_test3, 
		sys_test0, sys_test1, sys_test2, sys_test3,*/
		
		output reg correct_password, incorrect_password //result of compare operation
		);
	integer num_inputs;
	integer pw_length;
	//integer max_pw_length = 3;
	integer index;
	
	//counts the number of registers that match between pw_in and pw_sys
	integer num_matches;
	
	//reg [seast_significant_index:most_significant_index] array_name [num_elements:0]
	reg [1:0] pw_in [3:0];
	reg [1:0] pw_sys [3:0];
	
	//ASSIGN VALUES OF pw_in
	always @(posedge input_value or negedge input_reset or negedge system_reset) begin
		//MUST begin by resetting system in order for this to work!!
		if (!input_reset | !system_reset) begin
			num_inputs <= 0;
			num_matches <= 0;
			correct_password <= 0;
			incorrect_password <= 0;
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
	
	// view contents of registers of pw_in
	assign {in_test0, in_test1, in_test2, in_test3} = 
				{pw_in[0],pw_in[1],pw_in[2],pw_in[3]};

	//ASSIGN VALUES OF pw_sys
	always @(posedge store_value or negedge system_reset) begin
		//MUST begin by resetting system in order for this to work!!
		if (!system_reset) begin
			pw_length <= 0;
			pw_sys[0] <= 2'd0;
			pw_sys[1] <= 2'd0;
			pw_sys[2] <= 2'd0;
			pw_sys[3] <= 2'd0;
		end
		
		else begin
			/*assign password_input[num_inputs] to value in 'bits' 
			need to confirm that this array indexing is correct*/
			pw_sys[pw_length] <= bits;
			pw_length <= pw_length + 1;
			
		
		end
	end
	
	// view contents of registers of pw_sys
	assign {sys_test0, sys_test1, sys_test2, sys_test3} = 
					{pw_sys[0],pw_sys[1],pw_sys[2],pw_sys[3]};
	
	//COMPARE CODE WHEN 'compare' SIGNAL SENT FROM CONTROLLER
	always @(posedge compare) begin
		for (index = 0; index < 4; index = index + 1) begin
			if (pw_sys[index] == pw_in[index])
			begin
			num_matches = num_matches + 1;
			end
		end
	end
	
	// ASSIGN VALUES FOR RESULT OF PASSWORD COMPARE
	always @(compare) begin
		if (num_matches == pw_length)
		begin
			correct_password = 1;
			incorrect_password = 0;
		end
		else
		begin
			correct_password = 0;
			incorrect_password = 1;
		end
	end
			
			// reset the entire system
	
endmodule
