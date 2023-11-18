-- -----------------------------------------------------------
--!@FILE: 	CPU_CONTROLLER.vhd
--!@AUTHOR: Jonathan Hendriks, Shivang
--!@DATE: 	21st of January 2019, Oct 2023
-- -----------------------------------------------------------
--!@DESCRIPTION:
--! CPU_CONTROLLER is the supervision over the round buffer. It
--! looks after two modes :
--! - Normal Mode, which is the user can ask for FSTWINDOW and
--!   NBRWINDOW both parameter set by the PS side thourgh AXI-Lite.
--! - Trigger Mode, which is used to catch any trigger on the Raw
--!   trigger inputs.
-- -----------------------------------------------------------

-- Libraries
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.WindowCPU_PKG.ALL;
USE work.TARGETC_pkg.ALL;

--Entity
ENTITY CPU_CONTROLLER IS
  PORT (
    nrst              : IN STD_LOGIC;

    --Time Input
    ClockBus          : IN T_ClockBus;
    Timestamp         : IN T_timestamp;
    -- Control Signals
    CtrlBus_IxSL      : IN T_CtrlBus_IxSL;
    -- Raw trigger from external board
    trigger           : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- TRIGGER FROM BOARD NOT NEEDED FOR HMB CALORIMETERS EXTERNAL TRIGGER WILL BE PROVIDED
    -- Next and Prev address from Hamming code
    NextAddr_in       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    PrevAddr_in       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    NextValid_in      : IN STD_LOGIC;
    PrevValid_in      : IN STD_LOGIC;

    -- Interface to WindowCPU and WindowStore
    CPUBus            : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    CPUTime           : OUT T_timestamp;

    -- Storage pins of TargetC
    WR_RS_S           : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    WR_CS_S           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);

    -- 
    ValidData         : OUT STD_LOGIC;        -- To WindowStore
    ValidReal         : OUT STD_LOGIC;        -- To nxtAddressCnt

    -- FIFO IN for Digiting
    DIG_Full          : OUT STD_LOGIC;
    DIG_DataIn        : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    DIG_WriteEn       : IN STD_LOGIC
  );

END ENTITY;

--Architecture
ARCHITECTURE Behavioral OF CPU_CONTROLLER IS
  COMPONENT dig_sto_fifo_9W_16D
    PORT (
      wr_clk : IN STD_LOGIC;
      rd_clk : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC
    );
  END COMPONENT;

  TYPE storagestate IS (
    IDLE,
    READY,
    RESPREADY,

    EVALUATE,
    STABLE_EVAL,
    MARK_WINDOW,
    STABLE_MARK
  );
  SIGNAL storage_stm : storagestate := IDLE;

  TYPE digstoragestate IS (
    IDLE,
    READING,
    PREPARING,
    WRITING
  );
  SIGNAL digsto_stm : digstoragestate;

  SIGNAL CurAddr_s      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL updateWR       : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL RealTimeAddr   : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL NextAddr_intl  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL PrevAddr_intl  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL OldAddr_intl   : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL FstWindow512   : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL CntWindow512   : STD_LOGIC_VECTOR(8 DOWNTO 0);

  SIGNAL DIG_Empty_intl : STD_LOGIC;
  SIGNAL STO_ReadEn     : STD_LOGIC;
  SIGNAL DIG_DataOut_intl : STD_LOGIC_VECTOR(8 DOWNTO 0);

  -- Optimization for LUT reduction
  SIGNAL Cmp_s : STD_LOGIC := '0';

  SIGNAL CTRL_CPUBUS : STD_LOGIC_VECTOR(10 DOWNTO 0);
  SIGNAL TRIG_CPUBUS : STD_LOGIC_VECTOR(10 DOWNTO 0);
  SIGNAL DIGI_CPUBUS : STD_LOGIC_VECTOR(10 DOWNTO 0);

  SIGNAL Wr1_en_dly : STD_LOGIC;
  SIGNAL Wr2_en_dly : STD_LOGIC;
  SIGNAL Old_Wr_en  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
  SIGNAL TrigInfo_intl_dly, Old_TrigInfo : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Trig_intl : STD_LOGIC;
  SIGNAL TriggerRegDly : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL validreal_s, validdata_s, valid_1dly : STD_LOGIC;
  SIGNAL LE_intl : STD_LOGIC;
  SIGNAL prev_TimeStamp : T_Timestamp;

  SIGNAL Ctrl_Busy_s : STD_LOGIC;
  -- ADD-ON from SSTIN problem
  SIGNAL Old_TrigInfo_copy : STD_LOGIC_VECTOR(11 DOWNTO 0);

  ATTRIBUTE DONT_TOUCH : STRING;

  --ATTRIBUTE DONT_TOUCH of Trig_OldAddr_intl : signal is "TRUE";
  --ATTRIBUTE DONT_TOUCH of OldAddr_intl  : signal is "TRUE";
  --ATTRIBUTE DONT_TOUCH of CntWindow512  : signal is "TRUE";
  --ATTRIBUTE DONT_TOUCH of CTRL_CPUBUS   : signal is "TRUE";

  ATTRIBUTE mark_debug : string;
  -- ATTRIBUTE mark_debug of ClockBus     : signal is "TRUE";
  -- ATTRIBUTE mark_debug of nRST         : signal is "TRUE";
  -- ATTRIBUTE mark_debug of TimeStamp    : signal is "TRUE";
  
  ATTRIBUTE fsm_encoding : STRING;
	ATTRIBUTE fsm_encoding OF storage_stm 	: SIGNAL IS "sequential";
  ATTRIBUTE fsm_encoding OF digsto_stm 	  : SIGNAL IS "sequential";

BEGIN

  -- Process of address change on rising_edge of SSTIN ( Every 64 ns)  == Verified
  PROCESS (ClockBus.CLK125MHz, nRST)  
  BEGIN
    IF nRST = '0' THEN
      validData_s   <= '0';
      validReal_s   <= '0';
      RealTimeAddr  <= (OTHERS => '0');
      -- Init the CPUs
      CurAddr_s     <= (OTHERS => '0');
      Old_Wr_en     <= (OTHERS => '1');
      Old_TrigInfo  <= (OTHERS => '0');
      CPUTime       <= (OTHERS => (OTHERS => '0'));
      prev_TimeStamp<= (OTHERS => (OTHERS => '0'));
    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN

        valid_1dly <= NOT(validData_s);

        CASE TimeStamp.samplecnt IS
          WHEN "111" => --Time 0
            IF NextValid_in = '1' THEN
               validReal_s  <= '0';
               RealTimeAddr <= NextAddr_in;
            END IF;
            --Real Time Information
            prev_TimeStamp <= TimeStamp;
            Old_TrigInfo   <= TrigInfo_intl_dly;
            Old_Wr_en      <= NOT(wr2_en_dly) & NOT(wr1_en_dly);

          WHEN "000" => --Time 1
            validReal_s <= '1'; -- After this the data is correct, time to stabilize
          WHEN "010" => --Half way // Falling edge
            validData_s       <= '0';
            CurAddr_s         <= RealTimeAddr;
            OldAddr_intl      <= CurAddr_s;

          WHEN "011" =>
            updateWR          <= CurAddr_s;
            CPUTime           <= prev_TimeStamp;
            Old_TrigInfo_copy <= Old_TrigInfo;

          WHEN "100" =>
            validData_s <= '1'; -- After this the data is correct, time to stabilize

          WHEN OTHERS =>
        END CASE;

        IF TriggerRegDly = "01" THEN
          Old_TrigInfo <= TrigInfo_intl_dly;
          --add on
          Old_Wr_en <= NOT(wr2_en_dly) & NOT(wr1_en_dly);
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -- Address update
  ValidData <= validData_s;
  ValidReal <= validReal_s;
  
  WR_RS_S <= updateWR(1 DOWNTO 0);
  WR_CS_S <= updateWR(7 DOWNTO 2);
  ------------------------------------------

  DIG_STO_AFIFO : dig_sto_fifo_9W_16D
  PORT MAP
  (
    dout    => DIG_DataOut_intl,
    empty   => DIG_Empty_intl,
    rd_en   => STO_ReadEn,
    rd_clk  => ClockBus.CLK125MHz,
    din     => DIG_DataIn,
    full    => DIG_Full,
    wr_en   => DIG_WriteEn,
    wr_clk  => ClockBus.WL_CLK

  );
  -- Process for Next and Prev Address  ----======= This process looks unnecessary==========
  PROCESS (ClockBus.CLK125MHz, nrst)
  BEGIN
    IF nrst = '0' THEN
      NextAddr_intl <= x"01";
      PrevAddr_intl <= x"FF";
    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN
        IF PrevValid_in = '1' THEN
          PrevAddr_intl <= PrevAddr_in;
        END IF;

        IF NextValid_in = '1' THEN
          NextAddr_intl <= NextAddr_in;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -- Process for Trigger Information and Control
  PROCESS (ClockBus.CLK125MHz, nrst)
  BEGIN
    IF nrst = '0' THEN
      TRIG_CPUBUS   <= CMD_NOP & x"00";
      TriggerRegDly <= (OTHERS => '0');
    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN

        TriggerRegDly <= TriggerRegDly(0) & Trig_intl;

        IF valid_1dly = '1' THEN
          --Send the command
          IF Old_TrigInfo /= "000000000000" THEN
            CASE Old_Wr_en IS
              WHEN "00" =>
                TRIG_CPUBUS <= CMD_BOTH_MARKED & OldAddr_intl;
              WHEN "01" =>
                TRIG_CPUBUS <= CMD_WR2_MARKED & OldAddr_intl;
              WHEN "10" =>
                TRIG_CPUBUS <= CMD_WR1_MARKED & OldAddr_intl;
              WHEN "11" =>
                TRIG_CPUBUS <= DIGI_CPUBUS;
              WHEN OTHERS =>
            END CASE;
          ELSE
            TRIG_CPUBUS <= DIGI_CPUBUS;
          END IF;
        ELSE
          IF LE_intl = '1' AND TriggerRegDly = "01" THEN
            TRIG_CPUBUS <= CMD_WR2_MARKED & OldAddr_intl;
          ELSE
            TRIG_CPUBUS <= DIGI_CPUBUS;
          END IF;
          --end if;
        END IF;
      END IF;
    END IF;
  END PROCESS;
  -- Minimal State Machine For Windows select and liberate CPU
  PROCESS (ClockBus.CLK125MHz, nRST) 
  BEGIN
    IF nRST = '0' THEN
      storage_stm <= IDLE;

      FstWindow512 <= (OTHERS => '0');
      CntWindow512 <= (OTHERS => '0');

      CTRL_CPUBUS <= CMD_NOP & x"00";

    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN

        -- Normal Storage Case from PS
        CASE storage_stm IS
          WHEN IDLE =>
            CTRL_CPUBUS <= DIGI_CPUBUS;
            Ctrl_Busy_s <= '0';
            storage_stm <= READY;

          WHEN READY =>
            CTRL_CPUBUS <= DIGI_CPUBUS;
            
            IF (CtrlBus_IxSL.WindowStorage = '1') THEN
              -- First Window && Counter is on 512 windows (9bits)
              FstWindow512 <= CtrlBus_IxSL.FSTWINDOW(8 DOWNTO 0);
              CntWindow512 <= CtrlBus_IxSL.NBRWINDOW(8 DOWNTO 0);

              Ctrl_Busy_s <= '1';

              storage_stm <= RESPREADY;
            ELSE
              storage_stm <= READY;
            END IF;

          WHEN RESPREADY =>
            CTRL_CPUBUS <= DIGI_CPUBUS; 
            IF (CtrlBus_IxSL.WindowStorage = '0') THEN -- Digitization starts at falling edge of windowstorage signal
              storage_stm <= EVALUATE;

            ELSE
              storage_stm <= RESPREADY;
            END IF;

          WHEN EVALUATE =>

            -- Waiting to have the next window

            IF OldAddr_intl = FstWindow512(8 DOWNTO 1) AND (valid_1dly = '1') THEN

              IF FstWindow512(0) = '0' THEN --  If the window number is even

                IF Cmp_s = '1' THEN --                                  
                  CTRL_CPUBUS(10 DOWNTO 8) <= CMD_WR1_MARKED;
                  CntWindow512 <= STD_LOGIC_VECTOR(unsigned(CntWindow512) - 1); ---Count just one
                ELSE
                  CTRL_CPUBUS(10 DOWNTO 8) <= CMD_BOTH_MARKED;
                  CntWindow512 <= STD_LOGIC_VECTOR(unsigned(CntWindow512) - 2); -- Count two 
                END IF;
              ELSE
                CTRL_CPUBUS(10 DOWNTO 8) <= CMD_WR2_MARKED;
                CntWindow512 <= STD_LOGIC_VECTOR(unsigned(CntWindow512) - 1);
              END IF;

              CTRL_CPUBUS(7 DOWNTO 0) <= OldAddr_intl;
              storage_stm <= STABLE_EVAL;
            ELSE
              CTRL_CPUBUS <= DIGI_CPUBUS;
              storage_stm <= EVALUATE;
            END IF;

          WHEN STABLE_EVAL =>
            storage_stm <= MARK_WINDOW;

          WHEN MARK_WINDOW =>
            IF (to_integer(unsigned(CntWindow512)) /= 0) THEN

              IF (valid_1dly = '1') THEN

                IF Cmp_s = '1' THEN --- if it is the last window
                  CTRL_CPUBUS(10 DOWNTO 8) <= CMD_WR1_MARKED;
                  CntWindow512 <= STD_LOGIC_VECTOR(unsigned(CntWindow512) - 1);
                ELSE
                  CTRL_CPUBUS(10 DOWNTO 8) <= CMD_BOTH_MARKED;
                  CntWindow512 <= STD_LOGIC_VECTOR(unsigned(CntWindow512) - 2);
                END IF;
                CTRL_CPUBUS(7 DOWNTO 0) <= OldAddr_intl;
                storage_stm <= STABLE_MARK;
              ELSE
                CTRL_CPUBUS <= DIGI_CPUBUS;
              END IF;
            ELSE
              CTRL_CPUBUS <= DIGI_CPUBUS;
              storage_stm <= IDLE;
            END IF;
          WHEN STABLE_MARK =>
            storage_stm <= MARK_WINDOW;
          WHEN OTHERS =>
        END CASE;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (ClockBus.CLK125MHz, nRST)
  BEGIN
    IF nRST = '0' THEN
      digsto_stm <= IDLE;

      DIGI_CPUBUS <= CMD_NOP & x"00";
    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN
        -- State Machine for Reading the windows digitized
        CASE digsto_stm IS
          WHEN IDLE =>
            DIGI_CPUBUS <= CMD_NOP & x"00";
            IF DIG_Empty_intl = '0' THEN
              digsto_stm <= READING;
              STO_ReadEn <= '1';
            ELSE
              digsto_stm <= IDLE;
              STO_ReadEn <= '0';
            END IF;

          WHEN READING =>
            digsto_stm <= PREPARING;
            STO_ReadEn <= '0';

          WHEN PREPARING =>
            IF DIG_DataOut_intl(0) = '0' THEN
              DIGI_CPUBUS <= CMD_WR1_EN_DIS & DIG_DataOut_intl(8 DOWNTO 1);
            ELSE
              DIGI_CPUBUS <= CMD_WR2_EN_DIS & DIG_DataOut_intl(8 DOWNTO 1);
            END IF;
            digsto_stm <= WRITING;

          WHEN WRITING =>
            IF ((DIGI_CPUBUS = TRIG_CPUBUS) AND (CtrlBus_IxSL.CPUMode = '1')) OR ((DIGI_CPUBUS = CTRL_CPUBUS) AND (CtrlBus_IxSL.CPUMode = '0')) THEN
              digsto_stm <= IDLE;
              DIGI_CPUBUS <= CMD_NOP & x"00";
            ELSE
              digsto_stm <= WRITING;
            END IF;

          WHEN OTHERS =>
            digsto_stm <= IDLE;
            STO_ReadEn <= '0';
        END CASE;
      END IF;
    END IF;
  END PROCESS;


  PROCESS (ClockBus.CLK125MHz, nRST) 
  BEGIN
    IF nRST = '0' THEN
      CPUBus <= CMD_NOP & x"00";

    ELSE
      IF rising_edge(ClockBus.CLK125MHz) THEN
        IF CtrlBus_IxSL.CPUMode = '1' THEN
          CPUBus <= TRIG_CPUBUS;
        ELSE
          CPUBus <= CTRL_CPUBUS;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  Cmp_s <= '1' WHEN CntWindow512 = "000000001" ELSE
    '0';
END Behavioral;