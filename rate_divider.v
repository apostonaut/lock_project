// TOP MODULE, wrapper for 8-bit module
module rate_divider(CLOCK_50, SW, LEDR);// HEX0);
	//SW[1:0] is 
	//SW[2] is asynchronous reset signal
	//SW[3] is parallel load signal
    input [3:0]SW;
	 input CLOCK_50;
    //output [6:0] HEX0;
	 output [3:0] LEDR;//for testing only
	 
	 //instantiate d-value for 28-bit rate_divider
	 wire [27:0] d_value_28;
	 assign_d dVal(
			.d (d_value_28[27:0]), 
			.sw_1 (SW[1]), 
			.sw_0 (SW[0])
			);
	
	//instantiate 28-bit rate divider
	wire Enable;
	counter_28_bit count28Bit(
		.enable(Enable),
		.clock(CLOCK_50), 
		.reset_n (SW[2]),
		.d (d_value_28[27:0]),
		.par_load (SW[3])
		);
		
	//instantiate 4-bit hex counter
	wire [3:0]hex_out;
	counter_4_bit count4Bit(
			.out (hex_out),//output to LEDR for test case only
			.enable (Enable), 
			.clock (CLOCK_50), 
			.reset_n (SW[2]), 
			.d (4'b0000),  //input that gets parallel loaded
			.par_load (SW[3]));
			
	assign LEDR[3:0] = hex_out;
endmodule

//assign d multiplexer
module assign_d(d, sw_1, sw_0);
	input sw_1;
	input sw_0;
	output reg [27:0]d;
	
	always @(*)
	begin
		if (~sw_1 && ~sw_0)
			d = 28'b0000000000000000000000000011;
		else if (~sw_1 && sw_0)
			d = 28'b0010111110101111000001111111;
		else if (sw_1 && ~sw_0)
			d = 28'b0101111101011110000011111111;
		else if (sw_1 && sw_0)
			d = 28'b1011111010111100000111111111;
	end
	
endmodule

//28-bit counter
module counter_28_bit(enable, clock, reset_n,d, par_load); //
	input [27:0] d;
	input clock;
	input reset_n;
	input par_load;
	output reg enable;
	
	reg [27:0] q;
	
	always @ (posedge clock, negedge reset_n)
		begin
			if (!reset_n)
				begin
					q <= 0;// reset to 0
				end
			//resets d value on command
			else if (par_load)
				begin
					q <= d;
				end
			/*once counter q reaches 0, we reset the value to d
			and set enable to 1 for the duration of one clock pulse*/
			else if (q == 28'b0000000000000000000000000000 && clock)
				begin
					q <= d;
					enable <= 1'b1;
				end
			//otherwise, decrement q
			else if (q != 28'b0000000000000000000000000000 && clock)
				begin
					q <= q - 1'b1;
					enable <= 1'b0;
				end
		end
		
endmodule

//4-bit counter
module counter_4_bit (out, enable, clock, reset_n, d, par_load);//,

	input [3:0] d;
	input clock;
	input reset_n;
	input par_load;
	input enable;
	output [3:0]out;
	reg [3:0] q;
	
	always @ (posedge clock)
	begin
		if (reset_n == 1'b0)
			begin
			q <= 4'b0000;
			end
		else if (par_load == 1'b1)
			begin
			q <= d;
			end
		else if (enable == 1'b1)
			begin
				if (q == 4'b1111)
					q <= 0;
				else
					q <= q + 1'b1;
			end
	end
	assign out = q;
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



