`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/10 19:50:47
// Design Name: 
// Module Name: select_show
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


//模式判断
module select_show(
    input i_clk,
    input i_rst,
    input i_select_color,
    input i_detect_color,
    output o_show_select,
    output o_show_detect
);

    //状态参数
    localparam ST_IDLE=2'd0;
    localparam ST_SELECT=2'd1;
    localparam ST_DETECT=2'd2;
    localparam ST_END=2'd3;
    
    //状态
    reg [1:0]state_current=0;
    reg [1:0]state_next=0;
    
    //缓存
    reg [1:0]select_color_i=0;
    reg [1:0]detect_color_i=0;
    
    //标志
    reg flg_select=0;
    reg flg_detect=0;
    reg flg_reset=0;
    
    //输出
    reg show_select_o=0;
    reg show_detect_o=0;
    
    //输出连线
    assign o_show_select=show_select_o;
    assign o_show_detect=show_detect_o;
    
    //输出
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            show_select_o<=1'b0;
            show_detect_o<=1'b0;
        end
        else if(state_current==ST_IDLE|state_current==ST_SELECT)begin
            show_select_o<=1'b1;
            show_detect_o<=1'b0;
        end
        else if(state_current==ST_DETECT)begin
            show_select_o<=1'b0;
            show_detect_o<=1'b1;
        end
        else begin
            show_select_o<=1'b0;
            show_detect_o<=1'b0;
        end
    end
    
    //状态机
    always@(*)begin
        case(state_current)
            ST_IDLE:begin
                if(flg_select)state_next<=ST_SELECT;
                else state_next<=ST_IDLE;
            end
            ST_SELECT:begin
                if(flg_detect)state_next<=ST_DETECT;
                else state_next<=ST_SELECT;
            end
            ST_DETECT:begin
                if(flg_reset)state_next<=ST_END;
                else state_next<=ST_DETECT;
            end
            ST_END:begin
                state_next<=ST_IDLE;
            end
        endcase
    end
    
    //状态赋值
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            state_current<=2'd0;
        end
        else begin
            state_current<=state_next;
        end
    end
    
    //颜色选择
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            flg_select<=1'b0;
        end
        else if(state_current==ST_IDLE&select_color_i==2'b10)begin
            flg_select<=1'b1;
        end
        else begin
            flg_select<=1'b0;
        end
    end
    
    //颜色追踪
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            flg_detect<=1'b0;
        end
        else if(state_current==ST_SELECT&select_color_i==2'b01)begin
            flg_detect<=1'b1;
        end
        else begin
            flg_detect<=1'b0;
        end
    end
    
    //复位
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            flg_reset<=1'b0;
        end
        else if(state_current==ST_DETECT&detect_color_i==2'b10)begin
            flg_reset<=1'b1;
        end
        else begin
            flg_reset<=1'b0;
        end
    end
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            select_color_i<=2'd0;
            detect_color_i<=2'd0;
        end
        else begin
            select_color_i<={select_color_i[0],i_select_color};
            detect_color_i={detect_color_i[0],i_detect_color};
        end
    end
endmodule

