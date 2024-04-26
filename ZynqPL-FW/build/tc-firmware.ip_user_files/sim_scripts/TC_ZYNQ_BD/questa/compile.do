vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_13
vlib questa_lib/msim/processing_system7_vip_v1_0_15
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/xlconstant_v1_1_7
vlib questa_lib/msim/xlconcat_v2_1_4
vlib questa_lib/msim/lib_pkg_v1_0_2
vlib questa_lib/msim/fifo_generator_v13_2_7
vlib questa_lib/msim/lib_fifo_v1_0_16
vlib questa_lib/msim/lib_srl_fifo_v1_0_2
vlib questa_lib/msim/axi_datamover_v5_1_29
vlib questa_lib/msim/axi_sg_v4_1_15
vlib questa_lib/msim/axi_dma_v7_1_28
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_27
vlib questa_lib/msim/axi_data_fifo_v2_1_26
vlib questa_lib/msim/axi_crossbar_v2_1_28
vlib questa_lib/msim/axi_protocol_converter_v2_1_27
vlib questa_lib/msim/axis_infrastructure_v1_1_0
vlib questa_lib/msim/axis_register_slice_v1_1_27
vlib questa_lib/msim/axis_subset_converter_v1_1_27

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_13 questa_lib/msim/axi_vip_v1_1_13
vmap processing_system7_vip_v1_0_15 questa_lib/msim/processing_system7_vip_v1_0_15
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap xlconstant_v1_1_7 questa_lib/msim/xlconstant_v1_1_7
vmap xlconcat_v2_1_4 questa_lib/msim/xlconcat_v2_1_4
vmap lib_pkg_v1_0_2 questa_lib/msim/lib_pkg_v1_0_2
vmap fifo_generator_v13_2_7 questa_lib/msim/fifo_generator_v13_2_7
vmap lib_fifo_v1_0_16 questa_lib/msim/lib_fifo_v1_0_16
vmap lib_srl_fifo_v1_0_2 questa_lib/msim/lib_srl_fifo_v1_0_2
vmap axi_datamover_v5_1_29 questa_lib/msim/axi_datamover_v5_1_29
vmap axi_sg_v4_1_15 questa_lib/msim/axi_sg_v4_1_15
vmap axi_dma_v7_1_28 questa_lib/msim/axi_dma_v7_1_28
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_27 questa_lib/msim/axi_register_slice_v2_1_27
vmap axi_data_fifo_v2_1_26 questa_lib/msim/axi_data_fifo_v2_1_26
vmap axi_crossbar_v2_1_28 questa_lib/msim/axi_crossbar_v2_1_28
vmap axi_protocol_converter_v2_1_27 questa_lib/msim/axi_protocol_converter_v2_1_27
vmap axis_infrastructure_v1_1_0 questa_lib/msim/axis_infrastructure_v1_1_0
vmap axis_register_slice_v1_1_27 questa_lib/msim/axis_register_slice_v1_1_27
vmap axis_subset_converter_v1_1_27 questa_lib/msim/axis_subset_converter_v1_1_27

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/opt/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_13 -64 -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_15 -64 -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_processing_system7_0_0/sim/TC_ZYNQ_BD_processing_system7_0_0.v" \

vcom -work lib_cdc_v1_0_2 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_proc_sys_reset_0_0/sim/TC_ZYNQ_BD_proc_sys_reset_0_0.vhd" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_0_0/util_ds_buf.vhd" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_0_0/sim/TC_ZYNQ_BD_util_ds_buf_0_0.vhd" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_util_ds_buf_1_0/sim/TC_ZYNQ_BD_util_ds_buf_1_0.vhd" \

vlog -work xlconstant_v1_1_7 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/badb/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_0_0/sim/TC_ZYNQ_BD_xlconstant_0_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_1_0/sim/TC_ZYNQ_BD_xlconstant_1_0.v" \

vlog -work xlconcat_v2_1_4 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_0_0/sim/TC_ZYNQ_BD_xlconcat_0_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_1_0/sim/TC_ZYNQ_BD_xlconcat_1_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_2_0/sim/TC_ZYNQ_BD_xlconcat_2_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconcat_3_0/sim/TC_ZYNQ_BD_xlconcat_3_0.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_TARGETC_Top_0_0/sim/TC_ZYNQ_BD_TARGETC_Top_0_0.vhd" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_Data2AxiStream_0_0/sim/TC_ZYNQ_BD_Data2AxiStream_0_0.vhd" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_Control_multipleTC_0_0/sim/TC_ZYNQ_BD_Control_multipleTC_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xlconstant_2_0/sim/TC_ZYNQ_BD_xlconstant_2_0.v" \

vcom -work lib_pkg_v1_0_2 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_7 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_7 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_7 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_16 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/6c82/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_29 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/2237/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_15 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/751a/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_28 -64 -93  \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/70c4/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_axi_dma_0_0/sim/TC_ZYNQ_BD_axi_dma_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_27 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_26 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_28 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_xbar_0/sim/TC_ZYNQ_BD_xbar_0.v" \

vlog -work axi_protocol_converter_v2_1_27 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_pc_0/sim/TC_ZYNQ_BD_auto_pc_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_pc_1/sim/TC_ZYNQ_BD_auto_pc_1.v" \

vlog -work axis_infrastructure_v1_1_0 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_register_slice_v1_1_27 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/6ba3/hdl/axis_register_slice_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tdata_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tuser_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tstrb_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tkeep_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tid_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tdest_TC_ZYNQ_BD_auto_ss_k_0.v" \
"../../../bd/TC_ZYNQ_BD/ip/TC_ZYNQ_BD_auto_ss_k_0/hdl/tlast_TC_ZYNQ_BD_auto_ss_k_0.v" \

vlog -work axis_subset_converter_v1_1_27 -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../../hw/bd/TC_ZYNQ_BD/ipshared/40cb/hdl/axis_subset_converter_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ec67/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/ee60/hdl" "+incdir+../../../../../hw/bd/TC_ZYNQ_BD/ipshared/8713/hdl" "+incdir+/opt/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
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

vcom -work xil_defaultlib -64 -93  \
"../../../bd/TC_ZYNQ_BD/sim/TC_ZYNQ_BD.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

