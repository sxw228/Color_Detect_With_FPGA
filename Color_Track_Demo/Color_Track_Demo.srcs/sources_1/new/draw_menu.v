`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 15:16:18
// Design Name: 
// Module Name: draw_menu
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


module draw_menu(
    input i_clk,
    input i_rst,
    input i_select_color,
    input i_detect_color,
    input [4:0]i_addrx,
    input [4:0]i_addry,
    input [5:0]i_blockx,
    input [4:0]i_blocky,
    input [10:0]i_set_x,
    input [9:0]i_set_y,
    input [23:0]i_rgb_res,
    input [23:0]i_rgb_data,
    input i_rgb_vde,
    input i_rgb_hsync,
    input i_rgb_vsync,
    output [23:0]o_rgb_data,
    output o_rgb_vde,
    output o_rgb_hsync,
    output o_rgb_vsync
    );
    
    //标注坐标
    localparam HEAD_0_Y=4'd1;
    localparam HEAD_CENTERX_X=4'd1;
    localparam HEAD_CENTERX_X_Length=4'd2-4'd1;
    
    localparam HEAD_1_Y=4'd2;
    localparam HEAD_CENTERY_X=4'd1;
    localparam HEAD_CENTERY_X_Length=4'd2-4'd1;
    
    localparam HEAD_2_Y=4'd3;
    localparam HEAD_BLUE_X=4'd1;
    localparam HEAD_BLUE_X_Length=4'd2-4'd1;
    
    localparam CENTERX_X=4'd10;
    localparam CENTERX_X_Length=3'd4-3'd1;
    localparam CENTERY_X=4'd10;
    localparam CENTERY_X_Length=3'd4-3'd1;
   
    localparam BLUE_X=4'd10;
    localparam BLUE_X_Length=3'd4-3'd1;
    //数据
    reg en_txt=0;
    reg [7:0]word=0;
    reg [2:0]word_color=3'd7;
    
    reg [7:0]word_center_x=0;
    reg [7:0]word_center_y=0;
    reg [7:0]word_center_blue=0;
    
    reg [7:0]data_center_x=0;
    reg [7:0]data_center_y=0;
    reg [7:0]data_center_blue=0;
    
    wire [19:0]bcd_data_x;
    wire [19:0]bcd_data_y;
    wire [19:0]bcd_data_blue;
    
    //计数
    reg [2:0]data_centerx_num=0;
    reg [2:0]data_centery_num=0;
    reg [3:0]word_centerx_num=0;
    reg [3:0]word_centery_num=0;
    reg [2:0]data_blue_num=0;
    reg [3:0]word_blue_num=0;
    
    //缓存
    reg [10:0]center_x_i=0;
    reg [9:0]center_y_i=0;
    reg [9:0]blue_i=0;
    reg [4:0]addrx_i=0;
    reg [4:0]addry_i=0;
    reg [5:0]blockx_i=0;
    reg [4:0]blocky_i=0;
    
    //数据分配
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            word<=8'd0;
            word_color<=3'd7;
            en_txt<=0;
        end
        else if(blockx_i>=HEAD_CENTERX_X&blockx_i<=HEAD_CENTERX_X+HEAD_CENTERX_X_Length&blocky_i==HEAD_0_Y)begin
            word<=word_center_x;
            word_color<=3'd7;
            en_txt<=1;
        end
        else if(blockx_i>=HEAD_CENTERY_X&blockx_i<=HEAD_CENTERY_X+HEAD_CENTERY_X_Length&blocky_i==HEAD_1_Y)begin
            word<=word_center_y;
            word_color<=3'd7;
            en_txt<=1;
        end
        else if(blockx_i>=CENTERX_X&blockx_i<=CENTERX_X+CENTERX_X_Length&blocky_i==HEAD_0_Y)begin
            word<=data_center_x;
            word_color<=3'd7;
            en_txt<=1;
        end
        else if(blockx_i>=CENTERY_X&blockx_i<=CENTERY_X+CENTERY_X_Length&blocky_i==HEAD_1_Y)begin
            word<=data_center_y;
            word_color<=3'd7;
            en_txt<=1;
        end
        
        else if(blockx_i>=HEAD_CENTERY_X&blockx_i<=HEAD_CENTERY_X+HEAD_CENTERY_X_Length&blocky_i==HEAD_2_Y)begin
            word<=word_center_blue;
            word_color<=3'd7;
            en_txt<=1;
        end
        else if(blockx_i>=CENTERX_X&blockx_i<=CENTERX_X+CENTERX_X_Length&blocky_i==HEAD_2_Y)begin
            word<=data_center_blue;
            word_color<=3'd7;
            en_txt<=1;
        end
        
        
        
        else begin
            word_color<=3'd7;
            word<=8'd0;
            en_txt<=0;
        end
    end
    //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            word_center_x<=8'd0;
        end
        else begin
            case(word_centerx_num)
                3'd0:word_center_x<=8'd27;
                3'd1:word_center_x<=8'd37;
                default:word_center_x<=8'd0;
            endcase
        end
    end
        //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            word_center_blue<=8'd0;
        end
        else begin
            case(word_centerx_num)
                3'd0:word_center_blue<=8'd16;
                3'd1:word_center_blue<=8'd37;
                default:word_center_blue<=8'd0;
            endcase
        end
    end
    //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            word_center_y<=8'd0;
        end
        else begin
            case(word_centery_num)
                3'd0:word_center_y<=8'd11;
                3'd1:word_center_y<=8'd37;
                default:word_center_y<=8'd0;
            endcase
        end
    end
    //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            data_center_x<=8'd0;
        end
        else begin
            case(data_centerx_num)
                3'd3:data_center_x<=bcd_data_x[3:0];
                3'd2:data_center_x<=bcd_data_x[7:4];
                3'd1:data_center_x<=bcd_data_x[11:8];
                3'd0:data_center_x<=bcd_data_x[15:12];
                default:data_center_x<=8'd0;
            endcase
        end
    end
    //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            data_center_y<=8'd0;
        end
        else begin
            case(data_centery_num)
                3'd3:data_center_y<=bcd_data_y[3:0];
                3'd2:data_center_y<=bcd_data_y[7:4];
                3'd1:data_center_y<=bcd_data_y[11:8];
                3'd0:data_center_y<=bcd_data_y[15:12];
                default:data_center_y<=8'd0;
            endcase
        end
    end
        //字符串数据转换
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            data_center_blue<=8'd0;
        end
        else begin
            case(data_centery_num)
                3'd3:data_center_blue<=bcd_data_blue[3:0];
                3'd2:data_center_blue<=bcd_data_blue[7:4];
                3'd1:data_center_blue<=bcd_data_blue[11:8];
                3'd0:data_center_blue<=bcd_data_blue[15:12];
                default:data_center_blue<=8'd0;
            endcase
        end
    end
    
    //显示
    show_res Res_Show(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_txt(en_txt),
        .i_select_color(i_select_color),
        .i_detect_color(i_detect_color),
        .i_word(word),
        .i_word_color(word_color),
        .i_back_color(i_rgb_data),
        .i_addrx(i_addrx),
        .i_addry(i_addry),
        .i_set_x(i_set_x),
        .i_set_y(i_set_y),
        .i_center_x(center_x_i),
        .i_center_y(center_y_i),
        .i_rgb_vde(i_rgb_vde),
        .i_rgb_hsync(i_rgb_hsync),
        .i_rgb_vsync(i_rgb_vsync),
        .o_rgb_data(o_rgb_data),
        .o_rgb_vde(o_rgb_vde),
        .o_rgb_hsync(o_rgb_hsync),
        .o_rgb_vsync(o_rgb_vsync)
    );

    //坐标转BCD码
    Binary_To_BCD X_BCD(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(center_x_i),
        .o_bcd_data(bcd_data_x)	
    );
    //坐标转BCD码
    Binary_To_BCD Y_BCD(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(center_y_i),
        .o_bcd_data(bcd_data_y)	
    );
    
        //坐标转BCD码
    Binary_To_BCD BLUE_BCD(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(blue_i),
        .o_bcd_data(bcd_data_blue)	
    );
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            center_x_i<=11'd0;
            center_y_i<=10'd0;
            addrx_i<=5'd0;
            addry_i<=5'd0;
            blockx_i<=6'd0;
            blocky_i<=5'd0;
            data_centerx_num<=3'd0;
            data_centery_num<=3'd0;
            word_centerx_num<=4'd0;
            word_centery_num<=4'd0;
            data_blue_num<=3'd0;
            word_blue_num<=4'd0;
            blue_i<=10'd0;
        end
        else begin
            center_x_i<=i_rgb_res[23:16];
            center_y_i<=i_rgb_res[15:8];
            blue_i<=i_rgb_res[7:0];
            addrx_i<=i_addrx;
            addry_i<=i_addry;
            blockx_i<=i_blockx;
            blocky_i<=i_blocky;
            data_centerx_num<=i_blockx-CENTERX_X;
            data_centery_num<=i_blockx-CENTERY_X;
            word_centerx_num<=i_blockx-HEAD_CENTERX_X;
            word_centery_num<=i_blockx-HEAD_CENTERY_X;
            data_blue_num<=i_blockx-CENTERY_X;
            word_blue_num<=i_blockx-HEAD_CENTERX_X;
        end
    end
endmodule