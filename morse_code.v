// TOP MODULE, wrapper for 8-bit module
module morse_code(CLOCK_50, SW, LEDR, KEY);
	//KEY[0] is asynchronous reset signal for ALL MODULES
	//SW[2:0] is signal to choose a letter from S to Z
	//SW[3] is parallel load signal
	//SW[4] load_n --> when 0, value in LoadVal stored 
	//SW[5] shift_right --> bits of Shifter shift right on +ive clock edge (Enable)
    input [5:0]SW;
	input CLOCK_50;
	input [0:0]KEY;
	output [0:0] LEDR;//morse code output
	 
	//instantiate 28-bit rate divider
	wire Enable;
	counter_28_bit count28Bit(
		.enable(Enable), //output, shift signal for ShiftRegister
		.clock(CLOCK_50), 
		.reset_n (KEY[0]),
		.d (28'b0001011111010111100000111111),//d value for 2 Hz rate, which corresponds to 0.5 seconds
		.par_load (SW[3])
		);
		
	//instantiate LookupTable
	wire [15:0]lookup_output;
	LUT LookupTable(
			.pattern(lookup_output[15:0]),
			.signal(SW[2:0])
			);
			
	// instantiate 16-bit shifter
	wire [15:0]morse_output;
	bit_shifter_16 Shift16(
			.Q (morse_output[15:0]), //output 
			.LoadVal(lookup_output[15:0]), //value from Lookup Table 
			.Load_n (SW[4]), //
			.ShiftRight(SW[5]), 
			.ASR (0), 
			.clock(Enable), //clock input is enable from counter
			.reset_n (KEY[0])
			);
			
	//assign LEDR[0] to morse_output
	assign LEDR[0] = morse_output[0]
endmodule

//Lookup Table, multiplexer
module LUT(pattern, signal);
	input [2:0]signal;
	reg [15:0] out;
	output [15:0] pattern;
	
	always@(*)
	begin
		case(signal)
			3'b000   : out[15:0] = 16'b1010100000000000; 
			3'b001   : out[15:0] = 16'b1110000000000000; 
			3'b010   : out[15:0] = 16'b1010111000000000; 
			3'b011   : out[15:0] = 16'b1010101110000000; 
			3'b100   : out[15:0] = 16'b1011101110000000; 
			3'b101   : out[15:0] = 16'b1110101011100000; 
			3'b110   : out[15:0] = 16'b1110101110111000; 
			3'b111   : out[15:0] = 16'b1110111010100000;  
		endcase
	end
	assign pattern = out;
	

endmodule

// 16 bit shifter module
module bit_shifter_16(Q, LoadVal, Load_n, ShiftRight, ASR, clock, reset_n);
  input [15:0]LoadVal;
  input Load_n;
  input ShiftRight;
  input ASR; 
  input clock;
  input reset_n;
  output Q;
  wire connect[15:0];

  one_bit_shifter S15(.q_out(connect[15]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[15]), .reset_n(reset_n), .in(ASR)
          ); 

  one_bit_shifter S14(.q_out(connect[14]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[14]), .reset_n(reset_n), .in(connect[15])
          );  


  one_bit_shifter S13(.q_out(connect[13]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[5]), .reset_n(reset_n), .in(connect[14])
          ); 

  one_bit_shifter S12(.q_out(connect[12]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[4]), .reset_n(reset_n), .in(connect[13])
          ); 

  one_bit_shifter S11(.q_out(connect[11]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[3]), .reset_n(reset_n), .in(connect[12])
          ); 
  one_bit_shifter S10(.q_out(connect[10]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[2]), .reset_n(reset_n), .in(connect[11])
          ); 
  one_bit_shifter S9(.q_out(connect[9]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[1]), .reset_n(reset_n), .in(connect[10])
          ); 
  one_bit_shifter S8(.q_out(connect[8]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[0]), .reset_n(reset_n), .in(connect[9])
          ); 

   one_bit_shifter S7(.q_out(connect[7]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[7]), .reset_n(reset_n), .in(connect[8])
          ); 

  one_bit_shifter S6(.q_out(connect[6]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[6]), .reset_n(reset_n), .in(connect[7])
          );  

  one_bit_shifter S5(.q_out(connect[5]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[5]), .reset_n(reset_n), .in(connect[6])
          ); 

  one_bit_shifter S4(.q_out(connect[4]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[4]), .reset_n(reset_n), .in(connect[5])
          ); 

  one_bit_shifter S3(.q_out(connect[3]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[3]), .reset_n(reset_n), .in(connect[4])
          ); 
  one_bit_shifter S2(.q_out(connect[2]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[2]), .reset_n(reset_n), .in(connect[3])
          ); 
  one_bit_shifter S1(.q_out(connect[1]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[1]), .reset_n(reset_n), .in(connect[2])
          ); 
  one_bit_shifter S0(.q_out(connect[0]), .clock(clock), .load_n(Load_n), 
          .shift(ShiftRight), .load_val(LoadVal[0]), .reset_n(reset_n), .in(connect[1])
          ); 

  assign Q= connect[0];

endmodule


//one bit shifter module
module one_bit_shifter(q_out, clock, load_n, shift, load_val, reset_n, in);

  
  input clock;
  input load_n;
  input shift;
  input load_val;
  input reset_n;
  input in;
  output q_out;
  
  wire M0_to_M1;
  wire M1_to_F0;

  mux2to1 M0(
      .x(q_out),
      .y(in),
      .s(shift),
      .m(M0_to_M1)
  );

  mux2to1 M1(
      .x(load_val),
      .y(M0_to_M1),
      .s(load_n),
      .m(M1_to_F0)
  );  

  d_flipflop F0(
      .d(M1_to_F0),
      .q(q_out),
      .clock(clock),
      .reset_n(reset_n)
  );
  

endmodule

// positive edge-triggered flip-flop module
module d_flipflop(reset_n, clock, d, q);
  input reset_n;
  input clock;
  input d;
  output reg q;

  always @(posedge clock, negedge reset_n)//added negedge reset

  begin
    if (reset_n == 1'b0)
      q <= 0;
    else
      q <= d;
  end

endmodule


// 2 to 1 Multiplexer
module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

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