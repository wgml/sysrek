`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:25:20 05/11/2015
// Design Name:   circle
// Module Name:   /home/vka/Programming/VHDL/workspace/sysrek/skin_color_segm/tb_circle.v
// Project Name:  vision
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: circle
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_circle(
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

// proccessing 
	 
reg [7:0] cross_r;
reg [7:0] cross_g;
reg [7:0] cross_b;	 

wire [9:0] centr_x;
wire [9:0] centr_y;
wire [9:0] curr_h;
wire [9:0] curr_w;

wire inside_circle;

circle #
(
	.IMG_W(64),
	.IMG_H(64)
)
circ
(
    .clk(rx_pclk),
    .ce(1'b1),
    .rst(1'b0),
    .de(rx_de),
    .hsync(rx_hsync),
    .vsync(rx_vsync),
    .mask((rx_red == 8'hFF) ? 1'b1 : 1'b0),
    .x(centr_x),
    .y(centr_y),
	 .inside_circle(inside_circle),
	 
	 .c_h(curr_h),
	 .c_w(curr_w)
);

always @(posedge rx_pclk) begin
	cross_r = ((inside_circle == 1'b1) ? 8'hFF : rx_red);
	cross_g = ((inside_circle == 1'b1) ? 8'h00 : rx_red);
	cross_b = ((inside_circle == 1'b1) ? 8'h00 : rx_red);
end
// --------------------------------------
// Output assigment
// --------------------------------------
  
	assign tx_de 				= rx_de;
	assign tx_hsync 			= rx_hsync;
	assign tx_vsync 			= rx_vsync;
	assign tx_red         	= cross_r;
	assign tx_green        	= cross_g;
	assign tx_blue         	= cross_b;

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