module rate_divider(
	input clk, sleep,
	
	output reg end_sleep
		);
		
	reg [3:0] counter;	

	always @(posedge clk) begin
		// as long as sleep signal is 0, values stay at 0
		if (!sleep) begin
			counter <= 0;
			end_sleep <= 0;
		end
		// once counter reaches a certain value, send controller end_sleep signal
		else if (counter == 4'b1111) begin
			end_sleep <= 1;
		end
		// once sleep goes high, counter begins counting
		else if (sleep) begin
			counter <= counter + 1'b1;
		end
		// on next clock edge, reset back to 0
		else if (end_sleep == 1) begin
			end_sleep <= 0;
			counter <= 0;
		end

	end
	
endmodule