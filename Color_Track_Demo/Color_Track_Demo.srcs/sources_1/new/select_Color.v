`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 11:48:28
// Design Name: 
// Module Name: select_Color
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


//追踪颜色选择
module select_Color(
    input i_clk,
    input i_rst,
    input i_select,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [8:0]i_hsv_h,
    input [7:0]i_hsv_s,
    input [7:0]i_hsv_v,
    output [24:0]o_hsv_des
);
    localparam Default_HLine=11'd1280;
    localparam Default_VLine=10'd720;
    localparam Default_Width=7'd64;
    localparam Default_Height=7'd64;
    localparam Start_HLine=(Default_HLine>>1)-(Default_Width>>1);
    localparam End_HLine=(Default_HLine>>1)+(Default_Width>>1);
    localparam Start_VLine=(Default_VLine>>1)-(Default_Height>>1);
    localparam End_VLine=(Default_VLine>>1)+(Default_Height>>1);
    
    //数据
    reg [20:0]hsv_h_cnt=0;
    reg [19:0]hsv_s_cnt=0;
    reg [19:0]hsv_v_cnt=0;
    reg [24:0]hsv_tmp=0;
    
    //缓存
    reg select_i=0;
    reg [10:0]set_x_i=0;
    reg [9:0]set_y_i=0;
    reg [8:0]hsv_h_i=0;
    reg [7:0]hsv_s_i=0;
    reg [7:0]hsv_v_i=0;
    
    //输出
    reg [24:0]hsv_des_o=25'b1_11111111_11111111_11111111;
    
    //输出连线
    assign o_hsv_des=hsv_des_o;
    
    //输出赋值
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_des_o<=25'b1_11111111_11111111_11111111;
        end
        else if(select_i==1'b1)begin
            hsv_des_o<=hsv_tmp;
        end
        else begin
            hsv_des_o<=hsv_des_o;
        end
    end
    
    //HSV计算
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_tmp<=25'b1_11111111_11111111_11111111;
            hsv_h_cnt<=21'h0;
            hsv_s_cnt<=20'h0;
            hsv_v_cnt<=20'h0;
        end
        else if(set_x_i>=Start_HLine&set_x_i<End_HLine&set_y_i>=Start_VLine&set_y_i<End_VLine)begin
            hsv_tmp<=hsv_tmp;
            hsv_h_cnt<=hsv_h_cnt+hsv_h_i;
            hsv_s_cnt<=hsv_s_cnt+hsv_s_i;
            hsv_v_cnt<=hsv_v_cnt+hsv_v_i;
        end
        else if(set_y_i==10'd1&set_x_i==11'd1)begin
            hsv_tmp<=hsv_tmp;
            hsv_h_cnt<=20'h0;
            hsv_s_cnt<=20'h0;
            hsv_v_cnt<=20'h0;
        end
        else if(set_y_i==10'd719&set_x_i==11'd1279)begin
            hsv_tmp[24:16]<=hsv_h_cnt[20:12];
            hsv_tmp[15:8]<=hsv_s_cnt[19:12];
            hsv_tmp[7:0]<=hsv_v_cnt[19:12];
            hsv_h_cnt<=hsv_h_cnt;
            hsv_s_cnt<=hsv_s_cnt;
            hsv_v_cnt<=hsv_v_cnt;
        end
        else begin
            hsv_tmp<=hsv_tmp;
            hsv_h_cnt<=hsv_h_cnt;
            hsv_s_cnt<=hsv_s_cnt;
            hsv_v_cnt<=hsv_v_cnt;
        end
    end
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            select_i<=1'b0;
            set_x_i<=11'd0;
            set_y_i<=10'd0;
            hsv_h_i<=9'd0;
            hsv_s_i<=8'd0;
            hsv_v_i<=8'd0;
        end
        else begin
            select_i<=i_select;
            set_x_i<=i_set_x;
            set_y_i<=i_set_y;
            hsv_h_i<=i_hsv_h;
            hsv_s_i<=i_hsv_s;
            hsv_v_i<=i_hsv_v;
        end
    end
endmodule

