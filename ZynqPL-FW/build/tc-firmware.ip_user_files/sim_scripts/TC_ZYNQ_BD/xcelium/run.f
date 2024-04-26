-makelib xcelium_lib/xilinx_vip -sv \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_15 -sv \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_processing_system7_0_0/sim/TC_ZYNQ_BD_processing_system7_0_0.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_proc_sys_reset_0_0/sim/TC_ZYNQ_BD_proc_sys_reset_0_0.vhd" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_0_0/util_ds_buf.vhd" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_0_0/sim/TC_ZYNQ_BD_util_ds_buf_0_0.vhd" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_1_0/sim/TC_ZYNQ_BD_util_ds_buf_1_0.vhd" \
-endlib
-makelib xcelium_lib/xlconstant_v1_1_7 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/badb/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_0_0/sim/TC_ZYNQ_BD_xlconstant_0_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_1_0/sim/TC_ZYNQ_BD_xlconstant_1_0.v" \
-endlib
-makelib xcelium_lib/xlconcat_v2_1_4 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_0_0/sim/TC_ZYNQ_BD_xlconcat_0_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_1_0/sim/TC_ZYNQ_BD_xlconcat_1_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_2_0/sim/TC_ZYNQ_BD_xlconcat_2_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_3_0/sim/TC_ZYNQ_BD_xlconcat_3_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_TARGETC_Top_0_0/sim/TC_ZYNQ_BD_TARGETC_Top_0_0.vhd" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_Data2AxiStream_0_0/sim/TC_ZYNQ_BD_Data2AxiStream_0_0.vhd" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_Control_multipleTC_0_0/sim/TC_ZYNQ_BD_Control_multipleTC_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_2_0/sim/TC_ZYNQ_BD_xlconstant_2_0.v" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/lib_fifo_v1_0_16 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/6c82/hdl/lib_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_datamover_v5_1_29 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/2237/hdl/axi_datamover_v5_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_sg_v4_1_15 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/751a/hdl/axi_sg_v4_1_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_dma_v7_1_28 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/70c4/hdl/axi_dma_v7_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_axi_dma_0_0/sim/TC_ZYNQ_BD_axi_dma_0_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xbar_0/sim/TC_ZYNQ_BD_xbar_0.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_pc_0/sim/TC_ZYNQ_BD_auto_pc_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_pc_1/sim/TC_ZYNQ_BD_auto_pc_1.v" \
-endlib
-makelib xcelium_lib/axis_infrastructure_v1_1_0 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axis_register_slice_v1_1_27 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/6ba3/hdl/axis_register_slice_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tdata_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tuser_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tstrb_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tkeep_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tid_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tdest_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tlast_TC_ZYNQ_BD_auto_ss_k_0.v" \
-endlib
-makelib xcelium_lib/axis_subset_converter_v1_1_27 \
  "../../../../../hw/bd/TC_ZYNQ_BD/ipshared/40cb/hdl/axis_subset_converter_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/top_TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/sim/TC_ZYNQ_BD_auto_ss_k_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tdata_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tuser_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tstrb_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tkeep_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tid_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tdest_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/tlast_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/hdl/top_TC_ZYNQ_BD_auto_ss_slid_0.v" \
  "../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_slid_0/sim/TC_ZYNQ_BD_auto_ss_slid_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/TC_ZYNQ_BD/sim/TC_ZYNQ_BD.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

