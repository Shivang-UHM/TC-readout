-- -----------------------------------------------------------
--!@FILE: 	RoundBufferV5.vhd
--!@AUTHOR: Jonathan Hendriks, Shivang Tripathi
--!@DATE: 	21st of January 2019, Oct 2023
-- -----------------------------------------------------------
--!@DESCRIPTION:
--!
-- -----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TARGETC_pkg.all;
use work.WindowCPU_pkg.all;

entity RoundBuffer is
  port
  (
    ClockBus        : in T_ClockBus;
    Timecounter     : in std_logic_vector(63 downto 0);
    Timestamp       : in T_timestamp;
    trigger         : in std_logic_vector(3 downto 0);   -- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED
    CtrlBus_IxSL    : in T_CtrlBus_IxSL; --Outputs from Control Master
    --signals for the HMB roundbuffer
    hmb_trigger     : in std_logic;
    mode            : in std_logic;
    delay_trigger   : in std_logic_vector(3 downto 0);
    sstin_updateBit : in std_logic_vector(2 downto 0);
    -- FIFO out for Reading RDAD
    RDAD_ReadEn     : in std_logic;
    RDAD_DataOut    : out std_logic_vector(8 downto 0);
    RDAD_Empty      : out std_logic;

    -- FIFO IN for Digiting
    DIG_DataIn      : in std_logic_vector(8 downto 0);
    DIG_WriteEn     : in std_logic;
    DIG_Full        : out std_logic;

    WR_R            : out std_logic_vector(1 downto 0);
    WR_C            : out std_logic_vector(5 downto 0);
    -- FIFO for FiFoManager
    AXI_ReadEn           : in std_logic;
    AXI_Time_DataOut     : out std_logic_vector(63 downto 0);
    AXI_WdoAddr_DataOut  : out std_logic_vector(8 downto 0);
    AXI_TrigInfo_DataOut : out std_logic_vector(11 downto 0);
    AXI_Spare_DataOut    : out std_logic_vector(10 downto 0);
    AXI_Empty            : out std_logic;
    --Output For control
    RBNbrOfPackets       : out std_logic_vector(7 downto 0);
    address_is_zero_out  : out std_logic
  );
end entity;

architecture rtl of RoundBuffer is

  signal TriggerInfo_i  : std_logic_vector(11 downto 0);
  signal Bus_intl       : std_logic_vector(10 downto 0);
  signal NextValid_s    : std_logic;
  signal PrevValid_s    : std_logic;
  signal NextAddr_s     : std_logic_vector(7 downto 0);
  signal PrevAddr_s     : std_logic_vector(7 downto 0);

  signal CurWindowCnt   : std_logic_vector(7 downto 0); --
  signal OldWindowCnt   : std_logic_vector(7 downto 0); --
  signal NextWindowCnt  : std_logic_vector(7 downto 0); --
  signal PrevWindowCnt  : std_logic_vector(7 downto 0); --
  signal WR_C_sig       : std_logic_vector(5 downto 0) := (others => '0');
  signal WR_R_sig       : std_logic_vector(1 downto 0) := (others => '0');

  signal ValidData_s    : std_logic;
  signal ValidReal_s    : std_logic;
  signal ValidData_dly  : std_logic;
  signal ValidData_delay: std_logic;
  signal nrst           : std_logic;
  signal time_intl      : T_timestamp;

  signal RDAD_Data_s    : std_logic_vector(8 downto 0);
  signal RDAD_Full_s    : std_logic;
  signal RDAD_WrEn_s    : std_logic;

  signal WR_RS_S_trig   : std_logic_vector(1 downto 0) := (others => '0');
  signal WR_CS_S_trig   : std_logic_vector(5 downto 0) := (others => '0');
  signal WR_RS_S_user   : std_logic_vector(1 downto 0) := (others => '0');
  signal WR_CS_S_user   : std_logic_vector(5 downto 0) := (others => '0');
  signal reg3           : std_logic;
  signal reg4           : std_logic;
  signal flag_edge      : std_logic;
  signal CPUMODE_edge   : std_logic;
  signal trigger_s      : std_logic;
  signal trigger_ped    : std_logic;
  signal trigger_intl   : std_logic;
  signal delay_trigger_intl : std_logic_vector(3 downto 0);

  type WR_update is (
    IDLE,
    CPUMODE_edge_detected
  );
  signal wr_update_st : WR_update;

  type SSTIN_synch_st is (
    USERMODE,
    TRIGGERMODE,
    SSTIN_SYNC,
    EVALUATE
  );
  signal sstin_sync_st : SSTIN_synch_st := USERMODE;

  attribute DONT_TOUCH : string;
  attribute DONT_TOUCH of NextAddr_s  : signal is "TRUE";
  attribute DONT_TOUCH of PrevAddr_s  : signal is "TRUE";
  attribute DONT_TOUCH of NextValid_s : signal is "TRUE";
  attribute DONT_TOUCH of PrevValid_s : signal is "TRUE";

  ATTRIBUTE mark_debug : string;
  -- ATTRIBUTE mark_debug of trigger_intl : signal is "TRUE";
  
  ATTRIBUTE fsm_encoding : STRING;
	ATTRIBUTE fsm_encoding OF wr_update_st 	  : SIGNAL IS "sequential";
  ATTRIBUTE fsm_encoding OF sstin_sync_st 	: SIGNAL IS "sequential";

begin

  HMBroundBuff : ENTITY work.HMB_roundBuffer
  port map(
    clk             => ClockBus.CLK125MHz,
    RST             => nrst,
    trigger         => hmb_trigger,   -- PStrigger (in PS)
    full_fifo       => RDAD_Full_s,
    mode            => mode,          -- triggerMode (in PS)
    delay_trigger   => delay_trigger, 
    sstin_updateBit => sstin_updateBit,
    sstin_cntr      => Timestamp.samplecnt,
    enable_write    => RDAD_WrEn_s,   -- For enabling fifo on wdostore to pass RD_Addr
    RD_add          => RDAD_Data_s,
    TriggerInfo     => TriggerInfo_i,
    WR_RS           => WR_RS_S_trig,
    WR_CS           => WR_CS_S_trig
  );

  SyncBitNrst : entity work.SyncBit
  generic map (
      SYNC_STAGES_G => 2,
      CLK_POL_G     => '1',
      RST_POL_G     => '1',
      INIT_STATE_G  => '0',
      GATE_DELAY_G  => 1 ns
  )
  port map (
  -- Clock and reset
      clk => ClockBus.CLK125MHz,
      rst => '0',
      -- Incoming bit, asynchronous
      asyncBit => CtrlBus_IxSL.SW_nRST,
      -- Outgoing bit, synced to clk
      syncBit => nrst
  );
  
  CPU_CONTROLLER_inst : ENTITY work.CPU_CONTROLLER
  port map(
    nrst          => nrst,
    ClockBus      => ClockBus,
    timestamp     => timestamp,
    CtrlBus_IxSL  => CtrlBus_IxSL,
    trigger       => trigger,
    NextAddr_in   => NextAddr_s,
    PrevAddr_in   => PrevAddr_s,
    NextValid_in  => NextValid_s,
    PrevValid_in  => PrevValid_s,
  
    CPUBus        => Bus_intl,
    CPUTime       => Time_intl,
  
    WR_RS_S       => WR_RS_S_user,
    WR_CS_S       => WR_CS_S_user,
  
    ValidReal     => ValidReal_s,
    ValidData     => ValidData_s,
    
    DIG_Full      => DIG_Full,
    DIG_DataIn    => DIG_DataIn,
    DIG_WriteEn   => DIG_WriteEn
  );
  
  
  WDOSTORE : ENTITY work.WindowStore
  port map(
    nrst                 => nrst,
    ClockBus             => ClockBus,
    ValidData            => ValidData_s,
  
    CPUBus               => Bus_intl,
    CPUTime              => Time_intl,
    TriggerInfo          => TriggerInfo_i,
    CtrlBus_IxSL         => CtrlBus_IxSL,
    NbrOfPackets         => RBNbrOfPackets,
    Reg_Clr              => CtrlBus_IxSL.WindowStorage,
    -- FIFO out for Reading RDAD
    RDAD_ReadEn          => RDAD_ReadEn,
    RDAD_Data_trig       => RDAD_Data_s,
    RDAD_WriteEn_trig    => RDAD_WrEn_s,
    RDAD_DataOut         => RDAD_DataOut,
    RDAD_Empty           => RDAD_Empty,
    -- FIFO for FiFoManager
    AXI_ReadEn           => AXI_ReadEn,
    AXI_Time_DataOut     => AXI_Time_DataOut,
    AXI_WdoAddr_DataOut  => AXI_WdoAddr_DataOut,
    AXI_TrigInfo_DataOut => AXI_TrigInfo_DataOut,
    AXI_Spare_DataOut    => AXI_Spare_DataOut,
    AXI_Empty            => AXI_Empty
  );

  nextAddressCnt_inst : ENTITY work.nextAddressCnt
  port map(
    clk              => ClockBus.CLK125MHz,
    rst              => nrst,
    Ctrl             => ValidReal_s,
    usrRst           => CtrlBus_IxSL.WindowStorage,
    nextAddress      => NextAddr_s,
    nextAddressValid => NextValid_s,
    address_is_zero  => address_is_zero_out
  );

  -- Need to work on this module. haven't checked or tested it yet.
  pedestalTrigger_inst : ENTITY work.pedestalTrigger   
  port map (
    clk       => ClockBus.CLK125MHz,
    rst       => nrst,
    trigger   => trigger_ped,
    mode      => CtrlBus_IxSL.WindowStorage,
    pedestals => CtrlBus_IxSL.TriggerModePed,
    average   => CtrlBus_IxSL.pedestalTriggerAvg,
    wr_rs     => WR_RS_S_trig, -- To synchronize WR and start at window 0
    sstin     => Timestamp.samplecnt
  );
  
  edge_detect_cpu : process (ClockBus.CLK125MHz, nrst, CtrlBus_IxSL.CPUMode)
  begin
    if rising_edge(ClockBus.CLK125MHz) then
      reg3 <= CtrlBus_IxSL.CPUMode;
      reg4 <= reg3;
    end if;
  end process edge_detect_cpu;

  CPUMODE_edge <= (reg3) xor (reg4);

  edge_flag : process (ClockBus.CLK125MHz, nrst)
  begin
    if nrst = '0' then
      flag_edge <= '0';
    else
      if rising_edge(ClockBus.Clk125MHz) then
        if CPUMODE_edge = '1' then
          flag_edge <= '1';
        else
          flag_edge <= '0';
        end if;
      end if;
    end if;
  end process;

  WR_update_inst : process (ClockBus.CLK125MHz, nrst, TimeStamp.samplecnt, CPUMODE_edge)
  begin
    if nrst = '0' then
      WR_R_sig <= (others => '0');
      WR_C_sig <= (others => '0');
    else
      if rising_edge(ClockBus.Clk125MHz) then
        case sstin_sync_st is

          when USERMODE =>
            if CPUMODE_edge = '0' then
              WR_R_sig      <= WR_RS_S_user;
              WR_C_sig      <= WR_CS_S_user;
              sstin_sync_st <= USERMODE;
            else
              sstin_sync_st <= SSTIN_SYNC;
            end if;

          when TRIGGERMODE =>
            if CPUMODE_edge = '0' then
              WR_R_sig <= WR_RS_S_trig;
              WR_C_sig <= WR_CS_S_trig;

              sstin_sync_st <= TRIGGERMODE;
            else
              sstin_sync_st <= SSTIN_SYNC;
            end if;

          when SSTIN_SYNC =>
            if TimeStamp.samplecnt = "110" then
              sstin_sync_st <= EVALUATE;
            else
              sstin_sync_st <= SSTIN_SYNC;
            end if;

          when EVALUATE =>
            if (CtrlBus_IxSL.CPUMode = '0') then
              sstin_sync_st <= USERMODE;
            else
              sstin_sync_st <= TRIGGERMODE;
            end if;
        end case;
      end if;
    end if;
  end process;

  WR_R <= WR_R_sig;
  WR_C <= WR_C_sig;

  trigger_s <= '0' when trigger = "0000" else '1'; -- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED

  trigger_intl <= trigger_s or trigger_ped;

  delay_trigger_intl <= CtrlBus_IxSL.TC_Delay_RB(3 downto 0);

end rtl;