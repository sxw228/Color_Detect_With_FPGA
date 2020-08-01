`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/06 10:33:25
// Design Name: 
// Module Name: Delay_Signal
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


module Delay_Signal(
    input i_clk,                    //Signal unit clock
    input i_rst,                    //Reset signal, low reset
    input i_signal,                 //Delayed input signal
    input [2:0]i_delay_num,         //The number of clocks that need to be delayed, no more than 8, can be cascaded
    output o_signal                 //Signal output after delay
    );
    
    //信号缓存
    reg [7:0]signal_buff=0;
    reg [2:0]delay_num_i=0;
    
    //输出连线
    assign o_signal=signal_buff[delay_num_i];
    
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            signal_buff<=7'd0;
            delay_num_i<=3'd0;
        end
        else begin
            signal_buff<={signal_buff[6:0],i_signal};  
            delay_num_i<=i_delay_num;                      
        end
    end
endmodule
