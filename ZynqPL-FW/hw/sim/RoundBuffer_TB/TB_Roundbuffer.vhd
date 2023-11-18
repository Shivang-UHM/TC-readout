----------------------------------------------------------------------------------
-- Company: IDLab
-- Engineer: Shivang Tripathi
-- 
-- Create Date: 11/02/2023 03:42:09 PM
-- Design Name: Roundbuffer Testbench
-- Module Name: TB_Roundbuffer - Behavioral
-- Project Name: TC-Readout
-- Target Devices: Zynq 7020
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.simulation_pkg.all;
use work.TARGETC_pkg.all;
use work.WindowCPU_pkg.all;
use std.textio.all;

entity TB_Roundbuffer is
end TB_Roundbuffer;

architecture Behavioral of TB_Roundbuffer is
component TC_ClockManagement is
		port (
			nrst 		: IN STD_LOGIC;
			AXI_Clk 	: IN STD_LOGIC;
			HSCLKdif 	: IN STD_LOGIC;
			PLL_LOCKED 	: OUT STD_LOGIC;
			ClockBus 	: OUT T_ClockBus;
			Timecounter : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			Timestamp 	: OUT T_timestamp;	
			WLCLK 		: OUT STD_LOGIC;
			A_HSCLK_P 	: OUT STD_LOGIC;
			A_HSCLK_N 	: OUT STD_LOGIC;
			B_HSCLK_P 	: OUT STD_LOGIC;
			B_HSCLK_N 	: OUT STD_LOGIC

		);
	end component;

	component RoundBuffer is
		port(
			ClockBus        : in T_ClockBus;
			Timecounter     : in std_logic_vector(63 downto 0);
			Timestamp       : in T_timestamp;
			trigger         : in std_logic_vector(3 downto 0);   
			CtrlBus_IxSL    : in T_CtrlBus_IxSL; 
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
	end component;

	-- -------------------------------------------------------------
	-- Constant
	-- -------------------------------------------------------------
	--constant NBRWINDOWS : integer := 256;

	-- -------------------------------------------------------------
	-- SIGNALS
	-- -------------------------------------------------------------

	signal nrst :  std_logic;
	signal RST          :  std_logic;
	signal Refclk     : std_logic;

	signal trigger_sti : std_logic_vector(3 downto 0);
    -- Signals for simulation
    signal simulation_end_s : std_logic := '0';

	--signal 	triginfo_intl:	t_triginfobus(NBRWINDOWS-1 downto 0);

	signal CtrlBus_IxSL_intl : T_CtrlBus_OxMS_Intl;

	signal RDAD_READEn_sti : std_logic;
	signal RDAD_ReadEn_fromRDAD : std_logic;
	signal RDAD_DataOut_obs : std_logic_vector(8 downto 0);
	signal RDAD_Empty_obs:	std_logic;

	signal AXI_Time_DataOut_obs : std_logic_vector(63 downto 0);
	signal AXI_WdoAddr_DataOut_obs : std_logic_vector(8 downto 0);
	signal AXI_TrigInfo_DataOut_obs :std_logic_vector(11 downto 0);
	signal AXI_Spare_DataOut_obs : std_logic_vector(10 downto 0);

	signal DIG_Full_obs:	std_logic;
	signal DIG_DataIn_sti : std_logic_vector(8 downto 0);
	signal DIG_WriteEn_sti : std_logic;

--	constant CLK100MHz_PERIOD	: time := 10 ns;
	constant CLK125MHz_PERIOD	: time := 8 ns;
    constant reset_time         : time := 10 ns;

	signal ClockBus_intl:		T_ClockBus;
	signal timecounter_intl : std_logic_vector(63 downto 0);
	signal GrayTimeCnt_intl:	std_logic_vector(63 downto 0);
	signal timestamp_intl:		T_timestamp;
	signal hmb_trigger_intl: std_logic := '0' ;
	signal mode_intl: std_logic ;
	signal delay_trigger_intl:    std_logic_vector(3 downto 0):="0001";
	signal sstin_upd_intl: std_logic_vector(2 downto 0):= "011";

	--Variable for TB
--	file fd : text open WRITE_MODE is "/home/shivang/github/watchman-readout/6UVMEboard_Zynq/hw/sim/TB_RoundBufferElement_REPORT.txt";

begin
    nRST <= not RST;
    simple_startup_reset(RST, reset_time);
	clock_generator(Refclk,simulation_end_s, CLK125MHz_PERIOD);
	
	TC_ClockMgmt_inst : TC_ClockManagement
	port map(
		nrst 		=> nRST,
		AXI_Clk 	=> RefCLK,
		HSCLKdif 	=> '0',
		PLL_LOCKED 	=> open,
		ClockBus 	=> ClockBus_intl,
		Timecounter => timecounter_intl,
		Timestamp 	=> TimeStamp_intl,	
		WLCLK 		=> open,
		A_HSCLK_P 	=> open,
		A_HSCLK_N 	=> open,
		B_HSCLK_P 	=> open,
		B_HSCLK_N 	=> open
	);

	TC_RoundBuffer : RoundBuffer
		port map(
			ClockBus        => ClockBus_intl,
			Timecounter     => timecounter_intl,
			Timestamp       => TimeStamp_intl,
			trigger         => trigger_sti,   
			CtrlBus_IxSL    => CtrlBus_IxSL_intl, 
			--signals for the HMB roundbuffer
			hmb_trigger     => hmb_trigger_intl,
			mode            => mode_intl,
			delay_trigger   => delay_trigger_intl, 
			sstin_updateBit => sstin_upd_intl,  
			-- FIFO out for Reading RDAD
			RDAD_ReadEn     => RDAD_ReadEn_sti,
			RDAD_DataOut    => RDAD_DataOut_obs,
			RDAD_Empty      => RDAD_Empty_obs,
			-- FIFO IN for Digiting
			DIG_DataIn      => DIG_DataIn_sti,
			DIG_WriteEn     => DIG_WriteEn_sti,
			DIG_Full        => DIG_Full_obs,
			WR_R            => open,
			WR_C            => open,
			-- FIFO for FiFoManager
			AXI_ReadEn           => RDAD_ReadEn_sti,
			AXI_Time_DataOut     => AXI_Time_DataOut_obs,
			AXI_WdoAddr_DataOut  => AXI_WdoAddr_DataOut_obs,
			AXI_TrigInfo_DataOut => AXI_TrigInfo_DataOut_obs,
			AXI_Spare_DataOut    => AXI_Spare_DataOut_obs,
			AXI_Empty            => open,
			--Output For control
			RBNbrOfPackets       =>  open,
			address_is_zero_out  => open
		);

	

	RDADRead : Process
		variable L : Line;
	begin
		RDAD_READEn_sti <= '0';
		--wait until nrst = '1';
		loop
			--wait until empty_obs = '0';
			if RDAD_Empty_obs = '0' then

				wait until rising_Edge(ClockBus_intl.RDAD_CLK);
				RDAD_ReadEn_sti <= '1';
				wait until rising_Edge(ClockBus_intl.RDAD_CLK);
				RDAD_READEn_sti <= '0';
				wait until rising_Edge(ClockBus_intl.RDAD_CLK);

--				wait for 1 ns;
				--DIG back Process
				DIG_WriteEn_sti <= '0';

				DIG_DataIn_sti	<= RDAD_DataOut_obs;
				wait until rising_Edge(ClockBus_intl.WL_CLK);
				DIG_WriteEn_sti <= '1';
				wait until rising_Edge(ClockBus_intl.WL_CLK);
				DIG_WriteEn_sti <= '0';
				wait until rising_Edge(ClockBus_intl.WL_CLK);

			end if;
			wait for 10 ns;
		end loop;
	end process;

	tb : process
		variable test : integer	:= 0;
	begin
		simulation_end_s <= '0';
--		nrst <= '0';
		CtrlBus_IxSL_intl.SW_nRST <= '0';    
		CtrlBus_IxSL_intl.WindowStorage <= '0';    --> User mode will be active when this would go 1 --> 0 ( falling edge from PS)
        CtrlBus_IxSL_intl.CPUMode <= '0';

		wait for 20 ns;

		CtrlBus_IxSL_intl.SW_nRST <= '1';
		
		wait for 100 ns;
--		mode_intl <= '1';                 -- "trigger_mode" from PS
--		CtrlBus_IxSL_intl.CPUMode <= '1'; -- "CPUMODE ENable from PS [0 for usermode (cpu mode), 1 for trigger mode]
		
--		wait for 20 ns;
--		hmb_trigger_intl <= '1';    -- "PS_trigger" from PS
		
		wait for 1000 ns;
		
--		wait for 20 us;
		mode_intl <= '0';
		CtrlBus_IxSL_intl.CPUMode <= '0';
		wait for 1 us;

		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000000";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000001";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 1 us;
		
		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000001";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000001";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 5 us;
		
		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000002";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000001";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 1 us;

		wait for 20 us;
		CtrlBus_IxSL_intl.FSTWINDOW <= x"0000000A";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000003";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 1 us;
		
		
		wait for 20 us;
		report " Read window 0";
		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000000";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000001";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 1 us;
		wait for 20 us;
		report " Read window 1";
		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000001";
		CtrlBus_IxSL_intl.NBRWINDOW <= x"00000001";

		CtrlBus_IxSL_intl.WindowStorage <= '1';
		wait for 10 ns;
		CtrlBus_IxSL_intl.WindowStorage <= '0';
		wait for 1 us;

--		wait for 20 us;
--		report " Read window 5 with 10";
--		CtrlBus_IxSL_intl.FSTWINDOW <= x"00000005";
--		CtrlBus_IxSL_intl.NBRWINDOW <= x"0000000A";

--		CtrlBus_IxSL_intl.WindowStorage <= '1';
--		wait for 10 ns;
--		CtrlBus_IxSL_intl.WindowStorage <= '0';
--		wait for 1 us;

		
----- Trigger Mode		
		wait for 20 us;
		
		mode_intl <= '1';                 -- "trigger_mode" from PS
		CtrlBus_IxSL_intl.CPUMode <= '1'; -- "CPUMODE ENable from PS [0 for usermode (cpu mode), 1 for trigger mode]
		
		wait for 100 ns;
		hmb_trigger_intl <= '1';    -- "PS_trigger" from PS
		
		wait for 100 ns;
-------

		



    	
	end process;


end Behavioral;
