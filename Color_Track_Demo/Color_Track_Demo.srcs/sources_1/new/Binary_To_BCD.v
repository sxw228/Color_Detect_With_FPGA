`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 17:22:37
// Design Name: 
// Module Name: Binary_To_BCD
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


module Binary_To_BCD(
    input	i_clk,
    input	i_rst,
    input	[15:0]i_data,
    output	[19:0]o_bcd_data		
);

    //数据
    reg [ 3:0]data_0=0;    
    reg [ 9:0]data_1=0;
    reg [13:0]data_2=0;
    reg [18:0]data_3=0;
    
    reg [5:0]data_a=0;	
    reg [5:0]data_b=0;	
    reg [5:0]data_c=0;	
    reg [5:0]data_d=0;	
    reg [3:0]data_e=0;	
    
    wire [5:0]data_tmp_a;
    wire [5:0]data_tmp_b;
    wire [5:0]data_tmp_c;
    wire [5:0]data_tmp_d;
    wire [3:0]data_tmp_e;
    //缓存
    reg [15:0]data_i=0;
    
    //输出
    reg [19:0]bcd_data_o=0;
    
    //输出连线
    assign o_bcd_data=bcd_data_o;
    
    //输出数据
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            bcd_data_o<=20'd0;
        end
        else begin
            bcd_data_o<={data_e,data_d[3:0],data_c[3:0],data_b[3:0],data_a[3:0]};
        end
    end
    //数据计算
    assign data_tmp_a= Add_BCD4(data_0[3:0],data_1[3:0],data_2[3:0],data_3[3:0]);
    assign data_tmp_b= Add_BCD4(data_tmp_a[5:4],data_1[7:4],data_2[7:4],data_3[7:4]);
    assign data_tmp_c= Add_BCD4(data_tmp_b[5:4],data_1[9:8],data_2[11:8], data_3[11:8]);
    assign data_tmp_d= Add_BCD4(data_tmp_c[5:4],4'b0000,data_2[13:12],data_3[15:12]);
    assign data_tmp_e=data_tmp_d[5:4] + data_3[18:16];
    
    //数据处理
    always@(posedge i_clk or negedge i_rst)begin
	    if(!i_rst)begin
            data_a <= 6'd0;
            data_b <= 6'd0;
            data_c <= 6'd0;
            data_d <= 6'd0;
            data_e <= 4'd0;
        end
        else begin 
            data_a <= data_tmp_a;
            data_b <= data_tmp_b;
            data_c <= data_tmp_c;
            data_d <= data_tmp_d;
            data_e <= data_tmp_e;
        end
    end

    //输入数据四位提取
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            data_0<= 4'd0;
        end
        else begin
            data_0 <= {data_0[3:0],data_i[3:0]};
        end
    end
    //输入数据四位提取
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)data_1 <= 10'd0;
        else begin
            case(data_i[7:4])
                4'h0: data_1 <= 10'h000;
                4'h1: data_1 <= 10'h016;
                4'h2: data_1 <= 10'h032;
                4'h3: data_1 <= 10'h048;
                4'h4: data_1 <= 10'h064;
                4'h5: data_1 <= 10'h080;
                4'h6: data_1 <= 10'h096;
                4'h7: data_1 <= 10'h112;
                4'h8: data_1 <= 10'h128;
                4'h9: data_1 <= 10'h144;
                4'ha: data_1 <= 10'h160;
                4'hb: data_1 <= 10'h176;
                4'hc: data_1 <= 10'h192;
                4'hd: data_1 <= 10'h208;
                4'he: data_1 <= 10'h224;
                4'hf: data_1 <= 10'h240;
                default: data_1 <= 10'h000;
            endcase
        end
    end
    //输入数据四位提取
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)data_2 <= 14'd0;
        else begin
            case(data_i[11:8]) 
                4'h0: data_2 <= 14'h0000;
                4'h1: data_2 <= 14'h0256;			
                4'h2: data_2 <= 14'h0512;			
                4'h3: data_2 <= 14'h0768;			
                4'h4: data_2 <= 14'h1024;			
                4'h5: data_2 <= 14'h1280;			
                4'h6: data_2 <= 14'h1536;			
                4'h7: data_2 <= 14'h1792;			
                4'h8: data_2 <= 14'h2048;			
                4'h9: data_2 <= 14'h2304;			
                4'ha: data_2 <= 14'h2560;			
                4'hb: data_2 <= 14'h2816;			
                4'hc: data_2 <= 14'h3072;			
                4'hd: data_2 <= 14'h3328;			
                4'he: data_2 <= 14'h3584;			
                4'hf: data_2 <= 14'h3840;			
                default: data_2 <= 14'h0000;
            endcase
        end
    end
    //输入数据四位提取
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)data_3 <= 19'd0;
        else begin
            case(data_i[15:12])
                4'h0: data_3 <= 19'h00000;
                4'h1: data_3 <= 19'h04096;			
                4'h2: data_3 <= 19'h08192;			
                4'h3: data_3 <= 19'h12288;			
                4'h4: data_3 <= 19'h16384;			
                4'h5: data_3 <= 19'h20480;			
                4'h6: data_3 <= 19'h24576;			
                4'h7: data_3 <= 19'h28672;			
                4'h8: data_3 <= 19'h32768;			
                4'h9: data_3 <= 19'h36864;			
                4'ha: data_3 <= 19'h40960;			
                4'hb: data_3 <= 19'h45056;			
                4'hc: data_3 <= 19'h49152;			
                4'hd: data_3 <= 19'h53248;			
                4'he: data_3 <= 19'h57344;				
                4'hf: data_3 <= 19'h61440;					  
                default: data_3 <= 19'h00000;
            endcase
        end
    end
    //输入缓存
    always@(posedge i_clk or negedge i_rst)begin
        if(!i_rst)begin
            data_i<=16'd0;
        end
        else begin
            data_i<=i_data;
        end
    end

    //四个四位二进制位相加最大值为:4'hf+4'hf+4'hf+4'hf=6'd3C		
    function [5:0]Add_BCD4; 
        input	[3:0]i_add1;
        input	[3:0]i_add2;
        input	[3:0]i_add3;
        input	[3:0]i_add4;
        reg [5:0]result;
            begin
                if(i_add1 + i_add2 + i_add3 + i_add4>6'h3b)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'h24;	//大于十进制数59，结果加十进制36
                else if(i_add1 + i_add2 + i_add3 + i_add4>6'h31)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'h1e;	//大于十进制数49，结果加十进制30
                else if(i_add1 + i_add2 + i_add3 + i_add4>6'h27)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'h18;	//大于十进制数39，结果加十进制24
                else if(i_add1 + i_add2 + i_add3 + i_add4>6'h1d)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'h12;	//大于十进制数29，结果加十进制18
                else if(i_add1 + i_add2 + i_add3 + i_add4>6'h13)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'hc;	//大于十进制数19，结果加十进制12
                else if(i_add1 + i_add2 + i_add3 + i_add4>6'h09)
                    result=i_add1 + i_add2 + i_add3 + i_add4 + 5'h6;	//大于十进制数9，结果加十进制6
                else
                    result=i_add1 + i_add2 + i_add3 + i_add4;
                Add_BCD4=result;
            end
    endfunction

endmodule