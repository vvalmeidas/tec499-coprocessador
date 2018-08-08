module vgaController(clk, rst, r, g, b, hsync, vsync, data, wraddress, wren, memorySel);
	input clk;
	input rst;
	input [31:0] data; //data da memory
	input [5:0] wraddress; //write address da memory
	input wren; //write enable da memory
	input memorySel;
	output r;
	output g;
	output b;
	output hsync;
	output vsync;
	
	wire clk25;
	wire [9:0] x;
	wire [9:0] y;
	wire activeVideo;
	wire [5:0] rdaddressA; //read address da memory
	wire [5:0] rdaddressB;
	wire [31:0] qA;
	wire [31:0] qB;
	wire wrenA;
	wire wrenB;
	
	assign wrenA = (memorySel) ? 0:wren; // mux
	assign wrenB = (memorySel) ? wren:0;
	
	clockDivisor clockDivisor(
		.clk(clk), 
		.rst(rst), 
		.clkOut(clk25)
	);
	
	syncGen syncGen(
		.clk(clk25), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.x(x), 
		.y(y), 
		.activeVideo(activeVideo)
	);
	
	drawPixel drawPixel(
		.clk(clk25), 
		.rst(rst), 
		.x(x), 
		.y(y), 
		.activeVideo(activeVideo), 
		.r(r), 
		.g(g), 
		.b(b),
		.rdaddressA(rdaddressA),
		.rdaddressB(rdaddressB),
		.qA(qA),
		.qB(qB)
	);
	
	memory32 memory32(
		.clock(clk),
		.data(data),
		.rdaddress(rdaddressA),
		.wraddress(wraddress),
		.wren(wrenA),
		.q(qA)
	);

	memory64 memory64(
		.clock(clk),
		.data(data),
		.rdaddress(rdaddressB),
		.wraddress(wraddress),
		.wren(wrenB),
		.q(qB)
	);		
	
endmodule