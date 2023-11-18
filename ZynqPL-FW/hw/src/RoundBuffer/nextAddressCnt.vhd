-- -----------------------------------------------------------
--!@DESCRIPTION:
--! 8-bit address generator
--! A counter generates a 8-bit signal, nextAddress(7 downto 0) for cpuController
--! each new address must be delivered after a rising edge of a Ctrl signal
-- -----------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY nextAddressCnt IS
    GENERIC (
        NBITS : INTEGER := 8
    );
    PORT (
        CLK                 : IN STD_LOGIC;
        RST                 : IN STD_LOGIC; -- next address = 0
        Ctrl                : IN STD_LOGIC; -- the rising edge of this signal is used as a condition to generate/output the next address
        usrRst              : IN STD_LOGIC;
        nextAddress         : OUT STD_LOGIC_VECTOR(NBITS - 1 DOWNTO 0);
        nextAddressValid    : OUT STD_LOGIC;
        address_is_zero     : OUT STD_LOGIC
    );

END ENTITY;

ARCHITECTURE rtl OF nextAddressCnt IS

    SIGNAL cnt : STD_LOGIC_VECTOR(NBITS - 1 DOWNTO 0);
    SIGNAL reg1 : STD_LOGIC;
    SIGNAL reg2 : STD_LOGIC;
    SIGNAL edge_det : STD_LOGIC;
    SIGNAL reg3 : STD_LOGIC;
    SIGNAL reg4 : STD_LOGIC;
    SIGNAL keep_high : STD_LOGIC;
    SIGNAL edge_det_usrRst : STD_LOGIC;
    SIGNAL keep_high_counter : STD_LOGIC_VECTOR(3 DOWNTO 0);
    TYPE stm_kh IS (idle, high);
    SIGNAL stm_keep_high : stm_kh;
BEGIN
    p_edge_detector : PROCESS (clk)
    BEGIN
        IF rising_edge (clk) THEN
            reg1 <= Ctrl;
            reg2 <= reg1;
        END IF;

    END PROCESS p_edge_detector;

    edge_det <= reg1 AND NOT (reg2);

    p_edge_detector_usrRst : PROCESS (clk)
    BEGIN
        IF rising_edge (clk) THEN
            reg3 <= usrRst;
            reg4 <= reg3;

        END IF;

    END PROCESS p_edge_detector_usrRst;

    edge_det_usrRst <= NOT(reg3) AND (reg4);
    
    p_delay : PROCESS (clk, edge_det_usrRst, usrRst)
    BEGIN
        IF RST = '0' OR usrRst = '1' THEN
            stm_keep_high <= idle;
            keep_high_counter <= (OTHERS => '0');
            keep_high <= '0';
        ELSE
            IF rising_edge (clk) THEN

                CASE stm_keep_high IS

                    WHEN idle =>
                        IF edge_det_usrRst = '1' THEN
                            keep_high <= '1';
                            stm_keep_high <= high;

                        ELSIF edge_det_usrRst = '0' THEN
                            keep_high <= '0';
                            stm_keep_high <= idle;

                        END IF;

                    WHEN high =>
                        IF keep_high_counter < "1111" THEN
                            keep_high <= '1';
                            keep_high_counter <= STD_LOGIC_VECTOR(unsigned(keep_high_counter) + 1);
                        ELSE
                            keep_high_counter <= "1111";
                            keep_high <= '0';
                            stm_keep_high <= idle;
                        END IF;
                END CASE;

            END IF;
        END IF;
        --end if;
    END PROCESS p_delay;

    address_is_zero <= keep_high;

    p_counter : PROCESS (CLK, RST, usrRst)
    BEGIN
        IF RST = '0' OR edge_det_usrRst = '1' THEN
            cnt <= (OTHERS => '0');
            nextAddressValid <= '1';

        ELSE

            IF rising_edge(clk) THEN
                IF edge_det = '1' THEN
                    IF cnt < "11111111" THEN
                        cnt <= STD_LOGIC_VECTOR(unsigned(cnt) + 1);
                        nextAddressValid <= '1';
                    ELSE
                        cnt <= "11111111";
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS p_counter;

    nextAddress <= cnt;

END rtl;