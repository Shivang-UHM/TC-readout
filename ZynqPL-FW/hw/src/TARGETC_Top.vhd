----------------------------------------------------------------------------------
-- Company: VarnerLab for Instrumentation Development (IDLab)
-- Engineer: Shivang Tripathi
-- 
-- Create Date: 10/17/2023 10:10:43 AM
-- Design Name: TARGETC_Top
-- Module Name: TARGETC_Top - Behavioral
-- Project Name: TARGETC-READOUT
-- Target Devices: 6UVME_Microzed Board for HMB Calorimeter Readout 
-- Tool Versions: Vivado 2022.2
-- Description: Top level for the TARGETC readout
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
USE work.TARGETC_pkg.ALL;
USE work.AXI_Lite_pkg.ALL;

ENTITY TARGETC_Top IS

  PORT (
    SW_nRST : OUT STD_LOGIC;

    --! @name Ports of Axi Slave Bus Interface TC_AXI
    tc_axi_aclk         : IN STD_LOGIC;
    tc_axi_aresetn      : IN STD_LOGIC;
    tc_axi_awaddr       : IN STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 DOWNTO 0);
    tc_axi_awprot       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tc_axi_awvalid      : IN STD_LOGIC;
    tc_axi_awready      : OUT STD_LOGIC;
    tc_axi_wdata        : IN STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 DOWNTO 0);
    tc_axi_wstrb        : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH/8) - 1 DOWNTO 0);
    tc_axi_wvalid       : IN STD_LOGIC;
    tc_axi_wready       : OUT STD_LOGIC;
    tc_axi_bresp        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    tc_axi_bvalid       : OUT STD_LOGIC;
    tc_axi_bready       : IN STD_LOGIC;
    tc_axi_araddr       : IN STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH - 1 DOWNTO 0);
    tc_axi_arprot       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tc_axi_arvalid      : IN STD_LOGIC;
    tc_axi_arready      : OUT STD_LOGIC;
    tc_axi_rdata        : OUT STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH - 1 DOWNTO 0);
    tc_axi_rresp        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    tc_axi_rvalid       : OUT STD_LOGIC;
    tc_axi_rready       : IN STD_LOGIC;

    --Signals fanned out on the board
    MONTIMING_P         : IN STD_LOGIC; -- use for debugging
    MONTIMING_N         : IN STD_LOGIC;
    SSTIN               : OUT STD_LOGIC;
    WL_CLK              : OUT STD_LOGIC;
    SIN                 : OUT STD_LOGIC;
    SCLK                : OUT STD_LOGIC;
    --
    DO_A_B              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Cnt_AXIS_DATA       : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    CNT_CLR_A_B         : OUT STD_LOGIC;

    -- TARGETC 0 signals
    A_PCLK              : OUT STD_LOGIC;
    A_SHOUT             : IN STD_LOGIC;
    A_DONE              : IN STD_LOGIC;       --unused

    A_WR_RS_S0          : OUT STD_LOGIC;
    A_WR_RS_S1          : OUT STD_LOGIC;

    A_WR_CS_S0          : OUT STD_LOGIC;
    A_WR_CS_S1          : OUT STD_LOGIC;
    A_WR_CS_S2          : OUT STD_LOGIC;
    A_WR_CS_S3          : OUT STD_LOGIC;
    A_WR_CS_S4          : OUT STD_LOGIC;
    A_WR_CS_S5          : OUT STD_LOGIC;

    A_RAMP              : OUT STD_LOGIC;
    A_GCC_RESET         : OUT STD_LOGIC;

    A_RDAD_CLK          : OUT STD_LOGIC;
    A_RDAD_SIN          : OUT STD_LOGIC;
    A_RDAD_DIR          : OUT STD_LOGIC;

    A_SAMPLESEL_ANY     : OUT STD_LOGIC;
    
    A_HSCLK_P           : OUT STD_LOGIC;
    A_HSCLK_N           : OUT STD_LOGIC;
    A_SS_INCR           : OUT STD_LOGIC;
    A_SS_RESET          : OUT STD_LOGIC;
    
    --TARGETC 1 signals

    B_PCLK              : OUT STD_LOGIC;
    B_SHOUT             : IN STD_LOGIC;
    B_DONE              : IN STD_LOGIC;

    B_WR_RS_S0          : OUT STD_LOGIC;
    B_WR_RS_S1          : OUT STD_LOGIC;
      
    B_WR_CS_S0          : OUT STD_LOGIC;
    B_WR_CS_S1          : OUT STD_LOGIC;
    B_WR_CS_S2          : OUT STD_LOGIC;
    B_WR_CS_S3          : OUT STD_LOGIC;
    B_WR_CS_S4          : OUT STD_LOGIC;
    B_WR_CS_S5          : OUT STD_LOGIC;

    B_RAMP              : OUT STD_LOGIC;
    B_GCC_RESET         : OUT STD_LOGIC;

    B_RDAD_CLK          : OUT STD_LOGIC;
    B_RDAD_SIN          : OUT STD_LOGIC;
    B_RDAD_DIR          : OUT STD_LOGIC;

    B_SAMPLESEL_ANY     : OUT STD_LOGIC;

    B_HSCLK_P           : OUT STD_LOGIC;
    B_HSCLK_N           : OUT STD_LOGIC;
    B_SS_INCR           : OUT STD_LOGIC;
    B_SS_RESET          : OUT STD_LOGIC;

    -- From & to TargetC_axi_interconnect
    StreamReady         : IN STD_LOGIC;
    FIFOvalid           : OUT STD_LOGIC;
    FIFOdata            : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    TestStream          : OUT STD_LOGIC;

    -- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED
    --		TrigA :			in std_logic;
    --		TrigB :			in std_logic;
    --		TrigC :			in std_logic;
    --		TrigD :			in std_logic;

    -- Interrupt SIGNALS
    SSVALID_INTR        : OUT STD_LOGIC;

    --Signals for the HMB roundbuffer
    hmb_trigger         : IN STD_LOGIC;
    delay_trigger       : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    sstin_updateBit     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    mode                : IN STD_LOGIC; -- TriggerMode (on PS)
    windowstorage       : IN STD_LOGIC -- Digitization process start on falling edge of windowstorage (in user-mode)
  );

END ENTITY;

ARCHITECTURE rtl OF TARGETC_Top IS

  -- Attribute for vivado to infer WL_Clk, RDAD_CLK, SSTIN ports as a Clock pins
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO of tc_axi_aclk : SIGNAL is "xilinx.com:signal:clock:1.0 tc_axi_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO of WL_CLK      : SIGNAL is "xilinx.com:signal:clock:1.0      WL_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO of A_RDAD_CLK  : SIGNAL is "xilinx.com:signal:clock:1.0  A_RDAD_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO of B_RDAD_CLK  : SIGNAL is "xilinx.com:signal:clock:1.0  B_RDAD_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO of SSTIN       : SIGNAL is "xilinx.com:signal:clock:1.0       SSTIN CLK";

  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER of tc_axi_aclk : SIGNAL is "FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0";   -- 125 MHz    (8 ns)
  ATTRIBUTE X_INTERFACE_PARAMETER of WL_CLK     : SIGNAL is "FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0";   -- 125 MHz    (8 ns)
  ATTRIBUTE X_INTERFACE_PARAMETER of A_RDAD_CLK : SIGNAL is "FREQ_HZ  62500000, FREQ_TOLERANCE_HZ 0";   -- 62.5 MHz   (16 ns)
  ATTRIBUTE X_INTERFACE_PARAMETER of B_RDAD_CLK : SIGNAL is "FREQ_HZ  62500000, FREQ_TOLERANCE_HZ 0";   -- 62.5 MHz   (16 ns)
  ATTRIBUTE X_INTERFACE_PARAMETER of SSTIN      : SIGNAL is "FREQ_HZ  15625000, FREQ_TOLERANCE_HZ 0";   -- 15.625 MHz (64 ns)

  SIGNAL ClockBus_intl        : T_ClockBus; --! internal clock signal
  SIGNAL SSTIN_intl           : STD_LOGIC;
  SIGNAL CtrlBusIn_intl       : T_CtrlBus_IxMS_Intl;
  SIGNAL CtrlBusOut_intl      : T_CtrlBus_OxMS_Intl;

  SIGNAL WR_CS_S_intl         : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL WR_RS_S_intl         : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL hsclk_dif            : STD_LOGIC;
  SIGNAL PCLK_intl            : STD_LOGIC;
  SIGNAL RDAD_CLK_intl        : STD_LOGIC;
  SIGNAL RDAD_SIN_intl        : STD_LOGIC;
  SIGNAL RDAD_DIR_intl        : STD_LOGIC;
  SIGNAL RAMP_intl            : STD_LOGIC;
  SIGNAL GCC_RESET_intl       : STD_LOGIC;
  SIGNAL SS_INCR_intl         : STD_LOGIC;
  SIGNAL SS_RESET_intl        : STD_LOGIC;

  SIGNAL tc_axi_intr          : STD_LOGIC;

  SIGNAL RDAD_ReadEn_intl     : STD_LOGIC;
  SIGNAL RDAD_DataOut_intl    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL RDAD_Empty_intl      : STD_LOGIC;

  SIGNAL DIG_DataIn_intl      : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL DIG_WriteEn_intl     : STD_LOGIC;
  SIGNAL DIG_Full_intl        : STD_LOGIC;

  SIGNAL timecounter_intl     : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL GrayTimeCnt_intl     : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL timestamp_intl       : T_timestamp;

  SIGNAL trigger_intl         : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL FIFO_ReadEn_intl     : STD_LOGIC;
  SIGNAL FIFO_Time_intl       : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL FIFO_WdoAddr_intl    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL FIFO_TrigInfo_intl   : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL FIFO_Spare_intl      : STD_LOGIC_VECTOR(10 DOWNTO 0);
  SIGNAL FIFO_Empty_intl      : STD_LOGIC;

  SIGNAL Handshake_IxSEND_intl: T_Handshake_IxSEND;
  SIGNAL Handshake_SS_FIFO    : T_Handshake_SS_FIFO;
  SIGNAL Handshake_OxSEND_intl: T_Handshake_OxSEND;

  SIGNAL A_CH0_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH1_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH2_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH3_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL A_CH4_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH5_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH6_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH7_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL A_CH8_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH9_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH10_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH11_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL A_CH12_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH13_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH14_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL A_CH15_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL B_CH0_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH1_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH2_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH3_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL B_CH4_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH5_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH6_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH7_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL B_CH8_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH9_intl           : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH10_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH11_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);

  SIGNAL B_CH12_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH13_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH14_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL B_CH15_intl          : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL DO_A_B_intl          : STD_LOGIC_VECTOR(31 DOWNTO 0);

  --DEBUG Signals
  SIGNAL MONTIMING_s          : STD_LOGIC;
  SIGNAL MONTIMING_inverted   : STD_LOGIC;
  -- Signal for trigger the acquisition for debugging
  SIGNAL address_is_zero_intl : STD_LOGIC;
  SIGNAL cnt_clr_intl : STD_LOGIC;

  -- -------------------------------------------------------------
  -- Constraints on Signals
  -- -------------------------------------------------------------
  ATTRIBUTE DONT_TOUCH : STRING;
  ATTRIBUTE DONT_TOUCH OF TC_RoundBuffer : LABEL IS "TRUE";

  ATTRIBUTE mark_debug : STRING;
  -- ATTRIBUTE mark_debug of WR_CS_S_intl  : signal is "true";
  -- ATTRIBUTE mark_debug of WR_RS_S_intl  : signal is "true";

BEGIN
  --Noting useful now in here, can be bring everything outside.
  TC_ClockMgmt_inst : ENTITY work.TC_ClockManagement
    PORT MAP(
      nrst        => CtrlBusOut_intl.SW_nRST,
      AXI_Clk     => tc_axi_aclk,
      HSCLKdif    => HSCLK_dif,
      PLL_LOCKED  => CtrlBusIn_intl.PLL_LOCKED,
      ClockBus    => ClockBus_intl,
      Timecounter => timecounter_intl,
      Timestamp   => TimeStamp_intl,
      WLCLK       => WL_CLK,
      A_HSCLK_P   => A_HSCLK_P,
      A_HSCLK_N   => A_HSCLK_N,
      B_HSCLK_P   => B_HSCLK_P,
      B_HSCLK_N   => B_HSCLK_N
    );
  
    --! Communication with PS side through AXI Lite and Control Signals
  TC_Control_inst : ENTITY work.TC_Control
    PORT MAP(
      AxiBusIn.ACLK     => tc_axi_aclk,
      AxiBusIn.ARESETN  => tc_axi_aresetn,
      AxiBusIn.AWADDR   => tc_axi_awaddr,
      AxiBusIn.AWPROT   => tc_axi_awprot,
      AxiBusIn.AWVALID  => tc_axi_awvalid,
      AxiBusIn.WDATA    => tc_axi_wdata,
      AxiBusIn.WSTRB    => tc_axi_wstrb,
      AxiBusIn.WVALID   => tc_axi_wvalid,
      AxiBusIn.BREADY   => tc_axi_bready,
      AxiBusIn.ARADDR   => tc_axi_araddr,
      AxiBusIn.ARPROT   => tc_axi_arprot,
      AxiBusIn.ARVALID  => tc_axi_arvalid,
      AxiBusIn.RREADY   => tc_axi_rready,

      AxiBusOut.AWREADY => tc_axi_awready,
      AxiBusOut.WREADY  => tc_axi_wready,
      AxiBusOut.BRESP   => tc_axi_bresp,
      AxiBusOut.BVALID  => tc_axi_bvalid,
      AxiBusOut.ARREADY => tc_axi_arready,
      AxiBusOut.RDATA   => tc_axi_rdata,
      AxiBusOut.RRESP   => tc_axi_rresp,
      AxiBusOut.RVALID  => tc_axi_rvalid,
      AxiBusOut.intr    => tc_axi_intr,

      WindowStorage     => WindowStorage,
      ClockBus          => ClockBus_intl,
      CtrlBus_IxMS      => CtrlBusIn_intl,
      CtrlBus_OxMS      => CtrlBusOut_intl

    );

  --! Register Communication between FPGA and ASIC
  TC_SerialRegCtrl_inst : ENTITY work.TARGETX_DAC_CONTROL
    GENERIC MAP(
      REGISTER_WIDTH => 19
    )
    PORT MAP(
      CLK                     => ClockBus_intl.SCLK,
      PCLK_LATCH_PERIOD       => x"0005", --With SCLK (brut) 50 MHz, 20ns * 5 = 100ns High period
      PCLK_TRANSITION_PERIOD  => x"0003",
      LOAD_PERIOD             => (OTHERS => '0'),
      LATCH_PERIOD            => (OTHERS => '0'),
      CtrlBus_IxSL            => CtrlBusOut_intl,
      TC_BUS                  => CtrlBusIn_intl.TC_BUS,
      BUSY                    => CtrlBusIn_intl.BUSY,
      SIN       => SIN,
      SCLK      => SCLK,
      PCLK      => PCLK_intl,
      SHOUT     => A_SHOUT
    );

  TC_RoundBuffer : ENTITY work.RoundBuffer
    PORT MAP(
      ClockBus      => ClockBus_intl,
      Timecounter   => timecounter_intl,
      TimeStamp     => TimeStamp_intl,
      trigger       => trigger_intl,
      CtrlBus_IxSL  => CtrlBusOut_intl,
      WR_R          => WR_RS_S_intl,
      WR_C          => WR_CS_S_intl,
      RBNbrOfPackets=> CtrlBusIn_intl.RBNbrOfPackets,
      RDAD_ReadEn   => RDAD_ReadEn_intl,
      RDAD_DataOut  => RDAD_DataOut_intl,
      RDAD_Empty    => RDAD_Empty_intl,
      -- FIFO <-> AXI Connection
      AXI_ReadEn            => FIFO_ReadEn_intl,
      AXI_Time_DataOut      => FIFO_Time_intl,
      AXI_WdoAddr_DataOut   => FIFO_WdoAddr_intl,
      AXI_TrigInfo_DataOut  => FIFO_TrigInfo_intl,
      AXI_Spare_DataOut     => FIFO_Spare_intl,
      AXI_Empty             => FIFO_Empty_intl,
      -- FIFO IN for Digiting
      DIG_Full        => DIG_Full_intl,
      DIG_DataIn      => DIG_DataIn_intl,
      DIG_WriteEn     => DIG_WriteEn_intl,
      --signals for the HMB roundbuffer
      hmb_trigger     => hmb_trigger,
      mode            => mode,
      delay_trigger   => delay_trigger,
      sstin_updateBit => sstin_updateBit,
      -- Signal for trigger the acquisition for debugging
      address_is_zero_out => address_is_zero_intl
    );

  TC_RDAD_WL_SS : ENTITY work.TwoTARGETC_RDAD_WL_SMPL
    PORT MAP(
      DISCH_PERIOD     => x"0064",
      INCR_WAIT_PERIOD => x"0032",

      ClockBus      => ClockBus_intl,
      RDAD_CLK      => RDAD_CLK_intl,
      RDAD_SIN      => RDAD_SIN_intl,
      RDAD_DIR      => RDAD_DIR_intl,
      -- Fifo from storage
      RDAD_DataOut  => RDAD_DataOut_intl,
      RDAD_Empty    => RDAD_Empty_intl,
      RDAD_ReadEn   => RDAD_ReadEn_intl,
      -- FIFO IN for Digiting
      DIG_Full      => DIG_Full_intl,
      DIG_DataIn    => DIG_DataIn_intl,
      DIG_WriteEn   => DIG_WriteEn_intl,
      RAMP          => RAMP_intl,
      GCC_RESET     => GCC_RESET_intl,
      HSCLK         => HSCLK_dif,
      -- Data Readout
      DO_A_B        => DO_A_B_intl,
      SS_INCR       => SS_INCR_intl,
      SS_RESET      => SS_RESET_intl,
      CtrlBus_IxSL  => CtrlBusOut_intl,
      WindowBusy    => CtrlBusIn_intl.WindowBusy,   -- indicating if PL busy in doing RDAD/WL/SS processes (WINDOW_MASK in TC_STATUS_REG)
      RAMP_CNT      => CtrlBusIn_intl.RAMP_CNT,     -- check its usage: seems useless
      DO_BUS        => CtrlBusIn_intl.DO_BUS,
      SSvalid       => CtrlBusIn_intl.SSvalid,
      --Channels
      A_CH0         => A_CH0_intl,
      A_CH1         => A_CH1_intl,
      A_CH2         => A_CH2_intl,
      A_CH3         => A_CH3_intl,

      A_CH4         => A_CH4_intl,
      A_CH5         => A_CH5_intl,
      A_CH6         => A_CH6_intl,
      A_CH7         => A_CH7_intl,

      A_CH8         => A_CH8_intl,
      A_CH9         => A_CH9_intl,
      A_CH10        => A_CH10_intl,
      A_CH11        => A_CH11_intl,

      A_CH12        => A_CH12_intl,
      A_CH13        => A_CH13_intl,
      A_CH14        => A_CH14_intl,
      A_CH15        => A_CH15_intl,

      B_CH0         => B_CH0_intl,
      B_CH1         => B_CH1_intl,
      B_CH2         => B_CH2_intl,
      B_CH3         => B_CH3_intl,

      B_CH4         => B_CH4_intl,
      B_CH5         => B_CH5_intl,
      B_CH6         => B_CH6_intl,
      B_CH7         => B_CH7_intl,

      B_CH8         => B_CH8_intl,
      B_CH9         => B_CH9_intl,
      B_CH10        => B_CH10_intl,
      B_CH11        => B_CH11_intl,

      B_CH12        => B_CH12_intl,
      B_CH13        => B_CH13_intl,
      B_CH14        => B_CH14_intl,
      B_CH15        => B_CH15_intl,

      Handshake_IxSEND  => Handshake_IxSEND_intl,
      Handshake_Data    => Handshake_SS_FIFO,
      Handshake_OxSEND  => Handshake_OxSEND_intl
  );

  FIFOMANAGER : ENTITY work.TwoTARGETCs_FifoManager
    GENERIC MAP(
    C_M_AXIS_TDATA_WIDTH => 32
    )
    PORT MAP(
    CtrlBus_IxSL      => CtrlBusOut_intl,
    ClockBus          => ClockBus_intl,
    --Request and Acknowledge - READOUT
    Handshake_IxRECV  => Handshake_OxSEND_intl,
    Handshake_Data    => Handshake_SS_FIFO,
    Handshake_OxRECV  => Handshake_IxSEND_intl,

    --Header Information from FIFO
    FIFO_Time         => FIFO_Time_intl,
    FIFO_WdoAddr      => FIFO_WdoAddr_intl,
    FIFO_TrigInfo     => FIFO_TrigInfo_intl,
    FIFO_Spare        => FIFO_Spare_intl,
    FIFO_Empty        => FIFO_Empty_intl,
    FIFO_ReadEn       => FIFO_ReadEn_intl,

    --Channels
    CH0    => A_CH0_intl,
    CH1    => A_CH1_intl,
    CH2    => A_CH2_intl,
    CH3    => A_CH3_intl,

    CH4    => A_CH4_intl,
    CH5    => A_CH5_intl,
    CH6    => A_CH6_intl,
    CH7    => A_CH7_intl,

    CH8    => A_CH8_intl,
    CH9    => A_CH9_intl,
    CH10   => A_CH10_intl,
    CH11   => A_CH11_intl,

    CH12   => A_CH12_intl,
    CH13   => A_CH13_intl,
    CH14   => A_CH14_intl,
    CH15   => A_CH15_intl,

    CH16   => B_CH0_intl,
    CH17   => B_CH1_intl,
    CH18   => B_CH2_intl,
    CH19   => B_CH3_intl,

    CH20   => B_CH4_intl,
    CH21   => B_CH5_intl,
    CH22   => B_CH6_intl,
    CH23   => B_CH7_intl,

    CH24   => B_CH8_intl,
    CH25   => B_CH9_intl,
    CH26   => B_CH10_intl,
    CH27   => B_CH11_intl,

    CH28   => B_CH12_intl,
    CH29   => B_CH13_intl,
    CH30   => B_CH14_intl,
    CH31   => B_CH15_intl,
    -- DATA TO STREAM
    FIFOvalid => FIFOValid,
    FIFOdata  => FIFOdata,
    FIFOBusy  => CtrlBusIn_intl.FIFOBusy,
    StreamReady => StreamReady
  );

  A_SAMPLESEL_ANY <= CtrlBusOut_intl.SmplSl_Any;
  B_SAMPLESEL_ANY <= CtrlBusOut_intl.SmplSl_Any;

  --REGCLR <= CtrlBusOut_intl.REGCLR;

  A_WR_RS_S0 <= WR_RS_S_intl(0);
  A_WR_RS_S1 <= WR_RS_S_intl(1);

  A_WR_CS_S0 <= WR_CS_S_intl(0);
  A_WR_CS_S1 <= WR_CS_S_intl(1);
  A_WR_CS_S2 <= WR_CS_S_intl(2);
  A_WR_CS_S3 <= WR_CS_S_intl(3);
  A_WR_CS_S4 <= WR_CS_S_intl(4);
  A_WR_CS_S5 <= WR_CS_S_intl(5);

  B_WR_RS_S0 <= WR_RS_S_intl(0);
  B_WR_RS_S1 <= WR_RS_S_intl(1);

  B_WR_CS_S0 <= WR_CS_S_intl(0);
  B_WR_CS_S1 <= WR_CS_S_intl(1);
  B_WR_CS_S2 <= WR_CS_S_intl(2);
  B_WR_CS_S3 <= WR_CS_S_intl(3);
  B_WR_CS_S4 <= WR_CS_S_intl(4);
  B_WR_CS_S5 <= WR_CS_S_intl(5);


  CtrlBusIn_intl.Cnt_AXIS <= Cnt_AXIS_DATA; -- Signal driven only by TC0
  cnt_clr_intl <= CtrlBusOut_intl.WindowStorage;

  SyncBitCNT_CLR : ENTITY work.SyncBit
  GENERIC MAP(
    SYNC_STAGES_G => 2,
    CLK_POL_G     => '1',
    RST_POL_G     => '1',
    INIT_STATE_G  => '0',
    GATE_DELAY_G  => 1 ns
  )
  PORT MAP(
    -- Clock and reset
    clk => tc_axi_aclk,
    rst => tc_axi_aresetn,
    -- Incoming bit, asynchronous
    asyncBit => cnt_clr_intl,
    -- Outgoing bit, synced to clk
    syncBit => CNT_CLR_A_B
  );

  SW_nRST <= CtrlBusOut_intl.SW_nRST;
  -- Interrupt Interface
  SSVALID_INTR <= CtrlBusIn_intl.SSVALID WHEN CtrlBusOut_intl.SAMPLEMODE = '0' ELSE '0';
  -- Timing Buffer
  IBUFDS_MonTiming : IBUFDS
    GENERIC MAP(
    IOSTANDARD => "LVDS_25"
    )
    PORT MAP(
    I  => MONTIMING_P,
    IB => MONTIMING_N,

    O  => MONTIMING_s
  );
  -- MONTIMING INVERTED ON THE TARGETC, changed in firmware on 08/15/2019
  MONTIMING_inverted <= NOT MONTIMING_s;
  -- FANNING OUT SIGNALS
  A_PCLK     <= PCLK_intl;
  B_PCLK     <= PCLK_intl;

  A_RDAD_CLK <= RDAD_CLK_intl;
  B_RDAD_CLK <= RDAD_CLK_intl;
  A_RDAD_SIN <= RDAD_SIN_intl;
  B_RDAD_SIN <= RDAD_SIN_intl;
  A_RDAD_DIR <= RDAD_DIR_intl;
  B_RDAD_DIR <= RDAD_DIR_intl;

  A_RAMP    <= RAMP_intl;
  B_RAMP    <= RAMP_intl;

  A_GCC_RESET <= GCC_RESET_intl;
  B_GCC_RESET <= GCC_RESET_intl;
  A_SS_INCR   <= SS_INCR_intl;
  B_SS_INCR   <= SS_INCR_intl;
  A_SS_RESET  <= SS_RESET_intl;
  B_SS_RESET  <= SS_RESET_intl;
  DO_A_B_intl <= DO_A_B;

  TestStream  <= CtrlBusOut_intl.TestStream;
  SSTIN       <= ClockBus_intl.SSTIN;
END rtl;