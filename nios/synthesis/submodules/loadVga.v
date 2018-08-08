module loadVga(dataa, datab, clk, clk_en, reset, start, result, done, data, wraddress, wren, memorySel);
	input [31:0] dataa; // endereço da memoria e diz se escreve na memoria 1 ou 2
	input [31:0] datab; // dado
	input clk;
	input clk_en; 
	input reset;
	input start;
	output reg [31:0] result;// n vai ser usado mas tem que ter pq é parametro da custom instruction
	output reg done;
	output reg [31:0] data; //dado que vai ser escrito na memória
	output reg [5:0] wraddress; // endereço da memoria
	output reg wren; //write enable da memoria
	output reg memorySel; //seleciona memoria que vai escrever
	 
	reg [2:0] state;
	
	localparam IDLE    =2'b00;
	localparam WRITING =2'b01;
	localparam FINISH  =2'b10;
	
	always @ (posedge clk) begin
		if(reset) begin
			wren <= 1'b0;
			done <= 1'b0;
			result <= 32'd0;
			data <= 32'd0;
			wraddress <= 6'd0;
			memorySel <= 1'b0;
			state <= IDLE;
		end
		else begin
			if(clk_en) begin
				case(state)
					IDLE: begin
						wren <= 1'b0;
						done <= 1'b0;
						if(start) begin
							state <= WRITING;
							data <= datab;
							wraddress <= dataa[5:0];
							memorySel <= dataa[6];
						end
						else begin
							state <= IDLE;
						end
					end
					WRITING: begin
						state <= FINISH;
						wren <= 1'b1;
					end
					FINISH: begin
						wren <= 1'b0;
						done <= 1'b1;
						state <= IDLE;
					end
				endcase
			end
		end
	end
endmodule