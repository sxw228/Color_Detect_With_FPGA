`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/06 13:52:41
// Design Name: 
// Module Name: Image_Process
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


module Image_Process(
    input i_clk,
    input i_rst,
    input [1:0]i_mode,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    input [23:0]i_rgb_data,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync,
    output [23:0]o_rgb_res
    );
    
    


    //rgb结果
    wire [23:0] rgb_des;
    
  assign o_rgb_res=rgb_des;
    
    //按键数据
    wire show_select;
    wire show_detect;
    
    //第1级数据
    wire [23:0]rgb_data_1;
    wire rgb_vde_1;
    wire rgb_hsync_1;
    wire rgb_vsync_1;
    wire [10:0]set_x_1;
    wire [9:0]set_y_1;


    
    //第2级数据
    wire [8:0]addr_2;
    wire [4:0]addrx_2;
    wire [4:0]addry_2;
    wire [10:0]block_addr_2;
    wire [5:0]blockx_2;
    wire [4:0]blocky_2;
    wire [10:0]set_x_2;
    wire [9:0]set_y_2;
    wire [23:0]rgb_data_2;
    wire rgb_hsync_2;                
    wire rgb_vsync_2;                    
    wire rgb_vde_2;




    //根据按键操作转化成输出选择
    select_show select_show_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_select_color(i_mode[0]),
        .i_detect_color(i_mode[1]),
        .o_show_select(show_select),
        .o_show_detect(show_detect)
    );
    

 Color_Extract  extractor(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_select(show_select),
        .i_rgb_vde(i_rgb_vde),
        .i_rgb_hsync(i_rgb_hsync),
        .i_rgb_vsync(i_rgb_vsync),
        .i_rgb_data(i_rgb_data),
        .i_set_x(i_set_x),
        .i_set_y(i_set_y),
        .o_rgb_data(rgb_data_1),
        .o_rgb_vde(rgb_vde_1),
        .o_rgb_hsync(rgb_hsync_1),
        .o_rgb_vsync(rgb_vsync_1),
        .o_set_x(set_x_1),
        .o_set_y(set_y_1),
        .rgb_des(rgb_des)

    );
    
    

    //地址发生器
    Addr_Generator Addr_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_set_x(set_x_1),
        .i_set_y(set_y_1),
        .i_rgb_data(rgb_data_1),
        .i_rgb_hsync(rgb_hsync_1),                     
        .i_rgb_vsync(rgb_vsync_1),                     
        .i_rgb_vde(rgb_vde_1),
        .o_addr(addr_2),
        .o_addrx(addrx_2),
        .o_addry(addry_2),
        .o_block_addr(block_addr_2),
        .o_blockx(blockx_2),
        .o_blocky(blocky_2),
        .o_set_x(set_x_2),
        .o_set_y(set_y_2),
        .o_rgb_data(rgb_data_2),
        .o_rgb_hsync(rgb_hsync_2),                   
        .o_rgb_vsync(rgb_vsync_2),                     
        .o_rgb_vde(rgb_vde_2)
    );

    //显示
    draw_menu Menu_0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_select_color(show_select),
        .i_detect_color(show_detect),
        .i_addrx(addrx_2),
        .i_addry(addry_2),
        .i_blockx(blockx_2),
        .i_blocky(blocky_2),
        .i_set_x(set_x_2),
        .i_set_y(set_y_2),
        .i_rgb_res(rgb_des),
        .i_rgb_data(rgb_data_2),
        .i_rgb_vde(rgb_vde_2),
        .i_rgb_hsync(rgb_hsync_2),
        .i_rgb_vsync(rgb_vsync_2),
        .o_rgb_data(o_rgb_data),
        .o_rgb_vde(o_rgb_vde),
        .o_rgb_hsync(o_rgb_hsync),
        .o_rgb_vsync(o_rgb_vsync)
    );
    
endmodule
