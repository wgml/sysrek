`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH
// Engineer: Tomasz Kryjak
// 
// Create Date:    11:29:28 10/28/2013 
// Design Name: 
// Module Name:    tb_filter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tb_hdmi(
    );
	 

wire rx_pclk;

wire rx_de;
wire rx_hsync;
wire rx_vsync;

wire [7:0] rx_red;
wire [7:0] rx_green;
wire [7:0] rx_blue;


wire tx_de;
wire tx_hsync;
wire tx_vsync;

wire [7:0] tx_red;
wire [7:0] tx_green;
wire [7:0] tx_blue;



// --------------------------------------
// HDMI input
// --------------------------------------
hdmi_in file_input (
    .hdmi_clk(rx_pclk), 
    .hdmi_de(rx_de), 
    .hdmi_hs(rx_hsync), 
    .hdmi_vs(rx_vsync), 
    .hdmi_r(rx_red), 
    .hdmi_g(rx_green), 
    .hdmi_b(rx_blue)
    );

wire [7:0] H;
wire [7:0] S;
wire [7:0] V;
wire conv_vsync;
wire conv_hsync;
wire conv_de;
// image processing
rgb2hsv uut (
		.clk(rx_pclk), 
		.ce(1'b1), 
		.R(rx_red), 
		.G(rx_green), 
		.B(rx_blue), 
		.in_hsync(rx_hsync), 
		.in_vsync(rx_vsync), 
		.in_de(rx_de), 
		.H(H), 
		.S(S), 
		.V(V), 
		.out_hsync(conv_hsync), 
		.out_vsync(conv_vsync), 
		.out_de(conv_de)
	);

	 
// --------------------------------------
// Output assigment
// --------------------------------------
assign tx_de = conv_de;
assign tx_hsync = conv_hsync;
assign tx_vsync = conv_vsync;

assign tx_red = H;
assign tx_green = S;
assign tx_blue = V;	 
	 

// --------------------------------------
// HDMI output
// --------------------------------------
hdmi_out file_output (
    .hdmi_clk(rx_pclk), 
    .hdmi_vs(tx_vsync), 
    .hdmi_de(tx_de), 
    .hdmi_data({8'b0,tx_red,tx_green,tx_blue})
    );


endmodule
