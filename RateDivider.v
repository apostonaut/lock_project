module RateDivider(resetn, clk, newClk);
	input clk;
	input resetn;
	reg [20:0] counter;
	output reg newClk;
		

	always @(posedge clk, posedge resetn) begin
		counter <= counter + 1'b1;
		// convert to 1sec
		if (resetn) begin
			counter <= 0;
			newClk <= 1'b0;
		end
		if (counter == 20'd1000000) begin
			counter <= 0;
			newClk <= !newClk;
		end
	end
	
endmodule
