-makelib ies_lib/xil_defaultlib -sv \
  "D:/Software-Code/Vivado2018.2/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Software-Code/Vivado2018.2/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../ipstatic/hdl/csi2_parser.vhd" \
  "../../../ipstatic/hdl/lane_align.vhd" \
  "../../../ipstatic/hdl/lane_merge.vhd" \
  "../../../ipstatic/hdl/csi_to_axis_v1_0.vhd" \
  "../../../../Color_Track_Demo.srcs/sources_1/ip/csi_to_axis_0/sim/csi_to_axis_0.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

