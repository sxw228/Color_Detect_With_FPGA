`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/30 19:18:08
// Design Name: 
// Module Name: max3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// g=最大值的索引 0，1，2
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module max3(
input [7:0]a,
input [7:0]b,
input [7:0]c,
output reg [2:0] g
);
    reg [7:0]ff;
    always @(*)begin
        if(a<b)begin
            ff=b;
            g=3'b010;
        end
        else begin
            ff=a;
            g=3'b001;
        end
    end
    always @(*)begin
        if(ff<c)
            g=3'b100;
        else
            g=g;
     end
endmodule