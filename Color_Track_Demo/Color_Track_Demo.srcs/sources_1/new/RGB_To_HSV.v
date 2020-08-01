`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/06 13:52:51
// Design Name: 
// Module Name: RGB_To_HSV
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


module RGB_To_HSV(
    input i_clk,
    input i_rst,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    input [7:0]i_rgb_data_r,
    input [7:0]i_rgb_data_g,
    input [7:0]i_rgb_data_b,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    output [8:0]o_hsv_h,
    output [7:0]o_hsv_s,
    output [7:0]o_hsv_v,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync,
    output [7:0]o_rgb_data_r,
    output [7:0]o_rgb_data_g,
    output [7:0]o_rgb_data_b,
    output [10:0]o_set_x,
    output [9:0]o_set_y
    );
    
    //RGB转HSV延迟的时钟
    parameter Default_Delay_Num=4'd5;
    
    //延时
    reg [Default_Delay_Num*8-1:0]rgb_data_r_delay=0;
    reg [Default_Delay_Num*8-1:0]rgb_data_g_delay=0;
    reg [Default_Delay_Num*8-1:0]rgb_data_b_delay=0;
    reg [Default_Delay_Num*11-1:0]set_x_delay=0;
    reg [Default_Delay_Num*10-1:0]set_y_delay=0;
    
    //数据
    reg [7:0]max_rgb_data=0;
    reg [7:0]min_rgb_data=0;
    wire [15:0]rom_data_h;
    wire [15:0]rom_data_s;
    
    //除数和被除数
    reg [15:0]hsv_dividend_h=0;          //dividend
    reg [10:0]hsv_divisor_h=11'd1;       //divisor
    reg [15:0]hsv_dividend_s=0;          //dividend
    reg [10:0]hsv_divisor_s=11'd1;       //divisor
    reg [7:0]tmp_hsv_data_v=0;
    reg [8:0]tmp_hsv_data_h=0;
    
    //标志
    reg flg_sign=0;
    
    //除法
    wire[15:0]divider_res_h;
    wire[15:0]divider_res_s;
    
    //缓存
    reg [7:0]rgb_data_r_i=0;
    reg [7:0]rgb_data_g_i=0;
    reg [7:0]rgb_data_b_i=0;
    
    //输出
    reg [8:0]hsv_h_o=0;
    reg [7:0]hsv_s_o=0;
    reg [7:0]hsv_v_o=0;
    reg [7:0]rgb_data_r_o=0;
    reg [7:0]rgb_data_g_o=0;
    reg [7:0]rgb_data_b_o=0;
    reg [10:0]set_x_o=0;
    reg [9:0]set_y_o=0;
    
    //输出连线
    assign o_hsv_h=hsv_h_o;
    assign o_hsv_s=hsv_s_o;
    assign o_hsv_v=hsv_v_o;
    assign o_rgb_data_r=rgb_data_r_o;
    assign o_rgb_data_g=rgb_data_g_o;
    assign o_rgb_data_b=rgb_data_b_o;
    assign o_set_x=set_x_o;
    assign o_set_y=set_y_o;
    
    //HSV数据输出
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_h_o<=0;
            hsv_s_o<=0;
            hsv_v_o<=0;
        end
        else if(flg_sign)begin
            hsv_h_o<=tmp_hsv_data_h-divider_res_h[8:0];
            hsv_s_o<=divider_res_s[7:0];
            hsv_v_o<=tmp_hsv_data_v;
        end
        else begin
            hsv_h_o<=divider_res_h[8:0]+tmp_hsv_data_h;
            hsv_s_o<=divider_res_s[7:0];
            hsv_v_o<=tmp_hsv_data_v;
        end
    end
    //延时信号输出
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_r_o<=8'd0;
            rgb_data_g_o<=8'd0;
            rgb_data_b_o<=8'd0;
            set_x_o<=11'd0;
            set_y_o<=10'd0;
        end 
        else begin
            rgb_data_r_o<=rgb_data_r_delay[Default_Delay_Num*8-1:(Default_Delay_Num-1)*8];
            rgb_data_g_o<=rgb_data_g_delay[Default_Delay_Num*8-1:(Default_Delay_Num-1)*8];
            rgb_data_b_o<=rgb_data_b_delay[Default_Delay_Num*8-1:(Default_Delay_Num-1)*8];
            set_x_o<=set_x_delay[Default_Delay_Num*11-1:(Default_Delay_Num-1)*11];
            set_y_o<=set_y_delay[Default_Delay_Num*10-1:(Default_Delay_Num-1)*10];
        end
    end
    //HSV计算
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            hsv_dividend_h<=16'd0;
            hsv_divisor_h<=11'd1;
            hsv_dividend_s<=16'd0;
            hsv_divisor_s<=11'd1;
            tmp_hsv_data_h<=9'd0;
            tmp_hsv_data_v<=8'd0;
            flg_sign<=1'b0;
        end
        else if(max_rgb_data==min_rgb_data)begin
            hsv_dividend_h<=16'd0;
            hsv_divisor_h<=11'd1;
            hsv_dividend_s<=16'd0;
            hsv_divisor_s<=11'd1;
            tmp_hsv_data_h<=9'd0;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b0;
        end
        else if(max_rgb_data==rgb_data_r_i&rgb_data_g_i>rgb_data_b_i)begin
            hsv_dividend_h<=((rgb_data_g_i-rgb_data_b_i)<<6)-((rgb_data_g_i-rgb_data_b_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd0;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b0;
        end
        else if(max_rgb_data==rgb_data_r_i)begin
            hsv_dividend_h<=((rgb_data_b_i-rgb_data_g_i)<<6)-((rgb_data_b_i-rgb_data_g_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd360;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b1;
        end
        else if(max_rgb_data==rgb_data_g_i&rgb_data_b_i>rgb_data_r_i)begin
            hsv_dividend_h<=((rgb_data_b_i-rgb_data_r_i)<<6)-((rgb_data_b_i-rgb_data_r_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd120;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b0;
        end
        else if(max_rgb_data==rgb_data_g_i)begin
            hsv_dividend_h<=((rgb_data_r_i-rgb_data_b_i)<<6)-((rgb_data_r_i-rgb_data_b_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd120;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b1;
        end
        else if(max_rgb_data==rgb_data_b_i&rgb_data_r_i>rgb_data_g_i)begin
            hsv_dividend_h<=((rgb_data_r_i-rgb_data_g_i)<<6)-((rgb_data_r_i-rgb_data_g_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd240;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b0;
        end
        else begin
            hsv_dividend_h<=((rgb_data_g_i-rgb_data_r_i)<<6)-((rgb_data_g_i-rgb_data_r_i)<<2);
            hsv_divisor_h<=max_rgb_data-min_rgb_data;
            hsv_dividend_s<=((max_rgb_data-min_rgb_data)<<8)-(max_rgb_data-min_rgb_data);
            hsv_divisor_s<=max_rgb_data;
            tmp_hsv_data_h<=9'd240;
            tmp_hsv_data_v<=max_rgb_data;
            flg_sign<=1'b1;
        end
    end
    
    //计算RGB中的最大值和最小值
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            max_rgb_data<=0;
            min_rgb_data<=0;
        end
        else begin
            max_rgb_data<=MAX(i_rgb_data_r,i_rgb_data_g,i_rgb_data_b);
            min_rgb_data<=MIN(i_rgb_data_r,i_rgb_data_g,i_rgb_data_b);
        end
    end
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_r_i<=8'd0;
            rgb_data_g_i<=8'd0;
            rgb_data_b_i<=8'd0;
        end
        else begin
            rgb_data_r_i<=i_rgb_data_r;
            rgb_data_g_i<=i_rgb_data_g;
            rgb_data_b_i<=i_rgb_data_b;
        end
    end
    //除法器0
    Driver_Divider Driver_Divider_0
    (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_dividend(hsv_dividend_h),
        .i_divisor(hsv_divisor_h),
        .i_rom_data(rom_data_h),
        .o_result(divider_res_h),
        .o_delay_num()
    );
    //除法器1
    Driver_Divider Driver_Divider_1
    (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_dividend(hsv_dividend_s),
        .i_divisor(hsv_divisor_s),
        .i_rom_data(rom_data_s),
        .o_result(divider_res_s),
        .o_delay_num()
    );
    //ROM
    Divider_Params_Rom Rom_Divider_20Bit (.i_clk(i_clk),.i_rst(i_rst),.i_addra({1'b0,(hsv_divisor_h-11'd3)}),.i_addrb({1'b0,(hsv_divisor_s-11'd3)}),.o_data_a(rom_data_h),.o_data_b(rom_data_s));
    
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
    //数据信号延迟
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            rgb_data_r_delay<=0;
            rgb_data_g_delay<=0;
            rgb_data_b_delay<=0;
            set_x_delay<=0;
            set_y_delay<=0;
        end
        else begin
            rgb_data_r_delay<={rgb_data_r_delay[(Default_Delay_Num-1)*8-1:0],i_rgb_data_r};
            rgb_data_g_delay<={rgb_data_g_delay[(Default_Delay_Num-1)*8-1:0],i_rgb_data_g};
            rgb_data_b_delay<={rgb_data_b_delay[(Default_Delay_Num-1)*8-1:0],i_rgb_data_b};
            set_x_delay<={set_x_delay[(Default_Delay_Num-1)*11-1:0],i_set_x};
            set_y_delay<={set_y_delay[(Default_Delay_Num-1)*10-1:0],i_set_y};
        end
    end
    //Find the maximum function
    function [7:0]MAX;
        input [7:0]Data_A;
        input [7:0]Data_B;
        input [7:0]Data_C;
        reg [7:0]Max_AB;
        begin 
            Max_AB = Data_A>=Data_B?Data_A:Data_B;
            MAX = Max_AB>=Data_C?Max_AB:Data_C;
        end
    endfunction
    //Find the minimum function
    function [7:0]MIN;
        input [7:0]Data_A;
        input [7:0]Data_B;
        input [7:0]Data_C;
        reg [7:0]Min_AB;
        begin 
            Min_AB = Data_A <= Data_B ? Data_A : Data_B;
            MIN = Min_AB <= Data_C ? Min_AB : Data_C;
        end
    endfunction
endmodule
