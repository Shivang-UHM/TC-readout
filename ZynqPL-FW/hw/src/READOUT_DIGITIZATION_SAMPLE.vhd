----------------------------------------------------------------------------------
-- Company: VarnerLab for Instrumentation Development (IDLab)
-- Engineer: Salvador Ventura, Shivang Tripathi
-- 
-- Create Date: 10/18/2023
-- Module Name: TwoTARGETC_RDAD_WL_SMPL - Behavioral
-- Project Name: TARGETC-READOUT
-- Target Devices: 6UVME_Microzed Board for HMB Calorimeter Readout 
-- Tool Versions: Vivado 2022.2
-- Description: This module sends the window address for digitizing to TC 
--              It also starts the wilkinson RAMP and desrializes the digitized data 
--              and sends it to the fifomanager module
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;

ENTITY TwoTARGETC_RDAD_WL_SMPL IS
	PORT (
		DISCH_PERIOD 		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		INCR_WAIT_PERIOD 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);

		ClockBus 			: IN T_ClockBus;

		RDAD_CLK 			: OUT STD_LOGIC;
		RDAD_SIN 			: OUT STD_LOGIC;
		RDAD_DIR 			: OUT STD_LOGIC;

		-- Fifo from storage
		RDAD_DataOut		: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		RDAD_Empty 			: IN STD_LOGIC;
		RDAD_ReadEn 		: OUT STD_LOGIC;

		-- FIFO IN for Digiting
		DIG_Full 			: IN STD_LOGIC;
		DIG_DataIn 			: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		DIG_WriteEn 		: OUT STD_LOGIC;

		RAMP 				: OUT STD_LOGIC;
		GCC_RESET 			: OUT STD_LOGIC;

		HSCLK 				: OUT STD_LOGIC;

		DO_A_B 				: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		SS_INCR 			: OUT STD_LOGIC;
		SS_RESET 			: OUT STD_LOGIC;

		CtrlBus_IxSL		: IN T_CtrlBus_IxSL; --Outputs from Control Master
		--Output for control
		WindowBusy 			: OUT STD_LOGIC;
		RAMP_CNT 			: OUT STD_LOGIC;
		DO_BUS 				: OUT eDO_BUS_TYPE_2TC;
		SSvalid 			: OUT STD_LOGIC;

		--Channels
		A_CH0 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH1 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH2 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH3 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		A_CH4 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH5 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH6 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH7 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		A_CH8 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH9 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH10 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH11 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		A_CH12 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH13 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH14 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		A_CH15 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		B_CH0 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH1 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH2 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH3 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		B_CH4 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH5 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH6 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH7 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		B_CH8 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH9 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH10 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH11 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		B_CH12 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH13 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH14 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		B_CH15 				: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

		--Request and Acknowledge -
		Handshake_IxSEND 	: IN T_Handshake_IxSEND; --ACK, BUSY, ACLK
		Handshake_Data 		: OUT T_Handshake_SS_FIFO;
		Handshake_OxSEND 	: OUT T_Handshake_OxSEND --REQ, RCLK
	);

END TwoTARGETC_RDAD_WL_SMPL;

ARCHITECTURE Behavioral OF TwoTARGETC_RDAD_WL_SMPL IS

	--State for high speed data out process
	TYPE state_type IS (
		IDLE,
		READY,
		RESPREADY,
		SET_RDAD_ADDR,

		INCRWAIT,
		LOW_SET0,
		LOW_SET1,
		HIGH_SET1,
		HIGH_SET0,

		REQUEST,
		RESP_ACK,
		REQ_GRANT,
		IDLERESET,
		FIFOTEST_DATA,
		FIFOTEST_REQUEST,
		FIFOTEST_RESP_ACK,
		FIFOTEST_REQ_GRANT
	);
	SIGNAL hsout_stm : state_type := IDLE;

	-- RDAD : Reading the window for Digitazition STM
	TYPE rdad_state_type IS (
		IDLE,
		READY,
		FIFOREAD,
		FIFOEVAL,
		WDO_SET_RDAD_ADDR,
		WDO_LOW_SET0, WDO_LOW_SET1, WDO_HIGH_SET1, WDO_HIGH_SET0,
		WDO_VALID,
		WDO_RESPVALID
	);
	SIGNAL rdad_stm : rdad_state_type := IDLE;
	--State
	TYPE wilkinson_type IS (
		IDLE,
		READY,
		RESPREADY,

		CLEAR,
		START,

		VALID,
		RESPVALID,
		SAMPLE_END,
		RAMP_DISCH
	);
	SIGNAL wlstate : wilkinson_type := IDLE;

	SIGNAL RDAD_Addr_s 		: STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
	SIGNAL BitCnt 			: INTEGER := 8;

	SIGNAL RDAD_CLK_intl 	: STD_LOGIC;
	SIGNAL RDAD_SIN_intl 	: STD_LOGIC;
	SIGNAL RDAD_DIR_intl 	: STD_LOGIC;

	SIGNAL RAMP_intl 		: STD_LOGIC;
	SIGNAL GCC_RESET_intl 	: STD_LOGIC;

	SIGNAL SS_RESET_intl 	: STD_LOGIC;
	SIGNAL SS_INCR_intl 	: STD_LOGIC;
	SIGNAL HSCLK_intl 		: STD_LOGIC := '0';

	TYPE T_HANDSHAKE IS RECORD
		busy : STD_LOGIC;
		valid : STD_LOGIC;
		ready : STD_LOGIC;
		response : STD_LOGIC;
	END RECORD;

	SIGNAL STO 				: T_HANDSHAKE;
	SIGNAL RDAD 			: T_HANDSHAKE;
	SIGNAL WL 				: T_HANDSHAKE;
	SIGNAL SS 				: T_HANDSHAKE;

	SIGNAL WL_CNT_EN 		: STD_LOGIC := '0';
	SIGNAL WL_CNT_INTL 		: UNSIGNED(15 DOWNTO 0) := x"0000";

	SIGNAL SS_CNT_EN 		: STD_LOGIC := '0';
	SIGNAL SS_CNT_INTL 		: UNSIGNED(15 DOWNTO 0) := x"0000";

	SIGNAL SSBitCnt 		: INTEGER := 0;
	SIGNAL SSCnt 			: INTEGER := 0;
	SIGNAL ss_incr_flg 		: STD_LOGIC := '0';
	SIGNAL CtrlDO_intl 		: eDO_BUS_TYPE_2TC;
	SIGNAL TestFIFO_window 	: INTEGER;
	SIGNAL TestFIFO_cnt 	: INTEGER;
	SIGNAL NBRWINDOW_clkd 	: STD_LOGIC_VECTOR(31 DOWNTO 0);

	--Ack Request signals sets
	SIGNAL acknowledge_intl : STD_LOGIC;
	SIGNAL busy_intl 		: STD_LOGIC;
	SIGNAL Handshake_SEND_intl : T_Handshake_SEND_intl;

	SIGNAL A_CH0_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH1_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH2_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH3_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
		
	SIGNAL A_CH4_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH5_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH6_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH7_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
		
	SIGNAL A_CH8_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH9_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH10_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH11_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL A_CH12_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH13_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH14_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL A_CH15_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL B_CH0_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH1_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH2_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH3_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL B_CH4_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH5_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH6_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH7_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL B_CH8_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH9_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH10_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH11_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL B_CH12_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH13_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH14_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL B_CH15_intl 		: STD_LOGIC_VECTOR(11 DOWNTO 0);

	--   attribute keep_hierarchy 				: string;
	--   attribute keep_hierarchy of Behavioral : architecture is "yes";

	--   attribute mark_debug     				: string;
	--   attribute mark_debug of HSCLK       	: signal is "true";

	ATTRIBUTE syn_keep 					: STRING;
	ATTRIBUTE syn_keep OF DO_A_B 		: SIGNAL IS "true";

	ATTRIBUTE fsm_encoding 				: STRING;
	ATTRIBUTE fsm_encoding OF rdad_stm 	: SIGNAL IS "sequential";
	ATTRIBUTE fsm_encoding OF wlstate 	: SIGNAL IS "sequential";
	ATTRIBUTE fsm_encoding OF hsout_stm : SIGNAL IS "sequential";
BEGIN
	--Clock Domain Handshake
	ACK_CLKBUF : ENTITY work.clkcrossing_buf
		GENERIC MAP(
			NBITS => 1
		)
		PORT MAP(
			nrst => CtrlBus_IxSL.SW_nRST,
			DA(0) => Handshake_IxSEND.ACK,
			QB(0) => acknowledge_intl,
			ClkA => Handshake_IxSEND.ACLK, --foreign clock
			ClkB => ClockBus.HSCLK
		);

	SyncBitBUSY : ENTITY work.SyncBit
	GENERIC MAP(
		SYNC_STAGES_G => 2,
		CLK_POL_G => '1',
		RST_POL_G => '1',
		INIT_STATE_G => '0',
		GATE_DELAY_G => 1 ns
	)

	PORT MAP(
		-- Clock and reset
		clk => ClockBus.HSCLK,
		rst => CtrlBus_IxSL.SW_nRST,
		-- Incoming bit, asynchronous
		asyncBit => Handshake_IxSEND.BUSY,
		-- Outgoing bit, synced to clk
		syncBit => busy_intl
	);
	Handshake_OxSEND.Req 	<= Handshake_SEND_intl.REQ;
	Handshake_OxSEND.RClk 	<= ClockBus.HSCLK;

	SyncBuffer_NBRWINDOWS : ENTITY work.SyncBuffer
	GENERIC MAP(
		NBITS => 32
	)
	PORT MAP(
		clk => ClockBus.AXI_CLK,
		nrst => CtrlBus_IxSL.SW_nRST,
		asyncBuffer => CtrlBus_IxSL.NBRWINDOW,
		syncBUffer => NBRWINDOW_clkd
	);

	--counter process
	PROCESS (ClockBus.WL_CLK, WL_CNT_EN) BEGIN
		IF (WL_CNT_EN = '0') THEN
			WL_CNT_INTL <= (OTHERS => '0');
		ELSIF (rising_edge(ClockBus.WL_CLK)) THEN
			IF WL_CNT_EN = '1' THEN
				WL_CNT_INTL <= WL_CNT_INTL + 1;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (CtrlBus_IxSL.SW_nRST, ClockBus.RDAD_CLK)
	BEGIN
		IF CtrlBus_IxSL.SW_nRST = '0' THEN
			RDAD_ReadEn <= '0';
		ELSE
			IF falling_edge(ClockBus.RDAD_CLK) THEN
				CASE rdad_stm IS
					WHEN FIFOREAD =>
						RDAD_ReadEn <= '1';
					WHEN OTHERS =>
						RDAD_ReadEn <= '0';
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	-- Digitilization Readout the Samples Storage Location
	PROCESS (CtrlBus_IxSL.SW_nRST, ClockBus.RDAD_CLK)
	BEGIN
		IF CtrlBus_IxSL.SW_nRST = '0' THEN
			RDAD_CLK_intl <= '0';
			RDAD_SIN_intl <= '0';
			RDAD_DIR_intl <= '0';
			BitCnt <= 8;
			RDAD_Addr_s <= (OTHERS => '0');
			RDAD.response <= '0';
			RDAD.ready <= '0';
			RDAD.busy <= '0';
			RDAD.valid <= '0';
			RDAD_stm <= IDLE;

		ELSE
			IF rising_edge(ClockBus.RDAD_CLK) THEN
				CASE rdad_stm IS
					WHEN IDLE =>
						RDAD_CLK_intl <= '0';
						RDAD_SIN_intl <= '0';
						RDAD_DIR_intl <= '0';
						RDAD.ready <= '1';
						RDAD.valid <= '0';
						RDAD.busy <= '0';
						BitCnt <= 0;
						RDAD.response <= '0';
						rdad_stm <= READY;
					WHEN READY =>
						IF (RDAD_Empty = '0') THEN -- Something to read from the FIFO
							rdad_stm <= FIFOREAD;
						ELSE
							rdad_stm <= READY;
						END IF;
					WHEN FIFOREAD =>
						RDAD.response <= '1';
						RDAD.busy <= '1';

						rdad_stm <= FIFOEVAL;
					WHEN FIFOEVAL =>
						RDAD.response <= '1';
						RDAD.busy <= '1';

						rdad_stm <= WDO_SET_RDAD_ADDR;

					WHEN WDO_SET_RDAD_ADDR =>
						--Set Window Address to be digitized
						RDAD_Addr_s <= RDAD_DataOut; --RDAD_DataOut is the DATA COMING FROM WINDOW STORE, window number
						IF (WL.ready = '1') THEN
							RDAD.response <= '0';
							rdad_stm <= WDO_LOW_SET0;
						ELSE
							rdad_stm <= WDO_SET_RDAD_ADDR;
						END IF;
					WHEN WDO_LOW_SET0 =>
						RDAD_CLK_intl <= '0';
						RDAD_SIN_intl <= RDAD_Addr_s(8 - BitCnt); --MSB First
						RDAD_DIR_intl <= '1';
						rdad_stm <= WDO_LOW_SET1;
					WHEN WDO_LOW_SET1 =>
						RDAD_CLK_intl <= '1';
						rdad_stm <= WDO_HIGH_SET1;
					WHEN WDO_HIGH_SET1 =>
						RDAD_CLK_intl <= '1';
						rdad_stm <= WDO_HIGH_SET0;
					WHEN WDO_HIGH_SET0 =>
						IF BitCnt >= 8 THEN
							BitCnt <= 0;
							RDAD_DIR_intl <= '0';
							rdad_stm <= WDO_VALID;
							RDAD.valid <= '1';
							RDAD.busy <= '1';
						ELSE
							RDAD_DIR_intl <= '1';
							BitCnt <= BitCnt + 1;
							rdad_stm <= WDO_LOW_SET0;
							RDAD.busy <= '1';
						END IF;
						RDAD_CLK_intl <= '0';

					WHEN WDO_VALID =>
						RDAD_SIN_intl <= '0'; 

						IF (WL.response = '1') THEN
							RDAD.valid <= '0';
							rdad_stm <= WDO_RESPVALID;
						ELSE
							RDAD.valid <= '1';
							rdad_stm <= WDO_VALID;
						END IF;
					WHEN WDO_RESPVALID =>
						IF (WL.response = '0') THEN --Wilkinson
							RDAD.valid <= '0';
							RDAD.busy <= '0';
							rdad_stm <= IDLE;
						ELSE
							RDAD.valid <= '0';
							rdad_stm <= WDO_RESPVALID;
						END IF;

					WHEN OTHERS =>
						-- nop
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	RDAD_CLK <= RDAD_CLK_intl;
	RDAD_SIN <= RDAD_SIN_intl;
	RDAD_DIR <= RDAD_DIR_intl;

	-- Wilkinson
	PROCESS (CtrlBus_IxSL.SW_nRST, ClockBus.WL_CLK)
	BEGIN
		IF CtrlBus_IxSL.SW_nRST = '0' THEN
			RAMP_intl <= '0'; --Vdischarge
			GCC_RESET_intl <= '1';

			WL.response <= '0';
			WL.ready <= '0';
			WL.busy <= '0';
			WL.valid <= '0';
			WL_CNT_EN <= '0';
			wlstate <= IDLE;

			DIG_WriteEn <= '0';
			DIG_DataIn <= (OTHERS => '0');

		ELSE
			IF rising_edge(ClockBus.WL_CLK) THEN
				CASE wlstate IS
					WHEN IDLE =>
						RAMP_intl <= '0';
						WL.response <= '0';
						WL.ready <= '1';
						wlstate <= READY;
						GCC_RESET_intl <= '1';

					WHEN READY =>
						WL.ready <= '1';
						IF (RDAD.valid = '1') THEN
							wlstate <= RESPREADY;
							WL.response <= '1';
						ELSE
							wlstate <= READY;
							WL.response <= '0';
						END IF;
					WHEN RESPREADY =>
						WL.response <= '0';
						WL.ready <= '0';
						WL.busy <= '1';
						IF (RDAD.valid = '0') THEN
							-- Save the wdo address prior to starting the WL
							DIG_DataIn <= RDAD_Addr_s;
							WL.valid <= '0';
							GCC_RESET_intl <= '1';
							wlstate <= CLEAR;
						ELSE
							wlstate <= RESPREADY;
						END IF;

						WL_CNT_EN <= '0';

					WHEN CLEAR =>
						WL.response <= '0';
						GCC_RESET_intl <= '0';

						RAMP_intl <= '1';

						WL_CNT_EN <= '1';

						wlstate <= START;
					WHEN START =>
						IF (WL_CNT_INTL = x"7ff") THEN
							WL.valid <= '1';
							WL.ready <= '0';
							wlstate <= VALID;
							RAMP_intl <= '0';
							GCC_RESET_intl <= '0';

							WL_CNT_EN <= '0';
						ELSE
							WL_CNT_EN <= '1';
							wlstate <= START;
						END IF;
					WHEN VALID =>
						IF SS.response = '1' THEN
							WL.valid <= '0';
							wlstate <= RESPVALID;
						ELSE
							wlstate <= VALID;
							WL.valid <= '1';
						END IF;
					WHEN RESPVALID =>
						--Enable FIFODIG for removing the window
						DIG_WriteEn <= '0';
						IF (SS.response = '0') THEN
							WL.busy <= '1';
							WL.valid <= '0';
							wlstate <= SAMPLE_END;
						ELSE
							WL.valid <= '0';
							wlstate <= RESPVALID;
						END IF;
					WHEN SAMPLE_END =>
						IF (SS.busy = '1') THEN
							DIG_WriteEn <= '0';
							wlstate <= SAMPLE_END;
							WL_CNT_EN <= '0';
						ELSE
							-- Sampling is finished
							DIG_WriteEn <= '1';
							wlstate <= RAMP_DISCH;
							GCC_RESET_intl <= '0';
							WL_CNT_EN <= '1';
							RAMP_intl <= '0';
						END IF;
					WHEN RAMP_DISCH =>
						WL.ready <= '0';
						DIG_WriteEn <= '0';
						IF WL_CNT_INTL > UNSIGNED(DISCH_PERIOD) THEN
							WL.busy <= '0';
							WL.ready <= '1';
							WL.valid <= '0';
							wlstate <= IDLE;
							GCC_RESET_intl <= '0';
							WL_CNT_EN <= '0';
						ELSE
							WL_CNT_EN <= '1';
							wlstate <= RAMP_DISCH;
						END IF;
					WHEN OTHERS =>
						--nop
						wlstate <= IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	RAMP <= RAMP_intl;
	GCC_RESET <= GCC_RESET_intl;
	RAMP_CNT <= WL_CNT_EN;
	
	PROCESS (ClockBus.HSCLK, SS_CNT_EN) BEGIN
		IF (SS_CNT_EN = '0') THEN
			SS_CNT_INTL <= (OTHERS => '0');
		ELSIF (rising_edge(ClockBus.HSCLK)) THEN
			IF SS_CNT_EN = '1' THEN
				SS_CNT_INTL <= SS_CNT_INTL + 1;
			END IF;
		END IF;
	END PROCESS;

	-- Process for Data Out
	PROCESS (CtrlBus_IxSL.SW_nRST, ClockBus.HSCLK)
	BEGIN
		IF CtrlBus_IxSL.SW_nRST = '0' THEN

			SS.response <= '0';
			SS.ready <= '0';
			SS.busy <= '0';
			SS.valid <= '0';
			SS_INCR_flg <= '0';
			SScnt <= 0;
			SSBitcnt <= 0;
			SS_INCR_intl <= '0';
			SS_RESET_intl <= '1';

			hsout_stm <= IDLE;

			Handshake_SEND_intl.REQ <= '0';
			Handshake_Data.testfifo <= '0';
		ELSE
			IF rising_edge(ClockBus.HSCLK) THEN
				--STM
				CASE hsout_stm IS
					WHEN IDLE =>
						SS.response <= '0';
						SS.ready <= '1';
						SS.valid <= '0';
						SS.busy <= '0';
						hsout_stm <= READY;

						HSCLK_intl <= '0';
						SS_RESET_intl <= '0';
						SS_INCR_intl <= '0';

					WHEN READY =>
						IF (CtrlBus_IxSL.SS_INCR = '1') THEN
							SS_INCR_flg <= '1';
							SS_INCR_intl <= '1';
							hsout_stm <= LOW_SET0;
							--SS_CNT_EN <= '1';
							--hsout_stm <= INCRWAIT;
						ELSIF (CtrlBus_IxSL.TestFIFO = '1' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN -- New
							Handshake_Data.TestFIFO <= '1';
							TestFIFO_cnt <= 0;
							TestFIFO_window <= 0;
							SS.busy <= '1';
							hsout_stm <= FIFOTEST_DATA;
							--	TestFIFO <= '1';
						ELSIF (WL.valid = '1') AND (CtrlBus_IxSL.SAMPLEMODE = '1') THEN
							SS.response <= '1';
							Handshake_Data.TestFIFO <= '0';
							SS_RESET_intl <= '1';
							SS_INCR_flg <= '0';
							hsout_stm <= RESPREADY;
							SS.busy <= '1';
							--	TestFIFO <= '0';
						ELSE
							--	TestFIFO <= '0';
							hsout_stm <= READY;
						END IF;

						SScnt <= 0;
						SSBitcnt <= 0;

					WHEN FIFOTEST_DATA =>
						-- WDOTime	<= 	x"00000000" & x"FFFFFFFF";
						-- DIGTime <= 	x"FFFFFFFF" & x"00000000";
						-- Trigger <= x"123";
						-- WDONbr <= "110110110";

						--						CH0_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 0,CH0_intl'length));
						--						CH1_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 1,CH1_intl'length));
						--						CH2_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 2,CH2_intl'length));
						--						CH3_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 3,CH3_intl'length));

						--						CH4_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 4,CH4_intl'length));
						--						CH5_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 5,CH5_intl'length));
						--						CH6_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 6,CH6_intl'length));
						--						CH7_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 7,CH7_intl'length));

						--						CH8_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 8,CH8_intl'length));
						--						CH9_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 9,CH9_intl'length));
						--						CH10_intl <=std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 10,CH10_intl'length));
						--						CH11_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 11,CH11_intl'length));

						--						CH12_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 12,CH12_intl'length));
						--						CH13_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 13,CH13_intl'length));
						--						CH14_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 14,CH14_intl'length));
						--						CH15_intl  <= std_logic_vector(to_unsigned(TestFIFO_window * 512 + TestFIFO_cnt*16 + 15,CH15_intl'length));

						SS.valid <= '1';
						Handshake_SEND_intl.REQ <= '1';
						hsout_stm <= FIFOTEST_REQUEST;

					WHEN FIFOTEST_REQUEST =>
						hsout_stm <= FIFOTEST_RESP_ACK;

					WHEN FIFOTEST_RESP_ACK =>
						IF (acknowledge_intl = '1' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
							SS.valid <= '0';
							Handshake_SEND_intl.REQ <= '0';
							hsout_stm <= FIFOTEST_REQ_GRANT;
						ELSE
							hsout_stm <= FIFOTEST_RESP_ACK;
						END IF;
					WHEN FIFOTEST_REQ_GRANT =>
						IF (acknowledge_intl = '0' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
							IF (TestFIFO_cnt < 31) THEN
								hsout_stm <= FIFOTEST_DATA;
								TestFIFO_cnt <= TestFIFO_cnt + 1;
							ELSE
								TestFIFO_cnt <= 0;
								IF (TestFIFO_window < to_integer(unsigned(NBRWINDOW_clkd) - 1)) THEN
									hsout_stm <= FIFOTEST_DATA;
									TestFIFO_window <= TestFIFO_window + 1;
								ELSE
									TestFIFO_window <= 0;
									hsout_stm <= IDLE;
								END IF;
							END IF;
						ELSE
							hsout_stm <= FIFOTEST_REQ_GRANT;
						END IF;
					WHEN RESPREADY =>
						SS.busy <= '1';
						IF (WL.valid = '0') THEN
							SS.response <= '0';
							HSCLK_intl <= '0';
							SS_INCR_intl <= '1';
							SS_CNT_EN <= '1';
							hsout_stm <= LOW_SET0;
						ELSE
							SS.response <= '1';
							hsout_stm <= RESPREADY;
						END IF;
						
					WHEN LOW_SET0 =>
						HSCLK_intl <= '1'; --'0'
						IF SSBitCnt = 0 THEN
							SS_INCR_intl <= '1';
						ELSE
							SS_INCR_intl <= '0';
						END IF;
						SS_RESET_intl <= '0';
						hsout_stm <= LOW_SET1;

					WHEN LOW_SET1 =>
						HSCLK_intl <= '1';
						hsout_stm <= HIGH_SET0;
						SS_INCR_intl <= '0';

					WHEN HIGH_SET0 =>
						-- SAmple the output of TARGETC
						IF SSBitCnt > 2 THEN

							A_CH0_intl(SSBitCnt - 3) <= DO_A_B(0);
							A_CH1_intl(SSBitCnt - 3) <= DO_A_B(1);
							A_CH2_intl(SSBitCnt - 3) <= DO_A_B(2);
							A_CH3_intl(SSBitCnt - 3) <= DO_A_B(3);

							A_CH4_intl(SSBitCnt - 3) <= DO_A_B(4);
							A_CH5_intl(SSBitCnt - 3) <= DO_A_B(5);
							A_CH6_intl(SSBitCnt - 3) <= DO_A_B(6);
							A_CH7_intl(SSBitCnt - 3) <= DO_A_B(7);

							A_CH8_intl(SSBitCnt - 3) <= DO_A_B(8);
							A_CH9_intl(SSBitCnt - 3) <= DO_A_B(9);
							A_CH10_intl(SSBitCnt - 3) <= DO_A_B(10);
							A_CH11_intl(SSBitCnt - 3) <= DO_A_B(11);

							A_CH12_intl(SSBitCnt - 3) <= DO_A_B(12);
							A_CH13_intl(SSBitCnt - 3) <= DO_A_B(13);
							A_CH14_intl(SSBitCnt - 3) <= DO_A_B(14);
							A_CH15_intl(SSBitCnt - 3) <= DO_A_B(15);

							B_CH0_intl(SSBitCnt - 3) <= DO_A_B(16);
							B_CH1_intl(SSBitCnt - 3) <= DO_A_B(17);
							B_CH2_intl(SSBitCnt - 3) <= DO_A_B(18);
							B_CH3_intl(SSBitCnt - 3) <= DO_A_B(19);

							B_CH4_intl(SSBitCnt - 3) <= DO_A_B(20);
							B_CH5_intl(SSBitCnt - 3) <= DO_A_B(21);
							B_CH6_intl(SSBitCnt - 3) <= DO_A_B(22);
							B_CH7_intl(SSBitCnt - 3) <= DO_A_B(23);

							B_CH8_intl(SSBitCnt - 3) <= DO_A_B(24);
							B_CH9_intl(SSBitCnt - 3) <= DO_A_B(25);
							B_CH10_intl(SSBitCnt - 3) <= DO_A_B(26);
							B_CH11_intl(SSBitCnt - 3) <= DO_A_B(27);

							B_CH12_intl(SSBitCnt - 3) <= DO_A_B(28);
							B_CH13_intl(SSBitCnt - 3) <= DO_A_B(29);
							B_CH14_intl(SSBitCnt - 3) <= DO_A_B(30);
							B_CH15_intl(SSBitCnt - 3) <= DO_A_B(31);

						END IF;

						HSCLK_intl <= '0';

						IF SSBitCnt = 14 THEN
							--if SSBitCnt = 13 then
							--if SSBitCnt = 11 then
							hsout_stm <= REQUEST;
							SSBitCnt <= 0;
							SS.busy <= '1';
							SS.valid <= '1';
							--TPG_flg <= '0';
						ELSE
							SS.valid <= '0';
							SS.busy <= '1';
							hsout_stm <= LOW_SET1;
							SSBitCnt <= SSBitCnt + 1;
						END IF;
						--WLvalidAck <= '0';
					WHEN REQUEST =>
						IF Handshake_IxSEND.Busy = '0' THEN
							Handshake_SEND_intl.REQ <= '1';
							HSCLK_intl <= '0';
							hsout_stm <= RESP_ACK;
						ELSE
							Handshake_SEND_intl.REQ <= '0';
							HSCLK_intl <= '0';
							hsout_stm <= REQUEST;
						END IF;
					WHEN RESP_ACK =>
						HSCLK_intl <= '0';
						IF (CtrlBus_IxSL.SSACK = '1' AND CtrlBus_IxSL.SAMPLEMODE = '0') OR (acknowledge_intl = '1' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
							Handshake_SEND_intl.REQ <= '0';
							SS.valid <= '0';
							hsout_stm <= REQ_GRANT;

						ELSE
							SS.busy <= '1';
							SS.valid <= '1';
							hsout_stm <= RESP_ACK;
						END IF;

					WHEN REQ_GRANT =>
						IF (CtrlBus_IxSL.SSACK = '0' AND CtrlBus_IxSL.SAMPLEMODE = '0') OR (acknowledge_intl = '0' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
							IF (SS_INCR_flg = '0') THEN
								SScnt <= SScnt + 1;
								IF (SScnt < 31) THEN
									hsout_stm <= LOW_SET0;
									SS.busy <= '1';
								ELSE
									hsout_stm <= IDLERESET;
									SS.busy <= '0';
								END IF;
							ELSE
								SS_INCR_flg <= '0';
								SS.busy <= '0';
								hsout_stm <= IDLERESET;
							END IF;
						ELSE
							hsout_stm <= REQ_GRANT;
						END IF;
					WHEN IDLERESET =>
						SS.busy <= '0';
						--SS_RESET_intl <= '1';
						hsout_stm <= IDLE;
					WHEN OTHERS =>
						-- nop
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	--CtrlBus_OxSL.DO_BUS <= CtrlDO_intl;
	DO_BUS <= CtrlDO_intl;

	SS_RESET <= SS_RESET_intl;
	--SS_RESET 	<= '0';
	SS_INCR <= SS_INCR_intl;
	HSCLK <= HSCLK_intl;
	-- Input/Output Refresh

	A_CH0 <= A_CH0_intl;
	A_CH1 <= A_CH1_intl;
	A_CH2 <= A_CH2_intl;
	A_CH3 <= A_CH3_intl;

	A_CH4 <= A_CH4_intl;
	A_CH5 <= A_CH5_intl;
	A_CH6 <= A_CH6_intl;
	A_CH7 <= A_CH7_intl;

	A_CH8  <= A_CH8_intl;
	A_CH9  <= A_CH9_intl;
	A_CH10 <= A_CH10_intl;
	A_CH11 <= A_CH11_intl;

	A_CH12 <= A_CH12_intl;
	A_CH13 <= A_CH13_intl;
	A_CH14 <= A_CH14_intl;
	A_CH15 <= A_CH15_intl;

	B_CH0 <= B_CH0_intl;
	B_CH1 <= B_CH1_intl;
	B_CH2 <= B_CH2_intl;
	B_CH3 <= B_CH3_intl;

	B_CH4 <= B_CH4_intl;
	B_CH5 <= B_CH5_intl;
	B_CH6 <= B_CH6_intl;
	B_CH7 <= B_CH7_intl;

	B_CH8  <= B_CH8_intl;
	B_CH9  <= B_CH9_intl;
	B_CH10 <= B_CH10_intl;
	B_CH11 <= B_CH11_intl;

	B_CH12 <= B_CH12_intl;
	B_CH13 <= B_CH13_intl;
	B_CH14 <= B_CH14_intl;
	B_CH15 <= B_CH15_intl;
	
	SSvalid <= SS.valid; -- Status on AXI Lite

	WindowBusy <= '1' WHEN RDAD.busy = '1' ELSE
		'1' WHEN WL.busy = '1' ELSE
		'1' WHEN SS.busy = '1' ELSE
		'0';
END Behavioral;