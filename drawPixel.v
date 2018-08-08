module drawPixel(clk, rst, x, y, activeVideo, r, g, b, rdaddressA, rdaddressB, qA, qB);
	//vai ter buffer de memória depois
	// memória dual port - para ler e escrever ao mesmo tempo
	
	input clk;
	input rst;
	input [9:0] x;
	input [9:0] y;
	input activeVideo;
	input [31:0] qA;
	input [31:0] qB;
	output [5:0] rdaddressA;
	output [5:0] rdaddressB;
	output reg r;
	output reg g;
	output reg b;
	
	reg [9:0] counterA = 0;
	reg [9:0] counterB = 0;
	
	assign rdaddressA = counterA[5:0];
	assign rdaddressB = counterB[5:0]; 
	
	//pinta a tela
	always @ (posedge clk) begin
		if(!rst) begin
			r <= 1'b0;
			g <= 1'b0;
			b <= 1'b0;
			counterA <= 10'd0;
			counterB <= 10'd0;
		end	
		else begin
			if(activeVideo) begin //aqui é pra ler a memória
//				if(x >= 0 && x < 32 && y >= 0 && y < 64) begin
//					counterA <= y;
//					r <= qA[31-x];
// 					g <= qA[31-x];
//					b <= qA[31-x];					
//				end
//				else if(x >= 32 && x < 64 && y >= 0 && y < 64) begin
//					counterB <= y;
//					r <= qB[63-x];
// 					g <= qB[63-x];
//					b <= qB[63-x];					
//				end
				if(x >= 10'd288 && x < 10'd320 && y >= 10'd208 && y < 10'd272) begin
					counterA <= (271-y);
					r <= qA[319-x];
					g <= qA[319-x];
					b <= qA[319-x];
				end
				else if(x >= 10'd320 && x < 10'd352 && y >= 10'd208 && y < 10'd272) begin
					counterB <= (271-y);   
					r <= qB[351-x];
					g <= qB[351-x];
					b <= qB[351-x];
				end
				else if(y == 400) begin
					r <= 1'b1;
					g <= 1'b1;
					b <= 1'b1;
				end
				else begin
					r <= 1'b1;
					g <= 1'b0;
					b <= 1'b1;
				end
			end
			else begin
				r <= 1'b0;
				g <= 1'b0;
				b <= 1'b0;
			end
		end
	end
endmodule