`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 11:41:37
// Design Name: 
// Module Name: color_judge
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


module color_judge(
    input i_clk,
    input i_rst,
    input [23:0]i_rgb_data,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [24:0]i_hsv_des,
    input [24:0]i_hsv_data,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync,
    output [10:0]o_set_x,
    output [9:0]o_set_y,
    output o_result
);
    localparam Default_Differ=4'd14;
    localparam Default_Differ_h=4'd9;
    localparam Default_Differ_s=4'd15;
    localparam Default_Differ_v=4'd15;
    
    //数据
    reg [8:0]hsv_h_differential=0;
    reg [7:0]hsv_s_differential=0;
    reg [7:0]hsv_v_differential=0;
    
    //缓存
    reg [24:0]hsv_des_i=0;
    reg [24:0]hsv_data_i=0;
    reg [47:0]rgb_data_i=0;
    reg [21:0]set_x_i=0;
    reg [19:0]set_y_i=0;
    reg [1:0]rgb_vde_i=0;
    reg [1:0]rgb_hsync_i=0;
    reg [1:0]rgb_vsync_i=0;
    
    //输出
    reg result_o=0;
    reg [23:0]rgb_data_o=0;
    reg [10:0]set_x_o=0;
    reg [9:0]set_y_o=0;
    reg rgb_vde_o=0;
    reg rgb_hsync_o=0;
    reg rgb_vsync_o=0;
    
    //输出连线
    assign o_result=result_o;
    assign o_rgb_data=rgb_data_o;
    assign o_set_x=set_x_o;
    assign o_set_y=set_y_o;
    assign o_rgb_vde=rgb_vde_o;
    assign o_rgb_hsync=rgb_hsync_o;
    assign o_rgb_vsync=rgb_vsync_o;
    
    //输出数据
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            result_o<=1'b0;
        end
        else if(hsv_h_differential[8:2]+hsv_s_differential[7:2]+hsv_v_differential[7:2]>Default_Differ)begin
            result_o<=1'b0;
        end
        else if(hsv_h_differential[8:2]>Default_Differ_h|hsv_s_differential[7:2]>Default_Differ_s|hsv_v_differential[7:2]>Default_Differ_v)begin
            result_o<=1'b0;
        end
        else begin
            result_o<=1'b1;
        end
    end
    //输出数据
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_o<=24'd0;
            set_x_o<=11'd0;
            set_y_o<=10'd0;
            rgb_vde_o<=1'b0;
            rgb_hsync_o<=1'b0;
            rgb_vsync_o<=1'b0;
        end
        else begin
            rgb_data_o<=rgb_data_i[47:24];
            set_x_o<=set_x_i[21:11];
            set_y_o<=set_y_i[19:10];
            rgb_vde_o<=rgb_vde_i[1];
            rgb_hsync_o<=rgb_hsync_i[1];
            rgb_vsync_o<=rgb_vsync_i[1];
        end
    end
    //差分计算h通道
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_h_differential<=9'd0;
        end
        else if(hsv_des_i[24:16]>hsv_data_i[24:16])begin
            hsv_h_differential<=hsv_des_i[24:16]-hsv_data_i[24:16];
        end
        else begin
            hsv_h_differential<=hsv_data_i[24:16]-hsv_des_i[24:16];
        end
    end
    //差分计算s通道
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_s_differential<=8'd0;
        end
        else if(hsv_des_i[15:8]>hsv_data_i[15:8])begin
            hsv_s_differential<=hsv_des_i[15:8]-hsv_data_i[15:8];
        end
        else begin
            hsv_s_differential<=hsv_data_i[15:8]-hsv_des_i[15:8];
        end
    end
    //差分计算v通道
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_v_differential<=8'd0;
        end
        else if(hsv_des_i[7:0]>hsv_data_i[7:0])begin
            hsv_v_differential<=hsv_des_i[7:0]-hsv_data_i[7:0];
        end
        else begin
            hsv_v_differential<=hsv_data_i[7:0]-hsv_des_i[7:0];
        end
    end
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_i<=48'd0;
            set_x_i<=22'd0;
            set_y_i<=20'd0;
            rgb_vde_i<=2'd0;
            rgb_hsync_i<=2'd0;
            rgb_vsync_i<=2'd0;
            hsv_des_i<=25'd0;
            hsv_data_i<=25'd0;
        end
        else begin
            rgb_data_i<={rgb_data_i[23:0],i_rgb_data};
            set_x_i<={set_x_i[10:0],i_set_x};
            set_y_i<={set_y_i[9:0],i_set_y};
            rgb_vde_i<={rgb_vde_i[0],i_rgb_vde};
            rgb_hsync_i<={rgb_hsync_i[0],i_rgb_hsync};
            rgb_vsync_i<={rgb_vsync_i[0],i_rgb_vsync};
            hsv_des_i<=i_hsv_des;
            hsv_data_i<=i_hsv_data;
        end
    end
endmodule

