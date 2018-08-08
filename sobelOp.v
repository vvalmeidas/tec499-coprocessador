module sobelOp(clk, rst, rdaddress, wraddress, qR, qW, row1, row2, row3, rst_conv, conv_ready, conv_result, wren);

	input clk;
	input rst;
	input conv_ready;
	output reg rst_conv;
	input [7:0] conv_result;
	output [11:0] rdaddress;
	output [11:0] wraddress;
	output reg [7:0] qR;
	output reg [7:0] qW;
	output reg [23:0] row1, row2, row3;
	output reg wren;
	
	reg [4:0] l;
	reg [4:0] c;
	reg [11:0] counter;
	reg [11:0] wraddress_counter;
	reg is_counter_odd = (counter & 12'd1 == 12'd0) ? 1'd0 : 1'd1;
	reg [2:0] counter_read_pixel = 3'd0;
	reg [7:0] pixel [8:0];
	reg is_read_done = 1'd0;
	reg [11:0] rdaddress_pixel [8:0];
	
	reg waiting_conv = 1'd0;
	
	assign rdaddress = rdaddress_pixel[counter_read_pixel];
	assign wraddress = wraddress_counter;
	
	initial begin
		rdaddress_pixel[0] = counter - 12'd64 - 12'd1;
		rdaddress_pixel[1] = counter - 12'd64;
		rdaddress_pixel[2] = counter - 12'd64 + 12'd1;
		rdaddress_pixel[3] = counter - 12'd1;
		rdaddress_pixel[4] = counter;
		rdaddress_pixel[5] = counter + 12'd1;
		rdaddress_pixel[6] = counter + 12'd64 - 12'd1;
		rdaddress_pixel[7] = counter + 12'd64;
		rdaddress_pixel[8] = counter + 12'd64 + 12'd1;
	end
	
	always @ (posedge clk) begin
		if(l == 5'd0 || c == 5'd0 || l == 5'd63 || c == 5'd63) begin
			qW <= 8'd0;
			wraddress_counter <= wraddress_counter + 12'd1;
			l <= l + 5'd1;
			c <= c + 5'd1;
			counter <= counter + 1'd1;
			wren <= 1'b0;
		end else if(l == c) begin
			pixel[counter_read_pixel] <= qR;
			
			if(counter_read_pixel == 3'd8) begin
				is_read_done <= 1'd1;
				rst_conv <= 1'd1;
				counter_read_pixel <= 3'd0;
			end else begin
				is_read_done <= 1'd0;
				counter_read_pixel <= counter_read_pixel + 3'd1;
			end
			
			wren <= 1'b0;
		end else if(is_read_done == 1'd0) begin //desloca os valores lidos que serão usados
			pixel[counter_read_pixel + 2'd1] <= pixel[counter_read_pixel + 1'd1];
			pixel[counter_read_pixel + 1'd1] <= pixel[counter_read_pixel];
			pixel[counter_read_pixel] <= qR;
			
			if(counter_read_pixel == 3'd6) begin
				is_read_done <= 1'd1;
				rst_conv <= 1'd1;
				counter_read_pixel <= 3'd0;
			end else begin
				is_read_done <= 1'd0;
				counter_read_pixel <= counter_read_pixel + 3'd3;
			end
		
		wren <= 1'b0;
		end else if(waiting_conv == 1'd0) begin
				row1 <= {pixel[0], pixel[1], pixel[2]};
				row2 <= {pixel[3], pixel[4], pixel[5]};
				row3 <= {pixel[6], pixel[7], pixel[8]};
				rst_conv <= 1'd0;
				waiting_conv <= 1'd1;
				wren <= 1'b0;
		end else if(waiting_conv == 1'd1 && conv_ready == 1'd1) begin
			waiting_conv <= 1'd0;
			
			if(conv_result < 8'd15)		qW <= 1'd0;
			else 								qW <= 1'd1;

			counter = counter + 12'd1;
			l <= l + 5'd1;
			c <= c + 5'd1;
			wren <= 1'b1;
		end
	
	end

endmodule
