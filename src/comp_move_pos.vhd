-- ***************************************************************************************
--		******  Copyright (c) 2008 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:COMP_MOVE_POS.vhd
-- Detail of Function	:generate X/Y data from Start/END
-- Ver					:001									-- <<<<<< Check Version --
-- Date					:080630
-- Created by			:Y.NISHIO
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- [2008/06/30 : 001]
--  ・新規作成
--**************************************************************************************--

LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--  Entity Declaration

ENTITY COMP_MOVE_POS IS
	PORT
	(
		Reset		: IN STD_LOGIC;								
		SYS_CLK		: IN STD_LOGIC;							--20MHz	
		MOVE_CLK	: IN STD_LOGIC;							--800KHz
		MOVE_ENABLE	: IN STD_LOGIC;							--1:ON  0:OFF
		MOVE_START_X	: IN STD_LOGIC_VECTOR(11 downto 0);	-- スタートX座標
		MOVE_START_Y	: IN STD_LOGIC_VECTOR(11 downto 0);	-- スタートY座標
		MOVE_END_X	: IN STD_LOGIC_VECTOR(11 downto 0);		-- エンドX座標
		MOVE_END_Y	: IN STD_LOGIC_VECTOR(11 downto 0);		-- エンドY座標
		X_DATA		: OUT STD_LOGIC_VECTOR(11 downto 0);			-- X座標出力
		Y_DATA		: OUT STD_LOGIC_VECTOR(11 downto 0);			-- Y座標出力
		END_FLAG	: OUT STD_LOGIC
	);
END COMP_MOVE_POS;


ARCHITECTURE RTL OF COMP_MOVE_POS IS

	TYPE STATE_TYPE is ( MOVE_INI,
						 MOVE_SET_UP,
						 MOVE_RUN,
						 MOVE_END
						 );
	
	signal CURRENT_STATE	:STATE_TYPE;
	
	constant const_Galv_center_X	: std_logic_vector(11 downto 0) := "011111111111";	-- 2047 --
	constant const_Galv_center_Y	: std_logic_vector(11 downto 0) := "011111111111";	-- 2047 --
	
	signal sig_Start_X : std_logic_vector(11 downto 0);
	signal sig_Start_Y : std_logic_vector(11 downto 0);
	signal sig_End_X : std_logic_vector(11 downto 0);
	signal sig_End_Y : std_logic_vector(11 downto 0);
	signal sig_X_down  : std_logic;
	signal sig_Y_down  : std_logic;
	signal cnt_X_Dist : std_logic_vector(11 downto 0);
	signal cnt_Y_Dist : std_logic_vector(11 downto 0);
	
	signal sig_X_DATA_OUT : std_logic_vector(11 downto 0);
	signal sig_Y_DATA_OUT : std_logic_vector(11 downto 0);
	signal sig_X_END : std_logic;
	signal sig_Y_END : std_logic;
	signal sig_SET_UP_X_END : std_logic;
	signal sig_SET_UP_Y_END : std_logic;
	
	
	
	
begin

--**************************************************************************************--
--********************	STATE Machine						****************************--
--**************************************************************************************--
U_STATE_MACHINE:process(Reset,MOVE_ENABLE,SYS_CLK) begin 
	if(Reset='1' or MOVE_ENABLE ='0') then
		CURRENT_STATE <= MOVE_INI;
	elsif(SYS_CLK'event and SYS_CLK='1') then
		case CURRENT_STATE is
			when MOVE_INI =>								
				if(MOVE_ENABLE = '1') then
					CURRENT_STATE <= MOVE_SET_UP;
				else
					CURRENT_STATE <= MOVE_INI;
				end if;
			when MOVE_SET_UP =>								
				if(sig_SET_UP_X_END = '1' and sig_SET_UP_Y_END = '1') then
					CURRENT_STATE <= MOVE_RUN;
				else
					CURRENT_STATE <= MOVE_SET_UP;
				end if;
			when MOVE_RUN =>								
				if(sig_X_END = '1' and sig_Y_END = '1') then
					CURRENT_STATE <= MOVE_END;
				else
					CURRENT_STATE <= MOVE_RUN;
				end if;
			when MOVE_END =>
				CURRENT_STATE <= MOVE_END;
			when others	=>
		end case;
	end if;
end process;

--##### sig_Start_X #####
--スタート・エンドX座標取得
U_Set_XY : process(Reset,SYS_CLK) begin
	if(Reset = '1') then
		sig_Start_X <= (others => '0');
		sig_Start_Y <= (others => '0');
		sig_End_X   <= (others => '0');
		sig_End_Y   <= (others => '0');
	elsif(SYS_CLK'event and SYS_CLK = '1') then
		if(CURRENT_STATE = MOVE_INI) then
			sig_Start_X <= MOVE_START_X;
			sig_Start_Y <= MOVE_START_Y;
			sig_End_X <= MOVE_End_X;
			sig_End_Y <= MOVE_End_Y;
		end if;
	end if;
end process;


------------------------------------------------------------------------------------------
-- UP/DOWN 
------------------------------------------------------------------------------------------
--##### sig_X_down #####
--スタート・エンドX座標より増加するのか減少するのか判断
U_X_down : process(Reset,CURRENT_STATE,SYS_CLK) begin
	if(Reset = '1' or CURRENT_STATE = MOVE_INI) then
		sig_X_down <= '0';
		sig_SET_UP_X_END <= '0';
	elsif(SYS_CLK'event and SYS_CLK = '1') then
		if(CURRENT_STATE = MOVE_SET_UP) then
			if(MOVE_START_X > MOVE_END_X) then
				sig_X_down <= '1';			--set X-down mode
			else
				sig_X_down <= '0';
			end if;
				sig_SET_UP_X_END <= '1';
		end if;
	end if;
end process;

--##### sig_Y_down #####
--スタート・エンドY座標より増加するのか減少するのか判断
U_Y_down : process(Reset,CURRENT_STATE,SYS_CLK) begin
	if(Reset = '1'or CURRENT_STATE = MOVE_INI) then
		sig_Y_down <= '0';
		sig_SET_UP_Y_END <= '0';
	elsif(SYS_CLK'event and SYS_CLK = '1') then
		if(CURRENT_STATE = MOVE_SET_UP) then
			if(MOVE_START_Y > MOVE_END_Y) then
				sig_Y_down <= '1';			--set Y-down mode
			else
				sig_Y_down <= '0';
			end if;
				sig_SET_UP_Y_END <= '1';
		end if;
	end if;
end process;


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--XY_UP/DOWN_COUNTER
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
U_X_COUNTER : process(Reset,CURRENT_STATE,MOVE_CLK) begin
	if(Reset='1' or CURRENT_STATE = MOVE_INI) then
		cnt_X_Dist <= (others=>'0');
	elsif(MOVE_CLK'event and MOVE_CLK='1') then
		if(CURRENT_STATE = MOVE_RUN and sig_X_END = '0') then
			cnt_X_Dist <= cnt_X_Dist + 1;
		end if;
	end if;
end process;

U_Y_COUNTER : process(Reset,CURRENT_STATE,MOVE_CLK) begin
	if(Reset='1' or CURRENT_STATE = MOVE_INI) then
		cnt_Y_Dist <= (others=>'0');
	elsif(MOVE_CLK'event and MOVE_CLK='1') then
		if(CURRENT_STATE = MOVE_RUN and sig_Y_END = '0') then
			cnt_Y_Dist <= cnt_Y_Dist + 1;
		end if;
	end if;
end process;



sig_X_DATA_OUT <= (sig_Start_X - cnt_X_Dist) when sig_X_down = '1' else (sig_Start_X + cnt_X_Dist);
sig_Y_DATA_OUT <= (sig_Start_Y - cnt_Y_Dist) when sig_Y_down = '1' else (sig_Start_Y + cnt_Y_Dist);



sig_X_END <= '1' when sig_X_DATA_OUT = sig_End_X else '0';

sig_Y_END <= '1' when sig_Y_DATA_OUT = sig_End_Y else '0';

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--OUT_PUT
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--##### sig_X_DATA_OUT #####
--##### sig_Y_DATA_OUT #####
U_XY_DATA_OUT : process(Reset,SYS_CLK) begin
	if(Reset='1') then
		X_DATA <= const_Galv_center_X;
		Y_DATA <= const_Galv_center_Y;
	else
		case CURRENT_STATE is
			when MOVE_INI =>
				X_DATA <= sig_Start_X;
				Y_DATA <= sig_Start_Y;
			when MOVE_SET_UP =>	
				X_DATA <= sig_Start_X;
				Y_DATA <= sig_Start_Y;
			when MOVE_RUN =>			
				X_DATA <= sig_X_DATA_OUT;
				Y_DATA <= sig_Y_DATA_OUT;
			when MOVE_END =>			
				X_DATA <= sig_X_DATA_OUT;
				Y_DATA <= sig_Y_DATA_OUT;
			when others	=>				
				X_DATA <= (others => 'X');
				Y_DATA <= (others => 'X');
		end case;
	end if;
end process;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--OUT_PUT_END_FLAG
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
END_FLAG <= '1' when CURRENT_STATE = MOVE_END else '0';

end RTL;
