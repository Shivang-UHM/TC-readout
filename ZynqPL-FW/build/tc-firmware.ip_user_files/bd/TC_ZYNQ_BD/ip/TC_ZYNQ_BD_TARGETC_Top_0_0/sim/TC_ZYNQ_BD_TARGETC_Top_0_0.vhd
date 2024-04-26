-- (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:TARGETC_Top:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TC_ZYNQ_BD_TARGETC_Top_0_0 IS
  PORT (
    SW_nRST : OUT STD_LOGIC;
    tc_axi_aclk : IN STD_LOGIC;
    tc_axi_aresetn : IN STD_LOGIC;
    tc_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tc_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tc_axi_awvalid : IN STD_LOGIC;
    tc_axi_awready : OUT STD_LOGIC;
    tc_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tc_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    tc_axi_wvalid : IN STD_LOGIC;
    tc_axi_wready : OUT STD_LOGIC;
    tc_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    tc_axi_bvalid : OUT STD_LOGIC;
    tc_axi_bready : IN STD_LOGIC;
    tc_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tc_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tc_axi_arvalid : IN STD_LOGIC;
    tc_axi_arready : OUT STD_LOGIC;
    tc_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    tc_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    tc_axi_rvalid : OUT STD_LOGIC;
    tc_axi_rready : IN STD_LOGIC;
    MONTIMING_P : IN STD_LOGIC;
    MONTIMING_N : IN STD_LOGIC;
    SSTIN : OUT STD_LOGIC;
    WL_CLK : OUT STD_LOGIC;
    SIN : OUT STD_LOGIC;
    SCLK : OUT STD_LOGIC;
    DO_A_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Cnt_AXIS_DATA : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    CNT_CLR_A_B : OUT STD_LOGIC;
    A_PCLK : OUT STD_LOGIC;
    A_SHOUT : IN STD_LOGIC;
    A_DONE : IN STD_LOGIC;
    A_WR_RS_S0 : OUT STD_LOGIC;
    A_WR_RS_S1 : OUT STD_LOGIC;
    A_WR_CS_S0 : OUT STD_LOGIC;
    A_WR_CS_S1 : OUT STD_LOGIC;
    A_WR_CS_S2 : OUT STD_LOGIC;
    A_WR_CS_S3 : OUT STD_LOGIC;
    A_WR_CS_S4 : OUT STD_LOGIC;
    A_WR_CS_S5 : OUT STD_LOGIC;
    A_RAMP : OUT STD_LOGIC;
    A_GCC_RESET : OUT STD_LOGIC;
    A_RDAD_CLK : OUT STD_LOGIC;
    A_RDAD_SIN : OUT STD_LOGIC;
    A_RDAD_DIR : OUT STD_LOGIC;
    A_SAMPLESEL_ANY : OUT STD_LOGIC;
    A_HSCLK_P : OUT STD_LOGIC;
    A_HSCLK_N : OUT STD_LOGIC;
    A_SS_INCR : OUT STD_LOGIC;
    A_SS_RESET : OUT STD_LOGIC;
    B_PCLK : OUT STD_LOGIC;
    B_SHOUT : IN STD_LOGIC;
    B_DONE : IN STD_LOGIC;
    B_WR_RS_S0 : OUT STD_LOGIC;
    B_WR_RS_S1 : OUT STD_LOGIC;
    B_WR_CS_S0 : OUT STD_LOGIC;
    B_WR_CS_S1 : OUT STD_LOGIC;
    B_WR_CS_S2 : OUT STD_LOGIC;
    B_WR_CS_S3 : OUT STD_LOGIC;
    B_WR_CS_S4 : OUT STD_LOGIC;
    B_WR_CS_S5 : OUT STD_LOGIC;
    B_RAMP : OUT STD_LOGIC;
    B_GCC_RESET : OUT STD_LOGIC;
    B_RDAD_CLK : OUT STD_LOGIC;
    B_RDAD_SIN : OUT STD_LOGIC;
    B_RDAD_DIR : OUT STD_LOGIC;
    B_SAMPLESEL_ANY : OUT STD_LOGIC;
    B_HSCLK_P : OUT STD_LOGIC;
    B_HSCLK_N : OUT STD_LOGIC;
    B_SS_INCR : OUT STD_LOGIC;
    B_SS_RESET : OUT STD_LOGIC;
    StreamReady : IN STD_LOGIC;
    FIFOvalid : OUT STD_LOGIC;
    FIFOdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    TestStream : OUT STD_LOGIC;
    SSVALID_INTR : OUT STD_LOGIC;
    hmb_trigger : IN STD_LOGIC;
    delay_trigger : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    sstin_updateBit : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    mode : IN STD_LOGIC;
    windowstorage : IN STD_LOGIC
  );
END TC_ZYNQ_BD_TARGETC_Top_0_0;

ARCHITECTURE TC_ZYNQ_BD_TARGETC_Top_0_0_arch OF TC_ZYNQ_BD_TARGETC_Top_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF TC_ZYNQ_BD_TARGETC_Top_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT TARGETC_Top IS
    PORT (
      SW_nRST : OUT STD_LOGIC;
      tc_axi_aclk : IN STD_LOGIC;
      tc_axi_aresetn : IN STD_LOGIC;
      tc_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      tc_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      tc_axi_awvalid : IN STD_LOGIC;
      tc_axi_awready : OUT STD_LOGIC;
      tc_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      tc_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      tc_axi_wvalid : IN STD_LOGIC;
      tc_axi_wready : OUT STD_LOGIC;
      tc_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      tc_axi_bvalid : OUT STD_LOGIC;
      tc_axi_bready : IN STD_LOGIC;
      tc_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      tc_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      tc_axi_arvalid : IN STD_LOGIC;
      tc_axi_arready : OUT STD_LOGIC;
      tc_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      tc_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      tc_axi_rvalid : OUT STD_LOGIC;
      tc_axi_rready : IN STD_LOGIC;
      MONTIMING_P : IN STD_LOGIC;
      MONTIMING_N : IN STD_LOGIC;
      SSTIN : OUT STD_LOGIC;
      WL_CLK : OUT STD_LOGIC;
      SIN : OUT STD_LOGIC;
      SCLK : OUT STD_LOGIC;
      DO_A_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Cnt_AXIS_DATA : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      CNT_CLR_A_B : OUT STD_LOGIC;
      A_PCLK : OUT STD_LOGIC;
      A_SHOUT : IN STD_LOGIC;
      A_DONE : IN STD_LOGIC;
      A_WR_RS_S0 : OUT STD_LOGIC;
      A_WR_RS_S1 : OUT STD_LOGIC;
      A_WR_CS_S0 : OUT STD_LOGIC;
      A_WR_CS_S1 : OUT STD_LOGIC;
      A_WR_CS_S2 : OUT STD_LOGIC;
      A_WR_CS_S3 : OUT STD_LOGIC;
      A_WR_CS_S4 : OUT STD_LOGIC;
      A_WR_CS_S5 : OUT STD_LOGIC;
      A_RAMP : OUT STD_LOGIC;
      A_GCC_RESET : OUT STD_LOGIC;
      A_RDAD_CLK : OUT STD_LOGIC;
      A_RDAD_SIN : OUT STD_LOGIC;
      A_RDAD_DIR : OUT STD_LOGIC;
      A_SAMPLESEL_ANY : OUT STD_LOGIC;
      A_HSCLK_P : OUT STD_LOGIC;
      A_HSCLK_N : OUT STD_LOGIC;
      A_SS_INCR : OUT STD_LOGIC;
      A_SS_RESET : OUT STD_LOGIC;
      B_PCLK : OUT STD_LOGIC;
      B_SHOUT : IN STD_LOGIC;
      B_DONE : IN STD_LOGIC;
      B_WR_RS_S0 : OUT STD_LOGIC;
      B_WR_RS_S1 : OUT STD_LOGIC;
      B_WR_CS_S0 : OUT STD_LOGIC;
      B_WR_CS_S1 : OUT STD_LOGIC;
      B_WR_CS_S2 : OUT STD_LOGIC;
      B_WR_CS_S3 : OUT STD_LOGIC;
      B_WR_CS_S4 : OUT STD_LOGIC;
      B_WR_CS_S5 : OUT STD_LOGIC;
      B_RAMP : OUT STD_LOGIC;
      B_GCC_RESET : OUT STD_LOGIC;
      B_RDAD_CLK : OUT STD_LOGIC;
      B_RDAD_SIN : OUT STD_LOGIC;
      B_RDAD_DIR : OUT STD_LOGIC;
      B_SAMPLESEL_ANY : OUT STD_LOGIC;
      B_HSCLK_P : OUT STD_LOGIC;
      B_HSCLK_N : OUT STD_LOGIC;
      B_SS_INCR : OUT STD_LOGIC;
      B_SS_RESET : OUT STD_LOGIC;
      StreamReady : IN STD_LOGIC;
      FIFOvalid : OUT STD_LOGIC;
      FIFOdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      TestStream : OUT STD_LOGIC;
      SSVALID_INTR : OUT STD_LOGIC;
      hmb_trigger : IN STD_LOGIC;
      delay_trigger : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      sstin_updateBit : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      mode : IN STD_LOGIC;
      windowstorage : IN STD_LOGIC
    );
  END COMPONENT TARGETC_Top;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF A_GCC_RESET: SIGNAL IS "XIL_INTERFACENAME A_GCC_RESET, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF A_GCC_RESET: SIGNAL IS "xilinx.com:signal:reset:1.0 A_GCC_RESET RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF A_RDAD_CLK: SIGNAL IS "XIL_INTERFACENAME A_RDAD_CLK, FREQ_HZ 62500000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_TARGETC_Top_0_0_A_RDAD_CLK, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF A_RDAD_CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 A_RDAD_CLK CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF A_SS_RESET: SIGNAL IS "XIL_INTERFACENAME A_SS_RESET, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF A_SS_RESET: SIGNAL IS "xilinx.com:signal:reset:1.0 A_SS_RESET RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF B_GCC_RESET: SIGNAL IS "XIL_INTERFACENAME B_GCC_RESET, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF B_GCC_RESET: SIGNAL IS "xilinx.com:signal:reset:1.0 B_GCC_RESET RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF B_RDAD_CLK: SIGNAL IS "XIL_INTERFACENAME B_RDAD_CLK, FREQ_HZ 62500000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_TARGETC_Top_0_0_B_RDAD_CLK, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF B_RDAD_CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 B_RDAD_CLK CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF B_SS_RESET: SIGNAL IS "XIL_INTERFACENAME B_SS_RESET, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF B_SS_RESET: SIGNAL IS "xilinx.com:signal:reset:1.0 B_SS_RESET RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF SSTIN: SIGNAL IS "XIL_INTERFACENAME SSTIN, FREQ_HZ 15625000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_TARGETC_Top_0_0_SSTIN, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF SSTIN: SIGNAL IS "xilinx.com:signal:clock:1.0 SSTIN CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF SSVALID_INTR: SIGNAL IS "XIL_INTERFACENAME SSVALID_INTR, SENSITIVITY LEVEL_HIGH, PORTWIDTH 1";
  ATTRIBUTE X_INTERFACE_INFO OF SSVALID_INTR: SIGNAL IS "xilinx.com:signal:interrupt:1.0 SSVALID_INTR INTERRUPT";
  ATTRIBUTE X_INTERFACE_PARAMETER OF WL_CLK: SIGNAL IS "XIL_INTERFACENAME WL_CLK, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_TARGETC_Top_0_0_WL_CLK, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF WL_CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 WL_CLK CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tc_axi_aclk: SIGNAL IS "XIL_INTERFACENAME tc_axi_aclk, ASSOCIATED_BUSIF tc_axi, ASSOCIATED_RESET tc_axi_aresetn, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 tc_axi_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi ARADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tc_axi_aresetn: SIGNAL IS "XIL_INTERFACENAME tc_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 tc_axi_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi ARVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF tc_axi_awaddr: SIGNAL IS "XIL_INTERFACENAME tc_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 125000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN TC_ZYNQ_BD_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREA" & 
"DS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF tc_axi_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 tc_axi WVALID";
BEGIN
  U0 : TARGETC_Top
    PORT MAP (
      SW_nRST => SW_nRST,
      tc_axi_aclk => tc_axi_aclk,
      tc_axi_aresetn => tc_axi_aresetn,
      tc_axi_awaddr => tc_axi_awaddr,
      tc_axi_awprot => tc_axi_awprot,
      tc_axi_awvalid => tc_axi_awvalid,
      tc_axi_awready => tc_axi_awready,
      tc_axi_wdata => tc_axi_wdata,
      tc_axi_wstrb => tc_axi_wstrb,
      tc_axi_wvalid => tc_axi_wvalid,
      tc_axi_wready => tc_axi_wready,
      tc_axi_bresp => tc_axi_bresp,
      tc_axi_bvalid => tc_axi_bvalid,
      tc_axi_bready => tc_axi_bready,
      tc_axi_araddr => tc_axi_araddr,
      tc_axi_arprot => tc_axi_arprot,
      tc_axi_arvalid => tc_axi_arvalid,
      tc_axi_arready => tc_axi_arready,
      tc_axi_rdata => tc_axi_rdata,
      tc_axi_rresp => tc_axi_rresp,
      tc_axi_rvalid => tc_axi_rvalid,
      tc_axi_rready => tc_axi_rready,
      MONTIMING_P => MONTIMING_P,
      MONTIMING_N => MONTIMING_N,
      SSTIN => SSTIN,
      WL_CLK => WL_CLK,
      SIN => SIN,
      SCLK => SCLK,
      DO_A_B => DO_A_B,
      Cnt_AXIS_DATA => Cnt_AXIS_DATA,
      CNT_CLR_A_B => CNT_CLR_A_B,
      A_PCLK => A_PCLK,
      A_SHOUT => A_SHOUT,
      A_DONE => A_DONE,
      A_WR_RS_S0 => A_WR_RS_S0,
      A_WR_RS_S1 => A_WR_RS_S1,
      A_WR_CS_S0 => A_WR_CS_S0,
      A_WR_CS_S1 => A_WR_CS_S1,
      A_WR_CS_S2 => A_WR_CS_S2,
      A_WR_CS_S3 => A_WR_CS_S3,
      A_WR_CS_S4 => A_WR_CS_S4,
      A_WR_CS_S5 => A_WR_CS_S5,
      A_RAMP => A_RAMP,
      A_GCC_RESET => A_GCC_RESET,
      A_RDAD_CLK => A_RDAD_CLK,
      A_RDAD_SIN => A_RDAD_SIN,
      A_RDAD_DIR => A_RDAD_DIR,
      A_SAMPLESEL_ANY => A_SAMPLESEL_ANY,
      A_HSCLK_P => A_HSCLK_P,
      A_HSCLK_N => A_HSCLK_N,
      A_SS_INCR => A_SS_INCR,
      A_SS_RESET => A_SS_RESET,
      B_PCLK => B_PCLK,
      B_SHOUT => B_SHOUT,
      B_DONE => B_DONE,
      B_WR_RS_S0 => B_WR_RS_S0,
      B_WR_RS_S1 => B_WR_RS_S1,
      B_WR_CS_S0 => B_WR_CS_S0,
      B_WR_CS_S1 => B_WR_CS_S1,
      B_WR_CS_S2 => B_WR_CS_S2,
      B_WR_CS_S3 => B_WR_CS_S3,
      B_WR_CS_S4 => B_WR_CS_S4,
      B_WR_CS_S5 => B_WR_CS_S5,
      B_RAMP => B_RAMP,
      B_GCC_RESET => B_GCC_RESET,
      B_RDAD_CLK => B_RDAD_CLK,
      B_RDAD_SIN => B_RDAD_SIN,
      B_RDAD_DIR => B_RDAD_DIR,
      B_SAMPLESEL_ANY => B_SAMPLESEL_ANY,
      B_HSCLK_P => B_HSCLK_P,
      B_HSCLK_N => B_HSCLK_N,
      B_SS_INCR => B_SS_INCR,
      B_SS_RESET => B_SS_RESET,
      StreamReady => StreamReady,
      FIFOvalid => FIFOvalid,
      FIFOdata => FIFOdata,
      TestStream => TestStream,
      SSVALID_INTR => SSVALID_INTR,
      hmb_trigger => hmb_trigger,
      delay_trigger => delay_trigger,
      sstin_updateBit => sstin_updateBit,
      mode => mode,
      windowstorage => windowstorage
    );
END TC_ZYNQ_BD_TARGETC_Top_0_0_arch;
