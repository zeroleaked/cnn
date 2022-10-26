module cnn(
    clk, rst,
    x,
    w_en,
    y
    );

input clk;
input rst;    
input [7:0] x;
output reg w_en;
output reg [7:0] y;

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

wire [7:0] MH11, MH12, MH13, MH21, MH22, MH23, MH31, MH32, MH33;

assign MH11 = H11*x;
assign MH12 = H12*x;
assign MH13 = H13*x;

assign MH21 = H21*x;
assign MH22 = H22*x;
assign MH23 = H23*x;

assign MH31 = H31*x;
assign MH32 = H32*x;
assign MH33 = H33*x;

wire [7:0] ADD1, ADD2, ADD3, ADD4, ADD5, ADD6, ADD7, ADD8;

wire [7:0] D1, D2, D3, D4, D5, D6, D7, D8;
    
assign ADD1 = D1 + MH33;
assign ADD2 = D2 + MH32;
assign ADD3 = D3 + MH31;

assign ADD4 = D4 + MH23;
assign ADD5 = D5 + MH22;
assign ADD6 = D6 + MH21;

assign ADD7 = D7 + MH13;
assign ADD8 = D8 + MH12;

DFF dff1 (.clk (clk), .rst(rst), .D (ADD2), .Q (D1));
DFF dff2 (.clk (clk), .rst(rst), .D (ADD3), .Q (D2));

DFF7 dff3 (.clk (clk), .rst(rst), .D (ADD4), .Q (D3));

DFF dff4 (.clk (clk), .rst(rst), .D (ADD5), .Q (D4));
DFF dff5 (.clk (clk), .rst(rst), .D (ADD6), .Q (D5));

DFF7 dff6 (.clk (clk), .rst(rst), .D (ADD7), .Q (D6));

DFF dff7 (.clk (clk), .rst(rst), .D (ADD8), .Q (D7));
DFF dff8 (.clk (clk), .rst(rst), .D (MH11), .Q (D8));

reg [7:0] counter;

always @(posedge clk or negedge rst)
    if (rst) begin
        y = 0;
        counter = 0;
    end
    else begin
        y <= ADD1;
        counter <= counter + 1;

        if (
            (counter >= 21 && counter < 28) ||
            (counter >= 30 && counter < 37) ||
            (counter >= 39 && counter < 46) ||
            (counter >= 48 && counter < 55) ||
            (counter >= 57 && counter < 64) ||
            (counter >= 66 && counter < 73) ||
            (counter >= 75 && counter < 82)) begin
            w_en <= 1;
        end
        else w_en <= 0;
    end


endmodule

module DFF(
    input wire clk,
    input wire rst,
    input wire [7:0] D,
    output reg [7:0] Q
);
always @(posedge clk or negedge rst)
begin
    if (rst)
        Q <= 0;
    else
        Q <= D;
end
endmodule

module DFF7(
    input wire clk,
    input wire rst,
    input wire [7:0] D,
    output wire [7:0] Q
);

wire [7:0] D1, D2, D3, D4, D5, D6, D7;

DFF dff1 (.clk (clk), .rst(rst), .D (D), .Q (D1));
DFF dff2 (.clk (clk), .rst(rst), .D (D1), .Q (D2));
DFF dff3 (.clk (clk), .rst(rst), .D (D2), .Q (D3));
DFF dff4 (.clk (clk), .rst(rst), .D (D3), .Q (D4));
DFF dff5 (.clk (clk), .rst(rst), .D (D4), .Q (D5));
DFF dff6 (.clk (clk), .rst(rst), .D (D5), .Q (D6));
DFF dff7 (.clk (clk), .rst(rst), .D (D6), .Q (Q));

endmodule