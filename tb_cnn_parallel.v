`timescale 1ns / 1ps

module tb_cnn_parallel(

    );
    
reg [7:0] x0, x1;
reg rst, clk;
wire [7:0] y0, y1;

cnn_parallel UUT (.x0(x0), .x1(x1), .rst(rst), .clk(clk), .y0(y0), .y1(y1));
    
always begin
    clk = ~clk;
    #5;
end    

initial
begin
    clk=1;
    rst=0;
    end
        
initial
begin
#10
repeat(81)
    begin
        x0 <= $random;
        x1 <= $random;
        #10;
    end
x0=0;
x1=0;
#20;
$stop;
end
endmodule
