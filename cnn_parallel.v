`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 10:52:01 PM
// Design Name: 
// Module Name: cnn_parallel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cnn_parallel(
    clk, rst,
    x0,
    x1,
    y0,
    y1
    );

input clk, rst;
input [7:0] x0, x1;    
output reg [7:0] y0, y1;

parameter
    B11 = 1,
    B12 = 1,
    B13 = 1,
    B21 = 1,
    B22 = 1,
    B23 = 1,
    B31 = 1,
    B32 = 1,
    B33 = 1,
    
    H11=B33, H12=B32, H13=B31,
    H21=B23, H22=B22, H23=B21,
    H31=B13, H32=B12, H33=B11;
    
wire [7:0] aMH11, aMH12, aMH13, aMH21, aMH22, aMH23, aMH31, aMH32, aMH33;
wire [7:0] bMH11, bMH12, bMH13, bMH21, bMH22, bMH23, bMH31, bMH32, bMH33;

wire [7:0] x0p1, x0p2, x1p1, x1p2, x1p3;

assign aMH11 = H11*x0;
assign aMH12 = H12*x1;
assign aMH13 = H13*x0;
assign aMH21 = H21*x1;
assign aMH22 = H22*x0;
assign aMH23 = H23*x1p1;
assign aMH31 = H31*x0p1;
assign aMH32 = H32*x1p2;
assign aMH33 = H33*x0p2;

assign bMH11 = H11*x1;
assign bMH12 = H12*x0;
assign bMH13 = H13*x1p1;
assign bMH21 = H21*x0p1;
assign bMH22 = H22*x1p2;
assign bMH23 = H23*x0p2;
assign bMH31 = H31*x1p2;
assign bMH32 = H32*x0p2;
assign bMH33 = H33*x1p3;

wire [7:0] aADD1, aADD2, aADD3, aADD4, aADD5, aADD6, aADD7, aADD8;
wire [7:0] bADD1, bADD2, bADD3, bADD4, bADD5, bADD6, bADD7, bADD8;

wire [7:0] aD1, aD2, aD3, aD4, aD5, aD6, aD7, aD8;
wire [7:0] bD1, bD2, bD3, bD4, bD5, bD6, bD7, bD8;

assign aADD1 = aD1 + aMH33;
assign aADD2 = aD2 + aMH32;
assign aADD3 = aD3 + aMH31;
assign aADD4 = aD4 + aMH23;
assign aADD5 = aD5 + aMH22;
assign aADD6 = aD6 + aMH21;
assign aADD7 = aD7 + aMH13;
assign aADD8 = aMH11 + aMH12;

assign bADD1 = bD1 + bMH33;
assign bADD2 = bD2 + bMH32;
assign bADD3 = bD3 + bMH31;
assign bADD4 = bD4 + bMH23;
assign bADD5 = bD5 + bMH22;
assign bADD6 = bD6 + bMH21;
assign bADD7 = bD7 + bMH13;
assign bADD8 = bD8 + bMH12;

DFF adff1 (.clk (clk), .rst(rst), .D (aADD2), .Q (aD1));
DFF adff2 (.clk (clk), .rst(rst), .D (aADD3), .Q (aD2));
DFF4 adff3 (.clk (clk), .rst(rst), .D (aADD4), .Q (aD3));
DFF adff4 (.clk (clk), .rst(rst), .D (aADD5), .Q (aD4));
DFF adff5 (.clk (clk), .rst(rst), .D (aADD6), .Q (aD5));
DFF3 adff6 (.clk (clk), .rst(rst), .D (aADD7), .Q (aD6));
DFF adff7 (.clk (clk), .rst(rst), .D (aADD8), .Q (aD7));
DFF adff8 (.clk (clk), .rst(rst), .D (aADD1), .Q (aD8));

DFF bdff1 (.clk (clk), .rst(rst), .D (bADD2), .Q (bD1));
DFF bdff2 (.clk (clk), .rst(rst), .D (bADD3), .Q (bD2));
DFF3 bdff3 (.clk (clk), .rst(rst), .D (bADD4), .Q (bD3));
DFF bdff4 (.clk (clk), .rst(rst), .D (bADD5), .Q (bD4));
DFF bdff5 (.clk (clk), .rst(rst), .D (bADD6), .Q (bD5));
DFF4 bdff6 (.clk (clk), .rst(rst), .D (bADD7), .Q (bD6));
DFF bdff7 (.clk (clk), .rst(rst), .D (bADD8), .Q (bD7));
DFF bdff8 (.clk (clk), .rst(rst), .D (bMH11), .Q (bD8));

DFF dff0p1 (.clk (clk), .rst(rst), .D (x0), .Q (x0p1));
DFF dff0p2 (.clk (clk), .rst(rst), .D (x0p1), .Q (x0p2));
DFF dff1p1 (.clk (clk), .rst(rst), .D (x1), .Q (x1p1));
DFF dff2p2 (.clk (clk), .rst(rst), .D (x1p1), .Q (x1p2));
DFF dff2p3 (.clk (clk), .rst(rst), .D (x1p2), .Q (x1p3));

always @(posedge clk or negedge rst)
    if (rst)
    begin
        y0 = 0;
        y1 = 0;
    end
    else
    begin
        y0 <= aD8;
        y1 <= bADD1;
    end


endmodule

module DFF3(
    input wire clk,
    input wire rst,
    input wire [7:0] D,
    output wire [7:0] Q
);

wire [7:0] D1, D2;

DFF dff1 (.clk (clk), .rst(rst), .D (D), .Q (D1));
DFF dff2 (.clk (clk), .rst(rst), .D (D1), .Q (D2));
DFF dff3 (.clk (clk), .rst(rst), .D (D2), .Q (Q));

endmodule

module DFF4(
    input wire clk,
    input wire rst,
    input wire [7:0] D,
    output wire [7:0] Q
);

wire [7:0] D1, D2, D3;

DFF dff1 (.clk (clk), .rst(rst), .D (D), .Q (D1));
DFF dff2 (.clk (clk), .rst(rst), .D (D1), .Q (D2));
DFF dff3 (.clk (clk), .rst(rst), .D (D2), .Q (D3));
DFF dff4 (.clk (clk), .rst(rst), .D (D3), .Q (Q));

endmodule