//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor:        Xilinx
// \   \   \/    Version:       1.0.0
//  \   \        Filename:      dvi_demo.v
//  /   /        Date Created:  Feb. 2010
// /___/   /\    Last Modified: Feb. 2010
// \   \  /  \
//  \___\/\___\
//
// Devices:   Spartan-6  FPGA
// Purpose:   DVI Pass Through Top Module Based On XLAB Atlys Board
// Contact:   
// Reference: None
//
// Revision History:
//   Rev 1.0.0 - (Bob Feng) First created Feb. 2010
//
//////////////////////////////////////////////////////////////////////////////
//
// LIMITED WARRANTY AND DISCLAIMER. These designs are provided to you "as is".
// Xilinx and its licensors make and you receive no warranties or conditions,
// express, implied, statutory or otherwise, and Xilinx specifically disclaims
// any implied warranties of merchantability, non-infringement, or fitness for
// a particular purpose. Xilinx does not warrant that the functions contained
// in these designs will meet your requirements, or that the operation of
// these designs will be uninterrupted or error free, or that defects in the
// designs will be corrected. Furthermore, Xilinx does not warrant or make any
// representations regarding use or the results of the use of the designs in
// terms of correctness, accuracy, reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its licensors be liable
// for any loss of data, lost profits, cost or procurement of substitute goods
// or services, or for any special, incidental, consequential, or indirect
// damages arising from the use or operation of the designs or accompanying
// documentation, however caused and on any theory of liability. This
// limitation will apply even if Xilinx has been advised of the possibility
// of such damage. This limitation shall apply not-withstanding the failure
// of the essential purpose of any limited remedies herein.
//
//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
`define SPLITTER

module hdmi_main
 (

  input wire        rstbtn_n,    //The pink reset button
  input wire        clk100,      //100 MHz osicallator
  
  // DVI INPUT
  input wire [3:0]  RX1_TMDS,
  input wire [3:0]  RX1_TMDSB,

  // DVI OUTPUT
  output wire [3:0] TX0_TMDS,
  output wire [3:0] TX0_TMDSB,
  
  	
  input  wire [3:0] SW,

  output wire [7:0] LED
);

  // -----------------------------------------------------------------------------
  // Create a 25 MHz clock from 100 MHz
  // -----------------------------------------------------------------------------
    
  wire clk25, clk25m;

  BUFIO2 #(.DIVIDE_BYPASS("FALSE"), .DIVIDE(5))
  sysclk_div (.DIVCLK(clk25m), .IOCLK(), .SERDESSTROBE(), .I(clk100));

  BUFG clk25_buf (.I(clk25m), .O(clk25));

  // -----------------------------------------------------------------------------
  // HDMI input port 
  // -----------------------------------------------------------------------------  
  wire rx_pclk, rx_pclkx2, rx_pclkx10, rx_pllclk0;
  wire rx_plllckd;
  wire rx_reset;
  wire rx_serdesstrobe;
  wire rx_hsync;          // hsync data
  wire rx_vsync;          // vsync data
  wire rx_de;             // data enable
  wire rx_psalgnerr;      // channel phase alignment error
  wire [7:0] rx_red;      // pixel data out
  wire [7:0] rx_green;    // pixel data out
  wire [7:0] rx_blue;     // pixel data out
  wire [29:0] rx_sdata;
  wire rx_blue_vld;
  wire rx_green_vld;
  wire rx_red_vld;
  wire rx_blue_rdy;
  wire rx_green_rdy;
  wire rx_red_rdy;

`ifdef SPLITTER
  dvi_decoder dvi_rx1 (
    //These are input ports (RX1)
    .tmdsclk_p   (RX1_TMDS[3]),
    .tmdsclk_n   (RX1_TMDSB[3]),
    .blue_p      (RX1_TMDS[0]),
    .green_p     (RX1_TMDS[1]),
    .red_p       (RX1_TMDS[2]),
    .blue_n      (RX1_TMDSB[0]),
    .green_n     (RX1_TMDSB[1]),
    .red_n       (RX1_TMDSB[2]),
    .exrst       (~rstbtn_n),

    //These are output ports
    .reset       (rx_reset),
    .pclk        (rx_pclk),
    .pclkx2      (rx_pclkx2),
    .pclkx10     (rx_pclkx10),
    .pllclk0     (rx_pllclk0), // PLL x10 output
    .pllclk1     (rx_pllclk1), // PLL x1 output
    .pllclk2     (rx_pllclk2), // PLL x2 output
    .pll_lckd    (rx_plllckd),
    .tmdsclk     (rx_tmdsclk),
    .serdesstrobe(rx_serdesstrobe),
    
	 // Signal synchronization
	 .hsync       (rx_hsync),
    .vsync       (rx_vsync),
    .de          (rx_de),
	 
	 // Channel valid signals 
    .blue_vld    (rx_blue_vld),
    .green_vld   (rx_green_vld),
    .red_vld     (rx_red_vld),
    .blue_rdy    (rx_blue_rdy),
    .green_rdy   (rx_green_rdy),
    .red_rdy     (rx_red_rdy),

    .psalgnerr   (rx_psalgnerr),

    .sdout       (rx_sdata),
	 
	 // R, G, B data
    .red         (rx_red),
    .green       (rx_green),
    .blue        (rx_blue)); 
`else
  dvi_decoder_nok dvi_rx1 (
    //These are input ports (RX1)
    .tmdsclk_p   (RX1_TMDS[3]),
    .tmdsclk_n   (RX1_TMDSB[3]),
    .blue_p      (RX1_TMDS[0]),
    .green_p     (RX1_TMDS[1]),
    .red_p       (RX1_TMDS[2]),
    .blue_n      (RX1_TMDSB[0]),
    .green_n     (RX1_TMDSB[1]),
    .red_n       (RX1_TMDSB[2]),
    .exrst       (~rstbtn_n),

    //These are output ports
    .reset       (rx_reset),
    .pclk        (rx_pclk),
    .pclkx2      (rx_pclkx2),
    .pclkx10     (rx_pclkx10),
    .pllclk0     (rx_pllclk0), // PLL x10 output
    .pllclk1     (rx_pllclk1), // PLL x1 output
    .pllclk2     (rx_pllclk2), // PLL x2 output
    .pll_lckd    (rx_plllckd),
    .tmdsclk     (rx_tmdsclk),
    .serdesstrobe(rx_serdesstrobe),
    
	 // Signal synchronization
	 .hsync       (rx_hsync),
    .vsync       (rx_vsync),
    .de          (rx_de),
	 
	 // Channel valid signals 
    .blue_vld    (rx_blue_vld),
    .green_vld   (rx_green_vld),
    .red_vld     (rx_red_vld),
    .blue_rdy    (rx_blue_rdy),
    .green_rdy   (rx_green_rdy),
    .red_rdy     (rx_red_rdy),

    .psalgnerr   (rx_psalgnerr),

    .sdout       (rx_sdata),
	 
	 // R, G, B data
    .red         (rx_red),
    .green       (rx_green),
    .blue        (rx_blue)); 
`endif
 
  // -----------------------------------------------------------------------------
  // IMAGE PROCESSING  
  // -----------------------------------------------------------------------------  


//konwersja z rgb na ycbcr
wire [7:0] 	Y;
wire [7:0] 	Cb;
wire [7:0] 	Cr;
wire			conv_hsync;
wire			conv_vsync;
wire			conv_de;

rgb2ycbcr conversion
(
	.clk(rx_pclk),
	.ce(1'b1),
	
	.R(rx_red),
	.G(rx_green),
	.B(rx_blue),
	
	.in_hsync(rx_hsync),
	.in_vsync(rx_vsync),
	.in_de(rx_de),
	
	.Y(Y),
	.Cb(Cb),
	.Cr(Cr),
	
	.out_hsync(conv_hsync),
	.out_vsync(conv_vsync),
	.out_de(conv_de)
);

//progowanie obrazu wzgledem chrominacji
wire [7:0] binary;

ycbcr_thresholding thresholding
(
	.Y(Y),
	.Cb(Cb),
	.Cr(Cr),
	
	.Ta(8'd76),//40),
	.Tb(8'd128),//120),
	.Tc(8'd132),//120),
	.Td(8'd176),//200),
	
	.binary(binary)

);

//centroid
wire [7:0] cross_r;
wire [7:0] cross_g;
wire [7:0] cross_b;	 

wire [9:0] centr_x;
wire [9:0] centr_y;
wire [9:0] centr_curr_w;
wire [9:0] centr_curr_h;

centroid #
(
	.IMG_W(720),
	.IMG_H(576)
)
centro
(
    .clk(rx_pclk),
    .ce(1'b1),
    .rst(1'b0),
    .de(conv_de),
    .hsync(conv_hsync),
    .vsync(conv_vsync),
    .mask((binary == 8'hFF) ? 1'b1 : 1'b0),
    .x(centr_x),
    .y(centr_y),
	 
	 .c_h(centr_curr_h),
	 .c_w(centr_curr_w)
);

assign cross_r = ((centr_curr_h == centr_y || centr_curr_w == centr_x) ? 8'hFF : binary);
assign cross_g = ((centr_curr_h == centr_y || centr_curr_w == centr_x) ? 8'h00 : binary);
assign cross_b = ((centr_curr_h == centr_y || centr_curr_w == centr_x) ? 8'h00 : binary);

//bounding box
wire [7:0] bbox_r;
wire [7:0] bbox_g;
wire [7:0] bbox_b;	 

wire [9:0] bbox_x_min;
wire [9:0] bbox_y_min;
wire [9:0] bbox_x_max;
wire [9:0] bbox_y_max;
wire [9:0] bbox_curr_h;
wire [9:0] bbox_curr_w;
wire bbox_on_border;

bounding_box #
(
	.IMG_W(720),
	.IMG_H(576)
)
box
(
    .clk(rx_pclk),
    .ce(1'b1),
    .rst(1'b0),
    .de(rx_de),
    .hsync(rx_hsync),
    .vsync(rx_vsync),
    .mask((binary == 8'hFF) ? 1'b1 : 1'b0),
    .x_min(bbox_x_min),
    .y_min(bbox_y_min),
	 .x_max(bbox_x_max),
    .y_max(bbox_y_max),
	 
	 .c_h(bbox_curr_h),
	 .c_w(bbox_curr_w),
	 
	 .on_border(bbox_on_border)
);

assign bbox_r = ((bbox_on_border == 1'b1) ? 8'hFF : binary);
assign bbox_g = ((bbox_on_border == 1'b1) ? 8'h00 : binary);
assign bbox_b = ((bbox_on_border == 1'b1) ? 8'h00 : binary);

//circle
wire [7:0] circle_r;
wire [7:0] circle_g;
wire [7:0] circle_b;	 

wire [9:0] circle_x;
wire [9:0] circle_y;
wire [9:0] circle_curr_h;
wire [9:0] circle_curr_w;

wire inside_circle;

circle #
(
	.IMG_W(720),
	.IMG_H(576)
)
circ
(
    .clk(rx_pclk),
    .ce(1'b1),
    .rst(1'b0),
    .de(rx_de),
    .hsync(rx_hsync),
    .vsync(rx_vsync),
    .mask((binary == 8'hFF) ? 1'b1 : 1'b0),
    .x(circle_x),
    .y(circle_y),
	 .inside_circle(inside_circle),
	 
	 .c_h(circle_curr_h),
	 .c_w(circle_curr_w)
);

assign circle_r = ((inside_circle == 1'b1) ? 8'hFF : binary);
assign circle_g = ((inside_circle == 1'b1) ? 8'h00 : binary);
assign circle_b = ((inside_circle == 1'b1) ? 8'h00 : binary);

//mediana
reg [7:0] median_r;
reg [7:0] median_g;
reg [7:0] median_b;

wire median;
wire median_de;
wire median_vsync;
wire median_hsync;

median5x5 #
(
	.H_SIZE(10'd864)
)
med5
(
	.clk(rx_pclk),
	.ce(1'b1),
	.rst(1'b0),

	.mask((binary == 8'hFF) ? 1'b1 : 1'b0),
	.in_de(conv_de),
	.in_vsync(conv_vsync),
	.in_hsync(conv_hsync),

	.median(median),
	.out_de(median_de),
	.out_vsync(median_vsync),
	.out_hsync(median_hsync)

);

always @(posedge rx_pclk) begin
	median_r = (median) ? 8'hFF : 8'h00;
	median_g = (median) ? 8'hFF : 8'h00;
	median_b = (median) ? 8'hFF : 8'h00;
end


//otwarcie
reg [7:0] opening_r;
reg [7:0] opening_g;
reg [7:0] opening_b;

wire opening;
wire opening_de;
wire opening_vsync;
wire opening_hsync;

opening3x3 #
(
	.H_SIZE(10'd864)
)
open3
(
	.clk(rx_pclk),
	.ce(1'b1),
	.rst(1'b0),

	.mask((binary == 8'hFF) ? 1'b1 : 1'b0),
	.in_de(conv_de),
	.in_vsync(conv_vsync),
	.in_hsync(conv_hsync),

	.opened(opening),
	.out_de(opening_de),
	.out_vsync(opening_vsync),
	.out_hsync(opening_hsync)

);

always @(posedge rx_pclk) begin
	opening_r = (opening) ? 8'hFF : 8'h00;
	opening_g = (opening) ? 8'hFF : 8'h00;
	opening_b = (opening) ? 8'hFF : 8'h00;
end


//zamkniecie
reg [7:0] closing_r;
reg [7:0] closing_g;
reg [7:0] closing_b;

wire closing;
wire closing_de;
wire closing_vsync;
wire closing_hsync;

closing3x3 #
(
	.H_SIZE(10'd864)
)
close3
(
	.clk(rx_pclk),
	.ce(1'b1),
	.rst(1'b0),

	.mask((binary == 8'hFF) ? 1'b1 : 1'b0),
	.in_de(conv_de),
	.in_vsync(conv_vsync),
	.in_hsync(conv_hsync),

	.closed(closing),
	.out_de(closing_de),
	.out_vsync(closing_vsync),
	.out_hsync(closing_hsync)

);

always @(posedge rx_pclk) begin
	closing_r = (closing) ? 8'hFF : 8'h00;
	closing_g = (closing) ? 8'hFF : 8'h00;
	closing_b = (closing) ? 8'hFF : 8'h00;
end

//filtr usredniajacy
wire [7:0] mean_Y;
wire [7:0] mean_Cb;
wire [7:0] mean_Cr;
wire mean_de;
wire mean_vsync;
wire mean_hsync;

mean_filter3x3 #
(
	.H_SIZE(10'd864)
)
mean_f
(
	.clk(rx_pclk),
	.ce(1'b1),
	.rst(1'b0),

	.in_Y(Y),
	.in_Cb(Cb),
	.in_Cr(Cr),
	.in_de(conv_de),
	.in_vsync(conv_vsync),
	.in_hsync(conv_hsync),
	
	.out_Y(mean_Y),
	.out_Cb(mean_Cb),
	.out_Cr(mean_Cr),
	.out_de(mean_de),
	.out_vsync(mean_vsync),
	.out_hsync(mean_hsync)   

);

wire [7:0] sobel_img;
wire sobel_de;
wire sobel_vsync;
wire sobel_hsync;
sobel #(
    	.H_SIZE(10'd864)
) sob(
	.clk(rx_pclk),
	.ce(1'b1),
	.rst(1'b0),
	
	.in_image(binary),
	.in_de(conv_de),
	.in_vsync(conv_vsync),
	.in_hsync(conv_hsync),
	
	.out_sobel(sobel_img),
	.out_de(sobel_de),
	.out_vsync(sobel_vsync),
	.out_hsync(sobel_hsync)   
	);

  // -----------------------------------------------------------------------------
  // HDMI output port 
  // -----------------------------------------------------------------------------  
  wire         tx_de;
  wire         tx_pclk;
  wire         tx_pclkx2;
  wire         tx_pclkx10;
  wire         tx_serdesstrobe;
  wire         tx_reset;
  wire [7:0]   tx_blue;
  wire [7:0]   tx_green;
  wire [7:0]   tx_red;
  wire         tx_hsync;
  wire         tx_vsync;
  wire         tx_pll_reset;
  
  // implementacja multipleksera 
  // umozliwiajacego wyswietlanie roznych wyjsc
  // w zaleznosci od wartosci SW
  
  wire [7:0] 	r_mux 	[10:0];
  wire [7:0] 	g_mux 	[10:0];
  wire [7:0] 	b_mux 	[10:0];
  wire			de_mux	[10:0];
  wire			hs_mux	[10:0];
  wire			vs_mux	[10:0];
  
  //RGB
  assign r_mux[0] = rx_red;
  assign g_mux[0] = rx_green;
  assign b_mux[0] = rx_blue;
  assign de_mux[0] = rx_de;
  assign hs_mux[0] = rx_hsync;
  assign vs_mux[0] = rx_vsync;
  
  // YCbCr
  assign r_mux[1] = Y;
  assign g_mux[1] = Cb;
  assign b_mux[1] = Cr;
  assign de_mux[1] = conv_de;
  assign hs_mux[1] = conv_hsync;
  assign vs_mux[1] = conv_vsync; 
  
  //thresholding
  assign r_mux[2] = binary;
  assign g_mux[2] = binary;
  assign b_mux[2] = binary;
  assign de_mux[2] = conv_de;
  assign hs_mux[2] = conv_hsync;
  assign vs_mux[2] = conv_vsync; 
  
  //centroid
  assign r_mux[3] = cross_r;
  assign g_mux[3] = cross_g;
  assign b_mux[3] = cross_b;
  assign de_mux[3] = conv_de;
  assign hs_mux[3] = conv_hsync;
  assign vs_mux[3] = conv_vsync; 
  
  //bounding_box
  assign r_mux[4] = bbox_r;
  assign g_mux[4] = bbox_g;
  assign b_mux[4] = bbox_b;
  assign de_mux[4] = conv_de;
  assign hs_mux[4] = conv_hsync;
  assign vs_mux[4] = conv_vsync; 

  //circle
  assign r_mux[5] = circle_r;
  assign g_mux[5] = circle_g;
  assign b_mux[5] = circle_b;
  assign de_mux[5] = conv_de;
  assign hs_mux[5] = conv_hsync;
  assign vs_mux[5] = conv_vsync; 
  
  //median
  assign r_mux[6] = median_r;
  assign g_mux[6] = median_g;
  assign b_mux[6] = median_b;
  assign de_mux[6] = median_de;
  assign hs_mux[6] = median_hsync;
  assign vs_mux[6] = median_vsync; 

  //open
  assign r_mux[7] = opening_r;
  assign g_mux[7] = opening_g;
  assign b_mux[7] = opening_b;
  assign de_mux[7] = opening_de;
  assign hs_mux[7] = opening_hsync;
  assign vs_mux[7] = opening_vsync; 
  
  //close
  assign r_mux[8] = closing_r;
  assign g_mux[8] = closing_g;
  assign b_mux[8] = closing_b;
  assign de_mux[8] = closing_de;
  assign hs_mux[8] = closing_hsync;
  assign vs_mux[8] = closing_vsync; 
  
  //mean
  assign r_mux[9] = mean_Y;
  assign g_mux[9] = mean_Cb;
  assign b_mux[9] = mean_Cr;
  assign de_mux[9] = mean_de;
  assign hs_mux[9] = mean_hsync;
  assign vs_mux[9] = mean_vsync; 
  
  //sobel
  assign r_mux[10] = sobel_img;
  assign g_mux[10] = sobel_img;
  assign b_mux[10] = sobel_img;
  assign de_mux[10] = sobel_de;
  assign hs_mux[10] = sobel_hsync;
  assign vs_mux[10] = sobel_vsync; 
  

  // -----------------------------------------------------------------------------
  // HDMI output port signal assigments 
  // -----------------------------------------------------------------------------  

  assign tx_pll_reset	= rx_reset;
// przypisanie z muxow
  assign tx_red			= r_mux[SW];
  assign tx_green			= g_mux[SW];
  assign tx_blue			= b_mux[SW];
  assign tx_de				= de_mux[SW];
  assign tx_hsync			= hs_mux[SW];
  assign tx_vsync			= vs_mux[SW];  
  
  //////////////////////////////////////////////////////////////////
  // Instantiate a dedicate PLL for output port
  //////////////////////////////////////////////////////////////////
  wire tx_clkfbout, tx_clkfbin, tx_plllckd;
  wire tx_pllclk0, tx_pllclk2;

  PLL_BASE # (
    .CLKIN_PERIOD(10),
    .CLKFBOUT_MULT(10), //set VCO to 10x of CLKIN
    .CLKOUT0_DIVIDE(1),
    .CLKOUT1_DIVIDE(10),
    .CLKOUT2_DIVIDE(5),
    .COMPENSATION("SOURCE_SYNCHRONOUS")
  ) PLL_OSERDES_0 (
    .CLKFBOUT(tx_clkfbout),
    .CLKOUT0(tx_pllclk0),
    .CLKOUT1(),
    .CLKOUT2(tx_pllclk2),
    .CLKOUT3(),
    .CLKOUT4(),
    .CLKOUT5(),
    .LOCKED(tx_plllckd),
    .CLKFBIN(tx_clkfbin),
    .CLKIN(tx_pclk),
    .RST(tx_pll_reset)
  );

  //
  // This BUFGMUX directly selects between two RX PLL pclk outputs
  // This way we have a matched skew between the RX pclk clocks and the TX pclk
  //
  BUFGMUX tx_bufg_pclk (.S(1'b1), .I1(rx_pllclk1), .I0(rx_pllclk1), .O(tx_pclk));

  //
  // This BUFG is needed in order to deskew between PLL clkin and clkout
  // So the tx0 pclkx2 and pclkx10 will have the same phase as the pclk input
  //
  BUFG tx_clkfb_buf (.I(tx_clkfbout), .O(tx_clkfbin));

  //
  // regenerate pclkx2 for TX
  //
  BUFG tx0_pclkx2_buf (.I(tx_pllclk2), .O(tx_pclkx2));

  //
  // regenerate pclkx10 for TX
  //
  wire tx0_bufpll_lock;
  BUFPLL #(.DIVIDE(5)) tx_ioclk_buf (.PLLIN(tx_pllclk0), .GCLK(tx_pclkx2), .LOCKED(tx_plllckd),
           .IOCLK(tx_pclkx10), .SERDESSTROBE(tx_serdesstrobe), .LOCK(tx_bufpll_lock));

  assign tx0_reset = ~tx0_bufpll_lock;

  dvi_encoder_top dvi_tx (
    .pclk        (tx_pclk),
    .pclkx2      (tx_pclkx2),
    .pclkx10     (tx_pclkx10),
    .serdesstrobe(tx_serdesstrobe),
    .rstin       (tx_reset),
    .blue_din    (tx_blue),
    .green_din   (tx_green),
    .red_din     (tx_red),
    .hsync       (tx_hsync),
    .vsync       (tx_vsync),
    .de          (tx_de),
    .TMDS        (TX0_TMDS),
    .TMDSB       (TX0_TMDSB));

 



  //////////////////////////////////////
  // Status LED
  //////////////////////////////////////
  assign LED = {rx_red_rdy, rx_green_rdy, rx_blue_rdy, rx_red_rdy, rx_green_rdy, rx_blue_rdy,
                rx_de, rx_de};

endmodule
