`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 17:53:56
// Design Name: 
// Module Name: Color_Extract
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


module Color_Extract(
     input i_clk,
    input i_rst,
    input i_select,
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
    output [10:0]o_set_x,
    output [9:0]o_set_y,
    output [23:0] rgb_des

    );
   
    
    
    
    
   assign o_rgb_data=i_rgb_data;
   assign o_rgb_vde=i_rgb_vde;
   assign o_rgb_hsync=i_rgb_hsync;
   assign o_rgb_vsync=i_rgb_vsync;
   assign o_set_x=i_set_x;
   assign o_set_y=i_set_y;
       
     localparam Default_HLine=11'd1280;
    localparam Default_VLine=10'd720;
    localparam Default_Width=7'd64;
    localparam Default_Height=7'd64;
    localparam Start_HLine=(Default_HLine>>1)-(Default_Width>>1);
    localparam End_HLine=(Default_HLine>>1)+(Default_Width>>1);
    localparam Start_VLine=(Default_VLine>>1)-(Default_Height>>1);
    localparam End_VLine=(Default_VLine>>1)+(Default_Height>>1);
    
    //数据
    reg [19:0]rgb_r_cnt=0;
    reg [19:0]rgb_g_cnt=0;
    reg [19:0]rgb_b_cnt=0;
    reg [23:0]rgb_tmp=0;
    
    //缓存
    reg select_i=0;
    reg [10:0]set_x_i=0;
    reg [9:0]set_y_i=0;
    reg [7:0]rgb_r_i=0;
    reg [7:0]rgb_g_i=0;
    reg [7:0]rgb_b_i=0;
    
    //输出
    reg [24:0]rgb_des_o=24'b11111111_11111111_11111111;
    
    //输出连线
    assign rgb_des=rgb_des_o;
    
    //输出赋值
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_des_o<=24'b11111111_11111111_11111111;
        end
        else if(select_i==1'b1)begin
            rgb_des_o<=rgb_tmp;
        end
        else begin
            rgb_des_o<=rgb_des_o;
        end
    end
    
    //HSV计算
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_tmp<=25'b11111111_11111111_11111111;
            rgb_r_cnt<=20'h0;
            rgb_g_cnt<=20'h0;
            rgb_b_cnt<=20'h0;
        end
        else if(set_x_i>=Start_HLine&set_x_i<End_HLine&set_y_i>=Start_VLine&set_y_i<End_VLine)begin
            rgb_tmp<=rgb_tmp;
            rgb_r_cnt<=rgb_r_cnt+rgb_r_i;
            rgb_g_cnt<=rgb_g_cnt+rgb_g_i;
            rgb_b_cnt<=rgb_b_cnt+rgb_b_i;
        end
        else if(set_y_i==10'd1&set_x_i==11'd1)begin
            rgb_tmp<=rgb_tmp;
            rgb_r_cnt<=20'h0;
            rgb_g_cnt<=20'h0;
            rgb_b_cnt<=20'h0;
        end
        else if(set_y_i==10'd719&set_x_i==11'd1279)begin
            rgb_tmp[23:16]<=rgb_r_cnt[19:12];
            rgb_tmp[15:8]<=rgb_g_cnt[19:12];
            rgb_tmp[7:0]<=rgb_b_cnt[19:12];
            rgb_r_cnt<=rgb_r_cnt;
            rgb_g_cnt<=rgb_g_cnt;
            rgb_b_cnt<=rgb_b_cnt;
        end
        else begin
            rgb_tmp<=rgb_tmp;
            rgb_r_cnt<=rgb_r_cnt;
            rgb_g_cnt<=rgb_g_cnt;
            rgb_b_cnt<=rgb_b_cnt;
        end
    end
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            select_i<=1'b0;
            set_x_i<=11'd0;
            set_y_i<=10'd0;
            rgb_r_i<=8'd0;
            rgb_g_i<=8'd0;
            rgb_b_i<=8'd0;
        end
        else begin
            select_i<=i_select;
            set_x_i<=i_set_x;
            set_y_i<=i_set_y;
            rgb_r_i<=i_rgb_data[23:16];
            rgb_g_i<=i_rgb_data[15:8];
            rgb_b_i<=i_rgb_data[7:0];
        end
    end
    
    
    
    
    
    
endmodule
