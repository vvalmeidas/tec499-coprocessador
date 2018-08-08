module convolucao(clk, rst, linha1, linha2, linha3, ready, resultado);

	input clk;
	input rst;
	input [23:0] linha1;
	input [23:0] linha2;
	input [23:0] linha3;
	output [7:0] resultado;
	output ready;
	
	reg signed kernel_h_0 [0:2];
	reg signed kernel_h_1 [0:2];
	reg signed kernel_h_2 [0:2];
	
	reg signed kernel_v_0 [0:2];
	reg signed kernel_v_1 [0:2];
	reg signed kernel_v_2 [0:2];
		
	reg signed [7:0] vertical = 8'd0;
	reg signed [7:0] horizontal = 8'd0;
	reg [7:0] l = 8'd0;
	reg [7:0] c = 8'd0;
	
	initial begin //atribuindo os valores da máscara
		kernel_h_0[0] = -1;
		kernel_h_0[1] = -2;
		kernel_h_0[2] = -1;
		kernel_h_1[0] = 0;
		kernel_h_1[1] = 0;
		kernel_h_1[2] = 0;
		kernel_h_2[0] = 1;
		kernel_h_2[1] = 2;
		kernel_h_2[2] = 1;
		
		kernel_v_0[0] = 1;
		kernel_v_0[1] = 0;
		kernel_v_0[2] = -1;
		kernel_v_1[0] = 2;
		kernel_v_1[1] = 0;
		kernel_v_1[2] = -2;
		kernel_v_2[0] = 1;
		kernel_v_2[1] = 0;
		kernel_v_2[2] = -1;
	end
	
	always @ (posedge clk) begin
		if(rst) begin
			l = 8'd0;
			c = 8'd0;
			horizontal = 8'd0;
			vertical = 8'd0;
		end else begin
			if(l < 3'd3) begin
				if(c < 3'd3) begin
					if(l == 3'd0) begin
						vertical <= linha1[23 - l*8 -: 8] * kernel_h_0[c];
						horizontal <= linha1[23 - l*8 -: 8] * kernel_v_0[c];
					end else if(l == 3'd1) begin
						vertical <= vertical + linha2[23 - l*8 -: 8] * kernel_h_1[c];
						horizontal <= horizontal + linha2[23 - l*8 -: 8] * kernel_v_1[c];
					end else if(l == 3'd2) begin
						vertical <= vertical + linha3[23 - l*8 -: 8] * kernel_h_2[c];
						horizontal <= horizontal + linha3[23 - l*8 -: 8] * kernel_v_2[c];
					end
					c = c + 1;
				end
				l = l + 1;
			end
		end
	end
	
	assign ready = l == 3 && c == 3 ? 1'd1 : 1'd0;
	assign resultado = vertical + horizontal;
	
endmodule