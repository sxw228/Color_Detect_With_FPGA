`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 15:04:03
// Design Name: 
// Module Name: select_weight
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


module select_weight(
    input i_clk,
    input i_rst,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [10:0]i_center_x,
    input [9:0]i_center_y,
    output [3:0]o_res_weight
);
    //差分数据
    wire [11:0]diff_x;
    wire [10:0]diff_y;
    
    //输出
    reg [3:0]res_weight_o=4'b0001;
    
    //输出连线
    assign o_res_weight=res_weight_o;
    assign diff_x = (i_set_x > i_center_x)? (i_set_x - i_center_x):(i_center_x - i_set_x);
    assign diff_y = (i_set_y > i_center_y)? (i_set_y - i_center_y):(i_center_y - i_set_y);

    //权重分配
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            res_weight_o<=4'b0001;
        end
        else if(diff_x<50&diff_y<40)res_weight_o<=4'b1111;
        else if(diff_x<100&diff_y<80)res_weight_o<=4'b1101;
        else if(diff_x<150&diff_y<120)res_weight_o<=4'b1001;
        else if(diff_x<200&diff_y<160)res_weight_o<=4'b0101;
        else if(diff_x<250&diff_y<200)res_weight_o<=4'b0011;
        else if(diff_x<300&diff_y<240)res_weight_o<=4'b0010;
        else if(diff_x<350&diff_y<280)res_weight_o<=4'b0010;
        else res_weight_o<=4'b0001;
    end
endmodule
