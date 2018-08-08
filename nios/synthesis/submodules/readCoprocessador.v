module readCoprocessador(dataa, datab, clk, clk_en, reset, start, result, done, data, rdaddress);
	input [31:0] dataa; // endereço da memoria
	input [31:0] datab; // n vai ser usado mas tem que ter pq é parametro da custom instruction
	input clk;
	input clk_en; 
	input reset;
	input start;
	output reg [31:0] result;// dado lido
	output reg done;
	output reg [31:0] data; //dado que vai ser lido na memória
	output reg [31:0] rdaddress; // endereço da memoria
	 
	reg [2:0] state;
	
	localparam IDLE    =2'b00;
	localparam READING =2'b01;
	localparam FINISH  =2'b10;
	
	always @ (posedge clk) begin
		if(reset) begin
			done <= 1'b0;
			result <= 32'd0;
			data <= 32'd0;
			rdaddress <= 6'd0;
			state <= IDLE;
		end
		else begin
			if(clk_en) begin
				case(state)
					IDLE: begin
						done <= 1'b0;
						if(start) begin
							state <= READING;
							rdaddress <= dataa[6:0];
						end
						else begin
							state <= IDLE;
						end
					end
					READING: begin
						state <= FINISH;
					end
					FINISH: begin
						done <= 1'b1;
						result <= data;
						state <= IDLE;
					end
				endcase
			end
		end
	end
endmodule