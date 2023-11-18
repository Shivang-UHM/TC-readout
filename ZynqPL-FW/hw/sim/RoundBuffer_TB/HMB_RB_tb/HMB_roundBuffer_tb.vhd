----------------------------------------------------------------------------------
-- Company: IDLAB, Hawaii
-- Engineer: Shivang Tripathi
-- 
-- Create Date: 10/23/2023
-- Design Name: 
-- Module Name: HMB_roundbuffer_tb 
-- Project Name: TC-Readout
-- Target Devices: 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.simulation_pkg.all;
use work.TARGETC_pkg.all;
use work.WindowCPU_pkg.all;

use std.env.finish;

entity HMB_roundbuffer_tb is
end HMB_roundbuffer_tb; 


architecture rtl of HMB_roundBuffer_tb is
    signal RST          :  std_logic;
    signal nRST         : std_logic;
	signal RefCLK       : std_logic;

    constant CLK125MHz_PERIOD	: time := 8 ns;
    constant reset_time         : time := 10 ns;

    signal simulation_end_s : std_logic := '0';
    signal ClockBus_intl:		T_ClockBus;
    signal timecounter_intl : std_logic_vector(63 downto 0);
    signal timestamp_intl:		T_timestamp;
    
    
    
    signal trigger : std_logic := '0';
    signal full_fifo : std_logic := '0';
    signal mode:    std_logic := '0';
    signal enable_write : std_logic;
    signal WR_RS : std_logic_vector(1 downto 0);
    signal WR_CS : std_logic_vector(5 downto 0);
    signal RD_add: std_logic_vector(8 downto 0);
    signal TriggerInfo: std_logic_vector(11 downto 0);
    signal delay_trigger: std_logic_vector(3 downto 0) :="0001";
    signal sstin_updateBit : std_logic_vector(2 downto 0):= "011";

begin
    nRST <= not RST;
    simple_startup_reset(RST, reset_time);
    clock_generator(Refclk,simulation_end_s, CLK125MHz_PERIOD);

    TC_ClockMgmt_inst : entity work.TC_ClockManagement
	port map(
		nrst		 => nRST,
		axi_clk		 => RefCLK,
        HSCLKdif	 => '0',
		PLL_LOCKED   => open,
		ClockBus	 => ClockBus_intl,
		timecounter	 => timecounter_intl,
		TimeStamp    => TimeStamp_intl,
		
		A_HSCLK_P 	 => open,
		A_HSCLK_N 	 => open,
		B_HSCLK_P    => open,
		B_HSCLK_N    => open,
		WLCLK        => open
	);
    
    HMB_RoundBuff: entity work.HMB_roundBuffer
    port map(
   
     clk            => 	 ClockBus_intl.CLK125MHz, 
     RST            => 	 nRST, 
     trigger        => 	 trigger, 
     full_fifo      => 	 full_fifo, 
     mode           => 	 mode, 
     enable_write   => 	 enable_write, 
     TriggerInfo    => 	 TriggerInfo , 
     RD_add         => 	 RD_add, 
     WR_RS          => 	 WR_RS, 
     WR_CS          => 	 WR_CS, 
     delay_trigger  => 	 delay_trigger, 
     sstin_updateBit=> 	 sstin_updateBit, 
     sstin_cntr     => 	 TimeStamp_intl.samplecnt
       
     );

     stimuli_process: process 
     begin
        wait for 102*CLK125MHz_PERIOD;
        mode    <= '1';

        wait for 102*CLK125MHz_PERIOD;
        wait for 10 ns;
        trigger <= '1';

        wait for 1*CLK125MHz_PERIOD;
        trigger <= '0';
        
        wait for 200*CLK125MHz_PERIOD;
        mode <= '0' ;
      
        wait for 100 * CLK125MHz_PERIOD;
        trigger<= '1';
        
        wait for 1 * CLK125MHz_PERIOD;
        trigger<= '0';
        
        wait;

        
     end process;
end architecture;

