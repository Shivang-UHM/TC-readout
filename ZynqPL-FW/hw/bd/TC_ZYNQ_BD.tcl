
################################################################
# This is a generated script based on design: TC_ZYNQ_BD
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source TC_ZYNQ_BD_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# Control_multipleTC, Data2AxiStream, TARGETC_Top

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name TC_ZYNQ_BD

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2030 -severity "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_gid_msg -ssname BD::TCL -id 2031 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_gid_msg -ssname BD::TCL -id 2032 -severity "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2033 -severity "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2034 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2035 -severity "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_gid_msg -ssname BD::TCL -id 2036 -severity "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2037 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_gid_msg -ssname BD::TCL -id 2038 -severity "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
Control_multipleTC\
Data2AxiStream\
TARGETC_Top\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set A_DONE [ create_bd_port -dir I A_DONE ]
  set A_DO_1 [ create_bd_port -dir I -type data A_DO_1 ]
  set A_DO_2 [ create_bd_port -dir I -type data A_DO_2 ]
  set A_DO_3 [ create_bd_port -dir I -type data A_DO_3 ]
  set A_DO_4 [ create_bd_port -dir I -type data A_DO_4 ]
  set A_DO_5 [ create_bd_port -dir I -type data A_DO_5 ]
  set A_DO_6 [ create_bd_port -dir I -type data A_DO_6 ]
  set A_DO_7 [ create_bd_port -dir I -type data A_DO_7 ]
  set A_DO_8 [ create_bd_port -dir I -type data A_DO_8 ]
  set A_DO_9 [ create_bd_port -dir I -type data A_DO_9 ]
  set A_DO_10 [ create_bd_port -dir I -type data A_DO_10 ]
  set A_DO_11 [ create_bd_port -dir I -type data A_DO_11 ]
  set A_DO_12 [ create_bd_port -dir I -type data A_DO_12 ]
  set A_DO_13 [ create_bd_port -dir I -type data A_DO_13 ]
  set A_DO_14 [ create_bd_port -dir I -type data A_DO_14 ]
  set A_DO_15 [ create_bd_port -dir I -type data A_DO_15 ]
  set A_DO_16 [ create_bd_port -dir I -type data A_DO_16 ]
  set A_GCC_RESET [ create_bd_port -dir O -type rst A_GCC_RESET ]
  set A_HSCLK_N [ create_bd_port -dir O A_HSCLK_N ]
  set A_HSCLK_P [ create_bd_port -dir O A_HSCLK_P ]
  set A_PCLK [ create_bd_port -dir O A_PCLK ]
  set A_RAMP [ create_bd_port -dir O A_RAMP ]
  set A_RDAD_CLK [ create_bd_port -dir O -type clk A_RDAD_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] $A_RDAD_CLK
  set A_RDAD_DIR [ create_bd_port -dir O A_RDAD_DIR ]
  set A_RDAD_SIN [ create_bd_port -dir O A_RDAD_SIN ]
  set A_SAMPLESEL_ANY [ create_bd_port -dir O A_SAMPLESEL_ANY ]
  set A_SHOUT [ create_bd_port -dir I A_SHOUT ]
  set A_SS_INCR [ create_bd_port -dir O A_SS_INCR ]
  set A_SS_RESET [ create_bd_port -dir O -type rst A_SS_RESET ]
  set A_WR_CS_S0 [ create_bd_port -dir O A_WR_CS_S0 ]
  set A_WR_CS_S1 [ create_bd_port -dir O A_WR_CS_S1 ]
  set A_WR_CS_S2 [ create_bd_port -dir O A_WR_CS_S2 ]
  set A_WR_CS_S3 [ create_bd_port -dir O A_WR_CS_S3 ]
  set A_WR_CS_S4 [ create_bd_port -dir O A_WR_CS_S4 ]
  set A_WR_CS_S5 [ create_bd_port -dir O A_WR_CS_S5 ]
  set A_WR_RS_S0 [ create_bd_port -dir O A_WR_RS_S0 ]
  set A_WR_RS_S1 [ create_bd_port -dir O A_WR_RS_S1 ]
  set B_DONE [ create_bd_port -dir I B_DONE ]
  set B_DO_1 [ create_bd_port -dir I -type data B_DO_1 ]
  set B_DO_2 [ create_bd_port -dir I -type data B_DO_2 ]
  set B_DO_3 [ create_bd_port -dir I -type data B_DO_3 ]
  set B_DO_4 [ create_bd_port -dir I -type data B_DO_4 ]
  set B_DO_5 [ create_bd_port -dir I -type data B_DO_5 ]
  set B_DO_6 [ create_bd_port -dir I -type data B_DO_6 ]
  set B_DO_7 [ create_bd_port -dir I -type data B_DO_7 ]
  set B_DO_8 [ create_bd_port -dir I -type data B_DO_8 ]
  set B_DO_9 [ create_bd_port -dir I -type data B_DO_9 ]
  set B_DO_10 [ create_bd_port -dir I -type data B_DO_10 ]
  set B_DO_11 [ create_bd_port -dir I -type data B_DO_11 ]
  set B_DO_12 [ create_bd_port -dir I -type data B_DO_12 ]
  set B_DO_13 [ create_bd_port -dir I -type data B_DO_13 ]
  set B_DO_14 [ create_bd_port -dir I -type data B_DO_14 ]
  set B_DO_15 [ create_bd_port -dir I -type data B_DO_15 ]
  set B_DO_16 [ create_bd_port -dir I -type data B_DO_16 ]
  set B_GCC_RESET [ create_bd_port -dir O -type rst B_GCC_RESET ]
  set B_HSCLK_N [ create_bd_port -dir O B_HSCLK_N ]
  set B_HSCLK_P [ create_bd_port -dir O B_HSCLK_P ]
  set B_PCLK [ create_bd_port -dir O B_PCLK ]
  set B_RAMP [ create_bd_port -dir O B_RAMP ]
  set B_RDAD_CLK [ create_bd_port -dir O -type clk B_RDAD_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] $B_RDAD_CLK
  set B_RDAD_DIR [ create_bd_port -dir O B_RDAD_DIR ]
  set B_RDAD_SIN [ create_bd_port -dir O B_RDAD_SIN ]
  set B_SAMPLESEL_ANY [ create_bd_port -dir O B_SAMPLESEL_ANY ]
  set B_SHOUT [ create_bd_port -dir I B_SHOUT ]
  set B_SS_INCR [ create_bd_port -dir O B_SS_INCR ]
  set B_SS_RESET [ create_bd_port -dir O -type rst B_SS_RESET ]
  set B_WR_CS_S0 [ create_bd_port -dir O B_WR_CS_S0 ]
  set B_WR_CS_S1 [ create_bd_port -dir O B_WR_CS_S1 ]
  set B_WR_CS_S2 [ create_bd_port -dir O B_WR_CS_S2 ]
  set B_WR_CS_S3 [ create_bd_port -dir O B_WR_CS_S3 ]
  set B_WR_CS_S4 [ create_bd_port -dir O B_WR_CS_S4 ]
  set B_WR_CS_S5 [ create_bd_port -dir O B_WR_CS_S5 ]
  set B_WR_RS_S0 [ create_bd_port -dir O B_WR_RS_S0 ]
  set B_WR_RS_S1 [ create_bd_port -dir O B_WR_RS_S1 ]
  set MONTIMING_N [ create_bd_port -dir I MONTIMING_N ]
  set MONTIMING_P [ create_bd_port -dir I MONTIMING_P ]
  set SCLK [ create_bd_port -dir O SCLK ]
  set SIN [ create_bd_port -dir O SIN ]
  set SSTIN_N [ create_bd_port -dir O -from 0 -to 0 -type clk SSTIN_N ]
  set SSTIN_P [ create_bd_port -dir O -from 0 -to 0 -type clk SSTIN_P ]
  set WL_CLK_N [ create_bd_port -dir O -from 0 -to 0 -type clk WL_CLK_N ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $WL_CLK_N
  set WL_CLK_P [ create_bd_port -dir O -from 0 -to 0 -type clk WL_CLK_P ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $WL_CLK_P

  # Create instance: Control_multipleTC_0, and set properties
  set block_name Control_multipleTC
  set block_cell_name Control_multipleTC_0
  if { [catch {set Control_multipleTC_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Control_multipleTC_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Data2AxiStream_0, and set properties
  set block_name Data2AxiStream
  set block_cell_name Data2AxiStream_0
  if { [catch {set Data2AxiStream_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Data2AxiStream_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: TARGETC_Top_0, and set properties
  set block_name TARGETC_Top
  set block_cell_name TARGETC_Top_0
  if { [catch {set TARGETC_Top_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $TARGETC_Top_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_include_sg {0} \
    CONFIG.c_s2mm_burst_size {128} \
  ] $axi_dma_0


  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property CONFIG.NUM_MI {1} $axi_mem_intercon


  # Create instance: axis_interconnect_0, and set properties
  set axis_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0 ]
  set_property -dict [list \
    CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
    CONFIG.NUM_MI {1} \
  ] $axis_interconnect_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset_0


  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {25.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_CLK0_FREQ {125000000} \
    CONFIG.PCW_CLK1_FREQ {10000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
    CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
    CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps} \
    CONFIG.PCW_ENET0_RESET_ENABLE {0} \
    CONFIG.PCW_ENET_RESET_ENABLE {1} \
    CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
    CONFIG.PCW_EN_EMIO_ENET0 {0} \
    CONFIG.PCW_EN_EMIO_TTC0 {1} \
    CONFIG.PCW_EN_EMIO_UART0 {0} \
    CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
    CONFIG.PCW_EN_ENET0 {1} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_QSPI {1} \
    CONFIG.PCW_EN_SDIO0 {1} \
    CONFIG.PCW_EN_TTC0 {1} \
    CONFIG.PCW_EN_UART0 {0} \
    CONFIG.PCW_EN_UART1 {1} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_I2C_RESET_ENABLE {0} \
    CONFIG.PCW_IRQ_F2P_INTR {1} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_0_PULLUP {enabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_10_PULLUP {enabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_11_PULLUP {enabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_12_PULLUP {enabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_13_PULLUP {enabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_14_PULLUP {enabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_15_PULLUP {enabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {disabled} \
    CONFIG.PCW_MIO_16_SLEW {slow} \
    CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {disabled} \
    CONFIG.PCW_MIO_17_SLEW {slow} \
    CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {disabled} \
    CONFIG.PCW_MIO_18_SLEW {slow} \
    CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {disabled} \
    CONFIG.PCW_MIO_19_SLEW {slow} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_1_PULLUP {enabled} \
    CONFIG.PCW_MIO_1_SLEW {slow} \
    CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {disabled} \
    CONFIG.PCW_MIO_20_SLEW {slow} \
    CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {disabled} \
    CONFIG.PCW_MIO_21_SLEW {slow} \
    CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {disabled} \
    CONFIG.PCW_MIO_22_SLEW {slow} \
    CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {disabled} \
    CONFIG.PCW_MIO_23_SLEW {slow} \
    CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {disabled} \
    CONFIG.PCW_MIO_24_SLEW {slow} \
    CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {disabled} \
    CONFIG.PCW_MIO_25_SLEW {slow} \
    CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {disabled} \
    CONFIG.PCW_MIO_26_SLEW {slow} \
    CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {disabled} \
    CONFIG.PCW_MIO_27_SLEW {slow} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {enabled} \
    CONFIG.PCW_MIO_28_SLEW {slow} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {enabled} \
    CONFIG.PCW_MIO_29_SLEW {slow} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_2_SLEW {slow} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {enabled} \
    CONFIG.PCW_MIO_30_SLEW {slow} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {enabled} \
    CONFIG.PCW_MIO_31_SLEW {slow} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {enabled} \
    CONFIG.PCW_MIO_32_SLEW {slow} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {enabled} \
    CONFIG.PCW_MIO_33_SLEW {slow} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {enabled} \
    CONFIG.PCW_MIO_34_SLEW {slow} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {enabled} \
    CONFIG.PCW_MIO_35_SLEW {slow} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {enabled} \
    CONFIG.PCW_MIO_36_SLEW {slow} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {enabled} \
    CONFIG.PCW_MIO_37_SLEW {slow} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {enabled} \
    CONFIG.PCW_MIO_38_SLEW {slow} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {enabled} \
    CONFIG.PCW_MIO_39_SLEW {slow} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_3_SLEW {slow} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {enabled} \
    CONFIG.PCW_MIO_40_SLEW {slow} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {enabled} \
    CONFIG.PCW_MIO_41_SLEW {slow} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {enabled} \
    CONFIG.PCW_MIO_42_SLEW {slow} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {enabled} \
    CONFIG.PCW_MIO_43_SLEW {slow} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {enabled} \
    CONFIG.PCW_MIO_44_SLEW {slow} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {enabled} \
    CONFIG.PCW_MIO_45_SLEW {slow} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {enabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {enabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {disabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {disabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_4_SLEW {slow} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {enabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {enabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {disabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {disabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_5_SLEW {slow} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_6_SLEW {slow} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_8_SLEW {slow} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_9_PULLUP {enabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#UART 1#UART 1#SD 0#GPIO#Enet 0#Enet\
0} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#gpio[47]#tx#rx#wp#gpio[51]#mdc#mdio}\
\
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
    CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
    CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
    CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
    CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
    CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
    CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
    CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
    CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
    CONFIG.PCW_USB_RESET_ENABLE {1} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
  ] $processing_system7_0


  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property CONFIG.NUM_MI {3} $ps7_0_axi_periph


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {OBUFDS} $util_ds_buf_0


  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property CONFIG.C_BUF_TYPE {OBUFDS} $util_ds_buf_1


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {16} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {16} $xlconcat_1


  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {16} \
    CONFIG.IN1_WIDTH {16} \
  ] $xlconcat_2


  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_WIDTH {4} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {3} \
    CONFIG.CONST_WIDTH {3} \
  ] $xlconstant_1


  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $xlconstant_2


  # Create interface connections
  connect_bd_intf_net -intf_net Data2AxiStream_0_M_AXIS [get_bd_intf_pins Data2AxiStream_0/M_AXIS] [get_bd_intf_pins axis_interconnect_0/S00_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_interconnect_0/M00_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins TARGETC_Top_0/tc_axi] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins Control_multipleTC_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]

  # Create port connections
  connect_bd_net -net A_DONE_0_1 [get_bd_ports A_DONE] [get_bd_pins TARGETC_Top_0/A_DONE]
  connect_bd_net -net A_DO_10_1 [get_bd_ports A_DO_10] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net A_DO_11_1 [get_bd_ports A_DO_11] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net A_DO_12_1 [get_bd_ports A_DO_12] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net A_DO_13_1 [get_bd_ports A_DO_13] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net A_DO_14_1 [get_bd_ports A_DO_14] [get_bd_pins xlconcat_0/In13]
  connect_bd_net -net A_DO_15_1 [get_bd_ports A_DO_15] [get_bd_pins xlconcat_0/In14]
  connect_bd_net -net A_DO_16_1 [get_bd_ports A_DO_16] [get_bd_pins xlconcat_0/In15]
  connect_bd_net -net A_DO_1_1 [get_bd_ports A_DO_1] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net A_DO_2_1 [get_bd_ports A_DO_2] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net A_DO_3_1 [get_bd_ports A_DO_3] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net A_DO_4_1 [get_bd_ports A_DO_4] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net A_DO_5_1 [get_bd_ports A_DO_5] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net A_DO_6_1 [get_bd_ports A_DO_6] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net A_DO_7_1 [get_bd_ports A_DO_7] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net A_DO_8_1 [get_bd_ports A_DO_8] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net A_DO_9_1 [get_bd_ports A_DO_9] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net A_SHOUT_0_1 [get_bd_ports A_SHOUT] [get_bd_pins TARGETC_Top_0/A_SHOUT]
  connect_bd_net -net B_DONE_0_1 [get_bd_ports B_DONE] [get_bd_pins TARGETC_Top_0/B_DONE]
  connect_bd_net -net B_DO_10_1 [get_bd_ports B_DO_10] [get_bd_pins xlconcat_1/In9]
  connect_bd_net -net B_DO_11_1 [get_bd_ports B_DO_11] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net B_DO_12_1 [get_bd_ports B_DO_12] [get_bd_pins xlconcat_1/In11]
  connect_bd_net -net B_DO_13_1 [get_bd_ports B_DO_13] [get_bd_pins xlconcat_1/In12]
  connect_bd_net -net B_DO_14_1 [get_bd_ports B_DO_14] [get_bd_pins xlconcat_1/In13]
  connect_bd_net -net B_DO_15_1 [get_bd_ports B_DO_15] [get_bd_pins xlconcat_1/In14]
  connect_bd_net -net B_DO_16_1 [get_bd_ports B_DO_16] [get_bd_pins xlconcat_1/In15]
  connect_bd_net -net B_DO_1_1 [get_bd_ports B_DO_1] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net B_DO_2_1 [get_bd_ports B_DO_2] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net B_DO_3_1 [get_bd_ports B_DO_3] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net B_DO_4_1 [get_bd_ports B_DO_4] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net B_DO_5_1 [get_bd_ports B_DO_5] [get_bd_pins xlconcat_1/In4]
  connect_bd_net -net B_DO_6_1 [get_bd_ports B_DO_6] [get_bd_pins xlconcat_1/In5]
  connect_bd_net -net B_DO_7_1 [get_bd_ports B_DO_7] [get_bd_pins xlconcat_1/In6]
  connect_bd_net -net B_DO_8_1 [get_bd_ports B_DO_8] [get_bd_pins xlconcat_1/In7]
  connect_bd_net -net B_DO_9_1 [get_bd_ports B_DO_9] [get_bd_pins xlconcat_1/In8]
  connect_bd_net -net B_SHOUT_0_1 [get_bd_ports B_SHOUT] [get_bd_pins TARGETC_Top_0/B_SHOUT]
  connect_bd_net -net Control_multipleTC_0_PStrigger [get_bd_pins Control_multipleTC_0/PStrigger] [get_bd_pins TARGETC_Top_0/hmb_trigger]
  connect_bd_net -net Control_multipleTC_0_trigger_Mode [get_bd_pins Control_multipleTC_0/trigger_Mode] [get_bd_pins TARGETC_Top_0/mode]
  connect_bd_net -net Control_multipleTC_0_window_Storage [get_bd_pins Control_multipleTC_0/window_Storage] [get_bd_pins TARGETC_Top_0/windowstorage]
  connect_bd_net -net Data2AxiStream_0_Cnt_AXIS_DATA [get_bd_pins Data2AxiStream_0/Cnt_AXIS_DATA] [get_bd_pins TARGETC_Top_0/Cnt_AXIS_DATA]
  connect_bd_net -net Data2AxiStream_0_StreamReady [get_bd_pins Data2AxiStream_0/StreamReady] [get_bd_pins TARGETC_Top_0/StreamReady]
  connect_bd_net -net MONTIMING_N_0_1 [get_bd_ports MONTIMING_N] [get_bd_pins TARGETC_Top_0/MONTIMING_N]
  connect_bd_net -net MONTIMING_P_0_1 [get_bd_ports MONTIMING_P] [get_bd_pins TARGETC_Top_0/MONTIMING_P]
  connect_bd_net -net TARGETC_Top_0_A_GCC_RESET [get_bd_ports A_GCC_RESET] [get_bd_pins TARGETC_Top_0/A_GCC_RESET]
  connect_bd_net -net TARGETC_Top_0_A_HSCLK_N [get_bd_ports A_HSCLK_N] [get_bd_pins TARGETC_Top_0/A_HSCLK_N]
  connect_bd_net -net TARGETC_Top_0_A_HSCLK_P [get_bd_ports A_HSCLK_P] [get_bd_pins TARGETC_Top_0/A_HSCLK_P]
  connect_bd_net -net TARGETC_Top_0_A_PCLK [get_bd_ports A_PCLK] [get_bd_pins TARGETC_Top_0/A_PCLK]
  connect_bd_net -net TARGETC_Top_0_A_RAMP [get_bd_ports A_RAMP] [get_bd_pins TARGETC_Top_0/A_RAMP]
  connect_bd_net -net TARGETC_Top_0_A_RDAD_CLK [get_bd_ports A_RDAD_CLK] [get_bd_pins TARGETC_Top_0/A_RDAD_CLK]
  connect_bd_net -net TARGETC_Top_0_A_RDAD_DIR [get_bd_ports A_RDAD_DIR] [get_bd_pins TARGETC_Top_0/A_RDAD_DIR]
  connect_bd_net -net TARGETC_Top_0_A_RDAD_SIN [get_bd_ports A_RDAD_SIN] [get_bd_pins TARGETC_Top_0/A_RDAD_SIN]
  connect_bd_net -net TARGETC_Top_0_A_SAMPLESEL_ANY [get_bd_ports A_SAMPLESEL_ANY] [get_bd_pins TARGETC_Top_0/A_SAMPLESEL_ANY]
  connect_bd_net -net TARGETC_Top_0_A_SS_INCR [get_bd_ports A_SS_INCR] [get_bd_pins TARGETC_Top_0/A_SS_INCR]
  connect_bd_net -net TARGETC_Top_0_A_SS_RESET [get_bd_ports A_SS_RESET] [get_bd_pins TARGETC_Top_0/A_SS_RESET]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S0 [get_bd_ports A_WR_CS_S0] [get_bd_pins TARGETC_Top_0/A_WR_CS_S0]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S1 [get_bd_ports A_WR_CS_S1] [get_bd_pins TARGETC_Top_0/A_WR_CS_S1]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S2 [get_bd_ports A_WR_CS_S2] [get_bd_pins TARGETC_Top_0/A_WR_CS_S2]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S3 [get_bd_ports A_WR_CS_S3] [get_bd_pins TARGETC_Top_0/A_WR_CS_S3]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S4 [get_bd_ports A_WR_CS_S4] [get_bd_pins TARGETC_Top_0/A_WR_CS_S4]
  connect_bd_net -net TARGETC_Top_0_A_WR_CS_S5 [get_bd_ports A_WR_CS_S5] [get_bd_pins TARGETC_Top_0/A_WR_CS_S5]
  connect_bd_net -net TARGETC_Top_0_A_WR_RS_S0 [get_bd_ports A_WR_RS_S0] [get_bd_pins TARGETC_Top_0/A_WR_RS_S0]
  connect_bd_net -net TARGETC_Top_0_A_WR_RS_S1 [get_bd_ports A_WR_RS_S1] [get_bd_pins TARGETC_Top_0/A_WR_RS_S1]
  connect_bd_net -net TARGETC_Top_0_B_GCC_RESET [get_bd_ports B_GCC_RESET] [get_bd_pins TARGETC_Top_0/B_GCC_RESET]
  connect_bd_net -net TARGETC_Top_0_B_HSCLK_N [get_bd_ports B_HSCLK_N] [get_bd_pins TARGETC_Top_0/B_HSCLK_N]
  connect_bd_net -net TARGETC_Top_0_B_HSCLK_P [get_bd_ports B_HSCLK_P] [get_bd_pins TARGETC_Top_0/B_HSCLK_P]
  connect_bd_net -net TARGETC_Top_0_B_PCLK [get_bd_ports B_PCLK] [get_bd_pins TARGETC_Top_0/B_PCLK]
  connect_bd_net -net TARGETC_Top_0_B_RAMP [get_bd_ports B_RAMP] [get_bd_pins TARGETC_Top_0/B_RAMP]
  connect_bd_net -net TARGETC_Top_0_B_RDAD_CLK [get_bd_ports B_RDAD_CLK] [get_bd_pins TARGETC_Top_0/B_RDAD_CLK]
  connect_bd_net -net TARGETC_Top_0_B_RDAD_DIR [get_bd_ports B_RDAD_DIR] [get_bd_pins TARGETC_Top_0/B_RDAD_DIR]
  connect_bd_net -net TARGETC_Top_0_B_RDAD_SIN [get_bd_ports B_RDAD_SIN] [get_bd_pins TARGETC_Top_0/B_RDAD_SIN]
  connect_bd_net -net TARGETC_Top_0_B_SAMPLESEL_ANY [get_bd_ports B_SAMPLESEL_ANY] [get_bd_pins TARGETC_Top_0/B_SAMPLESEL_ANY]
  connect_bd_net -net TARGETC_Top_0_B_SS_INCR [get_bd_ports B_SS_INCR] [get_bd_pins TARGETC_Top_0/B_SS_INCR]
  connect_bd_net -net TARGETC_Top_0_B_SS_RESET [get_bd_ports B_SS_RESET] [get_bd_pins TARGETC_Top_0/B_SS_RESET]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S0 [get_bd_ports B_WR_CS_S0] [get_bd_pins TARGETC_Top_0/B_WR_CS_S0]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S1 [get_bd_ports B_WR_CS_S1] [get_bd_pins TARGETC_Top_0/B_WR_CS_S1]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S2 [get_bd_ports B_WR_CS_S2] [get_bd_pins TARGETC_Top_0/B_WR_CS_S2]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S3 [get_bd_ports B_WR_CS_S3] [get_bd_pins TARGETC_Top_0/B_WR_CS_S3]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S4 [get_bd_ports B_WR_CS_S4] [get_bd_pins TARGETC_Top_0/B_WR_CS_S4]
  connect_bd_net -net TARGETC_Top_0_B_WR_CS_S5 [get_bd_ports B_WR_CS_S5] [get_bd_pins TARGETC_Top_0/B_WR_CS_S5]
  connect_bd_net -net TARGETC_Top_0_B_WR_RS_S0 [get_bd_ports B_WR_RS_S0] [get_bd_pins TARGETC_Top_0/B_WR_RS_S0]
  connect_bd_net -net TARGETC_Top_0_B_WR_RS_S1 [get_bd_ports B_WR_RS_S1] [get_bd_pins TARGETC_Top_0/B_WR_RS_S1]
  connect_bd_net -net TARGETC_Top_0_CNT_CLR_A_B [get_bd_pins Data2AxiStream_0/CNT_CLR] [get_bd_pins TARGETC_Top_0/CNT_CLR_A_B]
  connect_bd_net -net TARGETC_Top_0_FIFOdata [get_bd_pins Data2AxiStream_0/FIFOdata] [get_bd_pins TARGETC_Top_0/FIFOdata]
  connect_bd_net -net TARGETC_Top_0_FIFOvalid [get_bd_pins Data2AxiStream_0/FIFOvalid] [get_bd_pins TARGETC_Top_0/FIFOvalid]
  connect_bd_net -net TARGETC_Top_0_SCLK [get_bd_ports SCLK] [get_bd_pins TARGETC_Top_0/SCLK]
  connect_bd_net -net TARGETC_Top_0_SIN [get_bd_ports SIN] [get_bd_pins TARGETC_Top_0/SIN]
  connect_bd_net -net TARGETC_Top_0_SSTIN [get_bd_pins TARGETC_Top_0/SSTIN] [get_bd_pins util_ds_buf_1/OBUF_IN]
  connect_bd_net -net TARGETC_Top_0_SSVALID_INTR [get_bd_pins TARGETC_Top_0/SSVALID_INTR] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net TARGETC_Top_0_SW_nRST [get_bd_pins Data2AxiStream_0/SW_nRST] [get_bd_pins TARGETC_Top_0/SW_nRST]
  connect_bd_net -net TARGETC_Top_0_TestStream [get_bd_pins Data2AxiStream_0/TestStream] [get_bd_pins TARGETC_Top_0/TestStream]
  connect_bd_net -net TARGETC_Top_0_WL_CLK [get_bd_pins TARGETC_Top_0/WL_CLK] [get_bd_pins util_ds_buf_0/OBUF_IN]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Control_multipleTC_0/S_AXI_ARESETN] [get_bd_pins Data2AxiStream_0/M_AXIS_ARESETN] [get_bd_pins TARGETC_Top_0/tc_axi_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axis_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_0/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S00_AXIS_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins Control_multipleTC_0/S_AXI_ACLK] [get_bd_pins Data2AxiStream_0/M_AXIS_ACLK] [get_bd_pins TARGETC_Top_0/tc_axi_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axis_interconnect_0/ACLK] [get_bd_pins axis_interconnect_0/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S00_AXIS_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net util_ds_buf_0_OBUF_DS_N [get_bd_ports WL_CLK_N] [get_bd_pins util_ds_buf_0/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_0_OBUF_DS_P [get_bd_ports WL_CLK_P] [get_bd_pins util_ds_buf_0/OBUF_DS_P]
  connect_bd_net -net util_ds_buf_1_OBUF_DS_N [get_bd_ports SSTIN_N] [get_bd_pins util_ds_buf_1/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_1_OBUF_DS_P [get_bd_ports SSTIN_P] [get_bd_pins util_ds_buf_1/OBUF_DS_P]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins TARGETC_Top_0/DO_A_B] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins TARGETC_Top_0/delay_trigger] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins TARGETC_Top_0/sstin_updateBit] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins Data2AxiStream_0/TID] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Control_multipleTC_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x60000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TARGETC_Top_0/tc_axi/reg0] -force
  assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


