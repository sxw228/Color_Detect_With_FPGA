`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 11:48:59
// Design Name: 
// Module Name: cal_center
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


//�������
module cal_center(
    input i_clk,
    input i_rst,
    input [23:0]i_rgb_data,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input i_judge_res,
    input [3:0]i_res_weight,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync,
    output [10:0]o_set_x,
    output [9:0]o_set_y,
    output [10:0]o_center_x,
    output [9:0]o_center_y
);
    localparam Default_HLine=11'd1280;
    localparam Default_VLine=10'd720;
    
    //ʹ���ź�
    reg en_count=0;
    
    //���ص����
    reg [20:0]all_valid_cnt=0;          //������Ч�����
    reg [20:0]valid_num=0;              //����������������
    reg [20:0]valid_cnt=0;              //������������������
    reg [10:0]h_cnt=0;                  //�е�����������
    reg [9:0]v_cnt=0;                   //�е������������
    reg [10:0]h_num_cnt=0;              //�м�һ�е��������ؼ�������
    reg [10:0]center_line_num=0;        //�м�һ�е���Ч��������
    reg [10:0]center_line_num_cnt=0;    //�м�һ�е���Ч������������
    
    //����
    reg [23:0]rgb_data_i=0;
    reg rgb_vde_i=0;
    reg rgb_hsync_i=0;
    reg rgb_vsync_i=0;
    reg [10:0]set_x_i=0;
    reg [9:0]set_y_i=0;
    reg judge_res_i=0;
    reg [3:0]res_weight_i=0;
    
    //���
    reg [23:0]rgb_data_o=0;
    reg rgb_vde_o=0;
    reg rgb_hsync_o=0;
    reg rgb_vsync_o=0;
    reg [10:0]set_x_o=0;
    reg [9:0]set_y_o=0;
    reg [10:0]center_x_o=0;
    reg [9:0]center_y_o=0;
    
    //�������
    assign o_rgb_data=rgb_data_o;
    assign o_rgb_vde=rgb_vde_o;
    assign o_rgb_hsync=rgb_hsync_o;
    assign o_rgb_vsync=rgb_vsync_o;
    assign o_set_x=set_x_o;
    assign o_set_y=set_y_o;
    assign o_center_x=center_x_o;
    assign o_center_y=center_y_o;
    
    //�������
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_o<=24'd0;
            rgb_vde_o<=1'b0;
            rgb_hsync_o<=1'b0;
            rgb_vsync_o<=1'b0;
            set_x_o<=11'd0;
            set_y_o<=10'd0;
        end
        else begin
            rgb_data_o<=rgb_data_i;
            rgb_vde_o<=rgb_vde_i;
            rgb_hsync_o<=rgb_hsync_i;
            rgb_vsync_o<=rgb_vsync_i;
            set_x_o<=set_x_i;
            set_y_o<=set_y_i;
        end
    end
    
    //���ĵ����
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            center_x_o<=11'd0;
            center_y_o<=10'd0;
            valid_num<=21'd0;
            center_line_num<=11'd0;
        end
        else if(set_x_i==Default_HLine-1&set_y_i==Default_VLine-1&all_valid_cnt>30)begin
            valid_num<=valid_cnt;
            center_line_num<=center_line_num_cnt;
            center_x_o<=h_cnt;
            center_y_o<=(v_cnt==Default_VLine-1)?0:v_cnt;
        end
        else if(set_x_i==Default_HLine-1&set_y_i==Default_VLine-1)begin
            valid_num<=valid_cnt;
            center_line_num<=center_line_num_cnt;
            center_x_o<=h_cnt;
            center_y_o<=v_cnt;
        end
        else begin
            valid_num<=valid_num;
            center_line_num<=center_line_num;
            center_x_o<=center_x_o;
            center_y_o<=center_y_o;
        end
    end
    
    //��Ч����
    always@(*)begin
        if(set_x_i>=0&set_x_i<Default_HLine&set_y_i>=0&set_y_i<Default_VLine)en_count<=1'b1;
        else en_count<=1'b0;
    end
    
    //������������������
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            valid_cnt<=21'd0;
            all_valid_cnt<=21'd0;
        end
        else if(set_x_i==11'd1&set_y_i==10'd0)begin
            valid_cnt<=21'd0;
            all_valid_cnt<=21'd0;
        end
        else if(judge_res_i&en_count)begin
            valid_cnt<=valid_cnt+res_weight_i;
            all_valid_cnt<=all_valid_cnt+1;
        end
        else begin
            valid_cnt<=valid_cnt;
            all_valid_cnt<=all_valid_cnt;
        end
    end
    
    //�ڵ�center_v��ʱ,�����������صĸ������м���,������ֵ����center_line_num��һ��ʱ,�����ص��м���ֵ��������,���õ��������صĺ�����
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            h_cnt<=11'd0;
            h_num_cnt<=11'd0;
        end
        else if(set_x_i==11'd1&set_y_i==10'd0)begin
            h_cnt<=11'd0;
            h_num_cnt<=11'd0;
        end
        else if(center_y_o==set_y_i&judge_res_i&en_count&h_num_cnt<center_line_num[10:1])begin
            h_cnt<=set_x_i;
            h_num_cnt<=h_num_cnt+res_weight_i;
        end
        else if(center_y_o==set_y_i&judge_res_i&en_count)begin
            h_cnt<=h_cnt;
            h_num_cnt<=h_num_cnt+res_weight_i;
        end
        else begin
            h_cnt<=h_cnt;
            h_num_cnt<=h_num_cnt;
        end
    end
    
    //valid_cntΪ������������������ֵ,������num��һ��ʱ����,�õ��е��������
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)v_cnt<=10'd0;
        else if(valid_cnt<valid_num[20:1])v_cnt<=set_y_i;
        else v_cnt<=v_cnt;
    end
    
    //�м�һ�е���Ч����
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            center_line_num_cnt<=11'd0;
        end
        else if(set_x_i==11'd1&set_y_i==10'd0)begin
            center_line_num_cnt<=11'd0;
        end
        else if(center_y_o==set_y_i&judge_res_i&en_count)begin
            center_line_num_cnt<=center_line_num_cnt+res_weight_i;
        end
        else begin
            center_line_num_cnt<=center_line_num_cnt;
        end
    end
    
    //���뻺��
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_i<=24'd0;
            rgb_vde_i<=1'b0;
            rgb_hsync_i<=1'b0;
            rgb_vsync_i<=1'b0;
            set_x_i<=11'd0;
            set_y_i<=10'd0;
            judge_res_i<=1'b0;
            res_weight_i<=4'd0;
        end
        else begin
            rgb_data_i<=i_rgb_data;
            rgb_vde_i<=i_rgb_vde;
            rgb_hsync_i<=i_rgb_hsync;
            rgb_vsync_i<=i_rgb_vsync;
            set_x_i<=i_set_x;
            set_y_i<=i_set_y;
            judge_res_i<=i_judge_res;
            res_weight_i<=i_res_weight;
        end
    end
endmodule
