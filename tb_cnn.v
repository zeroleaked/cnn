`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 09:14:45 PM
// Design Name: 
// Module Name: tb_cnn
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


module tb_cnn(

    );
    
wire [7:0] x;
reg rst, clk;
wire [7:0] y;

reg [7:0] addr_r, addr_w;
reg [7:0] data_w;
wire [7:0] data_r;
wire w_en;
reg  dump_en;

cnn #(
    .B11(219), .B12(181), .B13(130),
    .B21(201), .B22(81), .B23(34),
    .B31(63), .B32(11), .B33(199)
    )
    UUT (.x(x), .rst(rst), .clk(clk), .w_en(w_en), .y(y));
    
memory mem (.addr_r(addr_r), .addr_w(addr_w), .data_w(y), .data_r(x), .dump_en(dump_en), .w_en(w_en)); 
    
always begin
    clk = ~clk;
    #5;
end    

initial begin
    clk=1;
    rst=1;
    dump_en = 0;
    addr_r = 0;
    addr_w = 128;
end
        
initial begin

    #10
    rst = 0;
    for (integer i=0; i<128; i=i+1) begin
        #10;
        addr_r = addr_r + 1;
    end;
    #10
    #10
    $stop;
end


always @(posedge clk)
    if (w_en)
        addr_w = addr_w + 1;

initial begin
    #835
    dump_en = 1;
end

endmodule


module memory(addr_r, addr_w, w_en, data_w, data_r, dump_en);
    input [7:0] addr_r, addr_w;
    input w_en;
    input [7:0] data_w;
    output [7:0] data_r;
    input dump_en;
    
    reg [7:0] my_memory [0:255];
    
    initial begin
//        initialize
        for (integer i=0; i<256; i=i+1) begin
            if (i < 81)
                my_memory[i] = $random;
            else
                my_memory[i] = 0;
        end
    end
    
    always @(posedge dump_en) begin
        $writememh("memory.mem", my_memory);
    end
    
    always @(*)
        if (w_en)
            my_memory[addr_w] = data_w;
    
    
    assign data_r = my_memory[addr_r];
endmodule