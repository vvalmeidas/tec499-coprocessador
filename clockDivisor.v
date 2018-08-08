module clockDivisor(clk, rst, clkOut);
	input clk;
	input rst;
	output reg clkOut;
	
	always @(posedge clk) begin
		if (!rst) begin
			clkOut <= 1'b0; 
		end
		else begin
			clkOut <= ~clkOut;
		end
	end

endmodule