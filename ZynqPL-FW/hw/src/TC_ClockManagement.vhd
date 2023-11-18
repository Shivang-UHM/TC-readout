
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TARGETC_pkg.ALL;

LIBRARY UNISIM;
USE unisim.vcomponents.ALL;

ENTITY TC_ClockManagement IS

	PORT (
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
END ENTITY;

ARCHITECTURE rtl OF TC_ClockManagement IS

	SIGNAL locked_intl : STD_LOGIC;
	SIGNAL SSTIN_intl : STD_LOGIC;
	SIGNAL rst : STD_LOGIC;
	SIGNAL Timecounter_intl : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL GrayCounter_intl : STD_LOGIC_VECTOR(59 DOWNTO 0);

	-- attribute mark_debug : string;
	-- attribute mark_debug of SSTIN_intl: signal is "true";

BEGIN

	rst <= NOT nrst;
	locked_intl <= '1';
	WLCLK <= AXI_CLK;

	TimeCnt_inst : ENTITY work.counter
		GENERIC MAP(
			NBITS => 64
		)
		PORT MAP
		(
			CLK => AXI_CLK,
			RST => nrst,
			Q => Timecounter_intl
		);

	GrayTime : ENTITY work.GRAY_ENCODER
		GENERIC MAP(
			NBITS => 60
		)
		PORT MAP(
			GRAY_OUT => GrayCounter_intl,
			BIN_IN => Timecounter_intl(63 DOWNTO 4)
		);

	-- Timestamp
	Timestamp.graycnt 	<= GrayCounter_intl;
	Timestamp.samplecnt <= Timecounter_intl(2 DOWNTO 0);

	TimeCounter <= Timecounter_intl;
	SSTIN_intl <= NOT Timecounter_intl(2);
	
	OBUFDF_HSCLK_A : OBUFDS
	GENERIC MAP(
		IOSTANDARD => "LVDS_25"
	)
	PORT MAP(
		O => A_HSCLK_P,
		OB => A_HSCLK_N,

		I => HSCLKdif
	);

	OBUFDF_HSCLK_B : OBUFDS
	GENERIC MAP(
		IOSTANDARD => "LVDS_25"
	)
	PORT MAP(
		O => B_HSCLK_P,
		OB => B_HSCLK_N,

		I => HSCLKdif
	);
	-- CLOCK BUS OUTPUTS
	ClockBus.SCLK 		<= AXI_CLK;
	ClockBus.HSCLK 		<= AXI_CLK;
	ClockBus.WL_CLK 	<= AXI_CLK;
	ClockBus.RDAD_CLK 	<= AXI_CLK;

	ClockBus.CLK125MHz 	<= AXI_CLK;
	ClockBus.SSTIN 		<= SSTIN_intl;
	ClockBus.AXI_CLK 	<= AXI_CLK;
	PLL_LOCKED 			<= locked_intl; -- signal to use in TARGETC_Control.vhd for registers
END ARCHITECTURE rtl;