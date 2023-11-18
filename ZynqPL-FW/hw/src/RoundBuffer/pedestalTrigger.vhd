----------------------------------------------------------------------------------
-- Company: IDLAB	
-- Engineer: Salvador Ventura
-- 
-- Create Date: 05/20/2020 10:02:21 PM
-- Design Name:  
-- Module Name: pedestalTrigger 
-- Project Name: WATCHMAN
-- Target Devices: MicroZed board
-- Tool Versions: 
-- Description:  Trigger signal to get pedestal arrays for the TARGETC in trigger mode.
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
 use ieee.numeric_std.all;

entity pedestalTrigger is
    Port ( 
    		clk : in STD_LOGIC;   
           rst : in STD_LOGIC;
           trigger : out STD_LOGIC;   --- output signal 
           mode : in STD_LOGIC;   -- Signal toggling USER MODE / TRIGGER MODE, 0 for USER MODE, 1 for TRIGGER MODE
           pedestals: in std_logic; -- Signal to start the pedestal acquisition
           average :  in std_logic_vector(31 downto 0); -- Number of averages
           wr_rs:  in std_logic_vector(1 downto 0); -- From RoundBuffer, to synchronize WR and state machine at window 0
           sstin : in std_logic_vector(2 downto 0)   -- signal for synchronization
           );
end pedestalTrigger;

architecture Behavioral of pedestalTrigger is
type stm_trigger_type is(
   IDLE,
   START,
    NEXT_ITERATION,
   TRIGGER_HIGH_0,
   TRIGGER_LOW_0,
   WAIT_0,
   RUN_NUMBER

   
);

signal stm_trigger : stm_trigger_type := IDLE;
signal cnt_period : std_logic_vector(14 downto 0); -- Counter to set a period between trigger rising edges
signal cnt_i : std_logic_vector(8 downto 0); -- Counter for triggers, the total number will be 512 for the four Runs, that means 1024 digitized windows 
signal cnt_wait0_i: std_logic_vector(4 downto 0); -- Wait between Runs 
signal trigger_i  : std_logic;  
signal reg1: std_logic; -- Rising edge detector for pedestal signal which starts the generation of triggers
signal reg2: std_logic; -- Rising edge detector for pedestal signal which starts the generation of triggers
signal edge_det_i : std_logic;  -- Rising edge detector for pedestal signal which starts the generation of triggers
signal cnt_iterations: std_logic_vector(31 downto 0); -- Counter for the number of averages
signal cnt_run: std_logic_vector(1 downto 0); -- Counting Runs, 4 in total, this number is used to decide the period, which is  different for every Run, due to the windows to be digitized. 
signal  wait_number_i: std_logic_vector(4 downto 0); -- 
signal cnt_wait_iterations:  std_logic_vector(26 downto 0);
signal first_trigger_flag: std_logic;
begin

p_edge_detector :  process(clk)
begin
        if rising_edge (clk) then
            reg1 <= pedestals;
            reg2 <= reg1;
        end if;
   
   
end process p_edge_detector;

edge_det_i <= reg1  and not (reg2);

p_sm:  process(clk,rst, mode ,sstin,pedestals, cnt_run)
  begin 
  
 if (rst = '0') or (mode='0') then
      stm_trigger <= IDLE;
      cnt_i <= (others=> '0');
      cnt_period<= "100110111111101";  -- . This is for  a freq~12.5 kHz, 1/ (9981*8ns). Due to RoundBuffer design, this number may vary few cycles for different Runs. 
      cnt_wait0_i <= (others=> '0');
            cnt_run <= (others=> '0');
            wait_number_i <=  (others=> '0');
    cnt_wait_iterations<= (others=> '0');
      trigger_i<='0';
      cnt_iterations<= (others =>'0');
      first_trigger_flag <='1';
  else 
      if rising_edge(clk) then
          case stm_trigger is
              when IDLE =>
                   if ( edge_det_i= '1')   then 
                       cnt_iterations<= (others =>'0');    
                       stm_trigger <= START;
                   else
                       stm_trigger<= IDLE;
                   end if;
               
               when START => -- Synchronization state to catch WR and SSTIN
                            if  (sstin="011")  and (wr_rs="00")  then          --         
                                       cnt_period<= "100110111111101";
                                       wait_number_i <= "01110";
                                       first_trigger_flag <='1';             
                                       stm_trigger <= WAIT_0;
                              else
                                      stm_trigger<= START;
                                 end if;
      when WAIT_0 =>
                           if cnt_wait0_i <= wait_number_i  then
                                  cnt_wait0_i <= std_logic_vector(unsigned(cnt_wait0_i) + 1);
                                  stm_trigger<= WAIT_0;
                             else
                                    if first_trigger_flag ='0' then 
                                           cnt_wait0_i<= (others=>'0') ; 
                                           stm_trigger <= RUN_NUMBER;
                                    else 
                                            first_trigger_flag <= '0';   
                                            cnt_wait0_i<= (others=>'0') ; 
                                           stm_trigger <= TRIGGER_HIGH_0;

                                    end if;         
                                               

                               end if;

              when TRIGGER_HIGH_0 =>  --- Trigger signal HIGH          
                      trigger_i <= '1';
                      stm_trigger<= TRIGGER_LOW_0;
                      
              when TRIGGER_LOW_0 =>   --- Trigger signal LOW      and wait for the next trigger    
					   trigger_i <= '0';
	                   if (cnt_period > x"0000" ) then
						  cnt_period <= std_logic_vector(unsigned(cnt_period) -1 );
						  stm_trigger <= TRIGGER_LOW_0;
					   else
						  stm_trigger <= RUN_NUMBER;
					   end if;


     when RUN_NUMBER =>  -- Each case corresponds to a Run over the store array, digitizing pairs of windows with each trigger
                        case cnt_run is
                        when "00" =>  -- First RUN over the storage array  windows: [ 0,1, 4, 5 ...]
                                    if (cnt_i < "001111111") then    -- First run ends after 128 triggers (one trigger per subBuffer, every subBuffer has 4 windows)
                                       cnt_i <= std_logic_vector(unsigned(cnt_i) + 1);
                                       cnt_period <= "100110111111101"; --  
                                       stm_trigger <= TRIGGER_HIGH_0;
                                   else
                                         cnt_run <=  std_logic_vector(unsigned(cnt_run) + 1);
                                       stm_trigger <= WAIT_0;
                                       cnt_period <= "100110111111101"; --  
                                       wait_number_i<="00001";
                                   end if;					  
			           when "01" =>           -- Second RUN over the storage array, windows:  [1,2, 5, 6...]
                                  if  (cnt_i  < "011111111" ) then   -- Second  run ends after 256 triggers
                                     cnt_i <= std_logic_vector(unsigned(cnt_i) + 1);
                                      cnt_period <= "100110111111101";  --  
                                      stm_trigger <= TRIGGER_HIGH_0;
                                  else
                                     stm_trigger <= WAIT_0;
                                     cnt_run <=  std_logic_vector(unsigned(cnt_run) + 1);
                                     cnt_period <= "100110111111101"; --
                                     wait_number_i<="00001";

                                   end if;
                      
                      when "10" =>           -- Third  RUN over the storage array, windows:  [2,3,6,7...]
                          if   (cnt_i  < "101111111" ) then  -- Second  run ends after 384  triggers
                              cnt_i <= std_logic_vector(unsigned(cnt_i) + 1);
                               cnt_period <= "100110111110101";--
                               stm_trigger <= TRIGGER_HIGH_0;
                       else
                              stm_trigger <= WAIT_0;
                               cnt_run <=  std_logic_vector(unsigned(cnt_run) + 1);
                               cnt_period <= "100110111110101";--
                                 wait_number_i<="00001";

                        end if;                      
                     
                     when "11" =>     --     Fourth  RUN over the storage array, windows:  [3,0,7,4,11,8...]
                           if   (cnt_i  <"111111111" ) then  -- Second  run ends after 511  triggers
                                 cnt_i <= std_logic_vector(unsigned(cnt_i) + 1);
                                 cnt_period <= "100110111110101";--9973
                                 stm_trigger <= TRIGGER_HIGH_0;
                             else
                               cnt_i<= (others=>'0') ; 
                                stm_trigger <=NEXT_ITERATION ;
                                cnt_iterations<=  std_logic_vector(unsigned(cnt_iterations) + 1);
                               cnt_run <=  std_logic_vector(unsigned(cnt_run) + 1);
                             end if;
                             
                       when others=> null;
                         end case; 
                         
                          when   NEXT_ITERATION =>  -- Wait between averages
                                if cnt_iterations <=average then 
                                      if cnt_wait_iterations < x"0989680" then -- 5e6
                                            cnt_wait_iterations <= std_logic_vector(unsigned(cnt_wait_iterations) + 1);
                                             stm_trigger<= NEXT_ITERATION;
                                      else 
                                              stm_trigger <= START;
                                              cnt_wait_iterations <=(others=>'0'); 
                                      end if;
                                else
                                     cnt_wait_iterations <=(others=>'0');
                                     stm_trigger<=IDLE;                                

                                     end if;          

         end case;     
              
     end if;
end if;
          
end process;



trigger<= trigger_i;

end Behavioral;
