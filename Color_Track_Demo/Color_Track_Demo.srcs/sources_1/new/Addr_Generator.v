`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/03 17:23:47
// Design Name: 
// Module Name: Addr_Generator
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


//地址产生,将1280*720图像分割成54*30个块,每块24*24个像素
module Addr_Generator(
    input i_clk,
    input i_rst,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [23:0]i_rgb_data,
    input i_rgb_hsync,                     
    input i_rgb_vsync,                     
    input i_rgb_vde,
    output [8:0]o_addr,
    output [4:0]o_addrx,
    output [4:0]o_addry,
    output [10:0]o_block_addr,
    output [5:0]o_blockx,
    output [4:0]o_blocky,
    output [10:0]o_set_x,
    output [9:0]o_set_y,
    output [23:0]o_rgb_data,
    output o_rgb_hsync,                   
    output o_rgb_vsync,                     
    output o_rgb_vde
    );
    //分割参数
    localparam BLOCK_SINGLE=24;             //24像素一块
    localparam Default_Shift_Addr_0=3'd4;   //移位参数
    localparam Default_Shift_Addr_1=3'd3;   //移位参数
    localparam Default_Shift_Block_0=3'd5;  //移位参数
    localparam Default_Shift_Block_1=3'd1;  //移位参数
    
    //寄存器
    reg [6:0]pos_x=0;       //块的横坐标,24像素一块
    reg [5:0]pos_y=0;       //块的纵坐标,24像素一块
    reg [4:0]addr_x=0;      //地址X
    reg [4:0]addr_y=0;      //地址Y
    reg [21:0]set_x=0;      //缓存坐标x
    reg [19:0]set_y=0;      //缓存坐标y

    //缓存
    reg [47:0]rgb_data_i=0;
    reg [1:0]rgb_hsync_i=0;
    reg [1:0]rgb_vsync_i=0;
    reg [1:0]rgb_vde_i=0;
    
    //输出信号连线
    assign o_addr=addr_x+(addr_y<<Default_Shift_Addr_0)+(addr_y<<Default_Shift_Addr_1);
    assign o_blockx=pos_x;
    assign o_blocky=pos_y;
    assign o_block_addr=pos_x+(pos_y<<Default_Shift_Block_0)-(pos_y<<Default_Shift_Block_1);
    assign o_addrx=addr_x;
    assign o_addry=addr_y;
    assign o_rgb_hsync=rgb_hsync_i[1];
    assign o_rgb_vsync=rgb_vsync_i[1];
    assign o_rgb_vde=rgb_vde_i[1];
    assign o_rgb_data=rgb_data_i[47:24];
    assign o_set_x=set_x[21:11];
    assign o_set_y=set_y[19:10];
    
    //分块处理横向
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin 
            addr_x<=0;
            addr_y<=0;
            pos_x<=0;
            pos_y<=0;
        end
        else begin
            pos_x<=set_x[10:3]/3;
            pos_y<=set_y[9:3]/3;
            addr_x<=set_x[10:0]%BLOCK_SINGLE;
            addr_y<=set_y[9:0]%BLOCK_SINGLE;
        end
    end
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            set_x<=0;
            set_y<=0;
            rgb_data_i<=0;
            rgb_hsync_i<=0;
            rgb_vsync_i<=0;
            rgb_vde_i<=0;
        end
        else begin
            set_x<={set_x[10:0],i_set_x};
            set_y<={set_y[9:0],i_set_y};
            rgb_data_i<={rgb_data_i[23:0],i_rgb_data};
            rgb_hsync_i<={rgb_hsync_i[0],i_rgb_hsync};
            rgb_vsync_i<={rgb_vsync_i[0],i_rgb_vsync};
            rgb_vde_i<={rgb_vde_i[0],i_rgb_vde};
        end
    end
endmodule
