-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/Software-Code/Vivado2018.2/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Software-Code/Vivado2018.2/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../ipstatic/hdl/phy_clock_system.vhd" \
  "../../../ipstatic/hdl/line_if.vhd" \
  "../../../ipstatic/hdl/csi2_d_phy_rx.vhd" \
  "../../../../Color_Track_Demo.srcs/sources_1/ip/csi2_d_phy_rx_0/sim/csi2_d_phy_rx_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

