module syncGen(clk, rst, hsync, vsync, x, y, activeVideo);
	input clk;
	input rst;
	output reg hsync;
	output reg vsync;
	output reg [9:0] x = 10'd0; //10 bits para representar 800 = 640 + 16 + 96 + 48
	output reg [9:0] y = 10'd0; //10 bits para representar 524 = 480 + 11 + 2 + 31
	output reg activeVideo = 1'b0;
	
	localparam H_ACTIVE_VIDEO = 640;
	localparam H_FRONT_PORCH = 16;
	localparam H_SYNC_PULSE = 96;
	localparam H_BACK_PORCH = 48;
	localparam H_TOTAL = H_ACTIVE_VIDEO + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
	
	localparam V_ACTIVE_VIDEO = 480;
	localparam V_FRONT_PORCH = 11;
	localparam V_SYNC_PULSE = 2;
	localparam V_BACK_PORCH = 31;
	localparam V_TOTAL = V_ACTIVE_VIDEO + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
	
	//varredura de tela (horizontal e vertical)
	always @ (posedge clk) begin
		if(!rst) begin
			x <= 10'd0;
			y <= 10'd0;
		end
		
		else begin
			if(x <= H_TOTAL) begin
				x <= x + 10'd1;
			end
			else begin
				x <= 10'd0;			
				if(y <= V_TOTAL) begin
					y <= y + 10'd1;
				end
				else begin
					y <= 10'd0;
				end	
			end
		end	
	end
	
	//geração do hsync e vsync
	always @ (posedge clk) begin
		if(!rst) begin
			hsync <= 1'b0;
			vsync <= 1'b0;
		end
		
		else begin
			if( (x >= (H_ACTIVE_VIDEO + H_FRONT_PORCH)) && (x < (H_ACTIVE_VIDEO + H_FRONT_PORCH + H_SYNC_PULSE)) ) begin
				hsync <= 1'b0;
			end
			else begin
				hsync <= 1'b1;
			end
			
			if( (y >= (V_ACTIVE_VIDEO + V_FRONT_PORCH)) && (y < (V_ACTIVE_VIDEO + V_FRONT_PORCH + V_SYNC_PULSE)) ) begin
				vsync <= 1'b0;
			end
			else begin
				vsync <= 1'b1;
			end
		end
	
	end
	
	//gera pulso de activeVideo, diz se pode escrever na tela
	always @ (posedge clk) begin
		if(!rst) begin
			activeVideo <= 1'b0;
		end
		else begin
			if(x < H_ACTIVE_VIDEO && y < V_ACTIVE_VIDEO) begin
				activeVideo <= 1'b1;
			end
			else begin
				activeVideo <= 1'b0;
			end
			
		end
	end
	
endmodule