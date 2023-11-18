LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Data2AxiStream IS
    GENERIC (
        -- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
        C_M_AXIS_TDATA_WIDTH : INTEGER := 32;
        NBRWINDOW_MAX : INTEGER := 8;
        FIFO_NBR_MAX : INTEGER := 1030 --518+512
    );
    PORT (
        -- Users to add ports here
        SW_nRST : IN STD_LOGIC;
        TestStream : IN STD_LOGIC;

        FIFOvalid : IN STD_LOGIC;
        FIFOdata : IN STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 DOWNTO 0);
        StreamReady : OUT STD_LOGIC;

        Cnt_AXIS_DATA : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        CNT_CLR : IN STD_LOGIC;
        TID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        -- User ports ends
        -- Do not modify the ports beyond this line

        -- NBRWINDOW
        --	NBRWINDOW:		in std_logic_vector(31 downto 0);

        -- Global ports
        M_AXIS_ACLK : IN STD_LOGIC;
        M_AXIS_ARESETN : IN STD_LOGIC;
        M_AXIS_TVALID : OUT STD_LOGIC;
        M_AXIS_TDATA : OUT STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 DOWNTO 0);
        M_AXIS_TSTRB : OUT STD_LOGIC_VECTOR((C_M_AXIS_TDATA_WIDTH/8) - 1 DOWNTO 0);
        M_AXIS_TDEST : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        M_AXIS_TLAST : OUT STD_LOGIC;
        M_AXIS_TID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        M_AXIS_TREADY : IN STD_LOGIC
    );

END ENTITY;

ARCHITECTURE implementation OF Data2AxiStream IS
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;

    ATTRIBUTE X_INTERFACE_PARAMETER OF M_AXIS_ACLK:     SIGNAL IS "ASSOCIATED_RESET M_AXIS_ARESETN, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000";
    ATTRIBUTE X_INTERFACE_INFO      OF M_AXIS_ACLK:     SIGNAL IS "xilinx.com:signal:clock:1.0 M_AXIS_ACLK CLK";



    -- In this example, Depth of FIFO is determined by the greater of
    -- the number of input words and output words.
    --	constant depth : integer := 2048;

    -- bit_num gives the minimum number of bits needed to address 'depth' size of FIFO
    --	constant bit_num : integer := clogb2(depth);

    -- Define the states of state machine
    -- The control state machine oversees the writing of input streaming data to the FIFO,
    -- and outputs the streaming data from the FIFO
    TYPE state IS (IDLE,
        DATA_STREAM,
        DATA_STREAM_STALL,

        START_TEST_STREAM,
        SEND_TEST_STREAM);
    -- State variable
    SIGNAL mst_exec_state : state;
    -- Example design FIFO read pointer
    --signal cnt_stream_out : integer range 0 to bit_num-1;
    SIGNAL cnt_stream_out : INTEGER;
    SIGNAL cnt_window : INTEGER;

    -- AXI Stream internal signals
    --streaming data valid
    SIGNAL axis_tvalid : STD_LOGIC;
    --streaming data valid delayed by one clock cycle
    SIGNAL axis_tvalid_delay : STD_LOGIC;
    --Last of the streaming data
    SIGNAL axis_tlast : STD_LOGIC;
    --Last of the streaming data delayed by one clock cycle
    SIGNAL axis_tlast_delay : STD_LOGIC;
    --FIFO implementation signals
    SIGNAL M_AXIS_TDATA_intl : STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 DOWNTO 0);
    SIGNAL M_AXIS_TDATA_last : STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 DOWNTO 0);

    SIGNAL tx_en : STD_LOGIC;
    SIGNAL tx_state : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '1');
    SIGNAL StreamReady_intl : STD_LOGIC := '0';
    SIGNAL TDI_intl : STD_LOGIC_VECTOR(1 DOWNTO 0);

    --	signal nbr_of_packets_s : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    --	signal content_packet_s : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);

BEGIN
    -- I/O Connections assignments

    M_AXIS_TVALID <= axis_tvalid_delay;

    M_AXIS_TLAST <= axis_tlast_delay;
    M_AXIS_TSTRB <= (OTHERS => '1');
    M_AXIS_TID <= TID;

    -- Control state machine implementation
    PROCESS (M_AXIS_ACLK)
    BEGIN
        IF (rising_edge (M_AXIS_ACLK)) THEN
            IF (M_AXIS_ARESETN = '0' OR SW_nRST = '0') THEN
                -- Synchronous reset (active low)
                mst_exec_state <= IDLE;

                M_AXIS_TDATA_intl <= (OTHERS => '0');
                M_AXIS_TDATA_last <= (OTHERS => '0');
                cnt_stream_out <= 0;
                cnt_window <= 0;
            ELSE
                CASE (mst_exec_state) IS
                    WHEN IDLE =>
                        -- The slave starts accepting tdata when
                        -- there tvalid is asserted to mark the
                        -- presence of valid streaming data
                        --if (count = "0")then

                        IF (TestStream = '1') THEN
                            --if((S_START_STREAMING = '1') and (unsigned(S_NBR_PACKETS) /= 0)) then
                            StreamReady_intl <= '0';
                            mst_exec_state <= START_TEST_STREAM;

                            cnt_stream_out <= 0;

                        ELSE
                            mst_exec_state <= IDLE;
                        END IF;

                        StreamReady_intl <= '1';

                        IF (FIFOvalid = '1') THEN
                            mst_exec_state <= DATA_STREAM;
                            M_AXIS_TDATA_intl <= FIFOdata;
                            M_AXIS_TDATA_last <= FIFOData;
                            cnt_stream_out <= 0;

                            --cnt_stream_out <= 0;
                            cnt_window <= 0;
                        END IF;

                        IF CNT_CLR = '1' THEN
                            cnt_stream_out <= 0;
                            cnt_window <= 0;
                        END IF;
                        -- TEST Transmission
                    WHEN START_TEST_STREAM =>
                        IF (tx_en = '1') THEN
                            cnt_stream_out <= cnt_stream_out + 1;
                            mst_exec_state <= SEND_TEST_STREAM;
                            --M_AXIS_TDATA_intl <= std_logic_vector(to_unsigned(cnt_stream_out+cnt_stream_out,M_AXIS_TDATA_intl'length));
                            M_AXIS_TDATA_intl <= STD_LOGIC_VECTOR(to_unsigned(cnt_stream_out, M_AXIS_TDATA_intl'length));

                        END IF;

                    WHEN SEND_TEST_STREAM =>
                        -- The example design streaming master functionality starts
                        -- when the master drives output tdata from the FIFO and the slave
                        -- has finished storing the S_AXIS_TDATA
                        IF (cnt_stream_out < FIFO_NBR_MAX) THEN
                            IF (tx_en = '1') THEN
                                -- read pointer is incremented after every read from the FIFO
                                -- when FIFO read signal is enabled.
                                --M_AXIS_TDATA_intl <= std_logic_vector(to_unsigned(cnt_stream_out+cnt_stream_out,M_AXIS_TDATA_intl'length));
                                M_AXIS_TDATA_intl <= STD_LOGIC_VECTOR(to_unsigned(cnt_stream_out, M_AXIS_TDATA_intl'length));

                                cnt_stream_out <= cnt_stream_out + 1;

                            END IF;
                        ELSE
                            cnt_stream_out <= 0;
                            cnt_window <= 0;
                            mst_exec_state <= IDLE;
                        END IF;

                        -- DATA Transmission
                    WHEN DATA_STREAM =>
                        -- The example design streaming master functionality starts
                        -- when the master drives output tdata from the FIFO and the slave
                        -- has finished storing the S_AXIS_TDATA

                        IF (cnt_stream_out < FIFO_NBR_MAX) THEN
                            IF (tx_en = '1') THEN
                                StreamReady_intl <= '1';
                                -- read pointer is incremented after every read from the FIFO
                                -- when FIFO read signal is enabled.
                                cnt_stream_out <= cnt_stream_out + 1;
                                M_AXIS_TDATA_intl <= FIFOdata;
                                M_AXIS_TDATA_last <= FIFOData;
                                mst_exec_state <= DATA_STREAM;
                            ELSE
                                M_AXIS_TDATA_last <= FIFOdata;
                                mst_exec_state <= DATA_STREAM_STALL;
                            END IF;
                        ELSE
                            -- Check the number of windows sent for LAST signal
                            --					if (cnt_window < to_integer(unsigned(NBRWINDOW)-1)) then
                            --						cnt_window <= cnt_window + 1;
                            --						StreamReady_intl <= '0';
                            --						cnt_stream_out <= 0;
                            --						mst_exec_state <= IDLE;
                            --					else
                            -- tx_done is asserted when NUMBER_OF_OUTPUT_WORDS numbers of streaming data
                            -- has been out.
                            StreamReady_intl <= '0';
                            --cnt_stream_out <= 0;
                            cnt_window <= 0;
                            mst_exec_state <= IDLE;
                            --end if;
                        END IF;
                    WHEN DATA_STREAM_STALL =>
                        IF (tx_en = '1') THEN
                            cnt_stream_out <= cnt_stream_out + 1;
                            mst_exec_state <= DATA_STREAM;
                        ELSE
                            mst_exec_state <= DATA_STREAM_STALL;
                        END IF;
                    WHEN OTHERS =>
                        mst_exec_state <= IDLE;

                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- DATAOUT
    --M_AXIS_TDATA	<= M_AXIS_TDATA_intl;

    PROCESS (M_AXIS_ACLK)
    BEGIN
        IF rising_edge(M_AXIS_ACLK) THEN
            tx_state <= tx_state(0) & tx_en;
            --			case tx_state is
            --				when "00" =>
            --					M_AXIS_TDATA <= M_AXIS_TDATA_intl;
            --				when "01" =>
            --					M_AXIS_TDATA <= M_AXIS_TDATA_last;
            --				when "11" =>
            --					M_AXIS_TDATA <= M_AXIS_TDATA_intl;
            --				when "10" =>
            --					M_AXIS_TDATA <= M_AXIS_TDATA_intl;
            --				when others =>
            --					M_AXIS_TDATA <= (others => '0');
            --			end case;
        END IF;
    END PROCESS;

    M_AXIS_TDATA <= M_AXIS_TDATA_intl WHEN (mst_exec_state = START_TEST_STREAM) OR (mst_exec_state = SEND_TEST_STREAM) ELSE
        M_AXIS_TDATA_intl WHEN tx_state = "00" ELSE
        M_AXIS_TDATA_last WHEN tx_state = "01" ELSE
        M_AXIS_TDATA_intl WHEN tx_state = "11" ELSE
        M_AXIS_TDATA_last WHEN tx_state = "10" ELSE
        (OTHERS => '0');

    --tvalid generation
    --axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
    --number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
    axis_tvalid <= '1' WHEN (((mst_exec_state = DATA_STREAM) OR (mst_exec_state = DATA_STREAM_STALL) OR (mst_exec_state = START_TEST_STREAM) OR (mst_exec_state = SEND_TEST_STREAM)) AND (cnt_stream_out < FIFO_NBR_MAX)) ELSE
        '0';

    -- AXI tlast generation
    -- axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1
    -- (0 to NUMBER_OF_OUTPUT_WORDS-1)
    --axis_tlast <= '1' when (cnt_stream_out = FIFO_NBR_MAX-1) else '0';
    axis_tlast <= '1' WHEN (cnt_stream_out = FIFO_NBR_MAX - 1) ELSE
        '0';
    --axis_tlast <= '1' when ((cnt_stream_out = FIFO_NBR_MAX-1) and (cnt_window >= to_integer(unsigned(NBRWINDOW)-1))) else '0';

    -- Delay the axis_tvalid and axis_tlast signal by one clock cycle
    -- to match the latency of M_AXIS_TDATA
    PROCESS (M_AXIS_ACLK)
    BEGIN
        IF (rising_edge (M_AXIS_ACLK)) THEN
            IF (M_AXIS_ARESETN = '0' OR SW_nRST = '0') THEN
                axis_tvalid_delay <= '0';
                axis_tlast_delay <= '0';
            ELSE
                axis_tvalid_delay <= axis_tvalid;
                axis_tlast_delay <= axis_tlast;
            END IF;
        END IF;
    END PROCESS;

    -- process(M_AXIS_ACLK,nDCLR)
    -- begin
    -- 	if nDCLR = '1' then
    -- 		AXIS_Error <= (others => '0');
    -- 	else
    -- 		if (rising_edge (M_AXIS_ACLK)) then
    -- 			last_mst_exec_state <= mst_exec_state;
    -- 		    if((last_mst_exec_state = DATA_STREAM or last_mst_exec_state = SEND_TEST_STREAM) and mst_exec_state = IDLE) then
    Cnt_AXIS_DATA <= STD_LOGIC_VECTOR(to_unsigned(cnt_stream_out, 10));
    --FIFO read enable generation

    tx_en <= M_AXIS_TREADY AND axis_tvalid;
    --StreamReady <= tx_en when StreamReady_intl = '1' else '0';
    StreamReady <= StreamReady_intl WHEN mst_exec_state = IDLE ELSE
        tx_en WHEN mst_exec_state = DATA_STREAM OR mst_exec_state = DATA_STREAM_STALL ELSE
        '0';

    -- FIFO Implementation

    -- Streaming output data is read from FIFO
    -- Add user logic here

    -- User logic ends

END implementation;