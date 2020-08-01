// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Jul 27 16:29:47 2020
// Host        : DESKTOP-4GI3556 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Xilinx/projects/Chapter17/Color_Track_Demo/Color_Track_Demo/Color_Track_Demo.srcs/sources_1/ip/Word_Rom/Word_Rom_stub.v
// Design      : Word_Rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s15ftgb196-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module Word_Rom(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[9:0],douta[23:0]" */;
  input clka;
  input ena;
  input [9:0]addra;
  output [23:0]douta;
endmodule
