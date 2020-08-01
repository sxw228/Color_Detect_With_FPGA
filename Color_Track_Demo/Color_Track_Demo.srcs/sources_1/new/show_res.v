`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 16:06:14
// Design Name: 
// Module Name: Word_Ctrl
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


module show_res(
    input i_clk,
    input i_rst,
    input i_en_txt,
    input i_select_color,
    input i_detect_color,
    input [7:0]i_word,
    input [2:0]i_word_color,
    input [23:0]i_back_color,
    input [4:0]i_addrx,
    input [4:0]i_addry,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [10:0]i_center_x,
    input [9:0]i_center_y,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync
    );
    
    //颜色参数
    parameter COLOR_TXT_RED=24'hff0000;
    parameter COLOR_TXT_ORINGE=24'hff277f;
    parameter COLOR_TXT_YELLOW=24'hff00ff;
    parameter COLOR_TXT_GREEN=24'h0000c8;
    parameter COLOR_TXT_BLUE=24'h00ff80;
    parameter COLOR_TXT_PURPLE=24'h80ff00;
    parameter COLOR_TXT_BLACK=24'h000000;
    parameter COLOR_TXT_WHITE=24'hffffff;
    //延时数
    localparam Default_Delay_Num=3'd3;
    
    //画框参数
    localparam Default_HLine=11'd1280;
    localparam Default_VLine=10'd720;
    localparam Default_Width=7'd64;
    localparam Default_Height=7'd64;
    localparam Start_HLine=(Default_HLine>>1)-(Default_Width>>1);
    localparam End_HLine=(Default_HLine>>1)+(Default_Width>>1);
    localparam Start_VLine=(Default_VLine>>1)-(Default_Height>>1);
    localparam End_VLine=(Default_VLine>>1)+(Default_Height>>1);
    
    //颜色模式参数
    localparam COLOR_RED=3'd0;          //红色
    localparam COLOR_ORINGE=3'd1;       //橙色
    localparam COLOR_YELLOW=3'd2;       //黄色
    localparam COLOR_GREEN=3'd3;        //绿色
    localparam COLOR_BLUE=3'd4;         //蓝色
    localparam COLOR_PURPLE=3'd5;       //紫色
    localparam COLOR_BLACK=3'd6;        //黑色
    localparam COLOR_WHITE=3'd7;        //白色
    
    //分割参数
    localparam BLOCK_SINGLE=24;             //24像素一块
    localparam Default_Shift_Addr_0=3'd4;   //移位参数
    localparam Default_Shift_Addr_1=3'd3;   //移位参数
    
    //字库数据
    localparam WORD_0=8'd0;
    localparam WORD_1=8'd1;
    localparam WORD_2=8'd2;
    localparam WORD_3=8'd3;
    localparam WORD_4=8'd4;
    localparam WORD_5=8'd5;
    localparam WORD_6=8'd6;
    localparam WORD_7=8'd7;
    localparam WORD_8=8'd8;
    localparam WORD_9=8'd9;
    localparam WORD_a=8'd10;
    localparam WORD_b=8'd11;
    localparam WORD_c=8'd12;
    localparam WORD_d=8'd13;
    localparam WORD_e=8'd14;
    localparam WORD_f=8'd15;
    localparam WORD_g=8'd16;
    localparam WORD_h=8'd17;
    localparam WORD_i=8'd18;
    localparam WORD_j=8'd19;
    localparam WORD_k=8'd20;
    localparam WORD_l=8'd21;
    localparam WORD_m=8'd22;
    localparam WORD_n=8'd23;
    localparam WORD_o=8'd24;
    localparam WORD_p=8'd25;
    localparam WORD_q=8'd26;
    localparam WORD_r=8'd27;
    localparam WORD_s=8'd28;
    localparam WORD_t=8'd29;
    localparam WORD_u=8'd30;
    localparam WORD_v=8'd31;
    localparam WORD_w=8'd32;
    localparam WORD_x=8'd33;
    localparam WORD_y=8'd34;
    localparam WORD_z=8'd35;
    localparam WORD_dou=8'd36;
    localparam WORD_mao=8'd37;
    
    //数据
    wire [23:0]txt_out;
    reg [23:0]detect_show=0;
    reg [23:0]select_show=0;
    reg [9:0]txt_addr=0;
    reg [23:0]txt_out_buffer=0; //字库数据输出buffer
    reg [23:0]word_color=0;
    reg [23:0]back_color=0;
    
    //缓存
    reg select_color_i=0;
    reg detect_color_i=0;
    reg en_txt_i=0;
    reg [7:0]word_i=0;
    reg [2:0]word_color_i=0;
    reg [23:0]back_color_i=0;
    reg [9:0]addrx_i=0;
    reg [9:0]addry_i=0;
    reg [10:0]set_x_i=0;
    reg [9:0]set_y_i=0;
    reg [10:0]center_x_i=0;
    reg [9:0]center_y_i=0;

    //输出
    reg [23:0]rgb_data_o=0;
    
    //输出信号连线
    assign o_rgb_data=rgb_data_o;
    
    //RGB输出
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_o<=COLOR_TXT_BLACK;
        end
        else if(detect_color_i&en_txt_i&txt_out_buffer[BLOCK_SINGLE-1])begin
            rgb_data_o<=word_color;
        end
        else if(detect_color_i)begin
            rgb_data_o<=select_show;
        end
        else if(select_color_i)begin
            rgb_data_o<=select_show;
        end
        else begin
            rgb_data_o<=back_color;
        end
    end
    //追踪处理
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            detect_show<=24'd0;
        end
        else if(center_x_i>4&set_x_i>center_x_i-5&set_x_i<=center_x_i)begin
            detect_show<=24'hff0000;
        end
        else if(center_y_i>4&set_y_i>center_y_i-5&set_y_i<=center_y_i)begin
            detect_show<=24'hff0000;
        end
        else begin
            detect_show<=back_color;
        end
    end
    //画框处理
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            select_show<=24'd0;
        end
        else if((set_x_i==Start_HLine|set_x_i==Start_HLine-1|set_x_i==Start_HLine+1)&set_y_i>=Start_VLine&set_y_i<End_VLine)begin
            select_show<=24'hff0000;
        end
        else if((set_x_i==End_HLine|set_x_i==End_HLine-1|set_x_i==End_HLine+1)&set_y_i>=Start_VLine&set_y_i<End_VLine)begin
            select_show<=24'hff0000;
        end
        else if((set_y_i==Start_VLine|set_y_i==Start_VLine-1|set_y_i==Start_VLine+1)&set_x_i>=Start_HLine&set_x_i<End_HLine)begin
            select_show<=24'hff0000;
        end
        else if((set_y_i==End_VLine|set_y_i==End_VLine-1|set_y_i==End_VLine+1)&set_x_i>=Start_HLine&set_x_i<End_HLine)begin
            select_show<=24'hff0000;
        end
        else begin
            select_show<=back_color;
        end
    end
    //字库输出数据处理
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            txt_out_buffer<=0;
        end
        else if(en_txt_i)begin
            txt_out_buffer<=(txt_out<<addrx_i[9:5]);
        end
        else begin
            txt_out_buffer<=txt_out_buffer;
        end
    end
    //背景颜色
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            back_color<=COLOR_TXT_BLACK;
        end
        else begin
            back_color<=back_color_i;
        end
    end
    //字体颜色选择
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            word_color<=COLOR_TXT_WHITE;
        end
        else begin
            case(word_color_i)
                COLOR_RED:word_color<=COLOR_TXT_RED;
                COLOR_ORINGE:word_color<=COLOR_TXT_ORINGE;
                COLOR_YELLOW:word_color<=COLOR_TXT_YELLOW;
                COLOR_GREEN:word_color<=COLOR_TXT_GREEN;
                COLOR_BLUE:word_color<=COLOR_TXT_BLUE;
                COLOR_PURPLE:word_color<=COLOR_TXT_PURPLE;
                COLOR_BLACK:word_color<=COLOR_TXT_BLACK;
                COLOR_WHITE:word_color<=COLOR_TXT_WHITE;
            endcase
        end
    end
    
     //字库地址处理
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            txt_addr<=0;
        end
        else begin
            txt_addr<=(word_i<<Default_Shift_Addr_0)+(word_i<<Default_Shift_Addr_1)+addry_i[9:5];
        end
    end
    
    Word_Rom Rom_Word(
      .clka(i_clk),         // input wire clka
      .ena(i_rst),          // input wire ena
      .addra(txt_addr),     // input wire [9 : 0] addra
      .douta(txt_out)       // output wire [23 : 0] douta
    );
    
    //rgb_vde信号延迟
    Delay_Signal Delay_VDE(
        .i_clk(i_clk),                          //Signal unit clock
        .i_rst(i_rst),                          //Reset signal, low reset
        .i_signal(i_rgb_vde),                   //Delayed input signal
        .i_delay_num(Default_Delay_Num),        //The number of clocks that need to be delayed, no more than 8, can be cascaded
        .o_signal(o_rgb_vde)                    //Signal output after delay
    );
    //rgb_hsync信号延迟
    Delay_Signal Delay_HSYNC(
        .i_clk(i_clk),                          //Signal unit clock
        .i_rst(i_rst),                          //Reset signal, low reset
        .i_signal(i_rgb_hsync),                 //Delayed input signal
        .i_delay_num(Default_Delay_Num),        //The number of clocks that need to be delayed, no more than 8, can be cascaded
        .o_signal(o_rgb_hsync)                  //Signal output after delay
    );
    //rgb_vsnc信号延迟
    Delay_Signal Delay_VSYNC(
        .i_clk(i_clk),                          //Signal unit clock
        .i_rst(i_rst),                          //Reset signal, low reset
        .i_signal(i_rgb_vsync),                 //Delayed input signal
        .i_delay_num(Default_Delay_Num),        //The number of clocks that need to be delayed, no more than 8, can be cascaded
        .o_signal(o_rgb_vsync)                  //Signal output after delay
    );
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            select_color_i<=0;
            detect_color_i<=0;
            en_txt_i<=0;
            word_i<=0;
            word_color_i<=0;
            back_color_i<=0;
            addrx_i<=0;
            addry_i<=0;
            set_x_i<=0;
            set_y_i<=0;
            center_x_i<=0;
            center_y_i<=0;
        end
        else begin
            select_color_i<=i_select_color;
            detect_color_i<=i_detect_color;
            en_txt_i<=i_en_txt;
            word_i<=i_word;
            word_color_i<=i_word_color;
            back_color_i<=i_back_color;
            addrx_i<={addrx_i[4:0],i_addrx};
            addry_i<={addry_i[4:0],i_addry};
            set_x_i<=i_set_x;
            set_y_i<=i_set_y;
            center_x_i<=i_center_x;
            center_y_i<=i_center_y;
        end
    end
endmodule