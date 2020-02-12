---**************************************************************************************--
--********************	Library declaration part			****************************--
--**************************************************************************************--
LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	ENTITY declaration part				****************************--
--**************************************************************************************--
ENTITY GAL_CON IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		FPGAclk			: IN STD_LOGIC;		--20MHz
		Reset			: IN STD_LOGIC;
		Mode_sel		: IN STD_LOGIC_VECTOR(3 downto 0);
		Freq_Sel		: IN STD_LOGIC_VECTOR(7 downto 0);
--		Scan_Range		: IN STD_LOGIC;		-- 0=6.0mm ,1=8.2mm		--20090323YN
		Start_X			: IN STD_LOGIC_VECTOR(11 downto 0);
		Start_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
		End_X			: IN STD_LOGIC_VECTOR(11 downto 0);
		End_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
		Circle_R		: IN STD_LOGIC_VECTOR(11 downto 0);
--		Live_Start_X	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--		Live_Start_Y	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--		Live_End_X		: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--		Live_End_Y		: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--		Live_Circle_R	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--		L_R				: IN STD_LOGIC;
		Galv_run		: IN STD_LOGIC;
--		CAP_START		: IN STD_LOGIC;
--		Live_Resol		: IN STD_LOGIC_VECTOR(11 downto 0);
		Resolution		: IN STD_LOGIC_VECTOR(11 downto 0);
--		Dummy_Fram_Num	: IN STD_LOGIC_VECTOR(2 downto 0);
--		Resol_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
		--3D-Scanスキャン方向／順序指定		00:H,01:V,10:H->V,11:V->H
--		V_H_3D			: IN STD_LOGIC_VECTOR(1 downto 0);
--		C_Scan_Back_Num : IN STD_LOGIC_VECTOR(1 downto 0);
--		C_Scan_Back_Num : IN STD_LOGIC_VECTOR(3 downto 0);		--20081017TS
--		Radial_Scan_Num : IN STD_LOGIC_VECTOR(3 downto 0);		--20070330TS
--		Circle_Total_Num	: IN STD_LOGIC_VECTOR(5 downto 0);		--20080508YN
--		START_3D		: IN STD_LOGIC;
--		Web_Radial_R	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--		Web_Circle_R_Step	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--		Web_Live_Sel	: IN STD_LOGIC;		--0:Circle_Live 1:Line_Live		--20070329TS
--		Raster_Scan_Num	: IN STD_LOGIC_VECTOR(8 downto 0);		--20070404TS
--		Raster_Scan_Step	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070404TS
		Circle_Direction	: IN STD_LOGIC;		--20070329TS
--		SLD_ON_OFF		: IN STD_LOGIC;		--1:ON 0:OFF		--20070329TS
--		PULSE_ON_OFF	: IN STD_LOGIC;		--1:PULSE 0:C/W		--20070329TS
--		PULSE_Width		: IN STD_LOGIC_VECTOR(9 downto 0);		--20070830YN
--		SLD_Delay		: IN STD_LOGIC_VECTOR(9 downto 0);
		Adjust_Mode		: IN STD_LOGIC;		--1:Adjust_Mode 0:Normal_Mode		--20090421YN
--		PULSE_Mode		: IN STD_LOGIC;		--1:MEASURE 0:NORMAL		--20070902YN
--		SLD_M_Pos		: IN STD_LOGIC_VECTOR(3 downto 0);		--20090206YN
		GalvX_Adjust	: IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
		GalvY_Adjust	: IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
--		Custom_Scan_On	: IN STD_LOGIC;		--1=Custom Scan 0=Normal		--20081023TS
--		GalvX_Gain_Data	: IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--		GalvY_Gain_Data	: IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--		GalvX_Gain_Data_B	: IN STD_LOGIC_VECTOR(7 downto 0); --★★ 
--		GalvY_Gain_Data_B	: IN STD_LOGIC_VECTOR(7 downto 0);
--		cstm_LiveScanNOW_Flag	: IN STD_LOGIC;		--20090326YN_1
--		cstm_cnt_Live	: IN STD_LOGIC_VECTOR(3 downto 0);		--20090326YN_1
--		RetryFlag1_ON_OFF	: IN STD_LOGIC;		--20090326YN_1
--		RetryFlag2_ON_OFF	: IN STD_LOGIC;		--20090326YN_1
--		LiveBRetry1			: IN STD_LOGIC;
--		LiveBRetry2			: IN STD_LOGIC;
		cstm_param_en		: IN STD_LOGIC;		--20091006MN		--20091119YN
--		CSTM_LIVE_B_F_CNT	: IN STD_LOGIC_VECTOR(11 downto 0);
--		CSTM_LIVE_B_ENABLE	: IN STD_LOGIC;
--		CSTM_LIVE_B_ONOFF	: IN STD_LOGIC;
		V_END_WAIT_CNT		: IN STD_LOGIC_VECTOR(12 downto 0);
		RAM_CONST_DATA		: IN STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_ADR		: IN STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_DATA_EN	: IN STD_LOGIC		;
		BOTH_WAY_SCAN		: IN STD_LOGIC;
		BOTH_WAY_WAIT_TIME	: IN STD_LOGIC_VECTOR( 15 downto 0);
		OVER_SCAN			: IN STD_LOGIC;
		OVER_SCAN_NUM		: IN STD_LOGIC_VECTOR(7 downto 0);
--		OVER_SCAN_DLY_TIME	: IN STD_LOGIC_VECTOR( 15 downto 0);
		GALV_TIMING_ADJ_EN	: IN STD_LOGIC;
		GALV_TIMING_ADJ_T3	: IN STD_LOGIC_VECTOR(15 downto 0);
		GALV_TIMING_ADJ_T4	: IN STD_LOGIC_VECTOR(15 downto 0);
		GALV_TIMING_ADJ_T5	: IN STD_LOGIC_VECTOR(15 downto 0);
		HSYNC_END			: IN STD_LOGIC;
		HSYNC				: IN STD_LOGIC;
		SLD					: IN STD_LOGIC;
--		vh_sync_period		: IN STD_LOGIC_VECTOR(12 downto 0);
	--------------------------------------------------------------------------------------
		HSYNC_T				: OUT STD_LOGIC_VECTOR(11 downto 0);
		X_galv				: OUT STD_LOGIC_VECTOR(11 downto 0);
		Y_galv				: OUT STD_LOGIC_VECTOR(11 downto 0);
--		Hsync_out			: OUT STD_LOGIC;
--		Vsync_out			: OUT STD_LOGIC;
--		TRIG				: OUT STD_LOGIC;
--		Busy_out			: OUT STD_LOGIC;
--		V_End_Flag_OUT		: OUT STD_LOGIC;		-- 1:end		--20070329TS
--		SLD_out				: OUT STD_LOGIC;		--20070329TS
--		BackScan_Busy_out	: OUT STD_LOGIC;		--20081017TS
		CSTM_MOVE_END_out	: OUT STD_LOGIC;		--20081031TS
--		RetryFlag1_OUT		: OUT STD_LOGIC;		--20090326YN_1
--		RetryFlag2_OUT		: OUT STD_LOGIC;		--20090326YN_1
--		SLD_Gen_EN			: OUT STD_LOGIC;		--20090903MN
--		Inter_Reset			: OUT STD_LOGIC;
		VH_GEN_EN_OUT		: OUT STD_LOGIC;
		HSYNC_NUM_OUT		: OUT STD_LOGIC_VECTOR(12 downto 0)
		
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END GAL_CON;												

--**************************************************************************************--
--********************	ARCHITECTURE Body					****************************--
--**************************************************************************************--
ARCHITECTURE GAL_CON_architecture OF GAL_CON IS

--**************************************************************************************--
--********************	Component definition part			****************************--
--**************************************************************************************--
-- ============================================================
-- File Name: alt_divide_25_13.vhd
-- Megafunction Name(s): lpm_divide
-- ============================================================
	COMPONENT alt_divide_25_13 is
	PORT
	(
		clock		: IN STD_LOGIC ;
		denom		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (24 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (24 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
	);
	END COMPONENT;

------------------------------------------------------------------------------------------
-- ============================================================
-- File Name: alt_dp_ram_bscan.vhd
-- Megafunction Name(s): altsyncram
-- ============================================================
	COMPONENT alt_dp_ram_bscan is
	PORT
	(
 		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		wrclock		: IN STD_LOGIC;
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

------------------------------------------------------------------------------------------
	component comp_sin_cos_xy is
	port
	(
		fpgaclk				: in std_logic;
		reset				: in std_logic;
		Gal_clk_fall_edge	: in std_logic;
		RAM_CONST_DATA 		: IN STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_ADR  		: IN STD_LOGIC_VECTOR(15 downto 0);
		COS_TABLE_EN		: IN STD_LOGIC;
		SIN_TABLE_EN		: IN STD_LOGIC;
		rdaddress			: in std_logic_vector(11 downto 0);		-- 0 - 4095
		circle_r			: in std_logic_vector(11 downto 0);
		start_x				: in std_logic_vector(11 downto 0);
		start_y				: in std_logic_vector(11 downto 0);
--		romclk				: in std_logic;
		rom_en				: in std_logic;
--		l_r					: in std_logic;
		x_data				: out std_logic_vector(11 downto 0);
		y_data				: out std_logic_vector(11 downto 0)
	);
	end component;

------------------------------------------------------------------------------------------
-- ============================================================
-- File Name: alt_divide_16_9.vhd
-- Megafunction Name(s): lpm_divide
-- ============================================================
	COMPONENT alt_divide_16_9 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		denom		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
	END COMPONENT;

------------------------------------------------------------------------------------------
--	COMPONENT alt_rom_gain IS
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		clock		: IN STD_LOGIC  := '1';
--		rden		: IN STD_LOGIC  := '1';
--		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--	);
--	END COMPONENT;
------------------------------------------------------------------------------------------
--	COMPONENT alt_ram_gain IS
--	PORT
--	(
--		clock		: IN STD_LOGIC;
--		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
--		rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		wren		: IN STD_LOGIC;
--		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--	);
--	END COMPONENT;

------------------------------------------------------------------------------------------
--	COMPONENT comp_VHsync_gen IS			--20070404TS
--	PORT
--	(
--		Reset			: IN STD_LOGIC;
--		FPGAclk			: IN STD_LOGIC;		--20MHz
--		Gal_clk			: IN STD_LOGIC;		--ガルバノ出力CLK
--		Hsync_T			: IN STD_LOGIC_VECTOR(16 downto 0);		--Hsync周期
--		VH_Gen_EN		: IN STD_LOGIC;		--コンポーネントイネーブル
--		TRIG_EN			: IN STD_LOGIC;		--TRIG出力イネーブル
--		RetryFlag1_EN	: IN STD_LOGIC;		--RetryFlag1出力イネーブル		--20090326YN_1
--		RetryFlag2_EN	: IN STD_LOGIC;		--RetryFlag2出力イネーブル		--20090326YN_1
--		Galv_run		: IN STD_LOGIC;		-- ガルバノON/OFF	--20100415MN
--		LIVE_B_F_CNT	: IN STD_LOGIC_VECTOR( 11 downto 0);
--		LIVE_B_ENABLE	: IN STD_LOGIC;
--		OVER_SCAN			: IN STD_LOGIC;
--		OVER_SCAN_DLY_TIME	: IN STD_LOGIC_VECTOR( 15 downto 0);
--		Hsync			: OUT STD_LOGIC;		-- 水平同期出力
--		Vsync			: OUT STD_LOGIC;		-- 垂直同期出力
--		TRIG			: OUT STD_LOGIC;		-- トリガ出力
--		SLD_Gen_EN		: OUT STD_LOGIC;
--		RetryFlag1		: OUT STD_LOGIC;		--20090326YN_1
--		RetryFlag2		: OUT STD_LOGIC;		--20090326YN_1
--		Vsync_RISE_EN	: OUT STD_LOGIC		--20090326YN_1
--	);
--	END COMPONENT;

------------------------------------------------------------------------------------------
--	COMPONENT comp_SLD_gen IS	--20070329TS	--20070830YN
--	PORT
--	(
--		Reset 			: IN STD_LOGIC;
--		FPGAclk 		: IN STD_LOGIC;							--20MHz
--		SLD_ON_OFF		: IN STD_LOGIC;
--		PULSE_ON_OFF	: IN STD_LOGIC;
--		SLD_Delay		: IN STD_LOGIC_VECTOR(9 downto 0);		--SLD遅延
--		PULSE_Width 	: IN STD_LOGIC_VECTOR(9 downto 0);
--		HSYNC_IN		: IN STD_LOGIC;
--		OUT_SLD_PULSE	: OUT STD_LOGIC
--	);
--	END COMPONENT;

------------------------------------------------------------------------------------------
--	COMPONENT comp_sync_gen IS
--	PORT
--	(
--		Reset 				: IN STD_LOGIC;
--		FPGAclk 			: IN STD_LOGIC;	
--		VH_GEN_EN			: IN STD_LOGIC;
--		VH_SYNC_PERIOD		: IN STD_LOGIC_VECTOR(12 downto 0); --VH_GEN_EN↑からSYNC出力までの遅延時間、(設定値*0.05)us
--		HSYNC_T				: IN STD_LOGIC_VECTOR(11 downto 0); --H-Sync周期、(設定値*0.05)us
--		HSYNC_NUM			: IN STD_LOGIC_VECTOR(12 downto 0);
--		TRACK_CNT_LIVE		: IN STD_LOGIC_VECTOR(12 downto 0);
--		TRACK_CNT_SCAN  	: IN STD_LOGIC_VECTOR(12 downto 0);
--		OUT_VSYNC			: OUT STD_LOGIC;
--		OUT_HSYNC			: OUT STD_LOGIC;
--		OUT_VHSYNC			: OUT STD_LOGIC;
--		OUT_HSYNC_END		: OUT STD_LOGIC;
--		OUT_TRACK_LiVE_EN	: OUT STD_LOGIC;
--		OUT_TRACK_EN		: OUT STD_LOGIC
--	);
--	END COMPONENT;


------------------------------------------------------------------------------------------
	


--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
----------------------	STATE declaration part				------------------------------
	-- X and Y Galvano control signal are generated with the same state

------------------------------------------------------------------------------------------
----------------------	Constant declaration part			------------------------------
	--FPGAのシステムクロックを設定 Max127MHz <-動作未検証
	--Hsyncのスピード設定に使用
	--初期値：20(20MHz)
	constant const_FPGACLK		: std_logic_vector(5 downto 0) := "010100";
	--ウェイト
	--50us	1000clk FPGAclk(20MHz)		--20070403TS
	constant const_50us_wait	: std_logic_vector(12 downto 0) := B"0_0011_1110_1000";
	--400us	8000clk FPGAclk(20MHz)		--20070403TS
	constant const_400us_wait	: std_logic_vector(12 downto 0) := "1111101000000";
	--700us	14000clk FPGAclk(20MHz)
	constant const_700us_wait	: std_logic_vector(14 downto 0) := "011011010110000";
	--900us	18000clk FPGAclk(20MHz)
	constant const_900us_wait	: std_logic_vector(14 downto 0) := "100011001010000";
	--1ms	20000clk FPGAclk(20MHz)		--20080603YN
--	constant const_1ms_wait		: std_logic_vector(14 downto 0) := "100111000100000";		--20090324YN_2
	--2ms	40000clk FPGAclk(20MHz)		--20090324YN_2
	constant const_2ms_wait		: std_logic_vector(15 downto 0) := X"9C40";		--20090325YN
	--3ms	60000clk FPGAclk(20MHz)		--20090325YN
	constant const_3ms_wait		: std_logic_vector(15 downto 0) := X"EA60";		--20090325YN
	-- Mode --
	constant const_Mode_B_Scan		: std_logic_vector(3 downto 0) := "0001";		-- B-Scan
	constant const_Mode_Circle_Scan	: std_logic_vector(3 downto 0) := "0010";		-- Circle-Scan
	constant const_Mode_C_Scan		: std_logic_vector(3 downto 0) := "0011";		-- 3D-Scan
	constant const_Mode_Radial_Scan	: std_logic_vector(3 downto 0) := "0100";		-- Radial-Scan
	constant const_Mode_Web_Scan	: std_logic_vector(3 downto 0) := "0110";		-- 20070329TS
	constant const_Mode_Raster_Scan	: std_logic_vector(3 downto 0) := "0111";		-- 20070404TS
	-- Resolution --
	constant const_Resol_4096	: std_logic_vector(11 downto 0) := "111111111111";		-- 4095
	constant const_Resol_2048	: std_logic_vector(11 downto 0) := "011111111111";		-- 2047
	constant const_Resol_1024	: std_logic_vector(11 downto 0) := "001111111111";		-- 1023
	constant const_Resol_512	: std_logic_vector(11 downto 0) := "000111111111";		--  512
	constant const_Resol_256	: std_logic_vector(11 downto 0) := "000011111111";		--  256
	-- Position --
	constant const_Galv_center_X	: std_logic_vector(11 downto 0) := "011111111111";		-- 2047
	constant const_Galv_center_Y	: std_logic_vector(11 downto 0) := "011111111111";		-- 2047
	constant const_Galv_Left_X		: std_logic_vector(11 downto 0) := "111111111111";		-- 4095
	constant const_Galv_Right_X		: std_logic_vector(11 downto 0) := "000000000000";		-- 0000
	constant const_Galv_Top_Y		: std_logic_vector(11 downto 0) := "111111111111";		-- 4095
	constant const_Galv_Bottom_Y	: std_logic_vector(11 downto 0) := "000000000000";		-- 0000

------------------------------------------------------------------------------------------
--Hsync Counter パラメータ設定
------------------------------------------------------------------------------------------
	--					    
	--				         |<---10us---->|_________
	--Galv_OUT(Real)	___________________|         
	--					      ________________________________
	--Galv_OUT			   __|
	--
	--					   _________________________________________
	--Hsync_CLK_EN		__|
	--				          _     _     _     _     _     _         
	--Hsync_CLK 	      ___| |___| |___| |___| |___| |___| |_		
	--					  |<---10us--->|____________________________________
	--VH_Gen_EN 		_______________|                                      	comp_VHsync_genモジュールに対して10us waitしたENを与える
	--					                    _     _     _     _     _     _         
	--Hsync				               ____| |___| |___| |___| |___| |___| |_		
	--					                  ____
	--Vsync				          _______|    |______________________________		
	--					                 __   
	--TRIG				          ______|  |___________________________________		
	--					     ____________________________________________________
	--Busy_out			____|
	--					

------------------------------------------------------------------------------------------
	signal sig_Freq_Sel			: std_logic_vector(8 downto 0);		--1～150KHz(0.5kHz刻み)	--20091027MN
	signal sig_Freq_Count		: std_logic_vector(15 downto 0);		--Hsync周期/2 (Gal_clk のカウンタに使用)
	signal sig_Freq_Count_pre	: std_logic_vector(15 downto 0);		--Hsync周期/2 (Gal_clk のカウンタに使用)
	signal sig_Hsync_T			: std_logic_vector(16 downto 0);		--Hsync周期
	signal sig_Div_numer		: std_logic_vector(15 downto 0);
	signal sig_VH_Gen_EN		: std_logic;

--	constant const_Freq_18KHz	: std_logic_vector(7 downto 0) := "00010010";		-- 18		--20090324YN_1
--	constant const_Init_Freq	: std_logic_vector(8 downto 0) := X"36";		-- 27*2		--20090324YN_1 --20091027MN
	constant const_Init_Freq	: std_logic_vector(8 downto 0) := B"0_0011_1100";		-- 27*2		--20090324YN_1 --20091027MN


------------------------------------------------------------------------------------------
----------------------	Internal signal definition part		------------------------------
	TYPE STATE_TYPE is (
						SET_UP,
						INITIAL,
						Move_Start_Pos,
						Move_Next_Pos,
						Scan_Start,
--						Live_Line,
--						Live_Line_RAM_Write,
--						Live_Line_Wait_S,
--						Live_Line_Check_Pos,
--						Live_Line_Run,
--						Live_Line_Wait_E,
--						Live_Line_Back,
--						Live_Circle,
--						Live_Circle_Wait_S,
--						Live_Circle_Check_Pos,
--						Live_Circle_Run,
						B_Scan,
						B_Scan_RAM_Write,
						B_Scan_Wait_S,
						B_Scan_Run,
						B_Scan_Wait_E,
						B_Scan_Back,
						Circle_Scan,
						Circle_Scan_Wait_S,
						Circle_Scan_Run,
						Circle_Scan_Wait_E,
--						Radial_Scan,
--						Radial_Scan_Run,
--						Radial_Scan_Wait_S,
--						Radial_Scan_Move_Next_Pos,
--						Radial_Scan_Check_Num,
--						Web_Scan,		--20070329TS
--						Concentric_Circle_Scan_Run,		--20070329TS
--						Concentric_Circle_Scan_Wait_S,		--20070329TS
--						Concentric_Circle_Scan_Check_Num,		--20070329TS
--						Concentric_Circle_Scan_Move_Next_Pos,		--20070329TS
--						Raster_Scan,
--						Raster_Scan_Run,
--						Raster_Scan_Wait_S,
--						Raster_Scan_Move_Next_Pos,
--						Raster_Scan_Check_Num,
--						Dummy_Scan,
						Dummy_Scan_Check_Num,
						END_MOVE,
						END_MOVE_WAIT,		--20090325YN
						END_MOVE_CSTM,		--20081031TS
						RAM_Write,
						Move_Center_Pos,
						V_SYNC_RUN
						);

	signal CURRENT_STATE	:STATE_TYPE;

------------------------------------------------------------------------------------------
	signal sig_Reset					: std_logic;
	signal sig_inter_Reset				: std_logic;		-- internal Reset
	signal sig_FPGAclk					: std_logic;		-- clk
	signal n_FPGAclk					: std_logic;		-- negative clk
	signal Gal_clk						: std_logic;		-- ガルバノ動作クロック(Hsync と同周期)
	signal n_Gal_clk					: std_logic;
	signal reg_Gal_clk_en				: std_logic;
	signal reg_Gal_clk					: std_logic_vector(16 downto 0);
	signal carry_reg_Gal_clk_RISE		: std_logic;
	signal sig_Gal_clk_RISE				: std_logic;
	signal reg_Gal_clk_FALL				: std_logic_vector(15 downto 0);
	signal sig_Gal_clk_FALL_COUNT_EN	: std_logic;
	signal carry_reg_Gal_clk_FALL		: std_logic;
	signal sig_Gal_clk_FALL				: std_logic;
	-- 400us wait counter
	signal cnt_400us_wait		: std_logic_vector(12 downto 0);		--20070403TS
	-- wait counter
	signal cnt_Move_wait		: std_logic_vector(15 downto 0);		--20090323YN
	-- 1ms wait counter = Move End wait counter		--20090324YN_2
--	signal cnt_Move_End_wait	: std_logic_vector(14 downto 0);		--20090324YN_2
	-- 2ms wait counter = Move End wait counter		--20090324YN_2
	signal cnt_Move_End_wait	: std_logic_vector(15 downto 0);		--20090324YN_2
	signal cnt_Move_End_wait2	: std_logic_vector(15 downto 0);		--20090325YN
	signal sig_Move_Wait_End	: std_logic;
	--ゲイン設定値からウェイト期間を求める		--20090323YN
	signal sig_Gain_Data_X			: std_logic_vector(7 downto 0);
	signal sig_Gain_Data_Y			: std_logic_vector(7 downto 0);
	signal sig_Gain_Data			: std_logic_vector(7 downto 0);		--20090323YN
	signal sig_Move_Wait_time_pre	: std_logic_vector(15 downto 0);		--20090323YN
	signal sig_Move_Wait_time_post	: std_logic_vector(15 downto 0);		--20090323YN
	--
	signal sig_Galv_run			: std_logic;
	signal sig_Mode_sel			: std_logic_vector(3 downto 0);
	--current start X coordinate
	signal sig_Start_X			: std_logic_vector(11 downto 0);
	--current start Y coordinate
	signal sig_Start_Y			: std_logic_vector(11 downto 0);
	--current end X coordinate
	signal sig_End_X			: std_logic_vector(11 downto 0);
	--current endt Y coordinate
	signal sig_End_Y			: std_logic_vector(11 downto 0);
	--live resolution
	signal sig_Live_Resol		: std_logic_vector(11 downto 0);
	--next live resolution
	signal sig_Live_Next_Resol	: std_logic_vector(11 downto 0);
	--scan resolution
	signal sig_Resol			: std_logic_vector(11 downto 0);
	--Y方向解像度（3D-Scan用）
	signal sig_Resol_Y			: std_logic_vector(11 downto 0);
	--X方向解像度（割り算で使用）
	signal sig_Resol_X_denom	: std_logic_vector(12 downto 0);
	signal sig_Hsync_num		: std_logic_vector(11 downto 0);
	--Y方向解像度（割り算で使用）
	signal sig_Resol_Y_denom	: std_logic_vector(11 downto 0);
	signal sig_CAP_START		: std_logic;		--1:capture start
	signal sig_CAP_START_Latch	: std_logic;		--1:capture start
	signal sig_TRIG_EN			: std_logic;		--1:trig EN
	signal sig_TRIG				: std_logic;		--1:capture start trig
	signal sig_START_3D			: std_logic;		--3D-Scan開始信号 1:開始
	signal sig_START_3D_Latch	: std_logic;		--3D-Scan開始信号ラッチ

------------------------------------------------------------------------------------------
	-- signal for Hsync
	signal sig_Hsync			: std_logic;
	signal cnt_Hsync_out_time	: std_logic_vector(12 downto 0);		-- 1->4096

------------------------------------------------------------------------------------------
	-- signal for Vsync
	signal sig_Vsync			: std_logic;

	signal sig_vhsync			: std_logic;
------------------------------------------------------------------------------------------
	-- signal for RAM Read
	signal sig_RAM_Read_X_CLK				: std_logic;
	signal sig_RAM_Read_Y_CLK				: std_logic;
--	signal sig_B_Scan_RAM_X_Read_Address	: std_logic_vector(11 downto 0);
--	signal sig_B_Scan_RAM_Y_Read_Address	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	-- signal for Dummy Data out for RAM DATA Delay
--	signal cnt_RAM_Read_CLK_Dummy_Data	: std_logic_vector(1 downto 0);
	signal sig_RAM_Read_EN_CLK			: std_logic;
	signal sig_Data_Out_EN				: std_logic;
	signal sig_Dummy_Data_Out_EN		: std_logic;
	
------------------------------------------------------------------------------------------
	-- signal for B-Scan
	--スタート前Wait終了
	signal sig_Live_Line_Wait_S_End			: std_logic;		--20070403TS
	--スタート前Waitカウント
	signal cnt_LLW_S	: std_logic_vector(4 downto 0);		--20070403TS
	--signal cnt_LLW_S	: std_logic_vector(14 downto 0);		--20070403TS
	--signal cnt_LLW_S	: std_logic_vector(19 downto 0);		--20070403TS
	--スタート位置変更フラグ 1:変更
	signal sig_Live_Line_Check_Start_Pos	: std_logic;
	--解像度変更フラグ 1:変更
--	signal sig_Live_Line_Check_Resol		: std_logic;
	--終了フラグ 1:終了
	signal sig_Live_Line_Run_End			: std_logic;
	--current start X coordinate
	signal sig_B_Scan_Current_Start_X	: std_logic_vector(11 downto 0);
	--current start Y coordinate
	signal sig_B_Scan_Current_Start_Y	: std_logic_vector(11 downto 0);
	--next start X coordinate
	signal sig_B_Scan_Next_Start_X		: std_logic_vector(11 downto 0);
	--next start Y coordinate
	signal sig_B_Scan_Next_Start_Y		: std_logic_vector(11 downto 0);
	--current end X coordinate
	signal sig_B_Scan_Current_End_X		: std_logic_vector(11 downto 0);
	--current end Y coordinate
	signal sig_B_Scan_Current_End_Y		: std_logic_vector(11 downto 0);
	--next end X coordinate
	signal sig_B_Scan_Next_End_X		: std_logic_vector(11 downto 0);
	--next end Y coordinate
	signal sig_B_Scan_Next_End_Y		: std_logic_vector(11 downto 0);
	--Distance start_X to end_X
	signal sig_B_Scan_Dist_X			: std_logic_vector(11 downto 0);
	--Distance start_Y to end_Y
	signal sig_B_Scan_Dist_Y			: std_logic_vector(11 downto 0);
	--Distance start_X to end_X 24bit	--alt_divide_24_13 のdenom値が13bitになったので
	signal sig_B_Scan_Dist_X25			: std_logic_vector(24 downto 0);		--20070202TS
	--Distance start_Y to end_Y 24bit	--alt_divide_24_13 のdenom値が13bitになったので
	signal sig_B_Scan_Dist_Y25			: std_logic_vector(24 downto 0);		--20070202TS
	--X-up/down flag
	signal sig_X_down					: std_logic;
	--Y-up/down flag
	signal sig_Y_down					: std_logic;
	--increment X dist/20clk
	signal sig_DX_inc_25				: std_logic_vector(24 downto 0);
	--increment Y dist/20clk
	signal sig_DY_inc_25				: std_logic_vector(24 downto 0);
	--latch sig_DX_inc_25
	signal sig_DX_inc_25_latch			: std_logic_vector(24 downto 0);
	--latch sig_DY_inc_25
	signal sig_DY_inc_25_latch			: std_logic_vector(24 downto 0);
	--sig_DX/Y_inc_25 latch  clk
	signal sig_alt_divide_en		    : std_logic;
	signal sig_alt_divide_en_d		    : std_logic;
	signal divide_en_rise_edge		: std_logic;
	--accumulate X
	signal sig_Accum_X_25				: std_logic_vector(24 downto 0);
	--accumulate Y
	signal sig_Accum_Y_25				: std_logic_vector(24 downto 0);
	--delay register
	signal sig_B_Scan_RAM_Write_EN_reg	: std_logic_vector(6 downto 0);
	--5 clk Delay
	constant const_B_Scan_RAM_Write_Delay	: integer :=6;
	signal sig_B_Scan_RAM_Write_EN		: std_logic;
	signal sig_B_Scan_RAM_X_Write_END	: std_logic;
	signal sig_B_Scan_RAM_Y_Write_END	: std_logic;
	signal sig_B_Scan_RAM_Read_EN		: std_logic;
	signal sig_B_Scan_RAM_Read_END		: std_logic;
	signal sig_B_Scan_X_Wraddress		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Y_Wraddress		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_X_Rdaddress		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Y_Rdaddress		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_X_Write_Data		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Y_Write_Data		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_X_Read_Data		: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Y_Read_Data		: std_logic_vector(11 downto 0);
--	signal sig_B_Scan_X_Read_Data_Latch	: std_logic_vector(11 downto 0);
--	signal sig_B_Scan_Y_Read_Data_Latch	: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Run_End			: std_logic;	-- 1:end
	signal sig_B_Scan_X_out				: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Y_out				: std_logic_vector(11 downto 0);
	signal sig_B_Scan_Run_Now			: std_logic;	-- 1:run

------------------------------------------------------------------------------------------
	-- signal for Circle-Scan
	--スタート位置変更フラグ 1:変更
--	signal sig_Live_Circle_Check_Start_Pos	: std_logic;
	--解像度変更フラグ 1:変更
--	signal sig_Live_Circle_Check_Resol		: std_logic;
	--終了フラグ 1:終了
	signal sig_Live_Circle_Run_End			: std_logic;
	signal sig_Circle_Scan_Current_Start_X	: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Current_Start_Y	: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Next_Start_X		: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Next_Start_Y		: std_logic_vector(11 downto 0);
	signal sig_L_R							: std_logic;		-- 0:L 1:R
	signal sig_Circle_R						: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Rdaddress		: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Run_End			: std_logic;		-- 1:end
	signal sig_Circle_Scan_ROM_EN			: std_logic;
	signal sig_Circle_Scan_X_out			: std_logic_vector(11 downto 0);
	signal sig_Circle_Scan_Y_out			: std_logic_vector(11 downto 0);
	signal cnt_Circle_Scan_Dummy_Data		: std_logic_vector(1 downto 0);
	signal sig_Circle_Scan_Data_Out_EN		: std_logic;
	signal sig_Circle_Scan_Data_Out_EN_Wait : std_logic_vector(3 downto 0);
	signal sig_Circle_Scan_Run_Now			: std_logic;		-- 1:run
	signal sig_Circle_Scan_D_out_time		: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	-- signal for C-Scan
	--縦横の切り替え 00=横,01=縦,10=横->縦,11=縦->横
	signal sig_V_H_3D						: std_logic_vector(1 downto 0);
	--V_H_3Dが10or11のときに何回目のスキャンかカウント
	signal sig_V_H_3D_count					: std_logic_vector(1 downto 0);
	signal sig_BackScan_Busy_out   		: std_logic;		--20081017TS

------------------------------------------------------------------------------------------
	-- signal for Radial-Scan
	signal const_Radial_Scan_Total_Num		: std_logic_vector(6 downto 0); --max64本 "1000000"
--	signal sig_Radial_Scan_Current_Num		: std_logic_vector(6 downto 0); --max64本 "1000000"
	signal sig_Radial_Scan_Start_X			: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_Start_Y			: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_X				: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_Y				: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_Start_Calc_X		: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_Start_Calc_Y		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_End_Calc_X		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_End_Calc_Y		: std_logic_vector(11 downto 0);
	signal sig_Radial_Scan_Address			: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Address_Sel		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Address_S_R		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Address_E_R		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Address_S_L		: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Address_E_L		: std_logic_vector(11 downto 0);
	signal const_Radial_Scan_Address_Inc	: std_logic_vector(11 downto 0);
	signal const_Radial_Scan_Address_R_Init	: std_logic_vector(11 downto 0);
	signal const_Radial_Scan_Address_L_Init	: std_logic_vector(11 downto 0);
--	signal sig_Radial_Scan_Rdaddress_Chenge	: std_logic_vector(2 downto 0);
--	signal sig_Radial_Scan_Rdaddress_S_EN	: std_logic;
--	signal sig_Radial_Scan_Rdaddress_E_EN	: std_logic;
--	signal sig_Radial_Scan_Data_S_EN		: std_logic;
--	signal sig_Radial_Scan_Data_E_EN		: std_logic;
	signal sig_Radial_Scan_ROM_EN			: std_logic;
	signal sig_Radial_Scan_XY_Calc_End		: std_logic;
	signal sig_Radial_Scan_Run_Now			: std_logic;
	signal sig_Radial_Scan_End				: std_logic;
	signal sig_Comp_Sin_Cos_XY_Rdaddress	: std_logic_vector(11 downto 0);
	signal sig_Comp_Sin_Cos_XY_Start_X		: std_logic_vector(11 downto 0);
	signal sig_Comp_Sin_Cos_XY_Start_Y		: std_logic_vector(11 downto 0);
	signal sig_Comp_Sin_Cos_XY_ROM_EN		: std_logic;
	signal sig_Comp_Sin_Cos_X_out			: std_logic_vector(11 downto 0);
	signal sig_Comp_Sin_Cos_Y_out			: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	-- signal for Multi-Circle-Scan		--20080508YN		del --20081023TS

------------------------------------------------------------------------------------------
	-- signal for Dummy-Scan
	signal sig_Dummy_Fram_Num	: std_logic_vector(2 downto 0);		--0 - 7
	signal sig_Dummy_Scan_End	: std_logic;		-- 1:end
	signal sig_Dummy_Scan_Now	: std_logic;		-- 1:end
	signal cnt_Dummy_Scan		: std_logic_vector(2 downto 0);

------------------------------------------------------------------------------------------
	-- signal for Scan_End_Flag
	signal cnt_1ms				: std_logic_vector(14 downto 0);		--20070329TS
	signal sig_count_1ms_en		: std_logic;		--20070329TS
	signal sig_tracking_Live_EN	: std_logic;		--20080410YN
	signal sig_tracking_EN		: std_logic;		--20080410YN

------------------------------------------------------------------------------------------
	-- signal for OUTPUT
	signal sig_X_galv		: std_logic_vector(11 downto 0);		--20061202TS
	signal sig_Y_galv		: std_logic_vector(11 downto 0);		--20061202TS
	signal sig_X_galv_out	: std_logic_vector(11 downto 0);		--20061202TS
	signal sig_Y_galv_out	: std_logic_vector(11 downto 0);		--20061202TS

------------------------------------------------------------------------------------------
	-- signal for Circle-Scan_Direction
	signal sig_Circle_Dir			: std_logic;		--20070329TS
	constant const_Cir_Dir_Default	: std_logic := '0';		-- N->S->T->I		--20070329TS
	constant const_Cir_Dir_Reverse	: std_logic := '1';		-- T->S->N->I		--20070329TS

------------------------------------------------------------------------------------------
	-- signal for SLD_PULSE
	signal sig_SLD			: std_logic;		--20070329TS
--	signal sig_Delay_Sel	: std_logic;		--20070329TS
	signal sig_SLD_Gen_EN	: std_logic;		--20070329TS
	signal sig_PULSE_Mode	: std_logic;		--20070902YN
	signal sig_SLD_M_Pos	: std_logic_vector(3 downto 0);		--20090206YN

------------------------------------------------------------------------------------------
	-- signal for Concentric-Circle-Scan
--	signal sig_Concentric_Circle_Scan_R				: std_logic_vector(15 downto 0);		--20070329TS
--	signal sig_Concentric_Circle_Scan_Run_Now		: std_logic;		--20070330TS
	signal sig_Web_Circle_R_Step					: std_logic_vector(11 downto 0);		--20070330TS
	signal sig_Concentric_Circle_Scan_Current_Num	: std_logic_vector(3 downto 0);		--20070330TS
	signal sig_Web_Scan_C_R_Flag					: std_logic;		--20070330TS
	signal sig_Web_Live_Sel							: std_logic;		--20070330TS
--	signal const_Concentric_Circle_Scan_Total_Num	: std_logic_vector(5 downto 0);		--20080508YN
	signal Conc_Circle_Scan_Calc_End		: std_logic;		--20070330TS
	signal cnt_CC_Calc								: std_logic_vector(4 downto 0);		--20070330TS

------------------------------------------------------------------------------------------
	-- signal for Raster-Scan
	signal sig_Raster_Scan_XY_Calc_End		: std_logic;		--20070404TS
	signal sig_Raster_Scan_End				: std_logic;		--20070404TS
	signal sig_Raster_Scan_Run_Now			: std_logic;		------------------20070622TS  ↓
--	signal const_Raster_Scan_Total_Num		: std_logic_vector(8 downto 0);
	signal const_Raster_Scan_Step			: std_logic_vector(11 downto 0);
	signal sig_Raster_Scan_XY_Calc_EN_reg	: std_logic_vector(5 downto 0);
	signal sig_Raster_Y_inc_clk				: std_logic;
	signal sig_Raster_Scan_Start_Y			: std_logic_vector(11 downto 0);
	signal sig_Raster_Scan_CNT_UP_clk		: std_logic;
	signal sig_Raster_Scan_Current_Num		: std_logic_vector(8 downto 0);
	signal sig_Raster_DY					: std_logic_vector(20 downto 0);

------------------------------------------------------------------------------------------
	-- signal for Custom-Scan
	signal cnt_CSTM_MOVE_END		: std_logic_vector(3 downto 0);		--20081106TS
	signal sig_CSTM_MOVE_END_END	: std_logic;		--20081106TS

------------------------------------------------------------------------------------------
	-- signal for RetryFlag		--20090326YN_1
	signal sig_RetryFlag1_EN		: std_logic;		--1:Enable
	signal sig_RetryFlag1			: std_logic;
	signal sig_RetryFlag2_EN		: std_logic;		--1:Enable
	signal sig_RetryFlag2			: std_logic;
	signal sig_Vsync_RISE_EN		: std_logic;		--1:Enable
	signal cnt_VsyncLive			: std_logic;
	signal sig_RetryFlag1_ON_OFF	: std_logic;		--1:ON		--20090406YN
	signal sig_RetryFlag2_ON_OFF	: std_logic;		--1:ON		--20090406YN

------------------------------------------------------------------------------------------
	-- sonstant for Flag to Distingguish MARKⅡ form OCT-2k		--20090326YN_2
--	constant Mk2_OCT2k	: std_logic := '0';		--MARK2
--	constant Mk2_OCT2k	: std_logic := '1';		--OCT-2k

------------------------------------------------------------------------------------------
	-- signal for Anterior Adjust Mode		--20090421YN
	signal sig_Adjust_Mode	: std_logic;
	signal sig_GalvX_Adjust	: std_logic_vector(11 downto 0);
	signal sig_GalvY_Adjust	: std_logic_vector(11 downto 0);
------------------------------------------------------------------------------------------
	signal	reg_SLD_Gen_EN_fflg :	std_logic;
	signal	reg_SLD_Gen_EN_1d   :	std_logic;
	signal	sig_SLD_Gen_EN_neg	:	std_logic;

	signal	sig_galv_back_pos_x :	std_logic_vector(11 downto 0);
	signal	sig_galv_back_pos_y :	std_logic_vector(11 downto 0);
	signal	sig_galv_back_end_x :	std_logic_vector(11 downto 0);
	signal	sig_galv_back_end_y :	std_logic_vector(11 downto 0);
	signal	sig_back_galv_x		:	std_logic_vector(11 downto 0);
	signal	sig_back_galv_y		:	std_logic_vector(11 downto 0);
	signal	sig_back_step_x		:	std_logic_vector(11 downto 0);
	signal	sig_back_step_y		:	std_logic_vector(11 downto 0);
	signal	sig_sub_start_end_x :	std_logic_vector(11 downto 0);
	signal	sig_sub_start_end_y :	std_logic_vector(11 downto 0);
	signal	sig_wait_step		:	std_logic_vector( 7 downto 0);
	signal	sig_back_step_cnt	:	std_logic_vector(11 downto 0);
	signal	sig_end_big_x		:	std_logic;
	signal	sig_end_big_y		:	std_logic;
	signal	sig_gain_rom_out	:	std_logic_vector(15 downto 0);
--**************************************************************************************--
	signal cam_50k				:	std_logic;
	signal sig_VH_Gen_EN_ext	:	std_logic;
	signal sig_Hsync_negEdge	:	std_logic;
	signal sig_Hsync_d			:	std_logic;

	signal sig_vsync_run_cnt_end:	std_logic;
	signal sig_hsync_out_en		:	std_logic;

	signal sig_inc_mul_cnt		:	std_logic_vector(7 downto 0);
	signal sig_inc_mul_end		:	std_logic;

	signal track_cnt_live		: std_logic_vector(12 downto 0);
	signal track_cnt_scan		: std_logic_vector(12 downto 0);

 	signal	reg_ram_const_data 	: std_logic_vector(15 downto 0);
	signal	reg_ram_const_adr  	: std_logic_vector(15 downto 0);
	signal	reg_gain_timing_en 	: std_logic;
	signal	reg_cos_table_en	: std_logic;
	signal	reg_sin_table_en 	: std_logic;

	signal cstm_param_en_d		:	std_logic_vector(1 downto 0);
	
	signal Gal_clk_d			:	std_logic;
	signal vh_gen_en_ff			:	std_logic;
	signal hsync_cnt			:	std_logic_vector(12 downto 0);
	
	signal Gal_clk_rise_edge	: std_logic;
	signal Gal_clk_fall_edge	: std_logic;
	
BEGIN

------------------------------------------------------------------------------------------
sig_FPGAclk <= FPGAclk;

------------------------------------------------------------------------------------------
n_FPGAclk <= not FPGAclk;

------------------------------------------------------------------------------------------
sig_Reset <= Reset;




--Inter_Reset 		<= sig_Inter_Reset;

HSYNC_NUM_OUT <= '0' & sig_hsync_num;

HSYNC_T	<= sig_Hsync_T(11 downto 0);

------------------------------------------------------------------------------------------
--**************************************************************************************--
--********************	STATE Machine						****************************--
--**************************************************************************************--
	U_STATE_MACHINE:
	process( Reset,FPGAclk )begin 
		if( Reset='1') then
			CURRENT_STATE <= SET_UP;
		elsif( FPGAclk'event and FPGAclk='1' ) then

			case CURRENT_STATE is
------------------------------------------------------------------------------------------
				when SET_UP =>
					--【遷移条件１】
					--400us wait
					if( cnt_400us_wait=const_400us_wait ) then

						CURRENT_STATE <= INITIAL;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= SET_UP;
					end if;
------------------------------------------------------------------------------------------
				when INITIAL =>
					--【遷移条件１】
					--400us経過　かつ　sig_Galv_run信号のアサート
					if( cnt_400us_wait=const_400us_wait) then
						if(sig_Galv_run='1')then
							CURRENT_STATE <= Move_Start_Pos;
						end if;
					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= INITIAL;
					end if;
------------------------------------------------------------------------------------------
				when Move_Start_Pos =>
					--【遷移条件１】
					--sig_Move_Wait_END信号のアサート
					if( sig_Move_Wait_END = '1' ) then

						CURRENT_STATE <= Scan_Start;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= Move_Start_Pos;
					end if;
------------------------------------------------------------------------------------------
				when Scan_Start =>
					--【遷移条件１】
					--sig_CAP_START信号がアサートされた場合、選択されたスキャンモードの
					--キャプチャー動作を行うためのステートへ遷移する
--					if( sig_CAP_START = '1' ) then

						case Mode_sel is
							--Mode_sel 0001
							when const_Mode_B_Scan		=> CURRENT_STATE <= B_Scan;
							--Mode_sel 0010
							when const_Mode_Circle_Scan	=> CURRENT_STATE <= Circle_Scan;
							when others					=> CURRENT_STATE <= INITIAL;
						end case;

--					end if;
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
----------- STATE B_Scan -----------------------------------------------------------------
				when B_Scan =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					elsif( sig_Move_Wait_End = '1' ) then

						CURRENT_STATE <= B_Scan_RAM_Write;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= B_Scan;
					end if;
------------------------------------------------------------------------------------------
				when B_Scan_RAM_Write =>
					if( sig_Galv_run='0') then
						CURRENT_STATE <= END_MOVE;

					elsif( sig_B_Scan_RAM_X_Write_END = '1' and sig_B_Scan_RAM_Y_Write_END = '1' ) then

						CURRENT_STATE <= B_Scan_Wait_S;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= B_Scan_RAM_Write;
					end if;
------------------------------------------------------------------------------------------
				when B_Scan_Wait_S =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					else

						CURRENT_STATE <= B_Scan_Run;

					end if;
------------------------------------------------------------------------------------------
				when B_Scan_Run =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					elsif( sig_B_Scan_Run_End = '1' ) then

						CURRENT_STATE <= B_Scan_Wait_E;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= B_Scan_Run;
					end if;
------------------------------------------------------------------------------------------
				when B_Scan_Wait_E =>
					if( sig_Galv_run='0') then
						CURRENT_STATE <= END_MOVE;
					elsif((GALV_TIMING_ADJ_EN = '0' and cnt_400us_wait= const_400us_wait) or 
						(GALV_TIMING_ADJ_EN = '1' and cnt_400us_wait= GALV_TIMING_ADJ_T3(12 downto 0))) then
						
						CURRENT_STATE <= END_MOVE_CSTM;	
						
--						if( Custom_Scan_ON = '1' ) then
--							CURRENT_STATE <= END_MOVE_CSTM;		
--						if( sig_Mode_Sel = const_Mode_Web_Scan or sig_Mode_Sel = const_Mode_Raster_Scan ) then
--							CURRENT_STATE <= Dummy_Scan_Check_Num;
--						elsif( sig_Mode_Sel = const_Mode_B_Scan and sig_CAP_START = '0') then
--						elsif( sig_Mode_Sel = const_Mode_B_Scan and sig_galv_run = '0') then
--							CURRENT_STATE <= END_MOVE;
--						else
--							CURRENT_STATE <= B_Scan_Back;
--						end if;
						
					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= B_Scan_Wait_E;
					end if;
------------------------------------------------------------------------------------------
				when B_Scan_Back =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					elsif( sig_Move_Wait_End = '1' ) then

						CURRENT_STATE <= B_Scan_Wait_S;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= B_Scan_Back;
					end if;
-------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
----------- STATE Circle_Scan ------------------------------------------------------------
				when Circle_Scan =>
					if( sig_Galv_run='0') then
						CURRENT_STATE <= END_MOVE;

					elsif( cnt_400us_wait= const_400us_wait ) then

						CURRENT_STATE <= Circle_Scan_Wait_S;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= Circle_Scan;
					end if;
------------------------------------------------------------------------------------------
				when Circle_Scan_Wait_S =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					elsif( cnt_400us_wait= const_400us_wait ) then

						CURRENT_STATE <= Circle_Scan_Run;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= Circle_Scan_Wait_S;
					end if;
------------------------------------------------------------------------------------------
				when Circle_Scan_Run =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;

					elsif( sig_Circle_Scan_Run_End = '1' ) then

						CURRENT_STATE <= Circle_Scan_Wait_E;

					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= Circle_Scan_Run;
					end if;
------------------------------------------------------------------------------------------
				when Circle_Scan_Wait_E =>
					if( sig_Galv_run='0' ) then
						CURRENT_STATE <= END_MOVE;
					elsif( SLD = '0' ) then
						CURRENT_STATE <= END_MOVE_CSTM;	
						
--						if( Custom_Scan_ON = '1' ) then		
--							CURRENT_STATE <= END_MOVE_CSTM;			
--						else
--							CURRENT_STATE <= Circle_Scan_Wait_S;		--Circle_Scan
--						end if;
					else
						CURRENT_STATE <= Circle_Scan_Wait_E;		--Circle_Scan
					end if;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
				when END_MOVE =>
					if( cnt_Move_End_wait= const_3ms_wait		--20090325YN
					) then
						CURRENT_STATE <= END_MOVE_WAIT;		--20090325YN
					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= END_MOVE;
					end if;
------------------------------------------------------------------------------------------
				when END_MOVE_WAIT =>		--20090325YN
					if( cnt_Move_End_wait2= const_2ms_wait ) then
						CURRENT_STATE <= Move_Center_Pos;
					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= END_MOVE_WAIT;
					end if;
------------------------------------------------------------------------------------------
				when Move_Center_Pos =>
					if( sig_Move_Wait_End = '1' ) then
						CURRENT_STATE <= SET_UP;
					else
					--【現在のステートにとどまる】
						CURRENT_STATE <= Move_Center_Pos;
					end if;
------------------------------------------------------------------------------------------
				when END_MOVE_CSTM =>		--20081031TS
					if( cstm_param_en	= '1' ) then

						if( BOTH_WAY_SCAN = '1' ) then
							if ( cstm_param_en_d = "11" ) then		--往復スキャンのときはcstm_param_en_d=11となるまでウェイトする
								CURRENT_STATE <= Scan_Start;
							end if;
						else
							CURRENT_STATE <= Move_Start_Pos;		--20081224TS		--add 20090106TS
						end if;
						
					else		--20081106TS
					--【現在のステートにとどまる】
						CURRENT_STATE <= END_MOVE_CSTM;		--20081104TS
					end if;		--20081106TS
------------------------------------------------------------------------------------------
				when others =>
					CURRENT_STATE <= SET_UP;
			end case;
		end if;
	end process;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--Galv_run for chattering stop
	sig_Galv_run <= Galv_run;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--COMMON Function
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
------------------------------------------------------------------------------------------
-- 400us wait counter --
-- Move End wait counter -> 1msに設定 --
------------------------------------------------------------------------------------------

	U_400us_wait_counter :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			cnt_400us_wait <= (others => '0');
			cnt_Move_End_wait <= (others => '0');		--20080603YN
			cnt_Move_End_wait2 <= (others => '0');		--20090325YN
		elsif( FPGAclk'event and FPGAclk = '1') then
			case CURRENT_STATE is
				--下記ステート時のみカウントアップ
				when SET_UP						=> cnt_400us_wait <= cnt_400us_wait + '1';
				when INITIAL					=> cnt_400us_wait <= cnt_400us_wait + '1';
				when B_Scan_Wait_E				=> cnt_400us_wait <= cnt_400us_wait + '1';
				when Circle_Scan				=> cnt_400us_wait <= cnt_400us_wait + '1';
				when Circle_Scan_Wait_S			=> cnt_400us_wait <= cnt_400us_wait + '1';
				when END_MOVE					=> cnt_Move_End_wait <= cnt_Move_End_wait + '1';		--20080603YN
				when END_MOVE_WAIT				=> cnt_Move_End_wait2 <= cnt_Move_End_wait2 + '1';		--20090325YN
				--上記ステート以外ではクリアされる
				when others 					=> cnt_400us_wait <= (others => '0');
												   cnt_Move_End_wait <= (others => '0');		--20080603YN
												   cnt_Move_End_wait2 <= (others => '0');		--20090325YN
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
-- Move wait counter (700 or 900us)--
------------------------------------------------------------------------------------------
--ガルバノが戻るときのウェイトカウンタ
	U_Move_wait_counter :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			cnt_Move_wait <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(sig_Move_Wait_End = '1')then
				cnt_Move_wait <= (others => '0');
			else
				case CURRENT_STATE is
					--下記ステートでカウントアップする
					when Move_Center_Pos	=> cnt_Move_wait <= cnt_Move_wait + '1';
					when Move_Start_Pos		=> cnt_Move_wait <= cnt_Move_wait + '1';
					when B_Scan				=> cnt_Move_wait <= cnt_Move_wait + '1';
					when B_Scan_Back		=> cnt_Move_wait <= cnt_Move_wait + '1';
					--上記ステート以外ではクリアする
					when others => cnt_Move_wait <= (others => '0');
				end case;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--★★LVF固定値でok -> ゲインいらなくなる
--★★固定値 12mm 1200us
--ガルバノが戻るときのウェイト終了フラグ。
--スキャンレンジによって変化
--Scan_Rane = 0(6mmx6mm)     => 700us wait
--Scan_Rane = 1(8.2mmx8.2mm) => 900us wait
--ガルバノ制御波形ゲイン設定値によって変化		--20090323YN

--	U_sig_Gain_Data_pre :
--	process(Reset,FPGAclk) begin
--		if(Reset = '1') then
--			sig_Gain_Data_X <= (others => '0');
--			sig_Gain_Data_Y <= (others => '0');
--		elsif(FPGAclk'event and FPGAclk = '1') then
--			if(	CURRENT_STATE = INITIAL		or
--				CURRENT_STATE = B_Scan_Run) then
--				if(CSTM_LIVE_B_ENABLE = '1') then
--					sig_Gain_Data_X <= GalvX_Gain_Data_B;
--					sig_Gain_Data_Y <= GalvY_Gain_Data_B;
--				else
--					sig_Gain_Data_X <= GalvX_Gain_Data;
--					sig_Gain_Data_Y <= GalvY_Gain_Data;
--				end if;
--			end if;
--		end if;
--	end process;

--8/5(月)
--★★ LFV固定値でok -> ゲインいらなくなる。
--★★ 固定値でok 12mm 1200us
--ゲイン設定値の取得		--20090323YN
--	U_sig_Gain_Data :
--	process(
--		Reset,
--		FPGAclk,
--		GalvX_Gain_Data,
--		GalvY_Gain_Data
--	) begin
--		if(
--			Reset = '1'
--		) then
--			sig_Gain_Data <= (others => '0');
--		elsif(
--			FPGAclk'event and FPGAclk = '1'
--		) then
--			--小さいほうの設定値を取得する。
--			if(
--				sig_Gain_Data_X > sig_Gain_Data_Y
--			) then
--				sig_Gain_Data <= X"ff" - sig_Gain_Data_X;
--			else
--				sig_Gain_Data <= X"ff" - sig_Gain_Data_Y;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--8/5(月)
--★★ ガルバノ戻し時間 レジスタから設定できればOK
--★★ LFV固定値でok 
--★★ sig_Gain_Data => いらない

--ガルバノ制御波形ゲイン設定値からウェイト期間を求める		--20090323YN
	U_Move_Wait_time :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Move_Wait_time_pre  <= (others => '0');
			sig_Move_Wait_time_post <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE /= Move_Center_Pos and CURRENT_STATE /= Move_Start_Pos and  
				CURRENT_STATE /= B_Scan and  CURRENT_STATE /= B_Scan_Back )then

				--ガルバノ戻り時間 T4設定
				if( GALV_TIMING_ADJ_EN = '1' ) then
					sig_Move_Wait_time_pre  <= GALV_TIMING_ADJ_T4;
				else
					sig_Move_Wait_time_pre  <= X"5DC0";		--1200us(24000clks)
				end if;

				--ガルバノ戻り時間 T5設定
				if( GALV_TIMING_ADJ_EN = '1' ) then
					sig_Move_Wait_time_post <= GALV_TIMING_ADJ_T5;
				else
					sig_Move_Wait_time_post <= X"5DC0";		--1200us(24000clks)
				end if;

--				if( GALV_TIMING_ADJ_EN = '1' ) then
--					sig_Move_Wait_time_pre  <= GALV_TIMING_ADJ_T4;
--				elsif( sig_Gain_Data > X"84") then			--132(=5Vp-p)
--					sig_Move_Wait_time_pre  <= X"1f40";		--400us(8000clks)
--				elsif( sig_Gain_Data < X"6F") then		--111
--					sig_Move_Wait_time_pre  <= X"5DC0";		--1200us(24000clks)
--				else
--					sig_Move_Wait_time_pre  <= sig_gain_rom_out;			--
--				end if;
				
--				if( GALV_TIMING_ADJ_EN = '1' ) then
--					sig_Move_Wait_time_post <= GALV_TIMING_ADJ_T5;
--				elsif( sig_Gain_Data > X"84") then			--132(=5Vp-p)
--					sig_Move_Wait_time_post <= X"5DC0";		--1200us(24000clks)
--				else
--					sig_Move_Wait_time_post <= X"7D00" - sig_gain_rom_out;	--合計1.6msになるように調整
--				end if;
			end if;
		end if;
	end process;

--	U_alt_rom_gain : alt_rom_gain port map (
--		address		=>	sig_Gain_Data		,
--		clock		=>	FPGAclk				,
--		rden		=>	'1'					,
--		q			=>	sig_gain_rom_out
--	);

--★★いらなくなる
--	U_alt_ram_gain : alt_ram_gain port map (
--		clock		=> FPGAclk				,
-- 		data		=> reg_ram_const_data ,
--		rdaddress	=> sig_Gain_Data		,
--		wraddress	=> reg_ram_const_adr(7 downto 0)  ,
--		wren		=> reg_gain_timing_en	,
--		q			=> sig_gain_rom_out
--	);

--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
-- 			reg_ram_const_data <= (others => '0');
--			reg_ram_const_adr  <= (others => '0');
--			reg_gain_timing_en	 <= '0';
--			reg_cos_table_en	<= '0';
--			reg_sin_table_en 	<= '0';
--		elsif( FPGAclk'event and FPGAclk = '1')then
-- 			reg_ram_const_data <= RAM_CONST_DATA;
--			reg_ram_const_adr  <= RAM_CONST_ADR;
--			if( RAM_CONST_ADR(15 downto 12) = X"0")then
--				reg_gain_timing_en	<= RAM_CONST_DATA_EN;
--			else
--				reg_gain_timing_en	<= '0';
--			end if;
--			if(RAM_CONST_ADR(15 downto 12) = X"1")then
--				reg_cos_table_en	<= RAM_CONST_DATA_EN;
--			else
--				reg_cos_table_en	<= '0';
--			end if;
--			if(RAM_CONST_ADR(15 downto 12) = X"2")then
--				reg_sin_table_en 	<= RAM_CONST_DATA_EN;
--			else
--				reg_sin_table_en 	<= '0';
--			end if;
--		end if;
--	end process;


	
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
 			reg_ram_const_data <= (others => '0');
			reg_ram_const_adr  <= (others => '0');
			reg_gain_timing_en	 <= '0';
			reg_cos_table_en	<= '0';
			reg_sin_table_en 	<= '0';
		elsif( FPGAclk'event and FPGAclk = '1')then
 			reg_ram_const_data <= RAM_CONST_DATA;
			reg_ram_const_adr  <= RAM_CONST_ADR;
			if(RAM_CONST_ADR(15 downto 12) = X"1")then
				reg_cos_table_en	<= RAM_CONST_DATA_EN;
			else
				reg_cos_table_en	<= '0';
			end if;
			if(RAM_CONST_ADR(15 downto 12) = X"2")then
				reg_sin_table_en 	<= RAM_CONST_DATA_EN;
			else
				reg_sin_table_en 	<= '0';
			end if;
		end if;
	end process;






------------------------------------------------------------------------------------------
	--20090323YN
	U_Move_Wait_End :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Move_Wait_End <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(	(	CURRENT_STATE = Move_Center_Pos 						or
					CURRENT_STATE = B_Scan_Back 							)and
			  	cnt_Move_wait = X"4E20"										   ) then--1ms(20000clk)
			--ウェイト期間経過　かつ　上記ステートの場合、アサートする
				sig_Move_Wait_End <= '1';
			elsif( CURRENT_STATE = Move_Start_Pos and cnt_Move_wait = sig_Move_Wait_time_pre) then
				sig_Move_Wait_End <= '1';
			elsif( CURRENT_STATE = B_Scan and BOTH_WAY_SCAN = '1' and cnt_Move_wait = BOTH_WAY_WAIT_TIME) then
				sig_Move_Wait_End <= '1';
			elsif( CURRENT_STATE = B_Scan and cnt_Move_wait = sig_Move_Wait_time_post) then
				sig_Move_Wait_End <= '1';
			else
				sig_Move_Wait_End <= '0';
			end if;
		end if;
	end process;

------Live_Line_BackやB_Scan_Backのときのガルバノ座標を計算する
------ガルバノ不具合対応
	sig_back_step_x     <= "00000000" & sig_sub_start_end_x(11 downto 8);
	sig_back_step_y     <= "00000000" & sig_sub_start_end_y(11 downto 8);
	--sig_back_galv_x		<= sig_X_galv_out
	--sig_galv_back_end_x <= sig_Start_X;
	sig_sub_start_end_x <=  (sig_back_galv_x - sig_galv_back_end_x) when (sig_end_big_x = '1') else (sig_galv_back_end_x - sig_back_galv_x );
	sig_sub_start_end_y <=  (sig_back_galv_y - sig_galv_back_end_y) when (sig_end_big_y = '1') else (sig_galv_back_end_y - sig_back_galv_y );

	U_calc_Back_pos:
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_galv_back_pos_x <= (others => '0');
			sig_galv_back_pos_y <= (others => '0');
			sig_galv_back_end_x <= (others => '0');
			sig_galv_back_end_y <= (others => '0');
			sig_back_galv_x		<= (others => '0');
			sig_back_galv_y		<= (others => '0');
			sig_wait_step		<= (others => '0');
			sig_back_step_cnt	<= (others => '0');
			sig_end_big_x		<= '0';
			sig_end_big_y		<= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then

			if(CURRENT_STATE = INITIAL or CURRENT_STATE = B_Scan_Wait_E )then
				if(sig_X_galv_out > sig_Start_X) then 
					sig_end_big_x	<= '1';
				else
					 sig_end_big_x	<= '0';
				end if;
				
				if(sig_Y_galv_out > sig_Start_Y) then 
					sig_end_big_y	<= '1';
				else 
					sig_end_big_y	<= '0';
				end if;
				
				sig_back_galv_x		<= sig_X_galv_out;
				sig_back_galv_y		<= sig_Y_galv_out;
				sig_galv_back_end_x <= sig_Start_X;
				sig_galv_back_end_y <= sig_Start_Y;

				if(sig_end_big_x = '1') then
					sig_galv_back_pos_x <= sig_X_galv_out - sig_back_step_x;
				else
					sig_galv_back_pos_x <= sig_X_galv_out + sig_back_step_x;
				end if;
				if(sig_end_big_y = '1') then
					sig_galv_back_pos_y <= sig_Y_galv_out - sig_back_step_y;
				else
					sig_galv_back_pos_y <= sig_Y_galv_out + sig_back_step_y;
				end if;

				sig_wait_step 		<= (others => '0');
				sig_back_step_cnt	<= (others => '0');
			elsif( CURRENT_STATE = B_Scan_Back  or CURRENT_STATE = Move_Start_Pos )then
				if( sig_wait_step =  (sig_Move_Wait_time_pre(15 downto 8)-1)) then
					if(sig_back_step_cnt < X"0ff")then
						if(sig_end_big_x = '1') then
							sig_galv_back_pos_x <= sig_galv_back_pos_x - sig_back_step_x;
						else
							sig_galv_back_pos_x <= sig_galv_back_pos_x + sig_back_step_x;
						end if;
						if(sig_end_big_y = '1') then
							sig_galv_back_pos_y <= sig_galv_back_pos_y - sig_back_step_y;
						else
							sig_galv_back_pos_y <= sig_galv_back_pos_y + sig_back_step_y;
						end if;
					elsif(sig_back_step_cnt = X"0ff")then
						if(sig_end_big_x = '1') then
							sig_galv_back_pos_x <= sig_X_galv_out - ("0000" & sig_sub_start_end_x(7 downto 0));
						else
							sig_galv_back_pos_x <= sig_X_galv_out + ("0000" & sig_sub_start_end_x(7 downto 0));
						end if;
						if(sig_end_big_y = '1') then
							sig_galv_back_pos_y <= sig_Y_galv_out - ("0000" & sig_sub_start_end_y(7 downto 0));
						else
							sig_galv_back_pos_y <= sig_Y_galv_out + ("0000" & sig_sub_start_end_y(7 downto 0));
						end if;
					end if;
					sig_wait_step <= (others => '0');
					sig_back_step_cnt <= sig_back_step_cnt + B"0000_0000_0001";
				else
					sig_wait_step <= sig_wait_step + B"0000_0001";
				end if;
			end if;
		end if;
	end process;
------------------------------------------------------------------------------------------
-- Internal Reset (reset counter, enable-signal)
------------------------------------------------------------------------------------------
--	U_inter_reset :
--	process( Reset, FPGAclk ) begin
--		if( Reset = '1' ) then
--			sig_inter_Reset <= '0';
--		elsif( FPGAclk'event and FPGAclk = '1' ) then
--			case CURRENT_STATE is
--				when SET_UP					=> sig_inter_Reset <= '1';
--				when INITIAL				=> sig_inter_Reset <= '1';
--				when B_Scan_Wait_S			=> sig_inter_Reset <= '1';
--				when Circle_Scan_Wait_S		=> sig_inter_Reset <= '1';
--				when others 				=> sig_inter_Reset <= '0';
--			end case;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
-- Start Position & End position SET for ALL MODE
------------------------------------------------------------------------------------------
	U_Start_End_position :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Start_X	<= const_Galv_center_X;
			sig_Start_Y	<= const_Galv_center_Y;
			sig_End_X	<= const_Galv_center_X;
			sig_End_Y	<= const_Galv_center_Y;
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE=SET_UP)then
				sig_Start_X	<= const_Galv_center_X;
				sig_Start_Y	<= const_Galv_center_Y;
				sig_End_X	<= const_Galv_center_X;
				sig_End_Y	<= const_Galv_center_Y;
			else
				case sig_Mode_sel is
					when const_Mode_B_Scan =>
							if( CURRENT_STATE = INITIAL or CURRENT_STATE = B_Scan ) then	--20090106TS
								sig_Start_X	<= Start_X;		--20090106TS
								sig_Start_Y	<= Start_Y;		--20090106TS
								sig_End_X	<= End_X;		--20090106TS
								sig_End_Y	<= End_Y;		--20090106TS
							elsif( BOTH_WAY_SCAN = '1' and cstm_param_en = '1'	--往復スキャンのとき
								   and (CURRENT_STATE = END_MOVE_CSTM or CURRENT_STATE = Scan_Start) ) then
								sig_Start_X	<= Start_X;		--20090106TS
								sig_Start_Y	<= Start_Y;		--20090106TS
								sig_End_X	<= End_X;		--20090106TS
								sig_End_Y	<= End_Y;		--20090106TS
							end if;		--20090106TS
					when const_Mode_Circle_Scan =>
							if( CURRENT_STATE = INITIAL or CURRENT_STATE = Circle_Scan or CURRENT_STATE = Move_Start_Pos or 
								CURRENT_STATE = END_MOVE_CSTM ) then		--20090106TS
								sig_Start_X	<= Start_X + sig_Circle_R;
								sig_Start_Y	<= Start_Y;	
								sig_End_Y	<= End_Y;	
--								if(
--									sig_L_R = '0'
--								) then		--Left		--20090106TS
--									sig_Start_X	<= Start_X + sig_Circle_R;		--20090106TS
--								else		--Right		--20090106TS
--									sig_Start_X	<= Start_X - sig_Circle_R;		--20090106TS
--								end if;		--20090106TS
--								sig_Start_Y	<= Start_Y;		--20090106TS
--								sig_End_Y	<= End_Y;		--20090106TS
--							--	else		--20090106TS
--							--		値保持		--20090106TS
							end if;		--20090106TS
					when others =>
						sig_Start_X	<= const_Galv_center_X;
						sig_Start_Y	<= const_Galv_center_Y;
						sig_End_X	<= const_Galv_center_X;
						sig_End_Y	<= const_Galv_center_Y;
				end case;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_X_down
--スタート・エンドX座標より増加するのか減少するのか判断
	U_X_down :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_X_down	<= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = INITIAL)then
				sig_X_down	<= '0';
			else
					if( CURRENT_STATE = B_Scan) then

						if( sig_B_Scan_Current_Start_X > sig_B_Scan_Current_End_X) then
							sig_X_down	<= '1';		--set X-down mode
						else
							sig_X_down	<= '0';
						end if;
					end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Y_down
--スタート・エンドY座標より増加するのか減少するのか判断
	U_Y_down :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Y_down	<= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE =INITIAL)then
				sig_Y_down	<= '0';
			else
					if( CURRENT_STATE = B_Scan) then
						if( sig_B_Scan_Current_Start_Y > sig_B_Scan_Current_End_Y) then
							sig_Y_down	<= '1';		--set Y-down mode
						else
							sig_Y_down	<= '0';
						end if;
					--	else
					--		値保持	20070626TS
					end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Resol --------------------------------------------------------------
------------------------------------------------------------------------------------------
--★★8/5 live_resoいる??
--解像度の設定
--Internal signal sig_Resol_3bit
	U_Resol_3bit :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
--			sig_Live_Resol <= "001111111111";		--1023
			sig_Live_Next_Resol <= "001111111111";		--1023
			sig_Resol <= "001111111111";		--1023
		elsif( FPGAclk'event and FPGAclk='1')then
			if(CURRENT_STATE=SET_UP)then
--				sig_Live_Resol <= "001111111111";		--1023
				sig_Live_Next_Resol <= "001111111111";		--1023
				sig_Resol <= "001111111111";		--1023
			else
				case sig_Mode_sel is
					when const_Mode_B_Scan =>
						sig_Resol <= Resolution;
--							--ライブ用解像度
--							if( CURRENT_STATE = INITIAL ) then
--								sig_Live_Resol <= Live_Resol;
--							end if;
--							--スキャン用解像度
--							if( CURRENT_STATE = B_Scan) then
--								sig_Resol <= Resolution;
--							end if;
--							--	else
--							--		値保持	20070626TS
					when const_Mode_Circle_Scan =>
						sig_Resol <= Resolution;
--							--ライブ用解像度
--							if( CURRENT_STATE = INITIAL ) then 
-- 
--								sig_Live_Resol <= Live_Resol;
--							end if;
--							--スキャン用解像度
--							if( CURRENT_STATE = Circle_Scan) then
--								sig_Resol <= Resolution;
--							end if;
--							--	else
--							--		値保持	20070626TS
--
					when others =>
--						sig_Live_Resol <= "001111111111";		--1023
						sig_Live_Next_Resol <= "001111111111";		--1023
						sig_Resol <= "001111111111";		--1023
				end case;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_L_R
--	U_sig_L_R :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_L_R <= '0';
--		elsif( FPGAclk'event and FPGAclk = '1') then
--			if(CURRENT_STATE = SET_UP)then
--				sig_L_R <= '0';
--			else
--				if( CURRENT_STATE = INITIAL 			or
--					CURRENT_STATE = Circle_Scan 		or
--					CURRENT_STATE = Circle_Scan_Wait_S 	or
--					CURRENT_STATE = Move_Start_Pos 		or
--					CURRENT_STATE = END_MOVE_CSTM
--				) then
--					if( sig_Circle_Dir = const_Cir_Dir_Default) then		--20070329TS
--						sig_L_R <= L_R;
--					else
--						sig_L_R <= not L_R;
--					end if;
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Dir		--20070302TS
	U_sig_Circle_Dir :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Circle_Dir <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = SET_UP)then
				sig_Circle_Dir <= '0';
			else
				if( Circle_Direction = '0') then
					sig_Circle_Dir <= const_Cir_Dir_Default;		--N->S->T->I
				else		--Circle_Direction = '1'
					sig_Circle_Dir <= const_Cir_Dir_Reverse;		--T->S->N->I
				end if;
			end if;
		end if;	
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Freq_Sel------------------------------------------------------------
------------------------------------------------------------------------------------------
--   1/SPEED(KHz) = 1/FPGA_CLK(MHz) * COUNT
--  COUNT =( FPGA_CLK*1000)/SPEED
--        = const_FPGACLK*1000/SPEED
--
------------------------------------------------------------------------------------------
--Hsyncの周波数設定に応じて各カウンタ値の設定を行う
	U_dec_Freq_Sel_3to12 :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Freq_Sel <= const_Init_Freq;		--20090324YN_1
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE=SET_UP)then
				sig_Freq_Sel <= const_Init_Freq;		--20090324YN_1
			else
				if( CURRENT_STATE = INITIAL or CURRENT_STATE = B_Scan or CURRENT_STATE = Circle_Scan ) then
					--1刻みなので2倍して0.5刻みに変換
					--50kHzの場合のみ49.5kHzにする。
					if(Freq_Sel = X"32")then			--Freq_sel == 50
						sig_Freq_Sel <= B"0_0110_0011";	--sig_Freq_sel = 99 --20091210MN
					else
						sig_Freq_Sel <= Freq_Sel & '0';	-- *2 --20091210MN
					end if;
				--	else
				--		値保持	20070626TS
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	--numer/denom = quotient
	--sig_Freq_Selの値からカウンタ値を計算
	--Xilinx版にするにあたり信号名が変更
	--タイミングは1clk→18clkに伸びたが、B_SCANステートのうちに終わればよいのでタイミング変更しない 
	--20120416MN
	U_alt_divide_16_9 : alt_divide_16_9 port map (
		clock		=>	FPGAclk,
		denom	  	=>	sig_Freq_Sel,
		quotient	=>	sig_Freq_Count_pre,		--Hsync周期/2
		numer		=>	sig_Div_numer
	);
	-- 50kHzに設定された場合は49.3kHzにする
	sig_Freq_Count <= X"00CB" when sig_Freq_Sel = B"0_0110_0011" else sig_Freq_Count_pre;

------------------------------------------------------------------------------------------
	sig_Div_numer <= const_FPGACLK * "1111101000";		--20MHz*1000/2*2  = 20000 (10011100010000) --20091027MN

------------------------------------------------------------------------------------------
	sig_Hsync_T <= sig_Freq_Count & '0';				--Hsync周期

------------------------------------------------------------------------------------------
--Internal signal sig_Mode_sel -----------------------------------------------------------
------------------------------------------------------------------------------------------
--CURRENT_STATE が INITIAL のときにモード取り込み
	U_Mode_sel :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_Mode_sel <= "0001";		--デフォルト B-scan
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = SET_UP)then
				sig_Mode_sel <= "0001";		--デフォルト B-scan
			else
					if( CURRENT_STATE = INITIAL 		or
						CURRENT_STATE = END_MOVE_CSTM 	or
						CURRENT_STATE = MOVE_START_POS     ) then		--20090106TS
						sig_Mode_Sel <= Mode_Sel;
					--	else
					--		値保持	20070626TS
					end if;
			end if;
		end if;
	end process;

---------------------------------------------------------------------------------------------
--Internal signal sig_Dummy_Fram_Num --------------------------------------------------------
---------------------------------------------------------------------------------------------
--本スキャン前のダミースキャンの本数の取り込み
--	U_Dummy_Fram_Num :
--	process(
--		Reset,
--		FPGAclk
--	) begin
--		if(
--			Reset='1'
--		) then
--			sig_Dummy_Fram_Num <= (others=>'0');
--		elsif(
--			FPGAclk'event and FPGAclk ='1'
--		) then
--			sig_Dummy_Fram_Num <= Dummy_Fram_Num;
--		end if;
--	end process;



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 001 B-Scan
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--internal signal sig_B_Scan_Current_Start_X/Y
--0clk
--	U_B_Scan_Start_XY :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_B_Scan_Current_Start_X <= const_Galv_center_X;
--			sig_B_Scan_Current_Start_Y <= const_Galv_center_Y;
--			sig_B_Scan_Next_Start_X    <= const_Galv_center_X;
--			sig_B_Scan_Next_Start_Y    <= const_Galv_center_Y;
--			sig_B_Scan_Current_End_X   <= const_Galv_center_X;
--			sig_B_Scan_Current_End_Y   <= const_Galv_center_Y;
--			sig_B_Scan_Next_End_X      <= const_Galv_center_X;
--			sig_B_Scan_Next_End_Y      <= const_Galv_center_Y;
--		elsif( FPGAclk'event and FPGAclk = '1') then
--			if(CURRENT_STATE = SET_UP)then
--				sig_B_Scan_Current_Start_X <= const_Galv_center_X;
--				sig_B_Scan_Current_Start_Y <= const_Galv_center_Y;
--				sig_B_Scan_Next_Start_X    <= const_Galv_center_X;
--				sig_B_Scan_Next_Start_Y    <= const_Galv_center_Y;
--				sig_B_Scan_Current_End_X   <= const_Galv_center_X;
--				sig_B_Scan_Current_End_Y   <= const_Galv_center_Y;
--				sig_B_Scan_Next_End_X      <= const_Galv_center_X;
--				sig_B_Scan_Next_End_Y      <= const_Galv_center_Y;
--			else
--				if( CURRENT_STATE = INITIAL ) then
--					sig_B_Scan_Current_Start_X <= sig_Start_X;
--					sig_B_Scan_Current_Start_Y <= sig_Start_Y;
--					sig_B_Scan_Current_End_X   <= sig_End_X;
--					sig_B_Scan_Current_End_Y   <= sig_End_Y;
--					sig_B_Scan_Next_Start_X <= sig_Start_X;
--					sig_B_Scan_Next_Start_Y <= sig_Start_Y;
--					sig_B_Scan_Next_End_X   <= sig_End_X;
--					sig_B_Scan_Next_End_Y   <= sig_End_Y;
--			-- Current_Start --
--				elsif( CURRENT_STATE = B_Scan ) then
--					sig_B_Scan_Current_Start_X <= sig_Start_X;
--					sig_B_Scan_Current_Start_Y <= sig_Start_Y;
--					sig_B_Scan_Current_End_X   <= sig_End_X;
--					sig_B_Scan_Current_End_Y   <= sig_End_Y;
--		-- Next_Start --
--				elsif( CURRENT_STATE = B_Scan_Wait_S ) then
--					sig_B_Scan_Next_Start_X <= sig_Start_X;
--					sig_B_Scan_Next_Start_Y <= sig_Start_Y;
--					sig_B_Scan_Next_End_X   <= sig_End_X;
--					sig_B_Scan_Next_End_Y   <= sig_End_Y;
--				end if;
--			end if;
--		end if;
--	end process;

	U_B_Scan_Start_XY :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_Current_Start_X <= const_Galv_center_X;
			sig_B_Scan_Current_Start_Y <= const_Galv_center_Y;
			sig_B_Scan_Next_Start_X    <= const_Galv_center_X;
			sig_B_Scan_Next_Start_Y    <= const_Galv_center_Y;
			sig_B_Scan_Current_End_X   <= const_Galv_center_X;
			sig_B_Scan_Current_End_Y   <= const_Galv_center_Y;
			sig_B_Scan_Next_End_X      <= const_Galv_center_X;
			sig_B_Scan_Next_End_Y      <= const_Galv_center_Y;
		elsif( FPGAclk'event and FPGAclk = '1') then
			case CURRENT_STATE is
				when SET_UP => 
						sig_B_Scan_Current_Start_X <= const_Galv_center_X;
						sig_B_Scan_Current_Start_Y <= const_Galv_center_Y;
						sig_B_Scan_Next_Start_X    <= const_Galv_center_X;
						sig_B_Scan_Next_Start_Y    <= const_Galv_center_Y;
						sig_B_Scan_Current_End_X   <= const_Galv_center_X;
						sig_B_Scan_Current_End_Y   <= const_Galv_center_Y;
						sig_B_Scan_Next_End_X      <= const_Galv_center_X;
						sig_B_Scan_Next_End_Y      <= const_Galv_center_Y;
				when INITIAL =>
						sig_B_Scan_Current_Start_X <= sig_Start_X;
						sig_B_Scan_Current_Start_Y <= sig_Start_Y;
						sig_B_Scan_Current_End_X   <= sig_End_X;
						sig_B_Scan_Current_End_Y   <= sig_End_Y;
						sig_B_Scan_Next_Start_X <= sig_Start_X;
						sig_B_Scan_Next_Start_Y <= sig_Start_Y;
						sig_B_Scan_Next_End_X   <= sig_End_X;
						sig_B_Scan_Next_End_Y   <= sig_End_Y;
				when B_Scan =>
						sig_B_Scan_Current_Start_X <= sig_Start_X;
						sig_B_Scan_Current_Start_Y <= sig_Start_Y;
						sig_B_Scan_Current_End_X   <= sig_End_X;
						sig_B_Scan_Current_End_Y   <= sig_End_Y;
				when B_Scan_Wait_S =>
						sig_B_Scan_Next_Start_X <= sig_Start_X;
						sig_B_Scan_Next_Start_Y <= sig_Start_Y;
						sig_B_Scan_Next_End_X   <= sig_End_X;
						sig_B_Scan_Next_End_Y   <= sig_End_Y;
				when others => 	
						null;
			end case;
		end if;
	end process;


------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_Write_EN_reg
--Delay circuit
--パイプライン処理を行うためのイネーブル信号を生成
	U_B_Scan_RAM_Write_EN_reg :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
		--リセット信号のアサート　もしくは　上記ステートの場合クリアする
			sig_B_Scan_RAM_Write_EN_reg <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk = '1') then
				if( CURRENT_STATE = B_Scan_RAM_Write) then

					--以下のいずれかが終了していなければ続ける
					if( sig_B_Scan_RAM_X_Write_END = '0' or sig_B_Scan_RAM_Y_Write_END = '0') then
						sig_B_Scan_RAM_Write_EN_reg(0) <= '1';
						--const_B_Scan_RAM_Write_Delay=6 -> 5clk Delay
						--Xilinx版で乗算器の遅延が伸びたためロジック変更
							sig_B_Scan_RAM_Write_EN_reg(1) <= sig_B_Scan_RAM_Write_EN_reg(0);
							if(sig_inc_mul_end = '1')then
								sig_B_Scan_RAM_Write_EN_reg(2) <= sig_B_Scan_RAM_Write_EN_reg(1);
							end if;
							sig_B_Scan_RAM_Write_EN_reg(3) <= sig_B_Scan_RAM_Write_EN_reg(2);
							sig_B_Scan_RAM_Write_EN_reg(4) <= sig_B_Scan_RAM_Write_EN_reg(3);
							sig_B_Scan_RAM_Write_EN_reg(5) <= sig_B_Scan_RAM_Write_EN_reg(4);
							sig_B_Scan_RAM_Write_EN_reg(6) <= sig_B_Scan_RAM_Write_EN_reg(5);
					else
					--どちらも終了したらクリアする
						sig_B_Scan_RAM_Write_EN_reg <= (others=>'0');
					end if;
				else
				--上記ステート以外ではクリアする
					sig_B_Scan_RAM_Write_EN_reg <= (others=>'0');
				end if;
--			end if;
		end if;
	end process;

--Xilinx版のため乗算器の遅延を考慮するための信号追加 
--20120416MN
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_inc_mul_cnt <= (others => '0');
			sig_inc_mul_end <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if ( CURRENT_STATE = B_Scan_RAM_Write 		) then
				if(sig_B_Scan_RAM_Write_EN_reg(1) = '1' and sig_B_Scan_RAM_Write_EN_reg(2) = '0')then
					sig_inc_mul_cnt <= sig_inc_mul_cnt + X"01";
				else
					sig_inc_mul_cnt <= (others => '0');
				end if;
				if( sig_inc_mul_cnt = X"1C" )then
					sig_inc_mul_end <= '1';
				end if;
			else
				sig_inc_mul_cnt <= (others => '0');
				sig_inc_mul_end <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_Dist_X ------------------------------------------------------
-- set X scannig distance --
--1clk
	U_B_Scan_Dist_X :
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_B_Scan_Dist_X <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			if( sig_B_Scan_RAM_Write_EN_reg(1)= '1' ) then
					if( sig_B_Scan_Current_Start_X >= sig_B_Scan_Current_End_X ) then
						sig_B_Scan_Dist_X <= sig_B_Scan_Current_Start_X - sig_B_Scan_Current_End_X;
					else
						sig_B_Scan_Dist_X <= sig_B_Scan_Current_End_X - sig_B_Scan_Current_Start_X;
					end if;
			else
				sig_B_Scan_Dist_X <= (others => '0');
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_Dist_Y -----------------------------------------------------
-- set Y scannig distance --
	U_B_Scan_Dist_Y :
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_B_Scan_Dist_Y <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			if( sig_B_Scan_RAM_Write_EN_reg(1)= '1' ) then
					if( sig_B_Scan_Current_Start_Y >= sig_B_Scan_Current_End_Y ) then
						sig_B_Scan_Dist_Y <= sig_B_Scan_Current_Start_Y - sig_B_Scan_Current_End_Y;
					else
						sig_B_Scan_Dist_Y <= sig_B_Scan_Current_End_Y - sig_B_Scan_Current_Start_Y;
					end if;
			else
				sig_B_Scan_Dist_Y <= (others => '0');
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_Dist_X_24 ---------------------------------------------------
--alt_divide_24_13 のdenom値が13bitになったので  2007/2/2 T.Sato
	sig_B_Scan_Dist_X25 <= sig_B_Scan_Dist_X & "0000000000000";
	sig_B_Scan_Dist_Y25 <= sig_B_Scan_Dist_Y & "0000000000000";

------------------------------------------------------------------------------------------
--component 25/13 divide ----------------------------------------------------------------2007/2/2 T.Sato
--Internal signal sig_DX_inc_25 ---------------------------------------------------------
-- set X increment distance --
--2clk
--Xilinx版にするにあたりポートが変更
--レイテンシが大幅に変更になる 0clk→27clk
--20120416MN
	U_alt_divide_25_13_X:alt_divide_25_13 port map(
--		rfd			=>				,
		clock		=>	FPGAclk,
		numer		=> sig_B_Scan_Dist_X25,		--input A	 25bit
		denom		=> sig_Resol_X_denom,		--input B	 13bit
		quotient	=> sig_DX_inc_25			--output A/B 25bit
--		fractional	=>
	);

------------------------------------------------------------------------------------------
--sig_Resol_X_denom
	U_Resol_X_denom :
--	process(
--		Reset,
--		FPGAclk,
--		sig_CAP_START,
--		sig_Live_Resol,
--		sig_Resol,
--		sig_Resol_Y,
--		sig_Mode_Sel,
--		sig_V_H_3D,
--		sig_V_H_3D_count
--	) begin
	process( Reset, FPGAclk)begin
		if( Reset = '1') then
			sig_Resol_X_denom <= (others => '1');
			sig_Hsync_num     <= (others => '1');
		elsif( FPGAclk'event and FPGAclk='1') then
--			if( sig_CAP_START = '0') then
--				sig_Resol_X_denom <= '0' & sig_Live_Resol;
--				sig_Hsync_num     <= '0' & sig_Live_Resol;
--			else
				if( OVER_SCAN = '0' ) then
					sig_Resol_X_denom <= '0' & sig_Resol;
				else
					sig_Resol_X_denom <= ('0' & sig_Resol) + ("00000" & OVER_SCAN_NUM);
				end if;
				sig_Hsync_num     <= sig_Resol;
--			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--component 25/13 divide -----------------------------------------------------------------
--Internal signal sig_DY_inc_25 ----------------------------------------------------------
-- set Y increment distance --
	U_alt_divide_25_13_Y:alt_divide_25_13 port map(
--		rfd			=>						,
		clock		=> FPGAclk				,
		numer		=> sig_B_Scan_Dist_Y25	,
		quotient	=> sig_DY_inc_25		,
		denom		=> '0' & sig_Resol_Y_denom	
--		fractional	=>	
	);

------------------------------------------------------------------------------------------
	U_Resol_Y_denom :
--	process(
--		Reset,
--		sig_CAP_START,
--		FPGAclk,
--		sig_Live_Resol,
--		sig_Resol,
--		sig_Resol_Y,
--		sig_Mode_Sel,
--		sig_V_H_3D,
--		sig_V_H_3D_count
--	) begin
	process( Reset, FPGAclk)begin
		if( Reset='1') then
			sig_Resol_Y_denom <= (others=>'1');
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_Resol_Y_denom <= sig_Resol;
--			if(sig_CAP_START = '0') then
--				sig_Resol_Y_denom <= '0' & sig_Live_Resol;
--			else
--				sig_Resol_Y_denom <= '0' & sig_Resol;
--			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--latch divide out data ------------------------------------------------------------------
--Internal signal sig_DX_inc_25_latch-----------------------------------------------------
--	U_DXY_inc_25_latch :
--	process(
--		Reset,
--		sig_inter_Reset,
--		sig_D_inc_25_latch_clk
--	) begin
--		if(
--			Reset = '1'
--			or
--			sig_inter_Reset = '1'
--		) then
--			sig_DX_inc_25_latch <= (others =>'0');
--			sig_DY_inc_25_latch <= (others =>'0');
--		elsif(
--			sig_D_inc_25_latch_clk'event and sig_D_inc_25_latch_clk = '1'
--		) then
--				sig_DX_inc_25_latch <= sig_DX_inc_25;
--				sig_DY_inc_25_latch <= sig_DY_inc_25;
--		end if;
--	end process;

	
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_DX_inc_25_latch <= (others =>'0');
			sig_DY_inc_25_latch <= (others =>'0');
		elsif(FPGAclk'event and FPGAclk = '1') then
			if( divide_en_rise_edge = '1' )then
				sig_DX_inc_25_latch <= sig_DX_inc_25;
				sig_DY_inc_25_latch <= sig_DY_inc_25;
			end if;
		end if;
	end process;




------------------------------------------------------------------------------------------
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_alt_divide_en 	<= '0';
			sig_alt_divide_en_d <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			sig_alt_divide_en_d <= sig_alt_divide_en;
			if( sig_B_Scan_RAM_Write_EN_reg = "0000111") then
				sig_alt_divide_en 	<= '1';
			else
				sig_alt_divide_en 	<= '0';
			end if;
		end if;
	end process;

	divide_en_rise_edge <= ( sig_alt_divide_en and (not sig_alt_divide_en_d) );

------------------------------------------------------------------------------------------
--Internal signal sig_Accum_X_25 ---------------------------------------------------------
--Internal signal sig_Accum_Y_25 ---------------------------------------------------------
-- accumulate XY distance --
--3clk
	U_Accum_XY_24 :
	process( Reset, FPGAclk)begin
		if( Reset = '1') then
			sig_Accum_X_25 <= (others =>'0');
			sig_Accum_Y_25 <= (others =>'0');
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			if(CURRENT_STATE = B_Scan_Wait_S 	or 
			   CURRENT_STATE = END_MOVE				)then
				sig_Accum_X_25 <= (others =>'0');
				sig_Accum_Y_25 <= (others =>'0');
			else
				if( sig_B_Scan_RAM_Write_EN_reg(4) = '1') then
					sig_Accum_X_25 <= sig_Accum_X_25 + sig_DX_inc_25_latch;
					sig_Accum_Y_25 <= sig_Accum_Y_25 + sig_DY_inc_25_latch;
				else
					sig_Accum_X_25 <= sig_Accum_X_25;
					sig_Accum_Y_25 <= sig_Accum_Y_25;
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_X_out -------------------------------------------------------
--Internal signal sig_B_Scan_Y_out--------------------------------------------------------
-- output Galv_XY --
--
--    (4095,4095)                           (4095,4095)
--      ---------------------------------      ---------------------------------      
--      |               E               |      |               |               |      
--      |              /|               |      |  (Y-down)     |               |		
--      |             / |               |      |       S       |               |		
--      |            /  |               |      |       |       |               |		
--      |           /   |               |      |       |       |               |		
--      |          /    |(2047,         |      |       |       |(2047,         |		
--      |         /     |   2047)       |      |       |       |   2047)       |		
--      |--------/----------------------|      |-------|-----------------------|		
--      |       /       |               |      |       |       |               |		
--      |      /        |               |      |       |       |               |		
--      |     /         |               |      |       |       |               |		
--      |    /          |               |      |       |       |               |		
--      |   /           |               |      |       V       |               |		
--      |  S(X-down,Y-up)               |      |       E       |               |		
--      |---------------|---------------|(0,0) |---------------|---------------|(0,0)	
--
--       S:start   E:end
--
--4clk

------------------------------------------------------------------------------------------
	U_B_Scan_X_Write_Data :
	process( Reset, FPGAclk)begin
		if( Reset = '1') then
			sig_B_Scan_X_Write_Data <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = B_Scan_Wait_S)then

				sig_B_Scan_X_Write_Data <= (others => '0');
			else
					if( ( CURRENT_STATE = B_Scan_RAM_Write) and
						sig_B_Scan_RAM_Write_EN_reg(4)= '1'										   and
						sig_B_Scan_RAM_X_Write_END = '0'                                                ) then
						if( sig_X_down = '1') then		--X-down
							sig_B_Scan_X_Write_Data <= sig_B_Scan_Current_Start_X - sig_Accum_X_25(24 downto 13);
						else							--X-up
							sig_B_Scan_X_Write_Data <= sig_B_Scan_Current_Start_X + sig_Accum_X_25(24 downto 13);
						end if;
					else
						sig_B_Scan_X_Write_Data <= (others=>'0');
					end if;
--				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_B_Scan_Y_Write_Data :
	process( Reset, FPGAclk)begin
		if( Reset = '1') then
			sig_B_Scan_Y_Write_Data <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = B_Scan_Wait_S)then

				sig_B_Scan_Y_Write_Data <= (others => '0');
			else
					if( ( CURRENT_STATE = B_Scan_RAM_Write) and

						sig_B_Scan_RAM_Write_EN_reg(4)= '1' 		                               and
						sig_B_Scan_RAM_Y_Write_END = '0'												) then
						if( sig_Y_down = '1') then		--Y-down
							sig_B_Scan_Y_Write_Data <= sig_B_Scan_Current_Start_Y - sig_Accum_Y_25(24 downto 13);
						else							--Y-up
							sig_B_Scan_Y_Write_Data <= sig_B_Scan_Current_Start_Y + sig_Accum_Y_25(24 downto 13);
						end if;
					else
						sig_B_Scan_Y_Write_Data <= (others=>'0');
					end if;
--				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_Write_EN ------------------------------------------------
	U_B_Scan_RAM_Write_EN :
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_B_Scan_RAM_Write_EN <= '0';
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			if( sig_B_Scan_RAM_X_Write_END = '0' and sig_B_Scan_RAM_Y_Write_END = '0' 
				and sig_B_Scan_RAM_Write_EN_reg(4) = '1' ) then
				sig_B_Scan_RAM_Write_EN <= '1';			--Write start <const_B_Scan_RAM_Write_Delay =6>
			elsif( sig_B_Scan_RAM_X_Write_END = '1' and sig_B_Scan_RAM_Y_Write_END = '1' ) then		--XY共に書き込み終了したら
				sig_B_Scan_RAM_Write_EN <= '0';			--Write end
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_X_Wraddress -------------------------------------------------
-- RAM Write address counter
	U_B_Scan_X_Wraddress :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_X_Wraddress <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = B_Scan_Wait_S)then
				sig_B_Scan_X_Wraddress <= (others => '0');
			else
				if( sig_B_Scan_RAM_Write_EN_reg(4) = '1' and sig_B_Scan_RAM_X_Write_END = '0') then
					sig_B_Scan_X_Wraddress <= sig_B_Scan_X_Wraddress + '1';
				else
					sig_B_Scan_X_Wraddress <= (others => '0');
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_Y_Wraddress -------------------------------------------------
-- RAM Write address counter
	U_B_Scan_Y_Wraddress :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_Y_Wraddress <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = B_Scan_Wait_S)then

				sig_B_Scan_Y_Wraddress <= (others => '0');
			else
				if( sig_B_Scan_RAM_Write_EN_reg(4) = '1' and sig_B_Scan_RAM_Y_Write_END = '0') then
					sig_B_Scan_Y_Wraddress <= sig_B_Scan_Y_Wraddress + '1';
				else
					sig_B_Scan_Y_Wraddress <= (others => '0');
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_X_Write_END
--RAM Write End Flag
--RAMへの書き込み終了フラグ
	U_B_Scan_RAM_X_Write_END :
	process( Reset, FPGAclk ) begin
		if( Reset = '1') then
			sig_B_Scan_RAM_X_Write_END <= '0';
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			--sig_B_Scan_RAM_Write_EN_reg(4)のアサート　かつ　以下のステートの場合
			if( sig_B_Scan_RAM_Write_EN_reg(4) = '1'  and ( CURRENT_STATE = B_Scan_RAM_Write ) ) then
				if( sig_B_Scan_X_Wraddress = sig_Resol_X_denom(11 downto 0) ) then
				--上記が真ならば、アサートする
					sig_B_Scan_RAM_X_Write_END <= '1';
				end if;
			else
				sig_B_Scan_RAM_X_Write_END <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_Y_Write_END ---------------------------------------------
-- RAM Write End Flag --
	U_B_Scan_RAM_Y_Write_END :
	process( Reset, FPGAclk ) begin
		if( Reset = '1') then
			sig_B_Scan_RAM_Y_Write_END <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( sig_B_Scan_RAM_Write_EN_reg(4) = '1' and ( CURRENT_STATE = B_Scan_RAM_Write )) then
				if( sig_B_Scan_Y_Wraddress = sig_Resol_Y_denom(11 downto 0) ) then
					sig_B_Scan_RAM_Y_Write_END <= '1';
				--		値保持	20070626TS
				end if;
			else
				sig_B_Scan_RAM_Y_Write_END <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_Read_EN
	U_B_Scan_RAM_Read_EN :
	process( CURRENT_STATE ) begin
		case CURRENT_STATE is
			when B_Scan_Run		=> sig_B_Scan_RAM_Read_EN <= '1';
			when others			=> sig_B_Scan_RAM_Read_EN <= '0';
		end case;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_RAM_Read_X_CLK 
--	U_RAM_Read_X_CLK :
--	process(
--		CURRENT_STATE,
--		n_Gal_clk,
--		n_FPGAclk
--	) begin
--		case CURRENT_STATE is
--			when B_Scan_Run           => sig_RAM_Read_X_CLK <= n_Gal_clk;
--			when others => sig_RAM_Read_X_CLK <= '0';
--		end case;
--	end process;
--
--------------------------------------------------------------------------------------------
----Internal signal sig_RAM_Read_Y_CLK 
--	U_RAM_Read_Y_CLK :
--	process(
--		CURRENT_STATE,
--		n_Gal_clk,
--		n_FPGAclk
--	) begin
--		case CURRENT_STATE is
--			when B_Scan_Run           => sig_RAM_Read_Y_CLK <= n_Gal_clk;
--			when others => sig_RAM_Read_Y_CLK <= '0';
--		end case;
--	end process;

------------------------------------------------------------------------------------------
----Internal signal sig_B_Scan_RAM_X_Read_Address
--	U_B_Scan_RAM_X_Read_Address :
--	process( Reset, FPGAclk ) begin 
--		if( Reset='1' ) then
--			sig_B_Scan_RAM_X_Read_Address <= (others=>'1');
--		elsif( FPGAclk'event and FPGAclk='0' ) then
--			case CURRENT_STATE is
--				when B_Scan_Run     => sig_B_Scan_RAM_X_Read_Address <= sig_B_Scan_X_Rdaddress;
--				when others => sig_B_Scan_RAM_X_Read_Address <= (others=>'1');
--			end case;
--		end if;
--	end process;
 --
--------------------------------------------------------------------------------------------
----Internal signal sig_B_Scan_RAM_Y_Read_Address
--	U_B_Scan_RAM_Y_Read_Address :
--	process( Reset, FPGAclk ) begin 
--		if( Reset='1' ) then
--			sig_B_Scan_RAM_Y_Read_Address <= (others=>'1');
--		elsif( FPGAclk'event and FPGAclk='0' ) then
--			case CURRENT_STATE is
--				when B_Scan_Run     => sig_B_Scan_RAM_Y_Read_Address <= sig_B_Scan_Y_Rdaddress;
--				when others => sig_B_Scan_RAM_Y_Read_Address <= (others=>'1');
--			end case;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_RAM_Read_END
--Internal signal sig_B_Scan_Run_End
	U_B_Scan_RAM_Read_END :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_Run_End		<= '0';
			sig_B_Scan_RAM_Read_END <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( CURRENT_STATE = B_Scan_Run) then
				if( HSYNC_END = '1') then --OVER_SCAN_NUM分は不要なのでsig_Resol_X_denom->sig_Hsync_num
					sig_B_Scan_RAM_Read_END <= '1';
					sig_B_Scan_Run_End		<= '1';
				else
					sig_B_Scan_RAM_Read_END <= '0';
					sig_B_Scan_Run_End		<= '0';
				end if;
			else
				sig_B_Scan_RAM_Read_END <= '0';
				sig_B_Scan_Run_End		<= '0';
			end if;
		end if;
	end process;

-----------------------------------------------------------------------------------------
--component M4K RAM for B-Scan-----------------------------------------------------------
-- Write/Read for X --
	U_alt_dp_ram_bscan_X : alt_dp_ram_bscan port map(
--		wrclock		=> n_FPGAclk,					--: IN STD_LOGIC ;
		wrclock		=> FPGAclk,					--: IN STD_LOGIC ;
		data		=> sig_B_Scan_X_Write_Data,		--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		wren 		=> sig_B_Scan_RAM_Write_EN,		--: IN STD_LOGIC  := '1';
		wraddress	=> sig_B_Scan_X_Wraddress,		--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		rdaddress	=> sig_B_Scan_RAM_X_Read_Address,	--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdaddress	=> sig_B_Scan_X_Rdaddress,	--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		rdclock		=> sig_RAM_Read_X_CLK,			--: IN STD_LOGIC ;
		rdclock		=> FPGAclk,			--: IN STD_LOGIC ;
		q			=> sig_B_Scan_X_Read_Data		--: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);

------------------------------------------------------------------------------------------
--component M4K RAM ---------------------------------------------------------------------
-- Write/Read for Y --
	U_alt_dp_ram_bscan_Y : alt_dp_ram_bscan port map(
--		wrclock		=> n_FPGAclk,					--: IN STD_LOGIC ;
		wrclock		=> FPGAclk,					--: IN STD_LOGIC ;
		data		=> sig_B_Scan_Y_Write_Data,		--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		wren		=> sig_B_Scan_RAM_Write_EN,		--: IN STD_LOGIC  := '1';
		wraddress	=> sig_B_Scan_Y_Wraddress,		--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		rdaddress	=> sig_B_Scan_RAM_Y_Read_Address,	--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdaddress	=> sig_B_Scan_Y_Rdaddress,	--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		rdclock		=> sig_RAM_Read_Y_CLK,			--: IN STD_LOGIC ;
		rdclock		=> FPGAclk,			--: IN STD_LOGIC ;
		q			=> sig_B_Scan_Y_Read_Data		--: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_X_Read_Data_Latch
--Internal signal sig_B_Scan_Y_Read_Data_Latch
--	U_B_Scan_XY_Read_Data_Latch :
--	process( Reset, n_FPGAclk ) begin
--		if( Reset = '1' ) then
--			sig_B_Scan_X_Read_Data_Latch <= (others =>'0');
--			sig_B_Scan_Y_Read_Data_Latch <= (others =>'0');
--		elsif( n_FPGAclk'event and n_FPGAclk = '1' ) then
--			sig_B_Scan_X_Read_Data_Latch <= sig_B_Scan_X_Read_Data;
--			sig_B_Scan_Y_Read_Data_Latch <= sig_B_Scan_Y_Read_Data;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_X_out
--Internal signal sig_B_Scan_Y_out
--Sync FPGAclk 
	U_B_Scan_XY_out :
	process( Reset, sig_Dummy_Data_Out_EN, CURRENT_STATE, sig_B_Scan_Current_Start_X,
		sig_B_Scan_Current_Start_Y, sig_B_Scan_X_Read_Data, sig_B_Scan_Y_Read_Data, sig_X_galv_out,sig_Y_galv_out) begin
		if( CURRENT_STATE = B_Scan_Run 	) then
			if( sig_Dummy_Data_Out_EN ='1' ) then
				sig_B_Scan_X_out <= sig_X_galv_out;
				sig_B_Scan_Y_out <= sig_Y_galv_out;
			else
				sig_B_Scan_X_out <= sig_B_Scan_X_Read_Data;
				sig_B_Scan_Y_out <= sig_B_Scan_Y_Read_Data;
			end if;
		else
			sig_B_Scan_X_out <= sig_B_Scan_X_Read_Data;
			sig_B_Scan_Y_out <= sig_B_Scan_Y_Read_Data;
		end if;
	end process;

--Internal signal cnt_RAM_Read_CLK_Dummy_Data
--	U_cnt_RAM_Read_CLK_Dummy_Data :
--	process(
--		Reset,
--		CURRENT_STATE,
--		sig_RAM_Read_EN_CLK
--	) begin
--		if(
--			Reset = '1'
--			or
--			CURRENT_STATE = B_Scan_Wait_S
--			or
--			CURRENT_STATE = B_Scan_Wait_E
--		) then
--			cnt_RAM_Read_CLK_Dummy_Data <= (others=>'0');
--		elsif(
--			sig_RAM_Read_EN_CLK'event and sig_RAM_Read_EN_CLK = '1'
--		) then
--			if(
--				sig_B_Scan_RAM_Read_EN = '1'
--			) then
--				cnt_RAM_Read_CLK_Dummy_Data <= cnt_RAM_Read_CLK_Dummy_Data + '1';
--			--	else
--			--		値保持	20070626TS
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--	sig_RAM_Read_EN_CLK <= sig_RAM_Read_X_CLK or sig_RAM_Read_Y_CLK;

------------------------------------------------------------------------------------------
--Internal signal sig_Data_Out_EN
--	U_Data_Out_EN :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then		--20070626TS
--			sig_Data_Out_EN <= '0';
--		elsif( FPGAclk'event and FPGAclk = '1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_Data_Out_EN <= '0';
--			else
--				if( cnt_RAM_Read_CLK_Dummy_Data = "10") then
--					sig_Data_Out_EN <= '1';
--				elsif(   CURRENT_STATE = B_Scan_Wait_S    or
--					   CURRENT_STATE = B_Scan_Wait_E      ) then
--					sig_Data_Out_EN <= '0';
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Data_Out_EN <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( CURRENT_STATE = INITIAL)then
				sig_Data_Out_EN <= '0';
			elsif( CURRENT_STATE = B_Scan_Wait_S or CURRENT_STATE = B_Scan_Wait_E ) then
				sig_Data_Out_EN <= '0';
			elsif( CURRENT_STATE = B_Scan_Run and Gal_clk_fall_edge = '1' )then
				sig_Data_Out_EN <= '1';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Dummy_Data_Out_EN
	sig_Dummy_Data_Out_EN <= sig_B_Scan_RAM_Read_EN xor sig_Data_Out_EN;

-----------------------------------------------------------------------------------------
--**************************************************************************************--
-- STATE_= B_4 B_Scan_Run "001 0100"
--**************************************************************************************--
------------------------------------------------------------------------------------------
--Internal signal sig_B_Scan_Run_Now------------------------------------------------------
--B_Scan中のフラグ
--	U_B_Scan_Run_Now :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			sig_B_Scan_Run_Now <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_B_Scan_Run_Now <= '0';
--			else
--				if( sig_Mode_sel = const_Mode_B_Scan and sig_CAP_START = '1') then
--					if( CURRENT_STATE=B_Scan_Wait_S) then
--						sig_B_Scan_Run_Now <= '1';
--					--	else
--					--		値保持	20070626TS
--					end if;
--				else
--					sig_B_Scan_Run_Now <= '0';
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
-- RAM Read address counter when STATE=B_Scan_Run
--	U_B_Scan_X_Rdaddress :
--	process( Reset, Gal_clk, sig_inter_Reset, sig_B_Scan_RAM_Read_END) begin
--		if( Reset = '1' or sig_B_Scan_RAM_Read_END= '1' or sig_inter_Reset='1') then
--			sig_B_Scan_X_Rdaddress <= (others => '0');
--		elsif( Gal_clk'event and Gal_clk = '1') then
--			if( CURRENT_STATE = B_Scan_Run) then
--
--				--delay 1time for RAM data out delay
--				if( sig_B_Scan_X_Rdaddress = sig_Resol_X_denom(11 downto 0)) then
--					sig_B_Scan_X_Rdaddress <= sig_B_Scan_X_Rdaddress;	--count stop
--				else
--					sig_B_Scan_X_Rdaddress <= sig_B_Scan_X_Rdaddress + '1';
--				end if;
--			--	else
--			--		値保持	20070626TS
--			end if;
--		end if;
--	end process;

--	U_B_Scan_X_Rdaddress :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_X_Rdaddress <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( sig_B_Scan_RAM_Read_END= '1' )then
				sig_B_Scan_X_Rdaddress <= (others => '0');
			elsif( Gal_clk_rise_edge = '1' and  CURRENT_STATE = B_Scan_Run )then
				if( sig_B_Scan_X_Rdaddress = sig_Resol_X_denom(11 downto 0)) then
					sig_B_Scan_X_Rdaddress <= sig_B_Scan_X_Rdaddress;
				else
					sig_B_Scan_X_Rdaddress <= sig_B_Scan_X_Rdaddress + '1';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	U_B_Scan_Y_Rdaddress :
--	process( Reset, Gal_clk, sig_inter_Reset, sig_B_Scan_RAM_Read_END ) begin
--		if( Reset = '1' or sig_B_Scan_RAM_Read_END= '1' or sig_inter_Reset='1' ) then
--			sig_B_Scan_Y_Rdaddress <= (others => '0');
--		elsif( Gal_clk'event and Gal_clk = '1' ) then
--			if( CURRENT_STATE = B_Scan_Run ) then
--				--delay 1time for RAM data out delay
--				if( sig_B_Scan_Y_Rdaddress = sig_Resol_Y_denom(11 downto 0)) then
--					sig_B_Scan_Y_Rdaddress <= sig_B_Scan_Y_Rdaddress;	--count stop
--				else
--					sig_B_Scan_Y_Rdaddress <= sig_B_Scan_Y_Rdaddress + '1';
--				end if;
--			end if;
--		end if;
--	end process;

--	U_B_Scan_Y_Rdaddress :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_B_Scan_Y_Rdaddress <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( sig_B_Scan_RAM_Read_END = '1' )then
				sig_B_Scan_Y_Rdaddress <= (others => '0');
			elsif( Gal_clk_rise_edge = '1' and  CURRENT_STATE = B_Scan_Run )then
				if( sig_B_Scan_Y_Rdaddress = sig_Resol_Y_denom(11 downto 0)) then
					sig_B_Scan_Y_Rdaddress <= sig_B_Scan_Y_Rdaddress;
				else
					sig_B_Scan_Y_Rdaddress <= sig_B_Scan_Y_Rdaddress + '1';
				end if;
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 010 Circle-Scan
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Scan_Current_Start_X/Y,sig_Circle_Scan_Next_Start_X/Y
	U_Circle_Scan_Start_XY :
	process( Reset, FPGAclk) begin
		if( Reset = '1')then		--20070626TS
			sig_Circle_Scan_Current_Start_X <= const_Galv_center_X;
			sig_Circle_Scan_Current_Start_Y <= const_Galv_center_Y;
			sig_Circle_Scan_Next_Start_X    <= const_Galv_center_X;
			sig_Circle_Scan_Next_Start_Y    <= const_Galv_center_Y;
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = INITIAL)then
				sig_Circle_Scan_Current_Start_X <= const_Galv_center_X;
				sig_Circle_Scan_Current_Start_Y <= const_Galv_center_Y;
				sig_Circle_Scan_Next_Start_X    <= const_Galv_center_X;
				sig_Circle_Scan_Next_Start_Y    <= const_Galv_center_Y;
			elsif( CURRENT_STATE = Circle_Scan    ) then
				sig_Circle_Scan_Current_Start_X <= sig_Start_X;
				sig_Circle_Scan_Current_Start_Y <= sig_Start_Y;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
--Internal signal sig_Circle_R
	U_Circle_R :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then		--20090106TS
			sig_Circle_R <= "011111111111";		--2047
		elsif( FPGAclk'event and FPGAclk = '1') then
			case sig_Mode_Sel is
				when const_Mode_Circle_Scan =>
						if( CURRENT_STATE = INITIAL            or
							CURRENT_STATE = Circle_Scan        or
							CURRENT_STATE = END_MOVE_CSTM	      ) then	--20090106TS
							sig_Circle_R <= Circle_R;		--12bit		--20090106TS
						end if;		--20090106TS
				when others => sig_Circle_R <= "011111111111";
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--**************************************************************************************--
-- STATE_= R_4 Circle_Scan_Run "010 0100"
--**************************************************************************************--
------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Scan_Run_Now------------------------------------------------------
--Circle_Scan中のフラグ
	U_Circle_Scan_Run_Now :
	process( Reset, FPGAclk) begin
		if( Reset='1') then		--20070626TS
			sig_Circle_Scan_Run_Now <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = INITIAL)then
				sig_Circle_Scan_Run_Now <= '0';
			else
				if( sig_Mode_sel = const_Mode_Circle_Scan and sig_CAP_START = '1') then
					if( CURRENT_STATE = Circle_Scan_Wait_S) then
						sig_Circle_Scan_Run_Now <= '1';
					--	else
					--		値保持	20070626TS
					end if;
				else
					sig_Circle_Scan_Run_Now <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
-- RAM Read address counter
	process( Reset, FPGAclk) begin
		if( Reset='1') then	
			sig_Circle_Scan_Rdaddress <= (others=>'0');
			sig_Circle_Scan_D_out_time <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( CURRENT_STATE = SET_UP or CURRENT_STATE = INITIAL or CURRENT_STATE = END_MOVE_CSTM or  
				CURRENT_STATE = Circle_Scan_Wait_S )then
				sig_Circle_Scan_Rdaddress <= "011111111111";		--L start adress 2047
				sig_Circle_Scan_D_out_time <= (others=>'0');
			elsif( CURRENT_STATE = Circle_Scan_Run and Gal_clk_rise_edge = '1' )then
				if( sig_Circle_Scan_D_out_time = sig_Resol ) then
					sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress;
				else
					case sig_Resol is
						when "111111111111" =>		--4096
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 1;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "011111111111" =>		--2048
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 2;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "001111111111" =>		--1024
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 4;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "000111111111" =>		--512
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 8;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "000011111111" =>		--256
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 16;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "000001111111" =>		--128
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 32;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when "000000111111" =>		-- 64
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 64;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
						when others =>				--1024
							sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 4;
							sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
					end case;
				end if;
			end if;
		end if;
	end process;

--★★Gal_clk修正時、sig_L_R部分変更
-- RAM Read address counter
--	U_Circle_Scan_Rdaddress :
--	process( Reset,sig_L_R, Gal_clk,sig_inter_Reset,CURRENT_STATE) begin
--		if( Reset = '1') then
--			sig_Circle_Scan_Rdaddress <= (others=>'0');
--			sig_Circle_Scan_D_out_time <= (others=>'0');
--		elsif( sig_inter_Reset='1' or CURRENT_STATE = END_MOVE_CSTM )then			--20090106TS
--			if(	sig_L_R = '1') then		--R eye
--				sig_Circle_Scan_Rdaddress <= (others => '1');		--R start adress 0
--			else
--				sig_Circle_Scan_Rdaddress <= "011111111111";		--L start adress 2047
--			end if;
--			sig_Circle_Scan_D_out_time <= (others=>'0');
--		elsif( Gal_clk'event and Gal_clk = '1') then
--			if( sig_Mode_sel = const_Mode_Circle_Scan or sig_Mode_Sel = const_Mode_Web_Scan ) then		--20081023TS
--
--				if( CURRENT_STATE = Circle_Scan_Run ) then		--キャプチャー中
--					if(sig_Circle_Scan_D_out_time = sig_Resol ) then
--						sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress;	--アドレスカウンタストップ
--					else
--						if( sig_L_R = '1') then		--R eye
--							case sig_Resol is
--								when "111111111111" =>		--4096
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 1;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "011111111111" =>		--2048
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 2;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "001111111111" =>		--1024
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 4;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000111111111" =>		--512
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 8;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000011111111" =>		--256
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 16;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000001111111" =>		--128
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 32;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000000111111" =>		-- 64
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 64;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when others =>				--1024
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + 4;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--							end case;
--						elsif( sig_L_R = '0') then	--L eye
--							case sig_Resol is
--								when "111111111111" =>		--4096
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 1;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "011111111111" =>		--2048
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 2;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "001111111111" =>		--1024
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 4;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000111111111" =>		--512
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 8;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000011111111" =>		--256
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 16;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000001111111" =>		--128
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 32;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when "000000111111" =>		-- 64
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 64;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--								when others =>				--1024
--									sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - 4;
--									sig_Circle_Scan_D_out_time <= sig_Circle_Scan_D_out_time + 1;
--									
--							end case;
--						end if;
--					end if;
--				end if;
----			elsif(sig_Mode_sel = const_Mode_Radial_Scan ) then
----				if( CURRENT_STATE = Circle_Scan_Run ) then
----				--バックスキャン時のアドレスカウンターのインクリメント数はScan時のものと同じにする
----				--ただしHsyncの数がライン数x2に達したらステートがする (const_Radial_Scan_Total_Num : 6bit)
----					if( sig_L_R = '1' ) then		--R eye
----						sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress + const_Radial_Scan_Address_Inc;
----					elsif( sig_L_R = '0' ) then	--L eye
----						sig_Circle_Scan_Rdaddress <= sig_Circle_Scan_Rdaddress - const_Radial_Scan_Address_Inc;
----					end if;
----				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Scan_Run_End
U_Circle_Scan_Run_End :
process( Reset, FPGAclk ) begin
	if( Reset = '1' ) then
		sig_Circle_Scan_Run_End <= '0';
	elsif( FPGAclk'event and FPGAclk = '1' ) then
		if( CURRENT_STATE = Circle_Scan_Run ) then
			if( HSYNC_END = '1' ) then
				sig_Circle_Scan_Run_End <= '1';
			end if;
		else
			sig_Circle_Scan_Run_End <= '0';
		end if;
	end if;
end process;

------------------------------------------------------------------------------------------
--XY座標生成モジュール
	U_Circle_Scan_Comp_Sin_Cos_XY : Comp_Sin_Cos_XY port map(
		FPGAclk				=> FPGAclk,
		Reset				=> sig_Reset,
		Gal_clk_fall_edge	=> Gal_clk_fall_edge,
		RAM_CONST_DATA 	=> reg_ram_const_data ,
		RAM_CONST_ADR  	=> reg_ram_const_adr  ,
		COS_TABLE_EN	=> reg_cos_table_en,
		SIN_TABLE_EN	=> reg_sin_table_en,
		Rdaddress		=> sig_Comp_Sin_Cos_XY_Rdaddress,	--sig_Circle_Scan_Rdaddress,
		Circle_R		=> sig_Circle_R,
		Start_X			=> sig_Comp_Sin_Cos_XY_Start_X,		--sig_Circle_Scan_Current_Start_X,
		Start_Y			=> sig_Comp_Sin_Cos_XY_Start_Y,		--sig_Circle_Scan_Current_Start_Y,
--		ROMclk			=> n_Gal_clk,
		ROM_EN			=> sig_Comp_Sin_Cos_XY_ROM_EN,		--sig_Circle_Scan_ROM_EN,
--		L_R				=> sig_L_R,
		X_DATA			=> sig_Comp_Sin_Cos_X_out,			--sig_Circle_Scan_X,
		Y_DATA			=> sig_Comp_Sin_Cos_Y_out			--sig_Circle_Scan_Y
	);

------------------------------------------------------------------------------------------
--アドレス/データセレクタ
	process( Reset, FPGAclk) begin
		if( Reset='1') then		--20070626TS
			sig_Comp_Sin_Cos_XY_Rdaddress <= (others=>'1');
			sig_Comp_Sin_Cos_XY_Start_X   <= (others=>'0');
			sig_Comp_Sin_Cos_XY_Start_Y   <= (others=>'0');
			sig_Comp_Sin_Cos_XY_ROM_EN    <= '0';
			sig_Radial_Scan_X             <= (others=>'0');
			sig_Radial_Scan_Y             <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = INITIAL)then
				sig_Comp_Sin_Cos_XY_Rdaddress <= (others=>'1');
				sig_Comp_Sin_Cos_XY_Start_X   <= (others=>'0');
				sig_Comp_Sin_Cos_XY_Start_Y   <= (others=>'0');
				sig_Comp_Sin_Cos_XY_ROM_EN    <= '0';
				sig_Radial_Scan_X             <= (others=>'0');
				sig_Radial_Scan_Y             <= (others=>'0');
			else
				case CURRENT_STATE is
					when Circle_Scan_Run =>	--
						sig_Comp_Sin_Cos_XY_Rdaddress <= sig_Circle_Scan_Rdaddress;
						sig_Comp_Sin_Cos_XY_Start_X   <= sig_Circle_Scan_Current_Start_X;
						sig_Comp_Sin_Cos_XY_Start_Y   <= sig_Circle_Scan_Current_Start_Y;
						sig_Comp_Sin_Cos_XY_ROM_EN    <= sig_Circle_Scan_ROM_EN;
					when others => 
						sig_Comp_Sin_Cos_XY_Rdaddress <= (others=>'1');
						sig_Comp_Sin_Cos_XY_Start_X   <= (others=>'0');
						sig_Comp_Sin_Cos_XY_Start_Y   <= (others=>'0');
						sig_Comp_Sin_Cos_XY_ROM_EN    <= '0';
						sig_Radial_Scan_X             <= (others=>'0');
						sig_Radial_Scan_Y             <= (others=>'0');
				end case;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Scan_ROM_EN--------------------------------------------------
	U_Circle_Scan_ROM_EN :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_Circle_Scan_ROM_EN <= '0';
		elsif( FPGAclk'event and FPGAclk = '1') then
--			if( CURRENT_STATE = Live_Circle_Run or CURRENT_STATE = Circle_Scan_Run) then
			if(  CURRENT_STATE = Circle_Scan_Run) then

				sig_Circle_Scan_ROM_EN <= '1';
			else
				sig_Circle_Scan_ROM_EN <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal cnt_Circle_Scan_Dummy_Data
--	U_cnt_Circle_Scan_Dummy_Data :
--	process(
--		Reset,
--		CURRENT_STATE,
--		n_Gal_clk
--	) begin
--		if(
--			Reset = '1'
--			or
--			CURRENT_STATE = INITIAL
--			or
--			CURRENT_STATE = Circle_Scan_Wait_S
--		) then
--			cnt_Circle_Scan_Dummy_Data <= (others=>'0');
--		elsif( n_Gal_clk'event and n_Gal_clk = '1') then
--			if(sig_Circle_Scan_ROM_EN = '1') then
--				if( cnt_Circle_Scan_Dummy_Data = "11") then		--20070329TS
--					cnt_Circle_Scan_Dummy_Data <= cnt_Circle_Scan_Dummy_Data;		--count stop		--20070329TS
--				else		--20070329TS
--					cnt_Circle_Scan_Dummy_Data <= cnt_Circle_Scan_Dummy_Data + '1';
--				end if;
--			end if;
--		end if;
--	end process;

	process( Reset, FPGAclk) begin
		if( Reset = '1' )then
			cnt_Circle_Scan_Dummy_Data <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( CURRENT_STATE = INITIAL or CURRENT_STATE = Circle_Scan_Wait_S)then
				cnt_Circle_Scan_Dummy_Data <= (others=>'0');
			elsif( Gal_clk_rise_edge = '1' )then
				if( cnt_Circle_Scan_Dummy_Data = "10" )then
					cnt_Circle_Scan_Dummy_Data <= cnt_Circle_Scan_Dummy_Data;
				else
					cnt_Circle_Scan_Dummy_Data <= cnt_Circle_Scan_Dummy_Data + '1';
				end if;
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--	U_Circle_Scan_Data_Out_EN :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_Circle_Scan_Data_Out_EN_Wait <= (others=>'0');
--		elsif( FPGAclk'event and FPGAclk = '0') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_Circle_Scan_Data_Out_EN_Wait <= (others=>'0');
--			else
--				if( cnt_Circle_Scan_Dummy_Data = "10") then
--					sig_Circle_Scan_Data_Out_EN_Wait(0) <= '1';
--					for i in 1 to 3 loop
--						sig_Circle_Scan_Data_Out_EN_Wait(i) <= sig_Circle_Scan_Data_Out_EN_Wait(i-1);
--					end loop;
--				elsif( CURRENT_STATE = Circle_Scan_Wait_S) then
--
--					sig_Circle_Scan_Data_Out_EN_Wait <= (others=>'0');
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
	sig_Circle_Scan_Data_Out_EN <= '1' when (cnt_Circle_Scan_Dummy_Data = "10") else '0'; 

------------------------------------------------------------------------------------------
--Internal signal sig_Circle_Scan_X/Y_out
	U_Circle_Scan_XY_out :
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_Circle_Scan_X_out <= (others=>'0');
			sig_Circle_Scan_Y_out <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( sig_Circle_Scan_Data_Out_EN = '1' ) then
				sig_Circle_Scan_X_out <= sig_Comp_Sin_Cos_X_out;
				sig_Circle_Scan_Y_out <= sig_Comp_Sin_Cos_Y_out;
			else
				sig_Circle_Scan_X_out <= sig_Circle_Scan_Current_Start_X;
				sig_Circle_Scan_Y_out <= sig_Circle_Scan_Current_Start_Y;
			end if;
		end if;
	end process;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 0011 C-Scan
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

--**************************************************************************************--
-- STATE_= C_Scan
--**************************************************************************************--
------------------------------------------------------------------------------------------
--sig_Resol_Y
--Y方向解像度
	U_Y_Resol :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Resol_Y <= "010000000000";		--1024
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_Resol_Y <= "010000000000";		--1024
		end if;
	end process;

------------------------------------------------------------------------------------------
----sig_V_H_3D
----スキャン方向
----00:横  01:縦  10:横->縦  11:縦->横
--	U_V_H_3D :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_V_H_3D <= (others=>'0');
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if( CURRENT_STATE = INITIAL)then
--				sig_V_H_3D <= (others=>'0');
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--**************************************************************************************--
-- STATE_= C_Scan_Move_Next_Pos
--**************************************************************************************--
--	U_V_H_3D_count :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then		--20070626TS
--			sig_V_H_3D_count <= (others => '0');
--		elsif( FPGAclk'event and FPGAclk= '1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_V_H_3D_count <= (others => '0');
--			else
--				if( CURRENT_STATE = END_MOVE) then
--					sig_V_H_3D_count <= (others => '0');
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

--BackScan_Busy_out
--バックスキャン中フラグ
--	U_BackScan_Busy_out :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			sig_BackScan_Busy_out <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE = INITIAL or CURRENT_STATE = END_MOVE)then
--				sig_BackScan_Busy_out <= '0';
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--	BackScan_Busy_out <= sig_BackScan_Busy_out;



------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--Internal signal const_Radial_Scan_Line_Total_Num
--Radial_Scan_Numより下記の値をセット
--１．スキャン本数
--２．アドレスカウンタのインクリメント数
--３．左目(L)の際のアドレスカウンタ初期値(右目のときは0から)
	U_Radial_Scan_Line_Total_Num :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			const_Radial_Scan_Total_Num <= "0000010";					--2		20070330TS
			const_Radial_Scan_Address_Inc <= "010000000000";			--1024	20070330TS
			const_Radial_Scan_Address_R_Init <= (others=>'0');			--0		20070330TS
			const_Radial_Scan_Address_L_Init <= "100000000000";			--2048	20070330TS
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(CURRENT_STATE = INITIAL)then
				const_Radial_Scan_Total_Num <= "0000010";					--2		20070330TS
				const_Radial_Scan_Address_Inc <= "010000000000";			--1024	20070330TS
				const_Radial_Scan_Address_R_Init <= (others=>'0');			--0		20070330TS
				const_Radial_Scan_Address_L_Init <= "100000000000";			--2048	20070330TS
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_Radial_Scan_Current_Num
--現在のスキャン本数をカウント
--	U_Radial_Scan_Current_Num :
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_Radial_Scan_Current_Num <= (others => '0');
--		elsif( FPGAclk'event and FPGAclk = '1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_Radial_Scan_Current_Num <= (others => '0');
--			elsif( CURRENT_STATE = END_MOVE) then
--				sig_Radial_Scan_Current_Num <= (others => '0');
--			else
--				if( CURRENT_STATE = Radial_Scan_Wait_S) then
--					sig_Radial_Scan_Current_Num <= sig_Radial_Scan_Current_Num + 1;
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 0101 Multi-Circle-Scan		del 20081023TS
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 0110 Web-Scan (Concentric-Circle-Scan)
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Circle_live／ Line_liveの切り替えフラグ		--20070330TS
--	U_sig_Web_Live_Sel :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			sig_Web_Live_Sel <= '0';		--0:Circle_Live 1:Line_Live
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE=INITIAL)then
--				sig_Web_Live_Sel <= '0';		--0:Circle_Live 1:Line_Live
--			else
--				sig_Web_Live_Sel <= Web_Live_Sel;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--Internal signal sig_Concentric_Circle_Scan_Current_Num		--20070330TS
--現在のスキャン本数をカウント
	U_Concentric_Circle_Scan_Current_Num :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Concentric_Circle_Scan_Current_Num <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if( CURRENT_STATE = INITIAL or CURRENT_STATE = END_MOVE) then
				sig_Concentric_Circle_Scan_Current_Num <= (others => '0');
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Internal signal Conc_Circle_Scan_Calc_End		--20070330TS
--半径、スタート座標計算終了フラグ
	U_Conc_Circle_Scan_Calc_End :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then 
			Conc_Circle_Scan_Calc_End <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = INITIAL)then
				Conc_Circle_Scan_Calc_End <= '0';
			else
				if( cnt_CC_Calc(4) = '1') then
					Conc_Circle_Scan_Calc_End <= '1';
				else
					Conc_Circle_Scan_Calc_End <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Internal signal cnt_CC_Calc	5bit		--20070330TS
--計算に必要な時間だけカウント
	U_cnt_CC_Calc :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			cnt_CC_Calc <= (others=>'0');
		elsif(
			FPGAclk'event and FPGAclk='1'
		) then
			if(CURRENT_STATE = INITIAL)then
				cnt_CC_Calc <= (others=>'0');
--			else
--				if( CURRENT_STATE = Concentric_Circle_Scan_Run) then
--					cnt_CC_Calc(0) <= '1';
--					cnt_CC_Calc(4 downto 1) <= cnt_CC_Calc(3 downto 0);
--				else
--					cnt_CC_Calc <= (others=>'0');
--				end if;
			end if;
		end if;
	end process;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--Mode 0111 Raster-Scan (Concentric-Circle-Scan)
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
------------------------------------------------------------------------------------------
--Internal signal sig_Raster_Scan_Run_Now-----------------------------		--20070622TS
--Raster_Scan中のフラグ
	U_Raster_Scan_Run_Now :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_Raster_Scan_Run_Now <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = INITIAL)then
				sig_Raster_Scan_Run_Now <= '0';
			else
				if( sig_Mode_sel = const_Mode_Raster_Scan and sig_CAP_START = '1') then
					sig_Raster_Scan_Run_Now <= '1';	
				else
					sig_Raster_Scan_Run_Now <= '0';	
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------

--**************************************************************************************--
--*****************************  Generate CAP_START ************************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
--	--CAP_START入力信号をラッチする
--	--使いたいタイミングで信号がアサートされているとは限らない為、入力信号のデータを
--	--を保持する目的でラッチする
--	--ただし、クリア条件をしっかりと検証すること
--	U_CAP_START_Latch :
--	process( Reset, FPGAclk) begin		--20061027YN
--		if( Reset='1') then
--			sig_CAP_START_Latch <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then		--20070403TS
--			if(CURRENT_STATE=END_MOVE)then
--				sig_CAP_START_Latch <= '0';
--			else 
--				sig_CAP_START_Latch <= CAP_START;
--			--	else
--			--		値保持		--20090304YN_2
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_CAP_START
	U_CAP_START :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_CAP_START <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE=END_MOVE)then
				sig_CAP_START <= '0';
			else
				if( sig_CAP_START_Latch = '1') then
					if(	CURRENT_STATE = INITIAL) then
						--上記ステートの時、アサートする
							sig_CAP_START <= '1';
					end if;
				else
					if( CURRENT_STATE = INITIAL or
						CURRENT_STATE = END_MOVE or
						CURRENT_STATE = B_Scan_Wait_E or
						CURRENT_STATE = Circle_Scan_Wait_E) then		--20080408YN test
						--上記ステートの時、クリアする
						sig_CAP_START <= '0';
					--	else
					--		値保持		--20090304YN_2
					end if;
				end if;
			--	else
			--		値保持		--20090304YN_2
			end if;
		end if;
	end process;

--**************************************************************************************--
--*****************************  Generate START_3D  ************************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
--Internal signal sig_START_3D
--3D-Scanにおいてキャプチャースタート後の本スキャン開始のトリガになる
--START_3DがHになるまではスタート位置(最上位)でLive-Scanを行なう
--	U_START_3D_Latch :
--	process(
--		Reset,
--		START_3D,
--		CURRENT_STATE
--	) begin
--		if(
--			Reset='1'
--			or
--			CURRENT_STATE=END_MOVE
--		) then
--			sig_START_3D_Latch <= '0';
--		elsif(
--			START_3D'event and START_3D='1'
--		) then
--			sig_START_3D_Latch <= '1';
--		end if;
--	end process;

------------------------------------------------------------------------------------------

--**************************************************************************************--
--*****************************   Generate TRIG_EN  ************************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
--Internal signal sig_TRIG_EN
--sig_TRIG_EN
--	U_TRIG_EN :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			sig_TRIG_EN <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_TRIG_EN <= '0';
--			else
--				case sig_Mode_sel is
--					--------------------------------------------
--					when const_Mode_B_Scan => 
--						if( sig_B_Scan_Run_Now = '1' and CURRENT_STATE=B_Scan_Run) then
--							sig_TRIG_EN <= '1';
--						elsif( CURRENT_STATE=END_MOVE or CURRENT_STATE=END_MOVE_CSTM) then
--							sig_TRIG_EN <= '0';
--						end if;
--					--------------------------------------------
--					when const_Mode_Circle_Scan =>
--						if( sig_Circle_Scan_Run_Now = '1' and CURRENT_STATE=Circle_Scan_Run) then
--							sig_TRIG_EN <= '1';
--						elsif( CURRENT_STATE=END_MOVE or CURRENT_STATE=END_MOVE_CSTM) then
--							sig_TRIG_EN <= '0';
--						end if;
--					--------------------------------------------
--					--------------------------------------------
--					when others =>
--							--
--				end case;
--			end if;
--		end if;
--	end process;

--**************************************************************************************--
--******************************	Generate  Gal clk   ********************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
----------------------	Gal_CLK_RISE
--Gal_clkカウントイネーブル
--Internal signal reg_Gal_clk_en ( Gal_clk count  ENABLE )
	U_reg_Gal_clk_en :
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			reg_Gal_clk_en <= '0';
		elsif( FPGAclk'event and FPGAclk= '1' ) then
			case CURRENT_STATE is
				when B_Scan_Run			=> reg_Gal_clk_en <= '1';
				when Circle_Scan_Run	=> reg_Gal_clk_en <= '1';
				when others 			=> reg_Gal_clk_en <= '0';
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Gal_clk立ち上がり用カウンタ
	U_Gal_clk_RISE_COUNTER :
	process( RESET, FPGAclk)begin
		if( Reset = '1') then
			reg_Gal_clk <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(sig_Gal_clk_RISE = '1')then
				reg_Gal_clk <= (others=>'0');
			else
				if( reg_Gal_clk_en = '1') then
					reg_Gal_clk <= reg_Gal_clk + 1;
				else
					reg_Gal_clk <= (others=>'0');
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	--carry out 
	carry_reg_Gal_clk_RISE <= '1' when reg_Gal_clk = sig_Hsync_T - 2 else '0';

------------------------------------------------------------------------------------------
	--FF out sig_Gal_clk_RISE
	U_sig_Hsync_RISE :
	process( RESET, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_Gal_clk_RISE <= '0';
		elsif( FPGAclk'event and FPGAclk = '1' ) then
			if( carry_reg_Gal_clk_RISE = '1' ) then
				sig_Gal_clk_RISE <= '1';
			else
				sig_Gal_clk_RISE <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------
--Gal_clk立ち下がり用シグナル
--Gal_clk立ち下がり用カウンタ
	U_count_Gal_clk_FALL :
	process( RESET, FPGAclk) begin
		if( Reset = '1') then
			reg_Gal_clk_FALL <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk = '1') then
			if(sig_Gal_clk_FALL = '1')then
				reg_Gal_clk_FALL <= (others=>'0');
			else
				if( sig_Gal_clk_FALL_COUNT_EN = '1') then
					reg_Gal_clk_FALL <= reg_Gal_clk_FALL + 1;
				else
					reg_Gal_clk_FALL <= (others=>'0');
				end if;
			end if;
		end if;	
	end process;

------------------------------------------------------------------------------------------
--カウントイネーブル
	U_sig_Gal_clk_FALL_COUNT_EN :
	process( RESET, FPGAclk) begin
		if( Reset = '1') then
			sig_Gal_clk_FALL_COUNT_EN <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(sig_Gal_clk_FALL = '1')then
				sig_Gal_clk_FALL_COUNT_EN <= '0';
			else
				if( sig_Gal_clk_RISE = '1') then
					sig_Gal_clk_FALL_COUNT_EN <= '1';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--carry out
	carry_reg_Gal_clk_FALL	<= '1' when reg_Gal_clk_FALL = sig_Freq_Count - 1 else '0'; 

------------------------------------------------------------------------------------------
--FF out sig_Gal_clk_FALL
	U_sig_Hsync_FALL :
	process( RESET,FPGAclk) begin
		if( Reset = '1' ) then
			sig_Gal_clk_FALL <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( carry_reg_Gal_clk_FALL='1' ) then
				sig_Gal_clk_FALL <= '1';
			else
				sig_Gal_clk_FALL <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------
--Hsync out sync FPGAclk
	U_sig_Gal_clk :
	process( RESET, FPGAclk ) begin
		if( Reset = '1' ) then
			Gal_clk <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( sig_Gal_clk_RISE = '1' ) then
				Gal_clk <= '1';
			elsif( sig_Gal_clk_FALL = '1' ) then
				Gal_clk <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	n_Gal_clk <= not Gal_clk;

	Gal_clk_rise_edge <= ( Gal_clk and not Gal_clk_d );
	Gal_clk_fall_edge <= ( Gal_clk_d and not Gal_clk );

--**************************************************************************************--
--********************	Galvano Control Signal Output		****************************--
----------------------	X_Galvano							------------------------------
--**************************************************************************************--
------------------------------------------------------------------------------------------
	U_X_galv :
	process( Reset, FPGAclk ) begin
		if( Reset='1' ) then
			sig_X_galv <= const_Galv_center_X;
		elsif( FPGAclk'event and FPGAclk='1' ) then
			case CURRENT_STATE is
				when SET_UP		=> sig_X_galv <= const_Galv_center_X;
				when INITIAL	=> sig_X_galv <= const_Galv_center_X;
				--Live_Line
				--B_Scan
				when B_Scan		=>	if(
										sig_Mode_Sel = const_Mode_B_Scan
									) then
										sig_X_galv <= sig_Start_X;			--200070625TS
									else
										sig_X_galv <= sig_X_galv_out;		--200070625TS
									end if;
				when B_Scan_RAM_Write	=> sig_X_galv <= sig_X_galv_out;
				when B_Scan_Wait_S		=> sig_X_galv <= sig_X_galv_out;
				when B_Scan_Run			=> sig_X_galv <= sig_B_Scan_X_out;
				when B_Scan_Wait_E		=> sig_X_galv <= sig_X_galv_out;
				when B_Scan_Back		=> sig_X_galv <= sig_galv_back_pos_x;
				--Circle_Scan
				when Circle_Scan			=> sig_X_galv <= sig_X_galv_out;
				when Circle_Scan_Wait_S		=> sig_X_galv <= sig_X_galv_out;
				when Circle_Scan_Run		=> sig_X_galv <= sig_Circle_Scan_X_out;
					--del 20081023TS
				--when Move_Start_Pos			=> sig_X_galv <= sig_Start_X;
				when Move_Start_Pos			=> 
					if(sig_Mode_sel = const_Mode_Circle_Scan) then			--サークルのときは通常
						sig_X_galv <= sig_Start_X;
					else
						sig_X_galv <= sig_galv_back_pos_x;
					end if;
				when Move_Center_Pos		=> sig_X_galv <= const_Galv_center_X;

				when END_MOVE_WAIT			=> sig_X_galv <= const_Galv_center_X;		--20090325YN

				when others =>
					--X_galv <= const_Galv_center_X;
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--FF_OUT --2006/11/29  MEG Sato
--最後にFPGAclkで叩きなおす。sig_X_galvは現在の座標を取得するのに使用
	U_X_galv_out :
	process( Reset, FPGAclk ) begin
		if( Reset='1' ) then
			sig_X_galv_out <= const_Galv_center_X;
		elsif( FPGAclk'event and FPGAclk='1' ) then
			sig_X_galv_out <= sig_X_galv;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	X_galv <= sig_X_galv_out;

------------------------------------------------------------------------------------------
--PULSE_Mode		--20070902YN		--20071205YN
--Adjust_Mode追加		--20090417YN
	U_PULSE_Mode_X :
	process( FPGAclk, sig_PULSE_Mode, sig_SLD_M_Pos, sig_Adjust_Mode ) begin
		if( FPGAclk'event and FPGAclk='1' ) then

--			if( sig_PULSE_Mode='1') then
--				case sig_SLD_M_Pos is
--					when "0000"	=> X_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0001"	=> X_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0010"	=> X_galv <= B"1111_1111_1111";		--4095		--20090206YN
--					when "0011"	=> X_galv <= B"0000_0000_0000";		--0		--20090206YN
--					when "0100"	=> X_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0101"	=> X_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0110"	=> X_galv <= B"1111_1111_1111";		--4095		--20090206YN
--					when "0111"	=> X_galv <= B"0000_0000_0000";		--0		--20090206YN
--					when "1000"	=> X_galv <= B"1111_1111_1111";		--4095		--20090206YN
--					when "1001"	=> X_galv <= B"0000_0000_0000";		--0		--20090206YN
--					when others	=> X_galv <= B"0111_1111_1111";		--2047(Center)
--				end case;

			if( sig_Adjust_Mode='1' ) then
				X_galv <= sig_GalvX_Adjust;
			else		--Normal Mode
				X_galv <= sig_X_galv_out;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_GalvX_Adjust :		--20090417YN
	process( Reset, FPGAclk) begin
		if( Reset='1' ) then
			sig_GalvX_Adjust <= X"7FF";		--center
		elsif( FPGAclk'event and FPGAclk='1' ) then
			sig_GalvX_Adjust <= GalvX_Adjust;
		end if;
	end process;

------------------------------------------------------------------------------------------
----------------------	Y_Galvano							------------------------------
	U_Y_galv :
	process(Reset, FPGAclk ) begin
		if( Reset='1' ) then
			sig_Y_galv <= const_Galv_center_Y;
		elsif( FPGAclk'event and FPGAclk='1' ) then
			case CURRENT_STATE is
				when SET_UP			=> sig_Y_galv <= const_Galv_center_Y;
				when INITIAL		=> sig_Y_galv <= const_Galv_center_Y;
				--B_Scan
				when B_Scan		=>	if( sig_Mode_sel = const_Mode_B_Scan ) then
										sig_Y_galv <= sig_Start_Y;			--20070625TS
									else
										sig_Y_galv <= sig_Y_galv_out;		--20070625TS
									end if;
				when B_Scan_RAM_Write	=> sig_Y_galv <= sig_Y_galv_out;
				when B_Scan_Wait_S		=> sig_Y_galv <= sig_Y_galv_out;
				when B_Scan_Run			=> sig_Y_galv <= sig_B_Scan_Y_out;
				when B_Scan_Wait_E		=> sig_Y_galv <= sig_Y_galv_out;
				when B_Scan_Back		=> sig_Y_galv <= sig_galv_back_pos_y;
										
				--Circle_Scan
				when Circle_Scan			=> sig_Y_galv <= sig_Y_galv_out;
				when Circle_Scan_Wait_S		=> sig_Y_galv <= sig_Y_galv_out;
				when Circle_Scan_Run		=> sig_Y_galv <= sig_Circle_Scan_Y_out;
				--Radial_Scan
				--when Move_Start_Pos			=> sig_Y_galv <= sig_Start_Y;
				when Move_Start_Pos			=> 
					if(sig_Mode_sel = const_Mode_Circle_Scan) then
						sig_Y_galv <= sig_Start_Y;
					else 
						sig_Y_galv <= sig_galv_back_pos_y;
					end if;
				when Move_Center_Pos		=> sig_Y_galv <= const_Galv_center_Y;

				when END_MOVE_WAIT			=> sig_Y_galv <= const_Galv_center_Y;		--20090325YN

				when others =>
				 --Y_galv <= const_Galv_center_Y;
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--FF_OUT       --2006/11/29  MEG Sato
--最後にFPGAclkで叩きなおす。sig_X_galvは現在の座標を取得するのに使用
	U_Y_galv_out :
	process( Reset, FPGAclk) begin
		if( Reset='1' ) then
			sig_Y_galv_out <= const_Galv_center_Y;
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_Y_galv_out <= sig_Y_galv;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	Y_galv <= sig_Y_galv_out;

------------------------------------------------------------------------------------------
--PULSE_Mode		--20070902YN		--20071205YN
--Adjust_Mode追加		--20090417YN
	U_PULSE_Mode_Y :
	process( FPGAclk, sig_PULSE_Mode, sig_SLD_M_Pos, sig_Adjust_Mode ) begin
		if( FPGAclk'event and FPGAclk='1' ) then

--			if( sig_PULSE_Mode='1' ) then
--				case sig_SLD_M_Pos is
----					when "0000"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN		--20090409YN
--					when "0000"	=> Y_galv <= B"1111_1111_1111";		--4095		--20090206YN		--20090409YN
--					when "0010"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0011"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0100"	=> Y_galv <= B"1111_1111_1111";		--4095		--20090206YN
--					when "0101"	=> Y_galv <= B"0000_0000_0000";		--0		--20090206YN
--					when "0110"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "0111"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "1000"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when "1001"	=> Y_galv <= B"0111_1111_1111";		--2047(Center)		--20090206YN
--					when others	=> Y_galv <= B"0111_1111_1111";		--2047(Center)
--				end case;

			if( sig_Adjust_Mode='1' ) then
				Y_galv <= sig_GalvY_Adjust;
			else		--Normal Mode
				Y_galv <= sig_Y_galv_out;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_GalvY_Adjust :		
	process( Reset, FPGAclk ) begin
		if( Reset='1' ) then
			sig_GalvY_Adjust <= X"7FF";		--center
		elsif( FPGAclk'event and FPGAclk='1' ) then
			sig_GalvY_Adjust <= GalvY_Adjust;
		end if;
	end process;

--**************************************************************************************--
--***************************   generate Hsync   ***************************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
--	U_comp_VHsync_gen : comp_VHsync_gen port map(		--20070404TS
--		Reset			=> Reset,
--		FPGAclk			=> FPGAclk,
--		Gal_clk			=> n_Gal_clk,
--		Hsync_T			=> sig_Hsync_T,
--		VH_Gen_EN		=> sig_VH_Gen_EN,
--		TRIG_EN			=> sig_TRIG_EN,
--		LIVE_B_F_CNT	=> CSTM_LIVE_B_F_CNT,
--		LIVE_B_ENABLE	=> CSTM_LIVE_B_ENABLE,
--		OVER_SCAN			=> OVER_SCAN,
--		OVER_SCAN_DLY_TIME	=> OVER_SCAN_DLY_TIME,
--		Hsync			=> open,
--		Vsync			=> open,
--		TRIG			=> sig_TRIG,
--		SLD_Gen_EN		=> sig_SLD_Gen_EN,
--		RetryFlag1_EN	=> sig_RetryFlag1_EN,		--20090326YN_1
--		RetryFlag2_EN	=> sig_RetryFlag2_EN,		--20090326YN_1
--		RetryFlag1		=> sig_RetryFlag1,		--20090326YN_1
--		RetryFlag2		=> sig_RetryFlag2,		--20090326YN_1
--		Galv_run		=> sig_Galv_run	,				--20100415MN
--		Vsync_RISE_EN	=> sig_Vsync_RISE_EN		--20090326YN_1
--	);




	process(Reset, FPGAclk) begin
		if( Reset = '1') then
			vh_gen_en_ff <= '0';
			Gal_clk_d	 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			Gal_clk_d <= Gal_clk;
			if( sig_VH_Gen_EN = '1' )then
				if( Gal_clk_d = '0' and Gal_clk = '1' )then
					vh_gen_en_ff <= '1';
				end if;
			else 
				vh_gen_en_ff <= '0';
			end if;
		end if;
	end process;

	VH_GEN_EN_OUT <= vh_gen_en_ff;

--	track_cnt_live <= ('0' &( sig_Live_Resol + 2)) - V_END_WAIT_CNT;
	track_cnt_scan <= ('0' &( sig_Resol      + 2)) - V_END_WAIT_CNT;
	
--	U_comp_sync_gen : comp_sync_gen port map(
--		Reset 				=> Reset,
--		FPGAclk 		    => FPGAclk,
--		VH_GEN_EN		    => vh_gen_en_ff,
--		VH_SYNC_PERIOD	    => vh_sync_period(12 downto 0) + OVER_SCAN_DLY_TIME(12 downto 0),
--		HSYNC_NUM			=> sig_Hsync_num(12 downto 0),
--		HSYNC_T			    => sig_Hsync_T(11 downto 0),
--		TRACK_CNT_LIVE		=> track_cnt_live,
--		TRACK_CNT_SCAN		=> track_cnt_scan,
--		OUT_VSYNC		    => sig_Vsync,
--		OUT_HSYNC		    => sig_Hsync,
--		OUT_VHSYNC		    => sig_vhsync,
--		OUT_HSYNC_END		=> hsync_end,
--		OUT_TRACK_LiVE_EN	=> sig_tracking_Live_EN,
--		OUT_TRACK_EN        => sig_tracking_EN
--	);
	
------------------------------------------------------------------------------------------

--comp_VHsync_gen イネーブル信号
	U_sig_VH_Gen_EN :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_VH_Gen_EN <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(	CURRENT_STATE = B_Scan_Run 			or
				CURRENT_STATE = Circle_Scan_Run 	or
				CURRENT_STATE = V_SYNC_RUN				 ) then
				sig_VH_Gen_EN <= '1';
			else
					if(sig_VH_Gen_En_ext = '1')then
						sig_VH_Gen_EN <= '1';
					else
						sig_VH_Gen_EN <= '0';
					end if;
			end if;
		end if;
	end process;


--50kか27kか判断
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
		elsif( FPGAclk'event and FPGAclk='1') then
			if(sig_Freq_Sel < B"0_0011_1100")then
				cam_50k <= '0';
			else
				cam_50k <= '1';
			end if;
		end if;
	end process;

--comp_VHsync_gen 1回余分に打つため用
	U_VH_Gen_EN_ext :
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_VH_Gen_EN_ext <= '0';
			sig_Hsync_d <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_Hsync_d <= HSYNC;
			if( CURRENT_STATE = B_Scan_Run 			or
				CURRENT_STATE = Circle_Scan_Run 	) then
				sig_VH_Gen_EN_ext <= '1';
			elsif( sig_Hsync_negEdge = '1' )then
				sig_VH_Gen_EN_ext <= '0';
			end if;
		end if;
	end process;

	sig_Hsync_negEdge <= sig_Hsync_d and not HSYNC;

------------------------------------------------------------------------------------------
--V-Syncだけ出力モードのときの1V終了フラグ
--使っていない
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_vsync_run_cnt_end <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if( hsync_cnt = B"0_0001_0000_0000")then
--				sig_vsync_run_cnt_end <= '1';
--			else
--				sig_vsync_run_cnt_end <= '0';
--			end if;
--		end if;
--	end process;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--Hsyncの出力Enable
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_hsync_out_en <= '1';
		elsif( FPGAclk'event and FPGAclk='1') then
			if(CURRENT_STATE = V_SYNC_RUN)then
				sig_hsync_out_en <= '0';
			else
					sig_hsync_out_en <= '1';
			end if;
		end if;
	end process;
--**************************************************************************************--
--********************	 Signal Output						****************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
------------------------	H-Sync							------------------------------
--	Hsync_out <= sig_Hsync;

------------------------------------------------------------------------------------------
------------------------	V-Sync							------------------------------
--	Vsync_out <= sig_Vsync;

------------------------------------------------------------------------------------------
------------------------	VH-Sync							------------------------------
--	VH_sync_out <= sig_vhsync;

------------------------------------------------------------------------------------------
------------------------	TRIG							------------------------------
--	TRIG <= sig_TRIG;

------------------------------------------------------------------------------------------
------------------------	RetryFlag1		20090326YN_1	------------------------------
--RetryFlag1：
--MARKⅡとOCT-2kとで機能が異なる
--【MARkⅡ】
--Live-Scan時の奇数本目／偶数本目のフラグ	--0：even／1：odd･･･初期値：0
--【OCT-2k】
--Live-Scan時の1本目のフラグ	--１本目のときアサートする（High_Active）
--カスタム画像ボードへ出力（該当するbitへ埋め込む）
--アサートするタイミングはV-Syncよりも数CLKは前であること。
--
--	RetryFlag1_OUT <= sig_RetryFlag1;
--	RetryFlag2_OUT <= sig_RetryFlag2;

------------------------------------------------------------------------------------------
------------------------	RetryFlag2		20090326YN_1	------------------------------
--**************************************************************************************--
--********************	Galvano Busy Flag Output			****************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
----2006/05/19 TRIG信号立ち上がり時に出力するように変更
--	U_Busy_out :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			Busy_out <= '0';
--		elsif( FPGAclk'event and FPGAclk='0') then
--			if(CURRENT_STATE = INITIAL)then
--				Busy_out <= '0';
--			else
--				if( CURRENT_STATE = END_MOVE )then
--					Busy_out <= '0';
--				else
--					if( sig_TRIG = '1') then
--						Busy_out <= '1';
--					--	else
--					--		値保持	20070626TS
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;

---**************************************************************************************--
---**************************************************************************************--
----------------------	V-Sync_End_Flag_OUT					------------------------------20070329TS
---**************************************************************************************--
------------------------------------------------------------------------------------------
--20080410YN tracking
--	U_V_End_Flag_OUT :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			V_End_Flag_OUT <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE = INITIAL)then
--				V_End_Flag_OUT <= '0';
--			else
--				if( cnt_1ms = "000000000000001") then		--カウント開始でH
--					V_End_Flag_OUT <= '1';
--				elsif( cnt_1ms = "100111000100001") then		--カウント規定値(20,001=1ms)でL
--					V_End_Flag_OUT <= '0';
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
----------------------	1ms Counter							------------------------------20070329TS
--カウントイネーブル生成
	--20080410YN
--	U_1ms_counter_enable :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			sig_count_1ms_en <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if( sig_CAP_START = '1') then
--				if( sig_tracking_EN ='1') then
--					sig_count_1ms_en <= '1';
--				elsif( cnt_1ms = "100111000100001") then		--カウント規定値(20,001=1ms)でクリア
--					sig_count_1ms_en <= '0';
--				--	else
--				--		値保持	20070626TS
--				end if;
--			else
--				if( sig_tracking_Live_EN ='1') then
--					sig_count_1ms_en <= '1';
--				elsif( cnt_1ms = "100111000100001") then		--カウント規定値(20,001=1ms)でクリア
--					sig_count_1ms_en <= '0';
--				--	else
--				--		値保持	20070626TS
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--1ms Counter
--	U_1ms_counter :
--	process(
--		Reset,
--		FPGAclk
--	) begin
--		if(
--			Reset='1'
--		) then
--			cnt_1ms <= (others=>'0');
--		elsif(
--			FPGAclk'event and FPGAclk='1'
--		) then
--			if(
--				sig_count_1ms_en = '1'
--			) then		--Hの間だけカウント
--				cnt_1ms	<= cnt_1ms + '1';
--			else
--				cnt_1ms <= (others=>'0');		--それ以外は０
--			end if;
--		end if;
--	end process;

---**************************************************************************************--
----------------------	SLD_Pulse					-----------------------------20070329TS
---**************************************************************************************--
------------------------------------------------------------------------------------------

--	U_comp_SLD_gen : comp_SLD_gen port map(
--		Reset			=> Reset,
--		FPGAclk			=> FPGAclk,
--		SLD_ON_OFF		=> SLD_ON_OFF,
--		PULSE_ON_OFF	=> PULSE_ON_OFF,
--		SLD_Delay		=> SLD_Delay,
--		PULSE_Width		=> PULSE_Width,
--		HSYNC_IN		=> sig_Hsync,
--		OUT_SLD_PULSE	=> sig_SLD
--		);


------------------------------------------------------------------------------------------
--U_sig_Delay_Sel
--sig_Delay_Sel <= '1';	--1:5us 固定


------------------------------------------------------------------------------------------
----------------------	SLD_signal output					------------------------------
--	SLD_out <= sig_SLD;


----------------------	SLD_Gen_En output					------------------------------
--	U_SLD_Gen_En :
--	process( Reset, FPGAclk) begin
--		if( Reset='1') then
--			SLD_Gen_EN          <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--				if(cstm_LiveScanNOW_Flag = '1') then
--					SLD_Gen_EN <= not sig_SLD_Gen_EN;
--				else
--					SLD_Gen_EN <= '0';
--				end if;
--		end if;
--	end process;
------------------------------------------------------------------------------------------
--Adjust_Mode set		--20090417YN
	U_sig_Adjust_Mode :
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_Adjust_Mode <= '0';		--Normal Mode
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_Adjust_Mode <= Adjust_Mode;
		end if;
	end process;

------------------------------------------------------------------------------------------
----------------------	PULSE_Mode set						------------------------------
--	U_sig_PULSE_Mode :
--	process( Reset, FPGAclk) begin	--20070902YN
--		if( Reset='1') then
--			sig_PULSE_Mode <= '0';					--NORMAL Mode
--		elsif( FPGAclk'event and FPGAclk='1') then
--			sig_PULSE_Mode <= PULSE_Mode;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
----------------------	sig_SLD_M_Pos set					------------------------------
--	U_sig_SLD_M_Pos :
--	process( Reset, FPGAclk) begin		--20071205YN
--		if(Reset='1') then
--			sig_SLD_M_Pos <= "0001";		-- センター位置		--20090206YN
--		elsif( FPGAclk'event and FPGAclk='1') then
--			sig_SLD_M_Pos <= SLD_M_Pos;
--		end if;
--	end process;

---**************************************************************************************--
----------------------	MOVE_END_out						------------------------------
---**************************************************************************************--
------------------------------------------------------------------------------------------
--200810321TS
--カスタムスキャンモジュールへ出力
	U_CSTM_MOVE_END_out :
	process( Reset, FPGAclk ) begin
		if( Reset='1' ) then
			CSTM_MOVE_END_out <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( CURRENT_STATE = END_MOVE_CSTM ) then
				CSTM_MOVE_END_out <= '1';
			else
				CSTM_MOVE_END_out <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_cnt_CSTM_MOVE_END :
	process( Reset,FPGAclk ) begin
		if(Reset ='1') then
			cnt_CSTM_MOVE_END <= (others=>'0');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( CURRENT_STATE = END_MOVE_CSTM ) then
				if(cnt_CSTM_MOVE_END = "1100") then
					cnt_CSTM_MOVE_END <= (others=>'0');
				else
					cnt_CSTM_MOVE_END <= cnt_CSTM_MOVE_END + 1;
				end if;
			else
				--クリア
				cnt_CSTM_MOVE_END <= (others=>'0');
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_CSTM_MOVE_END_END :
	process( Reset, FPGAclk ) begin
		if( Reset ='1' ) then
			sig_CSTM_MOVE_END_END <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( cnt_CSTM_MOVE_END = "1100" ) then
				sig_CSTM_MOVE_END_END <= '1';
			else
				sig_CSTM_MOVE_END_END <= '0';
			end if;
		end if;
	end process;

--**************************************************************************************--
----------------------	Generate RetryFlag		20090326YN_1	--------------------------
--**************************************************************************************--
--	signal sig_RetryFlag1	: std_logic;
--	signal sig_RetryFlag2	: std_logic;
------------------------------------------------------------------------------------------
--	U_sig_RetryFlag1_ON_OFF :		--20090406YN
--	process( Reset, FPGAclk) begin
--		if( Reset = '1') then
--			sig_RetryFlag1_ON_OFF <= '0';		--20090421YN
--		elsif(	FPGAclk'event and FPGAclk='1'	) then		--20090421YN
--			if(CURRENT_STATE = SET_UP)then
--				sig_RetryFlag1_ON_OFF <= '0';		--20090421YN
--			else
--				sig_RetryFlag1_ON_OFF <= RetryFlag1_ON_OFF;		--20090421YN
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Internal signal sig_RetryFlag1_EN		--20090326YN_1
--	U_sig_RetryFlag1_EN :
--	process( Reset, FPGAclk) begin
--		if( Reset='1' ) then
--			sig_RetryFlag1_EN <= '0';
--			sig_RetryFlag2_EN <= '0';
--		elsif( FPGAclk'event and FPGAclk='1') then
--			if(CURRENT_STATE = INITIAL)then
--				sig_RetryFlag1_EN <= '0';
--				sig_RetryFlag2_EN <= '0';
--			else 
--				if( CSTM_LIVE_B_ONOFF = '1')then
--					if( Custom_Scan_On = '1') then
--						if	( CURRENT_STATE = B_Scan_Run 	or
--						  	CURRENT_STATE = Circle_Scan_Run	) then
--							if( LiveBRetry1 = '1' and LiveBRetry2 = '1')then -- Live B Start
--								sig_RetryFlag1_EN <= '1';
--								sig_RetryFlag2_EN <= '1';
--							elsif( LiveBRetry1 = '1' and LiveBRetry2 = '0')then -- Live B 
--								sig_RetryFlag1_EN <= '0';
--								sig_RetryFlag2_EN <= '1';
--							elsif( LiveBRetry1 = '0' and LiveBRetry2 = '1')then -- Live B Start
--								sig_RetryFlag1_EN <= '1';
--								sig_RetryFlag2_EN <= '1';
--							else
--								sig_RetryFlag1_EN <= '0';
--								sig_RetryFlag2_EN <= '0';
--							end if;
--						else
--							sig_RetryFlag1_EN <= '0';
--							sig_RetryFlag2_EN <= '0';
--						end if;
--					else
--						sig_RetryFlag1_EN <= '0';
--						sig_RetryFlag2_EN <= '0';
--					end if;
--				else
--					if( Custom_Scan_On = '1') then
--						if(	( CURRENT_STATE = B_Scan_Run 	or
--						  	CURRENT_STATE = Circle_Scan_Run	) 	) then
--							sig_RetryFlag2_EN <= sig_RetryFlag2_ON_OFF;
--						else
--							sig_RetryFlag2_EN <= '0';
--						end if;
--						if( cstm_cnt_Live = "0000" 				and		--1本目のLive-Scan
--							cstm_LiveScanNOW_Flag = '1' 		and		--ライブ中
--							( CURRENT_STATE = B_Scan_Run 	or
--						  	CURRENT_STATE = Circle_Scan_Run	) 	) then
--							sig_RetryFlag1_EN <= sig_RetryFlag1_ON_OFF;
--						else
--							sig_RetryFlag1_EN <= '0';
--						end if;
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--Live-Scan本数をカウント		--20090326YN_1
--	U_cnt_VsyncLive :
--	process(
--		Reset,
--		CURRENT_STATE,
--		sig_CAP_START,
--		sig_Vsync_RISE_EN
--	) begin
--		if(
--			Reset='1'
--			or
--			CURRENT_STATE = INITIAL
--			or
--			sig_CAP_START='1'
--		) then
--			cnt_VsyncLive <= '0';
--
--		elsif(
--			sig_Vsync_RISE_EN'event and sig_Vsync_RISE_EN='1'
--		) then
--
--			cnt_VsyncLive <= not cnt_VsyncLive;
--
--		--else不要
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--	U_sig_RetryFlag2_ON_OFF :		--20090406YN
--	process(
--		Reset,
--		CURRENT_STATE,		--20090421YN
--		FPGAclk,
--		RetryFlag2_ON_OFF
--	) begin
--		if(
--			Reset = '1'
--			or		--20090421YN
--			CURRENT_STATE = SET_UP		--20090421YN
--		) then
--			sig_RetryFlag2_ON_OFF <= '0';
--
--		elsif(
--			FPGAclk'event and FPGAclk='1'
--		) then
--			sig_RetryFlag2_ON_OFF <= RetryFlag2_ON_OFF;
--
--		--else
--			--不要
--		end if;
--	end process;

--------------------------------------------------------------------------------------------
-- 往復スキャン対応
--------------------------------------------------------------------------------------------
	process( Reset, FPGAclk) begin
		if( Reset = '1')then
			cstm_param_en_d <= (others =>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			cstm_param_en_d <= cstm_param_en_d(0) & cstm_param_en;
		end if;
	end process;

END GAL_CON_architecture;
