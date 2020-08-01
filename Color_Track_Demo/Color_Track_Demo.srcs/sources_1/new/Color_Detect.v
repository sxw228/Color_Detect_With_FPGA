`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 10:08:33
// Design Name: 
// Module Name: Color_Detect
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


module Color_Detect(
    input i_clk,
    input i_rst,
    input i_select,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    input [23:0]i_rgb_data,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [8:0]i_hsv_h,
    input [7:0]i_hsv_s,
    input [7:0]i_hsv_v,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync,
    output [10:0]o_set_x,
    output [9:0]o_set_y,
    output [10:0]o_center_x,
    output [9:0]o_center_y
    );
    //颜色选择数据
    wire [24:0]hsv_des;
    
    //第一级数据
    wire [23:0]rgb_data_0;
    wire rgb_vde_0;
    wire rgb_hsync_0;
    wire rgb_vsync_0;
    wire [10:0]set_x_0;
    wire [9:0]set_y_0;
    wire result_0;
    
    //权重数据
    wire [3:0]res_weight;
    
    //颜色选择
    select_Color select_Color_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_select(i_select),
        .i_set_x(i_set_x),
        .i_set_y(i_set_y),
        .i_hsv_h(i_hsv_h),
        .i_hsv_s(i_hsv_s),
        .i_hsv_v(i_hsv_v),
        .o_hsv_des(hsv_des)
    );
    
    
    //颜色判断
    color_judge color_judge_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rgb_data(i_rgb_data),
        .i_rgb_vde(i_rgb_vde),
        .i_rgb_hsync(i_rgb_hsync),
        .i_rgb_vsync(i_rgb_vsync),
        .i_set_x(i_set_x),
        .i_set_y(i_set_y),
        .i_hsv_des(hsv_des),
        .i_hsv_data({i_hsv_h,i_hsv_s,i_hsv_v}),
        .o_rgb_data(rgb_data_0),
        .o_rgb_vde(rgb_vde_0),
        .o_rgb_hsync(rgb_hsync_0),
        .o_rgb_vsync(rgb_vsync_0),
        .o_set_x(set_x_0),
        .o_set_y(set_y_0),
        .o_result(result_0)
    );
    //中心点计算
    cal_center cal_center_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rgb_data(rgb_data_0),
        .i_rgb_vde(rgb_vde_0),
        .i_rgb_hsync(rgb_hsync_0),
        .i_rgb_vsync(rgb_vsync_0),
        .i_set_x(set_x_0),
        .i_set_y(set_y_0),
        .i_judge_res(result_0),
        .i_res_weight(res_weight),
        .o_rgb_data(o_rgb_data),
        .o_rgb_vde(o_rgb_vde),
        .o_rgb_hsync(o_rgb_hsync),
        .o_rgb_vsync(o_rgb_vsync),
        .o_set_x(o_set_x),
        .o_set_y(o_set_y),
        .o_center_x(o_center_x),
        .o_center_y(o_center_y)
    );
    //选择权重
    select_weight select_weight_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_set_x(set_x_0),
        .i_set_y(set_y_0),
        .i_center_x(o_center_x),
        .i_center_y(o_center_y),
        .o_res_weight(res_weight)
    );
endmodule
