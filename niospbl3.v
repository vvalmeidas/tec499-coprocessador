module niospbl3(clk, rx, rst, r, g, b, hsync, vsync);
	input clk;
	input rst;
	input rx;
	output r;
	output g;
	output b;
	output hsync;
	output vsync;
	
	wire [31:0] data;
	wire [5:0] wraddress;
	wire wren;
	wire memorySel;
	wire [7:0] rx_dout;
	wire rx_rdy;
	wire rx_rdy_clr;
	
	wire [31:0] loadcoprocessador_0_conduit_end_wraddress; // loadcoprocessador_0_conduit_end.wraddress
	wire        loadcoprocessador_0_conduit_end_wren;      //                                .wren
	wire [31:0] loadcoprocessador_0_conduit_end_data;      //                                .data
	wire [31:0] readcoprocessador_0_conduit_end_data;      // readcoprocessador_0_conduit_end.data
	wire [31:0] readcoprocessador_0_conduit_end_rdaddress; //                                .rdaddress
	wire        sobel_ready_external_connection_export;     // sobel_ready_external_connection.export

	
	nios u0 (
      .clk_clk                         (clk),                         //                   clk.clk
      .loadvga_0_conduit_end_data      (data),      // loadvga_0_conduit_end.data
      .loadvga_0_conduit_end_wraddress (wraddress), //                      .wraddress
      .loadvga_0_conduit_end_wren      (wren),      //                      .wren
		.loadvga_0_conduit_end_memorySel (memorySel),  //                      .memorySel
		.rx_data_pio_export					(rx_dout),
		.rx_ready_pio_export					(rx_rdy),
		.rx_ready_clr_pio_export				(rx_rdy_clr),
		.loadcoprocessador_0_conduit_end_wraddress	(loadcoprocessador_0_conduit_end_wraddress),
		.loadcoprocessador_0_conduit_end_wren	(loadcoprocessador_0_conduit_end_wren),      //                                .wren
		.loadcoprocessador_0_conduit_end_data	(loadcoprocessador_0_conduit_end_data),      //                                .data
		.readcoprocessador_0_conduit_end_data	(readcoprocessador_0_conduit_end_data),      // readcoprocessador_0_conduit_end.data
		.readcoprocessador_0_conduit_end_rdaddress	(readcoprocessador_0_conduit_end_rdaddress), //                                .rdaddress
		.sobel_ready_external_connection_export	(sobel_ready_external_connection_export)     // sobel_ready_external_connection.export
		  
    );
	 
	 
	 uart uart_rx (
		.din									(),
		.clk_50m								(clk),
		.tx									(),
		.tx_busy								(),
		.rx									(rx),
		.rdy									(rx_rdy),
		.rdy_clr								(rx_rdy_clr),
		.dout									(rx_dout)
	);
	
	 vgaController vgaController(
		.clk(clk), 
		.rst(rst), 
		.r(r), 
		.g(g), 
		.b(b), 
		.hsync(hsync), 
		.vsync(vsync), 
		.data(data), 
		.wraddress(wraddress), 
		.wren(wren), 
		.memorySel(memorySel)
	 );
	 
	 sobOpTOP operador(
		.clk(clk),
		.ready(sobel_ready_external_connection_export),
		.loadcoprocessador_wraddress(loadcoprocessador_0_conduit_end_wraddress),
		.loadcoprocessador_wren(loadcoprocessador_0_conduit_end_wren),
		.loadcoprocessador_data(loadcoprocessador_0_conduit_end_data),
		.readcoprocessador_data(readcoprocessador_0_conduit_end_data),
		.readcoprocessador_rdaddress(readcoprocessador_0_conduit_end_rdaddress)
	);
	 
endmodule