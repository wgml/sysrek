`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:56 03/26/2015 
// Design Name: 
// Module Name:    summator 
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

/*
acc wymaga 21 bitow do poprawnego dzialania.
Zakres liczby 13 bitowej typu z8c4u to  -256.0000  255.9375 (matlab)
A wic w najgorszym przypadku (256 * min/max) = (-65536       65520)
potrzebne jest 21 bitow do reprezentacji. Zakres to wtedy -65536    65536.
Wymagana latencja - 0
*/
module summator(
    input [9:0] A,
    input clk,
    input ce,
    input rst,
	 
	 output [27:0] Y
    );
reg [27:0] sum = 28'b0;
wire [27:0] new_sum;
reg [9:0] tmp = 10'b0;

always @(posedge clk)
begin
	if(rst) 	sum = 28'b0;
	else 		sum = new_sum;
//	if(ce) tmp = A;
//	else tmp = 10'b0;
end
//lat = 0
summator_add adder (
  .a(sum), // input [18 : 0] a
  .b((ce ? A : 10'b0)), // input [9 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
  .s(new_sum) // output [18 : 0] s
);
assign Y = sum;
endmodule
