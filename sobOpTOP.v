module sobOpTOP(clk, ready, loadcoprocessador_data, loadcoprocessador_wraddress, loadcoprocessador_wren, readcoprocessador_data, readcoprocessador_rdaddress);

	input clk;
	output ready;
	input [31:0] loadcoprocessador_wraddress; // loadcoprocessador_0_conduit_end.wraddress
	input loadcoprocessador_wren;	//                                .wren
	input [31:0] loadcoprocessador_data;      //                                .data
	output [31:0] readcoprocessador_data;      // readcoprocessador_0_conduit_end.data
	input [31:0] readcoprocessador_rdaddress;  //                                .rdaddress

	wire [11:0] pixel_processado_address;
	wire pixel_processado_wren;
	wire conv_rst, conv_ready;
	wire [7:0] conv_res;
	wire [7:0] sobel_data_imgoriginal;
	wire [11:0] sobel_address_imgoriginal;
	wire [23:0] linha1, linha2, linha3;
	wire pixel_processado_data;
	
	convolucao c(
		.clk(clk),
		.rst(conv_rst),
		.linha1(linha1),
		.linha2(linha2),
		.linha3(linha3),
		.ready(conv_ready),
		.resultado(conv_res)
	);
		
	sobelOp sobelOp (
		.clk(clk), 
		.wraddress(pixel_processado_address),
		.qR(sobel_data_imgoriginal),
		.qW(pixel_processado_data),
		.row1(linha1),
		.row2(linha2),
		.row3(linha3),
		.rst_conv(conv_rst),
		.conv_ready(conv_ready),
		.conv_result(conv_res),
		.wren(pixel_processado_wren),
		.rdaddress(sobel_address_imgoriginal)
	);
	
	memory4096b memImgProcessada (
		.clock(clk),
		.data(pixel_processado_data),
		.rdaddress(readcoprocessador_rdaddress),
		.wraddress(pixel_processado_address),
		.wren(pixel_processado_wren),
		.q(readcoprocessador_data)
	);
	
	memory4096Bytes memImgOriginal (
		.clock(clk),
		.data(loadcoprocessador_data),
		.rdaddress(sobel_address_imgoriginal),
		.wraddress(loadcoprocessador_wraddress),
		.wren(loadcoprocessador_wren),
		.q(sobel_data_imgoriginal)
	);
	
	
	
	
endmodule