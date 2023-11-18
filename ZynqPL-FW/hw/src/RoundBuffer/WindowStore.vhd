-- -----------------------------------------------------------
--!@FILE: 	RoundBuffer.vhd
--!@AUTHOR: Jonathan Hendriks, Shivang Tripathi
--!@DATE: 	21st of January 2019, Oct 2023
-- -----------------------------------------------------------
--!@DESCRIPTION:
--!
-- -----------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.WindowCPU_pkg.ALL;

ENTITY WindowStore IS
	PORT (
		nrst 					: IN STD_LOGIC;
		ClockBus 				: IN T_ClockBus;

		ValidData 				: IN STD_LOGIC;

		CPUBus 					: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		CPUTime					: IN T_timestamp;
		TriggerInfo 			: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		-- Control Signals
		CtrlBus_IxSL 			: IN T_CtrlBus_IxSL;

		-- Overwatch of Transmission
		NbrOfPackets 			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Reg_Clr 				: IN STD_LOGIC;							--WindowStorage

		-- FIFO out for Reading RDAD
		RDAD_ReadEn 			: IN STD_LOGIC;
		RDAD_Data_trig 			: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		RDAD_WriteEn_trig 		: IN STD_LOGIC;
		RDAD_DataOut 			: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		RDAD_Empty 				: OUT STD_LOGIC;

		-- FIFO for FiFoManager
		AXI_ReadEn 				: IN STD_LOGIC;
		AXI_Time_DataOut 		: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		AXI_WdoAddr_DataOut 	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		AXI_TrigInfo_DataOut 	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		AXI_Spare_DataOut 		: OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		AXI_Empty 				: OUT STD_LOGIC
	);

END ENTITY;

ARCHITECTURE Behavioral OF WindowStore IS
	COMPONENT axi_wdo_addr_fifo
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

	COMPONENT axi_cmd_fifo_11W_5D
		PORT (
			wr_clk : IN STD_LOGIC;
			rd_clk : IN STD_LOGIC;
			din : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			rd_en : IN STD_LOGIC;
			dout : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			full : OUT STD_LOGIC;
			empty : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT axi_time_fifo_64W_32D
		PORT (
			wr_clk : IN STD_LOGIC;
			rd_clk : IN STD_LOGIC;
			din : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			rd_en : IN STD_LOGIC;
			dout : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			full : OUT STD_LOGIC;
			empty : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT AXI_TRIG_AFIFO
		PORT (
			wr_clk : IN STD_LOGIC;
			rd_clk : IN STD_LOGIC;
			din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			rd_en : IN STD_LOGIC;
			dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			full : OUT STD_LOGIC;
			empty : OUT STD_LOGIC
		);
	END COMPONENT;

	TYPE T_storestate IS(
	IDLE,
	STABILIZE,
	PREPARE,
	PULSE,
	STABILIZE2,
	PREPARE2,
	PULSE2
	);
	SIGNAL writeEn_stm : T_storestate := IDLE;

	SIGNAL Full_out_intl : STD_LOGIC;
	SIGNAL WriteEn_intl : STD_LOGIC;
	SIGNAL WriteEn : STD_LOGIC;

	SIGNAL Counter : STD_LOGIC_VECTOR(63 DOWNTO 0);

	SIGNAL Wdo1 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL WdoNumber : STD_LOGIC_VECTOR(8 DOWNTO 0);

	SIGNAL CMD_s : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL CMD_s1 : STD_LOGIC_VECTOR(10 DOWNTO 0);

	SIGNAL axi_full_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL axi_empty_s : STD_LOGIC_VECTOR(3 DOWNTO 0);

	SIGNAL NbrOfPackets_intl : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL WriteEn_mult : STD_LOGIC;
	SIGNAL WdoNumber_mult : STD_LOGIC_VECTOR(8 DOWNTO 0);

	ATTRIBUTE mark_debug : STRING;

	-- ATTRIBUTE mark_debug OF WriteEn 			: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF WdoNumber 		: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF WdoNumber_mult 	: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF WriteEn_mult 	: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF RDAD_WriteEn_trig: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF RDAD_Data_trig 	: SIGNAL IS "true";
	-- ATTRIBUTE mark_debug OF WriteEn_intl 	: SIGNAL IS "true";

	-- -------------------------------------------------------------
	-- Constraints on Signals
	-- -------------------------------------------------------------
	ATTRIBUTE DONT_TOUCH : STRING;
	-- ATTRIBUTE DONT_TOUCH OF RDAD_STO_AFIFO 	: LABEL IS "TRUE";
	-- ATTRIBUTE DONT_TOUCH OF writeEn_stm 		: SIGNAL IS "TRUE";
	-- ATTRIBUTE DONT_TOUCH OF writeen_intl 	: SIGNAL IS "TRUE";
	ATTRIBUTE fsm_encoding 					: STRING;
	ATTRIBUTE fsm_encoding OF writeEn_stm 	: SIGNAL IS "sequential";

BEGIN
	PROCESS (ClockBus.CLK125MHz)
	BEGIN
		IF nrst = '0' THEN
			NbrOfPackets_intl <= (OTHERS => '0');
			Wdo1 	<= (OTHERS => '0');
			cmd_s1 	<= (OTHERS => '0');
		ELSE
			IF rising_edge(ClockBus.Clk125MHz) THEN

				IF Reg_CLR = '1' THEN									-- WindowStorage (WindowStorage is Enabled on PS)
					NbrOfPackets_intl <= (OTHERS => '0');
				END IF;

				IF ValidData = '1' THEN
					CASE writeEn_stm IS
						WHEN IDLE =>
							CASE CPUBus(10 DOWNTO 8) IS
								WHEN CMD_WR1_MARKED => -- ODD WINDOW
									NbrOfPackets_intl <= STD_LOGIC_VECTOR(unsigned(NbrOfPackets_intl) + 1);
									--	counter <= CPUTime.graycnt & "0000"; -- gray counter is a timestamp for the window

									Wdo1 <= CPUBus(7 DOWNTO 0) & '0';
									cmd_s1 <= CPUBus;
									writeEn_stm <= STABILIZE;

								WHEN CMD_WR2_MARKED => -- EVEN WINDOW
									NbrOfPackets_intl <= STD_LOGIC_VECTOR(unsigned(NbrOfPackets_intl) + 1);
									--counter <= CPUTime.graycnt & "1000";
									Wdo1 <= CPUBus(7 DOWNTO 0) & '1';
									cmd_s1 <= CPUBus;
									writeEn_stm <= STABILIZE;

								WHEN CMD_BOTH_MARKED =>
									NbrOfPackets_intl <= STD_LOGIC_VECTOR(unsigned(NbrOfPackets_intl) + 2);
									--counter <= CPUTime.graycnt & "0000";
									Wdo1 <= CPUBus(7 DOWNTO 0) & '0';
									cmd_s1 <= CPUBus;
									writeEn_stm <= STABILIZE;
								WHEN OTHERS =>
									writeEn_stm <= IDLE;
							END CASE;

						WHEN STABILIZE =>
							writeEn_stm <= PREPARE;
						WHEN PREPARE =>
							writeEn_stm <= PULSE;

						WHEN PULSE =>
							IF cmd_s1(10 DOWNTO 8) = CMD_BOTH_MARKED THEN
								Wdo1 <= Wdo1(8 DOWNTO 1) & '1';
								--		Counter <= Counter(63 downto 4) & "1000";
								writeEn_stm <= STABILIZE2;
							ELSE
								writeEn_stm <= IDLE;
							END IF;

						WHEN STABILIZE2 =>
							writeEn_stm <= PREPARE2;

						WHEN PREPARE2 =>
							writeEn_stm <= PULSE2;

						WHEN PULSE2 =>
							writeEn_stm <= IDLE;

						WHEN OTHERS =>
							writeEn_stm <= IDLE;
					END CASE;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (ClockBus.CLK125MHz)
	BEGIN
		IF nrst = '0' THEN
			WriteEn_intl <= '0';
		ELSE
			IF rising_edge(ClockBus.Clk125MHz) THEN
				IF ValidData = '1' THEN
					CASE writeEn_stm IS
						WHEN STABILIZE =>
							WriteEn_intl <= '1';

						WHEN STABILIZE2 =>
							WriteEn_intl <= '1';

						WHEN OTHERS =>
							WriteEn_intl <= '0';
					END CASE;
				ELSE
					WriteEn_intl <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;

	multiplex_WdoNumber : PROCESS (ClockBus.CLK125MHz, CtrlBus_IxSL.CPUMode)
	BEGIN
		IF nrst = '0' THEN
			WriteEn_mult <= '0';
			WdoNumber_mult <= (OTHERS => '0');
		ELSE
			IF rising_edge(ClockBus.Clk125MHz) THEN
				CASE CtrlBus_IxSL.CPUMode IS
					WHEN '0' =>
						WriteEn_mult <= WriteEn_intl;
						WdoNumber_mult <= Wdo1;
					WHEN '1' =>
						WriteEn_mult <= RDAD_WriteEn_trig;
						WdoNumber_mult <= RDAD_Data_trig;
					WHEN OTHERS =>
						WriteEn_mult <= '0';
						WdoNumber_mult <= (OTHERS => '0');
				END CASE;
			END IF;
		END IF;
	END PROCESS;


	WriteEn <= WriteEn_mult;
	WdoNumber <= WdoNumber_mult;
	Cmd_s <= (OTHERS => '0');
	counter <= (OTHERS => '0');
	
	-- Window address to RDAD_ADD module
	RDAD_STO_AFIFO : axi_wdo_addr_fifo
	PORT MAP(
		--  rst => nrst,

		dout => RDAD_DataOut,
		empty => RDAD_Empty,
		rd_en => RDAD_ReadEn,
		rd_clk => ClockBus.RDAD_CLK,
		din => WdoNumber,
		full => Full_out_intl,
		wr_en => WriteEn,
		wr_clk => ClockBus.CLK125MHz

	);
	
	-- Window address for DIG time in FIFO manager
	AXI_CMD_AFIFO : axi_cmd_fifo_11W_5D
	PORT MAP(

		dout => AXI_Spare_DataOut,
		empty => axi_empty_s(0),
		rd_en => AXI_ReadEn,
		rd_clk => ClockBus.AXI_CLK,
		din => Cmd_s,
		full => axi_full_s(0),
		wr_en => WriteEn,
		wr_clk => ClockBus.CLK125MHz
	);

	-- Counter for WDOTime in FIFO manager
	AXI_Time_AFIFO : axi_time_fifo_64W_32D
	PORT MAP(

		dout => AXI_Time_DataOut,
		empty => axi_empty_s(1),
		rd_en => AXI_ReadEn,
		rd_clk => ClockBus.AXI_CLK,
		din => Counter,
		full => axi_full_s(1),
		wr_en => WriteEn,
		wr_clk => ClockBus.CLK125MHz
	);

	-- FIFO_WdoAddr for  FIFO manager
	AXI_WdoAddr_AFIFO : axi_wdo_addr_fifo
	PORT MAP(
		--  rst => nrst,

		dout => AXI_WdoAddr_DataOut,
		empty => axi_empty_s(2),
		rd_en => AXI_ReadEn,
		rd_clk => ClockBus.AXI_CLK,
		din => WdoNumber,
		full => axi_full_s(2),
		wr_en => WriteEn,
		wr_clk => ClockBus.CLK125MHz

	);
	-- Trigger info  for FIFO_TrigInfo in FIFO MANAGER

	AXI_Trig_AFIFO_inst : AXI_TRIG_AFIFO
	PORT MAP(

		dout => AXI_TrigInfo_DataOut,
		empty => axi_empty_s(3),
		rd_en => AXI_ReadEn,
		rd_clk => ClockBus.AXI_CLK,
		din => TriggerInfo,
		full => axi_full_s(3),
		wr_en => WriteEn,
		wr_clk => ClockBus.CLK125MHz
	);
	
	AXI_empty <= '0' WHEN axi_empty_s = "0000" ELSE '1';
	
	NbrOfPackets <= NbrOfPackets_intl;

END Behavioral;