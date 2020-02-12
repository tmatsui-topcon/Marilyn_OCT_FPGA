--**************************************************************************************--
--********************	Library declaration part			****************************--
--**************************************************************************************--
LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
ENTITY comp_CustomScan IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		FPGAclk				: IN STD_LOGIC;		--20MHz
		Reset				: IN STD_LOGIC;
		nPON_RESET			: IN STD_LOGIC;
--		L_R					: IN STD_LOGIC;
		Galv_run			: IN STD_LOGIC;
		CAP_START			: IN STD_LOGIC;
		nWE					: IN std_logic;
		-- データ・バス(入力)
		DataBusIn			: IN std_logic_vector(15 downto 0);
		-- 書き込みアドレス(入力)
		WR_ADDRES			: IN std_logic_vector(18 downto 0);
		CSTM_FLAG_WE		: IN std_logic;
		SCAN_NUM_WE			: IN std_logic;
		DUMMY_NUM_WE		: IN std_logic;
		BACK_SCAN_NUM_WE	: IN std_logic;
		LIVE_NUM_WE			: IN std_logic;
		L_Start_X_WE		: IN std_logic;
		L_Start_Y_WE		: IN std_logic;
		L_End_X_WE			: IN std_logic;
		L_End_Y_WE			: IN std_logic;
		L_Circle_R_WE		: IN std_logic;
		L_DIR_LINE_CIR_WE	: IN std_logic;
		DIR_LINE_CIR_WE		: IN std_logic;
		Start_X_WE			: IN std_logic;
		Start_Y_WE			: IN std_logic;
		End_X_WE			: IN std_logic;
		End_Y_WE			: IN std_logic;
		Dummy_DIR_LINE_CIR_WE		: IN std_logic;
		Back_Scan_DIR_LINE_CIR_WE	: IN std_logic;
		Dummy_Back_Data_WE	: IN std_logic;
		Galv_TRIG_in		: IN std_logic;
		GAL_CON_Busy_out	: IN std_logic;
		GAL_CON_MOVE_END_out: IN std_logic;
		CSTM_LIVE_A_X_RESO	: IN std_logic_vector(11 downto 0);
		CSTM_LIVE_B_X_RESO	: IN std_logic_vector(11 downto 0);
		CSTM_LIVE_B_CNT		: IN std_logic_vector(11 downto 0);
		CSTM_LIVE_B_RESO	: IN std_logic_vector(11 downto 0);
		CSTM_LIVE_B_PITCH	: IN std_logic_vector(15 downto 0); --: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		CSTM_LIVE_B_ONOFF	: IN std_logic;

		SCAN_SET_RUN_END_ALL: IN std_logic;
--		SCAN_SET_RUN_RET 	: IN std_logic;
--		SCAN_BACK_ADR		: IN std_logic_vector(11 downto 0);
		CIBT_ALMOST_FULL	: IN std_logic;
		ANGIO_SCAN			: IN std_logic;
		keisen_update 		: IN STD_LOGIC;
		keisen_update_num	: IN STD_LOGIC_VECTOR(11 downto 0);
		Repetition			: IN STD_LOGIC_VECTOR( 3 downto 0);
		CSTM_WR_ADR			: IN STD_LOGIC_VECTOR( 31 downto 0);
		CSTM_WR_DATA		: IN STD_LOGIC_VECTOR( 15 downto 0);
		CSTM_WR_EN			: IN STD_LOGIC;
		Resol				: IN STD_LOGIC_VECTOR(11 downto 0);
		Resol_CSTM			: IN STD_LOGIC_VECTOR(11 downto 0);
		Dum_Resol_CSTM		: IN STD_LOGIC_VECTOR(11 downto 0);
		Back_Resol_CSTM		: IN STD_LOGIC_VECTOR(11 downto 0);
		----------------------------------------------------------------------------------
		cstm_CSTM_FLAG		: OUT STD_LOGIC;
--		cstm_L_R			: OUT STD_LOGIC;
		cstm_Mode_Sel		: OUT STD_LOGIC_VECTOR(3 downto 0);
		cstm_Galv_run		: OUT STD_LOGIC;
--		cstm_CAP_START		: OUT STD_LOGIC;
--		cstm_INT_CAP_START	: OUT STD_LOGIC;
		cstm_Start_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_Start_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_End_X			: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_End_Y			: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_Circle_R		: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_Circle_DIR		: OUT STD_LOGIC;
--		cstm_Live_Start_X	: OUT STD_LOGIC_VECTOR(11 downto 0);
--		cstm_Live_Start_Y	: OUT STD_LOGIC_VECTOR(11 downto 0);
--		cstm_Live_End_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
--		cstm_Live_End_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
--		cstm_Live_Circle_R	: OUT STD_LOGIC_VECTOR(11 downto 0);
		cstm_TRIG_EN		: OUT STD_LOGIC;

		cstm_LiveScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
--		cstm_DummyScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
		cstm_CapScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
		cstm_BackScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
		cstm_cnt_Live		: OUT STD_LOGIC_VECTOR(3 downto 0);	--20090323YN
		cstm_param_en		: OUT STD_LOGIC;
--		CSTM_LIVE_RESO		: OUT STD_LOGIC_VECTOR(11 downto 0);
		LIVE_B_ENABLE 		: OUT STD_LOGIC;
		LIVE_B_RETRY1		: OUT STD_LOGIC;
		LIVE_B_RETRY2		: OUT STD_LOGIC;
		keisenNO			: OUT STD_LOGIC_VECTOR(11 downto 0);
		CAPT_OFFSET_EN		: OUT STD_LOGIC;
		Scan_Run_Flag		: OUT STD_LOGIC;
		Resol_OUT			: OUT STD_LOGIC_VECTOR(11 downto 0)

	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END comp_CustomScan;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
ARCHITECTURE RTL OF comp_CustomScan IS

--**************************************************************************************--
--********************	Component definition part			****************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
	component alt_dp_ram_12bit1024W_start_01 IS
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
	component alt_dp_ram_12bit1024W_end_01 IS
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
	component alt_dp_ram_12bit256W_01 IS
	PORT
	(
 		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wrclock		: IN STD_LOGIC;
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

------------------------------------------------------------------------------------------
	component alt_dp_ram_2bit1024W_01 IS
	PORT
	(
 		data		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		wrclock		: IN STD_LOGIC;
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
	END COMPONENT;

	component mul_16x12 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (27 DOWNTO 0)
	);
	END COMPONENT;


--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	TYPE STATE_TYPE is (
							ST_INIT,
							ST_SETUP,
							ST_LIVE,
							ST_LIVE_B,
							ST_DUMMY_SCAN,
							ST_SCAN_RUN,
							ST_SCAN_SET_RUN,
							ST_SCAN_SET_INTERVAL,
							ST_SCAN_SET_WAIT_LAST,
							ST_BACK_SCAN,
							ST_SCAN_END,
							ST_ANGIO_LIVE
						);
	signal current_state : STATE_TYPE;
	signal next_state : STATE_TYPE;

	TYPE STATE_TRIG is (
							TRIG_IDLE,
							TRIG_EN,
							TRIG_WAIT_LIVE
						);
	signal trig_state : STATE_TRIG;
	signal Trig_en_tmp : std_logic;
------------------------------------------------------------------------------------------
	--スキャンXY座標	
	signal sig_Start_X_WD	: std_logic_vector(11 downto 0);	--Xスタート 書込みデータ
	signal sig_Start_X_WRA	: std_logic_vector(11 downto 0);	--Xスタート 書込みアドレス
	signal sig_Start_X_WE	: std_logic;					--Xスタート 書込みイネーブル
	signal sig_Start_X_RDA	: std_logic_vector(11 downto 0);	--Xスタート リードアドレス
	signal sig_Start_X_RE	: std_logic;						--Xスタート リードイネーブル
	signal sig_Start_X_RDATA: std_logic_vector(11 downto 0);	--Xスタート リードデータ

	signal sig_Start_Y_WD	: std_logic_vector(11 downto 0);	--Yタート 書込みデータ
	signal sig_Start_Y_WRA	: std_logic_vector(11 downto 0);	--Yスタート 書込みアドレス
	signal sig_Start_Y_WE	: std_logic;						--Yスタート 書込みイネーブル
	signal sig_Start_Y_RDA	: std_logic_vector(11 downto 0);	--Yスタート リードアドレス
	signal sig_Start_Y_RE	: std_logic;						--Yスタート リードイネーブル
	signal sig_Start_Y_RDATA: std_logic_vector(11 downto 0);	--Yスタート リードデ

	signal sig_End_X_WD		: std_logic_vector(11 downto 0);	--Xエンド 書込みデータ
	signal sig_End_X_WRA	: std_logic_vector(11 downto 0);	--Xエンド 書込みアドレス
	signal sig_End_X_WE		: std_logic;						--Xエンド 書込みイネーブル
	signal sig_End_X_RDA	: std_logic_vector(11 downto 0);	--Xエンド リードアドレス
	signal sig_End_X_RE		: std_logic;						--Xエンド リードイネーブル
	signal sig_End_X_RDATA	: std_logic_vector(11 downto 0);	--Xエンド リードデータ

	signal sig_End_Y_WD		: std_logic_vector(11 downto 0);	--Yエンド 書込みデータ
	signal sig_End_Y_WRA	: std_logic_vector(11 downto 0);	--Yエンド 書込みアドレス
	signal sig_End_Y_WE		: std_logic;						--Yエンド 書込みイネーブル
	signal sig_End_Y_RDA	: std_logic_vector(11 downto 0);	--Yエンド リードアドレス
	signal sig_End_Y_RE		: std_logic;						--Yエンド リードイネーブル
	signal sig_End_Y_RDATA	: std_logic_vector(11 downto 0);	--Yエンド リードデータ

--	signal sig_Circle_R		: std_logic_vector(11 downto 0);	--サークル半径 リードデータ

------------------------------------------------------------------------------------------
	--スキャンサークル回転方向&ラインorサークル
	signal sig_D_L_C_WD		: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal sig_D_L_C_RDA	: STD_LOGIC_VECTOR (11 DOWNTO 0);
	signal sig_D_L_C_RE		: STD_LOGIC;
 	signal sig_D_L_C_WRA	: STD_LOGIC_VECTOR (11 DOWNTO 0);
 	signal sig_D_L_C_WE		: STD_LOGIC;
	signal sig_D_L_C_RDATA	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal sig_Scan_Circle_Dir	: std_logic;					--サークル回転方向
	signal sig_Scan_L_C		: std_logic;

	signal sig_DM_BS_WD		: std_logic_vector(11 downto 0);	--Dummy & BackScan 書込みデータ
	signal sig_DM_BS_RE		: std_logic;						--Dummy & BackScan リードイネーブル
	signal sig_DM_BS_WRA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan 書込みアドレス
	
	signal reg_DM_BS_WRA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan 書込みアドレス
	signal cstm_wradr_ext	: std_logic_vector( 7 downto 0);	--Dummy & BackScan 書込みアドレス
	
	signal sig_Dummy_Back_Data_WE	: std_logic;				--Dummy & BackScan 書込みイネーブル
	signal sig_DM_BS_RDATA	: std_logic_vector(11 downto 0);	--Dummy & BackScan リードデータ
	signal sig_DM_BS_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
	signal sig_DM_BS_RDA_cnt: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレスカウンタ
--	signal reg_DM_BS_RDA_en	: std_logic_vector( 12 downto 0);	--Dummy & BackScan リードアドレスカウンタ
	signal reg_DM_BS_RDA_en	: std_logic_vector( 13 downto 0);	--Dummy & BackScan リードアドレスカウンタ

--	signal sig_Dummy_Xs_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_Dummy_Ys_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_Dummy_Xe_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_Dummy_Ye_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_Dummy_Cir_RDA: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_BackScan_Xs_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_BackScan_Ys_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_BackScan_Xe_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_BackScan_Ye_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス
--	signal sig_BackScan_Cir_RDA	: std_logic_vector( 7 downto 0);	--Dummy & BackScan リードアドレス

------------------------------------------------------------------------------------------
	signal sig_XY_ADDRESS	: std_logic_vector( 11 downto 0);	--Xスタート リードアドレス
	signal reg_CSTM_FLAG	: std_logic;	--カスタムスキャンフラグレジスタ 0:OFF 1:ON
	signal reg_SCAN_NUM		: std_logic_vector(11 downto 0);	--スキャン回数レジスタ
	signal reg_DUMMY_NUM	: std_logic_vector( 3 downto 0);	--ダミースキャン回数レジスタ
	signal reg_BACK_SCAN_NUM	: std_logic_vector( 3 downto 0);	--バックスキャン回数レジスタ
	signal reg_LIVE_NUM		: std_logic_vector( 3 downto 0);	--ライブ本数レジスタ [1-8]本

------------------------------------------------------------------------------------------
	--ダミー座標
	signal sig_Dummy_Xs		: std_logic_vector(11 downto 0);
	signal sig_Dummy_Ys		: std_logic_vector(11 downto 0);
	signal sig_Dummy_Xe		: std_logic_vector(11 downto 0);
	signal sig_Dummy_Ye		: std_logic_vector(11 downto 0);
	signal sig_Dummy_Circle_R	: std_logic_vector(11 downto 0);
	signal sig_Dummy_Circle_DIR	: std_logic;
	signal sig_DUMMY_L_C	: std_logic;

------------------------------------------------------------------------------------------
	--ライブスタートX座標
	signal sig_Live_Xs		: std_logic_vector(11 downto 0);
	signal reg_L_Start_X0	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X1	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X2	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X3	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X4	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X5	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X6	: std_logic_vector(11 downto 0);
	signal reg_L_Start_X7	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	--ライブスタートY座標
	signal sig_Live_Ys		: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y0	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y1	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y2	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y3	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y4	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y5	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y6	: std_logic_vector(11 downto 0);
	signal reg_L_Start_Y7	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	--ライブエンドX座標
	signal sig_Live_Xe	: std_logic_vector(11 downto 0);
	signal reg_L_End_X0	: std_logic_vector(11 downto 0);
	signal reg_L_End_X1	: std_logic_vector(11 downto 0);
	signal reg_L_End_X2	: std_logic_vector(11 downto 0);
	signal reg_L_End_X3	: std_logic_vector(11 downto 0);
	signal reg_L_End_X4	: std_logic_vector(11 downto 0);
	signal reg_L_End_X5	: std_logic_vector(11 downto 0);
	signal reg_L_End_X6	: std_logic_vector(11 downto 0);
	signal reg_L_End_X7	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	--ライブエンドY座標
	signal sig_Live_Ye	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y0	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y1	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y2	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y3	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y4	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y5	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y6	: std_logic_vector(11 downto 0);
	signal reg_L_End_Y7	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	--ライブサークル半径
	signal sig_Live_Circle	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R0	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R1	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R2	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R3	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R4	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R5	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R6	: std_logic_vector(11 downto 0);
	signal reg_L_Circle_R7	: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	--ライブサークル回転方向
	signal sig_Live_Circle_DIR	: std_logic;
	signal reg_L_Circle_DIR0	: std_logic;
	signal reg_L_Circle_DIR1	: std_logic;
	signal reg_L_Circle_DIR2	: std_logic;
	signal reg_L_Circle_DIR3	: std_logic;
	signal reg_L_Circle_DIR4	: std_logic;
	signal reg_L_Circle_DIR5	: std_logic;
	signal reg_L_Circle_DIR6	: std_logic;
	signal reg_L_Circle_DIR7	: std_logic;

------------------------------------------------------------------------------------------
	--ライブ ラインorサークル
	signal sig_LIVE_L_C		: std_logic;
	signal reg_LIVE_L_C0	: std_logic;
	signal reg_LIVE_L_C1	: std_logic;
	signal reg_LIVE_L_C2	: std_logic;
	signal reg_LIVE_L_C3	: std_logic;
	signal reg_LIVE_L_C4	: std_logic;
	signal reg_LIVE_L_C5	: std_logic;
	signal reg_LIVE_L_C6	: std_logic;
	signal reg_LIVE_L_C7	: std_logic;

------------------------------------------------------------------------------------------
	--ダミーサークル回転方向
	signal reg_Dummy_Circle_DIR0	: std_logic;
	signal reg_Dummy_Circle_DIR1	: std_logic;
	signal reg_Dummy_Circle_DIR2	: std_logic;
	signal reg_Dummy_Circle_DIR3	: std_logic;
	signal reg_Dummy_Circle_DIR4	: std_logic;
	signal reg_Dummy_Circle_DIR5	: std_logic;
	signal reg_Dummy_Circle_DIR6	: std_logic;
	signal reg_Dummy_Circle_DIR7	: std_logic;
	signal reg_Dummy_Circle_DIR8	: std_logic;
	signal reg_Dummy_Circle_DIR9	: std_logic;
	signal reg_Dummy_Circle_DIR10	: std_logic;
	signal reg_Dummy_Circle_DIR11	: std_logic;
	signal reg_Dummy_Circle_DIR12	: std_logic;
	signal reg_Dummy_Circle_DIR13	: std_logic;
	signal reg_Dummy_Circle_DIR14	: std_logic;

------------------------------------------------------------------------------------------
	--ダミーLine/Circle
	signal reg_Dummy_L_C0	: std_logic;
	signal reg_Dummy_L_C1	: std_logic;
	signal reg_Dummy_L_C2	: std_logic;
	signal reg_Dummy_L_C3	: std_logic;
	signal reg_Dummy_L_C4	: std_logic;
	signal reg_Dummy_L_C5	: std_logic;
	signal reg_Dummy_L_C6	: std_logic;
	signal reg_Dummy_L_C7	: std_logic;
	signal reg_Dummy_L_C8	: std_logic;
	signal reg_Dummy_L_C9	: std_logic;
	signal reg_Dummy_L_C10	: std_logic;
	signal reg_Dummy_L_C11	: std_logic;
	signal reg_Dummy_L_C12	: std_logic;
	signal reg_Dummy_L_C13	: std_logic;
	signal reg_Dummy_L_C14	: std_logic;

------------------------------------------------------------------------------------------
	--バックスキャン座標
	signal sig_Back_Xs		: std_logic_vector(11 downto 0);
	signal sig_Back_Ys		: std_logic_vector(11 downto 0);
	signal sig_Back_Xe		: std_logic_vector(11 downto 0);
	signal sig_Back_Ye		: std_logic_vector(11 downto 0);
	signal sig_Back_Circle_R: std_logic_vector(11 downto 0);

------------------------------------------------------------------------------------------
	signal sig_Live_Flag		:std_logic;
	signal reg_Live_Flag_1d		:std_logic;
	signal reg_Live_Flag_2d		:std_logic;
	signal sig_Dummy_Flag		:std_logic;
	signal sig_Scan_Run_Flag	:std_logic;
	signal sig_Back_Scan_Flag	:std_logic;

------------------------------------------------------------------------------------------
	signal cnt_Live			: std_logic_vector(3 downto 0);
	signal cnt_Dummy		: std_logic_vector(3 downto 0);
	signal cnt_Scan_Run		: std_logic_vector(11 downto 0);
	signal cnt_Back_Scan	: std_logic_vector(4 downto 0);

------------------------------------------------------------------------------------------
	signal cstm_Reset		: std_logic;
	signal reg_CAP_START	: std_logic;
	signal sig_CAP_START	: std_logic;
	signal sig_CAP_START_OUT	: std_logic;
	signal sig_Shift_Galv_TRIG_in0	: std_logic;
	signal sig_Shift_Galv_TRIG_in1	: std_logic;
	signal sig_Reset_Trig_EN		: std_logic;

------------------------------------------------------------------------------------------
	signal sig_DUMMY_SCAN_END	: std_logic;
	signal sig_SCAN_RUN_END		: std_logic;
--	signal sig_SCAN_RUN_END2	: std_logic;
	signal sig_BACK_SCAN_END	: std_logic;

------------------------------------------------------------------------------------------
	signal INIT_RESET	: std_logic;
	signal SET_UP_RESET	: std_logic;

------------------------------------------------------------------------------------------
--	signal sig_cstm_TRIG_EN_0	: std_logic;
	signal sig_cstm_TRIG_EN		: std_logic;

------------------------------------------------------------------------------------------
	signal sig_LiveScanNow		: std_logic;		--20090323YN
	signal sig_DummyScanNow		: std_logic;		--20090323YN
	signal sig_CapScanNow		: std_logic;		--20090323YN
	signal sig_BackScanNow		: std_logic;		--20090323YN

	signal	reg_Live_cnt_d  	: std_logic_vector(3 downto 0);
	signal	reg_Dummy_flag_1d 	: std_logic;
	signal	reg_Scan_flag_d  	: std_logic_vector(3 downto 0);
	signal	reg_Back_flag_1d  	: std_logic;
	signal	reg_data_en 		: std_logic;
	signal 	reg_dm_bs_end	 	: std_logic;
	signal 	reg_dm_bs_end_pre 	: std_logic;

	signal	GAL_CON_MOVE_END_out_1d: std_logic;
	signal	GAL_CON_MOVE_END_out_2d: std_logic;
	signal	GAL_CON_MOVE_END_out_3d: std_logic;
	signal	GAL_CON_MOVE_END_out_4d: std_logic;
	signal	GAL_CON_MOVE_END_out_5d: std_logic;
	signal	GAL_CON_MOVE_END_out_6d: std_logic;
	signal	GAL_CON_MOVE_END_out_7d: std_logic;
------------------------------------------------------------------------------------------
	signal	sig_Live_A_End : std_logic;
	signal	sig_Live_B_End : std_logic;
	signal	sig_cnt_live_b : std_logic_vector(11 downto 0);
	signal	sig_cnt_live_b_reso : std_logic_vector(11 downto 0);
	signal	cnt_live_b : std_logic_vector(11 downto 0);
	signal	cnt_live_b_reso : std_logic_vector(11 downto 0);
	signal	sig_live_b_y : std_logic_vector(27 downto 0);
	signal	sig_LiveResol : std_logic_vector(11 downto 0);
	signal 	move_end_get_flg : std_logic;
	signal	sig_live_b_y_out : std_logic_vector(12 downto 0);
--	signal sig_debug : std_logic_vector( 2 downto 0);

	signal  GAL_MOVE_pedge    : std_logic;
	signal  GAL_MOVE_pedge_1d : std_logic;
	signal  GAL_MOVE_pedge_2d : std_logic;
	signal  GAL_MOVE_pedge_3d : std_logic;

	signal  sig_SCAN_SET_RUN_END_ALL : std_logic;
	signal	sig_CIBT_ALMOST_FULL	: std_logic;

	signal	cnt_scan_run_update : std_logic;
	signal	cnt_scan_run_update_num : std_logic_vector( 11 downto 0 );
	signal	keisen_num_offset : std_logic_vector( 11 downto 0 );
	signal	cnt_Rep			  : std_logic_vector( 3 downto 0);

	signal	reg_CSTM_FLAG_WE       			: std_logic;
	signal	reg_SCAN_NUM_WE        		    : std_logic;
	signal	reg_DUMMY_NUM_WE       		    : std_logic;
	signal	reg_BACK_SCAN_NUM_WE   		    : std_logic;
	signal	reg_LIVE_NUM_WE        		    : std_logic;
	signal	reg_L_Start_X_WE       		    : std_logic;
	signal	reg_L_Start_Y_WE       		    : std_logic;
	signal	reg_L_End_X_WE         		    : std_logic;
	signal	reg_L_End_Y_WE         		    : std_logic;
	signal	reg_L_Circle_R_WE      		    : std_logic;
	signal	reg_L_DIR_LINE_CIR_WE  		    : std_logic;
	signal	reg_DIR_LINE_CIR_WE    		    : std_logic;
	signal	reg_Start_X_WE         		    : std_logic;
	signal	reg_Start_Y_WE         		    : std_logic;
	signal	reg_End_X_WE           		    : std_logic;
	signal	reg_End_Y_WE           		    : std_logic;
	signal	reg_Dummy_DIR_LINE_CIR_WE       : std_logic;
	signal	reg_Back_Scan_DIR_LINE_CIR_WE   : std_logic;
	signal	reg_Dummy_Back_Data_WE          : std_logic;

	signal	cstm_wr_adr_ff					: std_logic_vector(18 downto 0);
	signal	cstm_wr_data_ff					: std_logic_vector(15 downto 0);

	signal	start_0							: std_logic;
	signal	start_1							: std_logic;
	signal	start_2							: std_logic;
	signal	start_3							: std_logic;
	signal	start_4							: std_logic;
	signal	start_5							: std_logic;
	signal	start_6							: std_logic;
	signal	start_7							: std_logic;
	signal	start_8							: std_logic;
	signal	start_9							: std_logic;
	signal	start_10							: std_logic;
	signal	start_11							: std_logic;
	signal	start_12							: std_logic;
	signal	start_13							: std_logic;
	signal	start_14							: std_logic;

	signal	l_start_x0_en					: std_logic;
	signal	l_start_x1_en					: std_logic;
	signal	l_start_x2_en					: std_logic;
	signal	l_start_x3_en					: std_logic;
	signal	l_start_x4_en					: std_logic;
	signal	l_start_x5_en					: std_logic;
	signal	l_start_x6_en					: std_logic;
	signal	l_start_x7_en					: std_logic;
	
	signal	l_start_y0_en					: std_logic;
	signal	l_start_y1_en					: std_logic;
	signal	l_start_y2_en					: std_logic;
	signal	l_start_y3_en					: std_logic;
	signal	l_start_y4_en					: std_logic;
	signal	l_start_y5_en					: std_logic;
	signal	l_start_y6_en					: std_logic;
	signal	l_start_y7_en					: std_logic;
	
	signal	l_end_x0_en					: std_logic;
	signal	l_end_x1_en					: std_logic;
	signal	l_end_x2_en					: std_logic;
	signal	l_end_x3_en					: std_logic;
	signal	l_end_x4_en					: std_logic;
	signal	l_end_x5_en					: std_logic;
	signal	l_end_x6_en					: std_logic;
	signal	l_end_x7_en					: std_logic;
	
	signal	l_end_y0_en					: std_logic;
	signal	l_end_y1_en					: std_logic;
	signal	l_end_y2_en					: std_logic;
	signal	l_end_y3_en					: std_logic;
	signal	l_end_y4_en					: std_logic;
	signal	l_end_y5_en					: std_logic;
	signal	l_end_y6_en					: std_logic;
	signal	l_end_y7_en					: std_logic;
	
	signal	l_circle_r0_en				: std_logic;
	signal	l_circle_r1_en				: std_logic;
	signal	l_circle_r2_en				: std_logic;
	signal	l_circle_r3_en				: std_logic;
	signal	l_circle_r4_en				: std_logic;
	signal	l_circle_r5_en				: std_logic;
	signal	l_circle_r6_en				: std_logic;
	signal	l_circle_r7_en				: std_logic;
	
	signal	l_circle_dir0_en			: std_logic;
	signal	l_circle_dir1_en			: std_logic;
	signal	l_circle_dir2_en			: std_logic;
	signal	l_circle_dir3_en			: std_logic;
	signal	l_circle_dir4_en			: std_logic;
	signal	l_circle_dir5_en			: std_logic;
	signal	l_circle_dir6_en			: std_logic;
	signal	l_circle_dir7_en			: std_logic;
	
	signal	dummy_circle_dir0_en		: std_logic;
	signal	dummy_circle_dir1_en		: std_logic;
	signal	dummy_circle_dir2_en		: std_logic;
	signal	dummy_circle_dir3_en		: std_logic;
	signal	dummy_circle_dir4_en		: std_logic;
	signal	dummy_circle_dir5_en		: std_logic;
	signal	dummy_circle_dir6_en		: std_logic;
	signal	dummy_circle_dir7_en		: std_logic;
	signal	dummy_circle_dir8_en		: std_logic;
	signal	dummy_circle_dir9_en		: std_logic;
	signal	dummy_circle_dir10_en		: std_logic;
	signal	dummy_circle_dir11_en		: std_logic;
	signal	dummy_circle_dir12_en		: std_logic;
	signal	dummy_circle_dir13_en		: std_logic;
	signal	dummy_circle_dir14_en		: std_logic;
	
	signal	move_end_rise_edge			: std_logic;
	
----------------------	STATE declaration part				------------------------------
	-- X and Y Galvano control signal are generated with the same state

------------------------------------------------------------------------------------------
----------------------	Constant declaration part			------------------------------

------------------------------------------------------------------------------------------
----------------------	Internal signal definition part		------------------------------

------------------------------------------------------------------------------------------
--**************************************************************************************--
BEGIN


Scan_Run_Flag <= sig_Scan_Run_Flag;

------------------------------------------------------------------------------------------
--cstm_Reset <= Reset or (not reg_CSTM_FLAG) ;
--cstm_Reset <= Reset or INIT_RESET;

--**************************************************************************************--
--********************	DATA OUTPUT							****************************--
--**************************************************************************************--
------------------------------------------------------------------------------------------
cstm_Galv_run <= Galv_run;

------------------------------------------------------------------------------------------
--cstm_CAP_START <= sig_CAP_START_OUT;

------------------------------------------------------------------------------------------
--cstm_INT_CAP_START <= sig_CAP_START;

------------------------------------------------------------------------------------------
cstm_CSTM_FLAG <= reg_CSTM_FLAG;

------------------------------------------------------------------------------------------
cstm_param_en <= reg_data_en;

--**************************************************************************************--
--********************	STATE Machine						****************************--
--**************************************************************************************--






--	U_state_FF : process(Reset,cstm_Reset,FPGAclk)
--	begin
--		if(Reset = '1') then
--			current_state <= ST_INIT;
--		elsif rising_edge(FPGAclk) then
--			current_state <= next_state;
--		end if;
--	end process;

	U_state_machine :
--	process(
--		Reset,
--		FPGAclk,
--		sig_CAP_START,
--		current_state,
--		Galv_run,CAP_START,
--		sig_DUMMY_SCAN_END,
--		sig_SCAN_RUN_END,
--		sig_BACK_SCAN_END,
--		GAL_CON_MOVE_END_out
--	) begin

	process( Reset, FPGAclk) begin
 		if( Reset = '1') then
			current_state <= ST_INIT;
		elsif ( FPGAclk'event and FPGAclk='1') then
			case current_state is
			------------------------------------------------------------------------------
				when ST_INIT =>
						current_state <= ST_SETUP;
--						INIT_RESET <= '1';
						SET_UP_RESET <= '0';
			------------------------------------------------------------------------------
				--Galv_runがネゲートされた場合、このステートへ遷移する
				when ST_SETUP =>
					if(Galv_run = '1' and sig_CAP_START = '1' )then
						current_state <= ST_SCAN_RUN;
					elsif(Galv_run = '1') then
						current_state <= ST_LIVE;
					else
						current_state <= ST_SETUP;
					end if;
					--各フラグをリセット	※レジスタの値はリセットしない
--					INIT_RESET <= '0';
					SET_UP_RESET <= '1';
			------------------------------------------------------------------------------
				when ST_LIVE =>
					if( Galv_run = '0' ) then
						current_state <= ST_SETUP;		--081222TS
					elsif( sig_CAP_START = '1' and GAL_CON_MOVE_END_out = '1' ) then
						if(reg_DUMMY_NUM /= "0000")then 
							current_state <= ST_DUMMY_SCAN;
						else
							current_state <= ST_SCAN_RUN;
						end if;
					elsif( sig_Live_A_End = '1' and CSTM_LIVE_B_ONOFF = '1')then
						current_state <= ST_LIVE_B;
					else
						current_state <= ST_LIVE;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			------------------------------------------------------------------------------
				when ST_LIVE_B =>
					if( Galv_run = '0') then
						current_state <= ST_SETUP;	
					elsif( sig_CAP_START = '1' and GAL_CON_MOVE_END_out = '1') then
						current_state <= ST_DUMMY_SCAN;
					elsif( CSTM_LIVE_B_ONOFF = '0' and GAL_CON_MOVE_END_out = '1') then
						current_state <= ST_LIVE;
					elsif( sig_Live_B_End = '1' )then
						current_state <= ST_LIVE;
					else
						current_state <= ST_LIVE_B;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			------------------------------------------------------------------------------
				when ST_DUMMY_SCAN =>
					if( Galv_run = '0' ) then
						current_state <= ST_SETUP;		--081222TS
					elsif( sig_DUMMY_SCAN_END = '1' ) then
						current_state <= ST_SCAN_RUN;
					else
						current_state <= ST_DUMMY_SCAN;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			------------------------------------------------------------------------------
				when ST_SCAN_RUN =>
					if( Galv_run = '0' ) then
						current_state <= ST_SETUP;		--081222TS
					elsif( sig_SCAN_RUN_END = '1' ) then
						if(reg_BACK_SCAN_NUM /= "0000") then
							current_state <= ST_BACK_SCAN;
						else
							current_state <= ST_SCAN_END;
						end if;
					elsif( sig_SCAN_SET_RUN_END_ALL = '1'and GAL_MOVE_pedge = '1')then
						current_state <= ST_SCAN_END;
					elsif( sig_CIBT_ALMOST_FULL = '1' and ANGIO_SCAN = '1' and GAL_MOVE_pedge = '1')then
						current_state <= ST_ANGIO_LIVE;
					else
						current_state <= ST_SCAN_RUN;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';

				when ST_ANGIO_LIVE =>
					if( Galv_run = '0') then
						current_state <= ST_SETUP;		--081222TS
					elsif( sig_CIBT_ALMOST_FULL = '0' and ANGIO_SCAN = '1' and GAL_MOVE_pedge = '1')then
						current_state <= ST_SCAN_RUN;
					end if;
--				when ST_SCAN_SET_RUN =>
--					if( Galv_run = '0') then
--						current_state <= ST_SETUP;		
--					elsif( sig_SCAN_RUN_END = '1') then
--						current_state <= ST_SCAN_SET_WAIT_LAST;		
--					elsif( sig_SCAN_SET_RUN_END = '1') then
--						current_state <= ST_SCAN_SET_INTERVAL;		
--					end if;
--				when ST_SCAN_SET_INTERVAL =>
--					if( Galv_run = '0') then
--						current_state <= ST_SETUP;		
--					else
--						if( GAL_CON_MOVE_END_out   ='0'	and GAL_CON_MOVE_END_out_1d='1'	and CIBT_ALMOST_FULL = '0')then
--							current_state <= ST_SCAN_SET_RUN;		
--						end if;
--					end if;
--
--				when ST_SCAN_SET_WAIT_LAST =>
--					if( Galv_run = '0') then
--						current_state <= ST_SETUP;		
--					elsif( SCAN_SET_RUN_END_ALL = '1')then
--						current_state <= ST_SCAN_END;
--					elsif( SCAN_SET_RUN_RET = '1' )then
--						current_state <= ST_SCAN_SET_RUN;		
--					end if;
			------------------------------------------------------------------------------
				when ST_BACK_SCAN =>
					if( Galv_run = '0' ) then
						current_state <= ST_SETUP;		--081222TS
					elsif( sig_BACK_SCAN_END = '1' ) then
						current_state <= ST_SCAN_END;
					else
						current_state <= ST_BACK_SCAN;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			------------------------------------------------------------------------------ 
				when ST_SCAN_END =>
					if( sig_CAP_START = '1' ) then
						if(reg_DUMMY_NUM /= "0000")then 
							current_state <= ST_DUMMY_SCAN;
						else
							current_state <= ST_SCAN_RUN;
						end if;
					else
						current_state <= ST_SETUP;
					end if;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			------------------------------------------------------------------------------
				when others =>
					current_state <= ST_SETUP;
--					INIT_RESET <= '0';
					SET_UP_RESET <= '0';
			end case;
		end if;
	end process;

	GAL_MOVE_pedge <= not GAL_CON_MOVE_END_out_1d  and GAL_CON_MOVE_END_out ;

--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset   = '1'  ) then
	process( Reset, FPGAclk) begin
		if( Reset   = '1'  ) then
			GAL_MOVE_pedge_1d <= '0';
			GAL_MOVE_pedge_2d <= '0';
			GAL_MOVE_pedge_3d <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			GAL_MOVE_pedge_1d <= GAL_MOVE_pedge ;
			GAL_MOVE_pedge_2d <= GAL_MOVE_pedge_1d ;
			GAL_MOVE_pedge_3d <= GAL_MOVE_pedge_2d ;
		end if;
	end process;

--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset   = '1'  ) then
	process( Reset, FPGAclk) begin
		if( Reset   = '1'  ) then
			sig_CIBT_ALMOST_FULL <= '0';
			sig_SCAN_SET_RUN_END_ALL <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			sig_CIBT_ALMOST_FULL <= CIBT_ALMOST_FULL;
			if( SCAN_SET_RUN_END_ALL = '1')then
				sig_SCAN_SET_RUN_END_ALL <= '1';
			elsif( current_state = ST_SCAN_END )then
				sig_SCAN_SET_RUN_END_ALL <= '0';
			end if;
		end if;
	end process;
------------------------------------------------------------------------------------------
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset   = '1'  ) then
	process( Reset, FPGAclk) begin
		if( Reset   = '1'  ) then
			sig_Live_A_End <= '0';
			sig_Live_B_End <= '0';
			sig_cnt_live_b <= (others => '0');
			sig_cnt_live_b_reso <= (others => '0');
			cnt_live_b 		<= (others => '0');
			cnt_live_b_reso <= (others => '0');
			move_end_get_flg <= '0';
			LIVE_B_ENABLE <= '0';
			LIVE_B_RETRY1 <= '0';
			LIVE_B_RETRY2 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_LIVE) then
			--	if( reg_data_en = '1'and GAL_CON_MOVE_END_out = '1') then
			--	if( GAL_CON_MOVE_END_out_1d = '0' and GAL_CON_MOVE_END_out = '1')then
				if( GAL_MOVE_pedge = '1' )then
					sig_Live_A_End <= '1';
				end if;
			else
				sig_Live_A_End <= '0';
			end if;

			if( current_state = ST_SETUP) then
				cnt_live_b 		<= CSTM_LIVE_B_CNT;
				cnt_live_b_reso <= CSTM_LIVE_B_RESO;
			elsif(current_state = ST_LIVE_B)then
				--if( GAL_CON_MOVE_END_out = '1' and GAL_CON_MOVE_END_out_1d = '0' )then
				if( GAL_MOVE_pedge = '1' )then
					if( cnt_live_b /= CSTM_LIVE_B_CNT )then
						cnt_live_b <= CSTM_LIVE_B_CNT;
					end if;
					if( cnt_live_b_reso /= CSTM_LIVE_B_RESO )then
						cnt_live_b_reso <= CSTM_LIVE_B_RESO;
					end if;
				end if;
			end if;

			if( current_state = ST_LIVE_B) then
				LIVE_B_ENABLE <= '1';
				LIVE_B_RETRY1 <= '1';
				if( sig_cnt_live_b_reso = X"000" )then
					LIVE_B_RETRY2 <= '1';
				else 
					LIVE_B_RETRY2 <= '0';
				end if;
			else
				LIVE_B_ENABLE <= '0';
				LIVE_B_RETRY1 <= '0';
				LIVE_B_RETRY2 <= '0';
			end if;
			if( current_state = ST_LIVE_B) then
				--if( GAL_CON_MOVE_END_out = '1' and reg_data_en = '1' and sig_cnt_live_b = cnt_live_b )then
				--if( GAL_CON_MOVE_END_out = '1' and GAL_CON_MOVE_END_out_1d = '0' and sig_cnt_live_b = cnt_live_b )then
				--if( GAL_MOVE_pedge = '1' and sig_cnt_live_b = cnt_live_b )then
				--if( reg_data_en = '1' and sig_cnt_live_b = cnt_live_b )then
				if( GAL_CON_MOVE_END_out_5d = '1' and GAL_CON_MOVE_END_out_6d = '0' and sig_cnt_live_b = (cnt_live_b + X"001") )then
					sig_Live_B_End <= '1';
				end if;
				--if( GAL_CON_MOVE_END_out = '1' and move_end_get_flg = '0') then
				--if(  GAL_CON_MOVE_END_out = '1' and GAL_CON_MOVE_END_out_1d = '0') then
				if( GAL_MOVE_pedge = '1' ) then
					move_end_get_flg <= '1';
					if( (cnt_live_b_reso   /= CSTM_LIVE_B_RESO)  or (cnt_live_b /= CSTM_LIVE_B_CNT) )then
						sig_cnt_live_b <= (others => '0');
					else
						sig_cnt_live_b <= sig_cnt_live_b + X"001";
					end if;
					
					if( (sig_cnt_live_b_reso = cnt_live_b_reso) or (cnt_live_b_reso /= CSTM_LIVE_B_RESO) or (cnt_live_b /= CSTM_LIVE_B_CNT))then
						sig_cnt_live_b_reso <= (others => '0');
					else
						sig_cnt_live_b_reso <= sig_cnt_live_b_reso + X"001";
					end if;
--				elsif( GAL_CON_MOVE_END_out = '0') then
--					move_end_get_flg <= '0';
				end if;
			else
				sig_Live_B_End <= '0';
				move_end_get_flg <= '0';
				sig_cnt_live_b <= (others => '0');
				if( CSTM_LIVE_B_ONOFF =  '0')then
					sig_cnt_live_b_reso <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	U_mul_16x12 : mul_16x12 port map (
		clock		=> FPGAclk,
		dataa		=> CSTM_LIVE_B_PITCH,--: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		=> sig_cnt_live_b_reso,
		result		=> sig_live_b_y
	);

	sig_live_b_y_out <= sig_live_b_y(16 downto 4) + sig_live_b_y(3);
------------------------------------------------------------------------------------------
--	Dummy_ON_OUT <= '1' when current_state = ST_DUMMY_SCAN else '0';
--	Scan_ON_OUT  <= '1' when current_state = ST_SCAN_RUN else '0';

------------------------------------------------------------------------------------------
	--Live_FLAG
	U_LIVE_FLAG:
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_Live_Flag <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SET_UP_RESET = '1') then
				sig_Live_Flag <= '0';
			else
				if( current_state = ST_LIVE or current_state = ST_LIVE_B) then
					sig_Live_Flag <= '1';
				else
					sig_Live_Flag <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	--DUMMY_FLAG
	U_DUMMY_FLAG :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1') then
	process( Reset, FPGAclk) begin
		if( Reset = '1') then
			sig_Dummy_Flag <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SET_UP_RESET = '1') then
				sig_Dummy_Flag <= '0';
			else
				if( current_state = ST_DUMMY_SCAN) then
					sig_Dummy_Flag <= '1';
				else
					sig_Dummy_Flag <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	--SCAN_RUN_FLAG
	U_SCAN_RUN_FLAG :
--	process( cstm_Reset, FPGAclk)begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk)begin
		if( Reset = '1' ) then
			sig_Scan_Run_Flag <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( SET_UP_RESET = '1') then
				sig_Scan_Run_Flag <= '0';
			else
				if( current_state = ST_SCAN_RUN) then
					sig_Scan_Run_Flag <= '1';
				else
					sig_Scan_Run_Flag <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	--BACK_SCAN_FLAG
	U_BACK_SCAN_FLAG :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_Back_Scan_Flag <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SET_UP_RESET = '1') then
				sig_Back_Scan_Flag <= '0';
			else 
				if( current_state = ST_BACK_SCAN) then
					sig_Back_Scan_Flag <= '1';
				else
					sig_Back_Scan_Flag <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Data Enable生成
	U_Data_Enable :
--	process( cstm_Reset, FPGAclk ) begin
--		if( cstm_Reset = '1') then
	process( Reset, FPGAclk ) begin
		if( Reset = '1') then
			reg_data_en       <= '0';
--			reg_Live_cnt_d    <= (others => '0');
			reg_Scan_flag_d   <= (others => '0');
			reg_Live_Flag_1d  <= '0';
			reg_Live_Flag_2d  <= '0';
			GAL_CON_MOVE_END_out_1d <= '0';
			GAL_CON_MOVE_END_out_2d <= '0';
			GAL_CON_MOVE_END_out_3d <= '0';
			GAL_CON_MOVE_END_out_4d <= '0';
			GAL_CON_MOVE_END_out_5d <= '0';
			GAL_CON_MOVE_END_out_6d <= '0';
			GAL_CON_MOVE_END_out_7d <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SET_UP_RESET = '1') then
				reg_data_en       <= '0';
--				reg_Live_cnt_d    <= (others => '0');
				reg_Scan_flag_d   <= (others => '0');
				reg_Live_Flag_1d  <= '0';
				reg_Live_Flag_2d  <= '0';
				GAL_CON_MOVE_END_out_1d <= '0';
				GAL_CON_MOVE_END_out_2d <= '0';
				GAL_CON_MOVE_END_out_3d <= '0';
				GAL_CON_MOVE_END_out_4d <= '0';
				GAL_CON_MOVE_END_out_5d <= '0';
				GAL_CON_MOVE_END_out_6d <= '0';
				GAL_CON_MOVE_END_out_7d <= '0';
			else
				GAL_CON_MOVE_END_out_1d <= GAL_CON_MOVE_END_out;
				GAL_CON_MOVE_END_out_2d <= GAL_CON_MOVE_END_out_1d;
				GAL_CON_MOVE_END_out_3d <= GAL_CON_MOVE_END_out_2d;
				GAL_CON_MOVE_END_out_4d <= GAL_CON_MOVE_END_out_3d;
				GAL_CON_MOVE_END_out_5d <= GAL_CON_MOVE_END_out_4d;
				GAL_CON_MOVE_END_out_6d <= GAL_CON_MOVE_END_out_5d;
				GAL_CON_MOVE_END_out_7d <= GAL_CON_MOVE_END_out_6d;
				reg_Live_Flag_1d  <= sig_Live_Flag;
				reg_Live_Flag_2d  <= reg_Live_Flag_1d;
				case current_state is
					when ST_LIVE			=>
--						reg_Live_cnt_d <= cnt_Live;
						reg_Scan_flag_d  <= (others => '0');
						if(reg_Live_Flag_2d = '0' and reg_Live_Flag_1d = '1') then
							reg_data_en <= '1';
						elsif(  GAL_MOVE_pedge_1d = '1')then
							reg_data_en <= '1';
						else 
							reg_data_en <= '0';
						end if;
					when ST_ANGIO_LIVE			=>
--						reg_Live_cnt_d <= cnt_Live;
						reg_Scan_flag_d  <= (others => '0');
						if(reg_Live_Flag_2d = '0' and reg_Live_Flag_1d = '1') then
							reg_data_en <= '1';
						elsif(  GAL_MOVE_pedge_1d = '1')then
							reg_data_en <= '1';
						else 
							reg_data_en <= '0';
						end if;
					when ST_LIVE_B			=>
						reg_Scan_flag_d  <= (others => '0');
						if( GAL_CON_MOVE_END_out_7d = '0' and GAL_CON_MOVE_END_out_6d = '1')then
							reg_data_en <= '1';
						else 
							reg_data_en <= '0';
						end if;
					when ST_DUMMY_SCAN		=>
						reg_data_en <= reg_dm_bs_end_pre;
						reg_Scan_flag_d  <= (others => '0');
					when ST_SCAN_RUN		=>
						reg_Scan_flag_d(0)          <= sig_Scan_Run_Flag;
						reg_Scan_flag_d(3 downto 1) <= reg_Scan_flag_d(2 downto 0);
						if(reg_Scan_flag_d(3) = '0' and reg_scan_flag_d(2) = '1') then
							reg_data_en <= '1';
						elsif( GAL_CON_MOVE_END_out_6d = '0' and GAL_CON_MOVE_END_out_5d = '1')then
							reg_data_en <= '1';
						else 
							reg_data_en <= '0';
						end if;
					when ST_BACK_SCAN		=>
						reg_data_en <= reg_dm_bs_end_pre;
						reg_Scan_flag_d  <= (others => '0');
					when others =>
						reg_data_en <= '0';
						reg_Scan_flag_d  <= (others => '0');
				end case;
			end if;
		end if;
	end process;
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--CAP制御 WRITE
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--カスタムスキャン中はガルバノコントローラへCAP信号を出力する
--ガルバノコントローラは常に本スキャン状態
--※ScanのたびにガルバノコントローラからTRIGが出力されるが
--  このモジュールで生成したTRIG_ENで出力するTRIGを選択する
--	U_CAP_START_OUT :
--	process( cstm_Reset, FPGAclk ) begin
--		if( cstm_Reset = '1' ) then
--			sig_CAP_START_OUT <= '0';
--		elsif( FPGAclk'event and FPGAclk='1' ) then
--			if( Galv_run = '1' ) then 
--				sig_CAP_START_OUT <= '1';
--			else
--				sig_CAP_START_OUT <= '0';
--			end if;
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--	U_FF_CAP_START :
--	process( cstm_Reset, FPGAclk, sig_Scan_Run_End, CAP_START, SET_UP_RESET ) begin
--		if( cstm_Reset = '1' or ( CAP_START='0' and SET_UP_RESET ='1' ) or ( CAP_START='0' 	and sig_Scan_Run_End = '1' )) then	
--			reg_CAP_START <= '0';
--		elsif( CAP_START'event and CAP_START='1' ) then
--			reg_CAP_START <= '1';
--		end if;
--	end process;

------------------------------------------------------------------------------------------
--	U_CAP_START : process(cstm_Reset,GAL_CON_MOVE_END_out,sig_Scan_Run_End,SET_UP_RESET) begin		--20090106YN
--	U_CAP_START :
--	process(
--		cstm_Reset,
--		GAL_CON_MOVE_END_out,
--		sig_Scan_Run_End,
--		SET_UP_RESET,
--		CAP_START
--	) begin		--20090106YN
--		if(
--			cstm_Reset = '1'
--			or
--			(
--				CAP_START='0'
--				and
--				SET_UP_RESET ='1'
--			)
--			or
--			(
--				CAP_START='0'
--				and
--				sig_Scan_Run_End = '1'
--			)
--		) then	--081226TS
--
--			sig_CAP_START <= '0';
--
--		elsif(
--			GAL_CON_MOVE_END_out'event and GAL_CON_MOVE_END_out='1'
--		) then
--			if(
----				reg_CAP_START = '1'
--			) then
--
--				sig_CAP_START <= '1';
--
--			end if;
--		end if;
--	end process;
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_CAP_START <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( CAP_START = '1' )then
				sig_CAP_START <= '1';
			elsif( sig_Scan_Run_End = '1' or SET_UP_RESET ='1')then
				sig_CAP_START <= '0';
			elsif( sig_SCAN_SET_RUN_END_ALL = '1') then
				if( GAL_MOVE_pedge = '1')then
					sig_CAP_START <= '0';
				end if;
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
	U_TRIG_EN :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_cstm_TRIG_EN <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_Reset_Trig_EN = '1')then
				sig_cstm_TRIG_EN <= '0';
			else
				if( current_state = ST_SCAN_RUN ) then
					sig_cstm_TRIG_EN <= '1';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_FF_SHIFT_Galv_TRIG_in0 :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			sig_Shift_Galv_TRIG_in0 <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			sig_Shift_Galv_TRIG_in0 <= Galv_TRIG_in;
		end if;
	end process;

------------------------------------------------------------------------------------------
	U_FF_SHIFT_Galv_TRIG_in1 :
--	process( cstm_Reset, FPGAclk ) begin
--		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
			sig_Shift_Galv_TRIG_in1 <= '0';
		elsif( FPGAclk'event and FPGAclk='1' ) then
			sig_Shift_Galv_TRIG_in1 <= sig_Shift_Galv_TRIG_in0;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	sig_Reset_Trig_EN <= (not Galv_TRIG_in) and sig_Shift_Galv_TRIG_in1;
	sig_Reset_Trig_EN <= sig_SCAN_RUN_END ;
------------------------------------------------------------------------------------------
	--cstm_TRIG_EN <= sig_cstm_TRIG_EN;
	cstm_TRIG_EN <= Trig_en_tmp;

	process( Reset, FPGAclk )begin
 		if( Reset = '1') then
			trig_state <= TRIG_IDLE;
		elsif ( FPGAclk'event and FPGAclk='1') then
			case trig_state is
				when TRIG_IDLE =>
					if( current_state = ST_SCAN_RUN )then
						trig_state <= TRIG_EN;
					end if;
				when TRIG_EN =>
					if( sig_SCAN_RUN_END = '1' ) then
						trig_state <= TRIG_WAIT_LIVE;
					elsif( sig_SCAN_SET_RUN_END_ALL = '1'and GAL_MOVE_pedge = '1')then
						trig_state <= TRIG_WAIT_LIVE;
					end if;
				when TRIG_WAIT_LIVE =>
					if( current_state = ST_LIVE )then
						trig_state <= TRIG_IDLE;
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;

	process( Reset, FPGAclk )begin
 		if( Reset = '1') then
			Trig_en_tmp <= '0';
		elsif ( FPGAclk'event and FPGAclk='1') then
			if( trig_state = TRIG_EN and current_state /= ST_ANGIO_LIVE )then
				Trig_en_tmp <= '1';
			else
				Trig_en_tmp <= '0';
			end if;
		end if;
	end process;


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--REGISTER WRITE
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

	--データWriteEnable生成
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_CSTM_FLAG_WE       			<= '0';
			reg_SCAN_NUM_WE        		    <= '0';
			reg_DUMMY_NUM_WE       		    <= '0';
			reg_BACK_SCAN_NUM_WE   		    <= '0';
			reg_LIVE_NUM_WE        		    <= '0';
			reg_L_Start_X_WE       		    <= '0';
			reg_L_Start_Y_WE       		    <= '0';
			reg_L_End_X_WE         		    <= '0';
			reg_L_End_Y_WE         		    <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( CSTM_WR_EN = '1' )then
				case CSTM_WR_ADR(23 downto 16) is
					when X"01" =>
						reg_CSTM_FLAG_WE 		<= '1';
					when X"02" =>
						reg_SCAN_NUM_WE 		<= '1';
					when X"03" =>
						reg_DUMMY_NUM_WE 		<= '1';
					when X"04" =>
						reg_BACK_SCAN_NUM_WE 	<= '1';
					when X"05" =>
						reg_LIVE_NUM_WE 		<= '1';
					when X"06" =>
						reg_L_Start_X_WE 		<= '1';
					when X"07" =>
						reg_L_Start_Y_WE 		<= '1';
					when X"08" =>
						reg_L_End_X_WE 			<= '1';
					when X"09" =>
						reg_L_End_Y_WE 			<= '1';
					when others =>
						null;
				end case;
			else
				reg_CSTM_FLAG_WE       		<= '0';
				reg_SCAN_NUM_WE        		<= '0';
				reg_DUMMY_NUM_WE       		<= '0';
				reg_BACK_SCAN_NUM_WE   		<= '0';
				reg_LIVE_NUM_WE        		<= '0';
				reg_L_Start_X_WE       		<= '0';
				reg_L_Start_Y_WE       		<= '0';
				reg_L_End_X_WE         		<= '0';
				reg_L_End_Y_WE         		<= '0';
			end if;
		end if;
	end process;


	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R_WE      		    <= '0';
			reg_L_DIR_LINE_CIR_WE  		    <= '0';
			reg_DIR_LINE_CIR_WE    		    <= '0';
			reg_Start_X_WE         		    <= '0';
			reg_Start_Y_WE         		    <= '0';
			reg_End_X_WE           		    <= '0';
			reg_End_Y_WE           		    <= '0';
			reg_Dummy_DIR_LINE_CIR_WE       <= '0';
			reg_Back_Scan_DIR_LINE_CIR_WE   <= '0';
			reg_Dummy_Back_Data_WE          <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( CSTM_WR_EN = '1' )then
				case CSTM_WR_ADR(23 downto 16) is
					when X"0A" =>
						reg_L_Circle_R_WE 				<= '1';
					when X"0B" =>
						reg_L_DIR_LINE_CIR_WE 			<= '1';
					when X"0C" =>
						reg_DIR_LINE_CIR_WE 			<= '1';
					when X"0D" =>
						reg_Start_X_WE 					<= '1';
					when X"0E" =>
						reg_Start_Y_WE 					<= '1';
					when X"0F" =>
						reg_End_X_WE 					<= '1';
					when X"10" =>
						reg_End_Y_WE 					<= '1';
					when X"11" =>
						reg_Dummy_DIR_LINE_CIR_WE 		<= '1';
					when X"12" =>
						reg_Back_Scan_DIR_LINE_CIR_WE 	<= '1';
					when X"13" =>
						reg_Dummy_Back_Data_WE 			<= '1';
					when others =>
						null;
				end case;
			else
				reg_L_Circle_R_WE      		    <= '0';
			    reg_L_DIR_LINE_CIR_WE  		    <= '0';
			    reg_DIR_LINE_CIR_WE    		    <= '0';
			    reg_Start_X_WE         		    <= '0';
			    reg_Start_Y_WE         		    <= '0';
			    reg_End_X_WE           		    <= '0';
			    reg_End_Y_WE           		    <= '0';
			    reg_Dummy_DIR_LINE_CIR_WE       <= '0';
			    reg_Back_Scan_DIR_LINE_CIR_WE   <= '0';
			    reg_Dummy_Back_Data_WE          <= '0';
			end if;
		end if;
	end process;






	process( nPON_RESET, FPGAclk ) begin
		if(  nPON_RESET = '0' )then
			cstm_wr_adr_ff	<= (others => '0');
			cstm_wr_data_ff	<= (others => '0');
		elsif( FPGAclk'event and FPGAclk='1') then
			cstm_wr_adr_ff(18 downto 0)	<= CSTM_WR_ADR(19 downto 1);
			cstm_wr_data_ff <= CSTM_WR_DATA ;
		end if;
	end process;

	start_0  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"0" ) else '0' ;  --0x*****0
	start_1  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"1" ) else '0' ;  --0x*****2
	start_2  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"2" ) else '0' ;  --0x*****4
	start_3  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"3" ) else '0' ;  --0x*****6
	start_4  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"4" ) else '0' ;  --0x*****8
	start_5  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"5" ) else '0' ;  --0x*****A
	start_6  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"6" ) else '0' ;  --0x*****C
	start_7  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"7" ) else '0' ;  --0x*****E
	start_8  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"8" ) else '0' ;  --0x****11
	start_9  <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"9" ) else '0' ;  --0x****13
	start_10 <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"A" ) else '0' ;  --0x****15
	start_11 <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"B" ) else '0' ;  --0x****17
	start_12 <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"C" ) else '0' ;  --0x****19
	start_13 <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"D" ) else '0' ;  --0x****1B
	start_14 <= '1' when ( cstm_wr_adr_ff(3 downto 0) = X"E" ) else '0' ;  --0x****1D


	--ライブスタートX0-7
	l_start_x0_en <= ( reg_L_Start_X_WE and start_0 );
	l_start_x1_en <= ( reg_L_Start_X_WE and start_1 );
	l_start_x2_en <= ( reg_L_Start_X_WE and start_2 );
	l_start_x3_en <= ( reg_L_Start_X_WE and start_3 );
	l_start_x4_en <= ( reg_L_Start_X_WE and start_4 );
	l_start_x5_en <= ( reg_L_Start_X_WE and start_5 );
	l_start_x6_en <= ( reg_L_Start_X_WE and start_6 );
	l_start_x7_en <= ( reg_L_Start_X_WE and start_7 );

	--ライブスタートY0-7
	l_start_y0_en <= ( reg_L_Start_Y_WE and start_0 );
	l_start_y1_en <= ( reg_L_Start_Y_WE and start_1 );
	l_start_y2_en <= ( reg_L_Start_Y_WE and start_2 );
	l_start_y3_en <= ( reg_L_Start_Y_WE and start_3 );
	l_start_y4_en <= ( reg_L_Start_Y_WE and start_4 );
	l_start_y5_en <= ( reg_L_Start_Y_WE and start_5 );
	l_start_y6_en <= ( reg_L_Start_Y_WE and start_6 );
	l_start_y7_en <= ( reg_L_Start_Y_WE and start_7 );
	
	--ライブエンドX0-7
	l_end_x0_en <= ( reg_L_End_X_WE and start_0 );
    l_end_x1_en <= ( reg_L_End_X_WE and start_1 );
    l_end_x2_en <= ( reg_L_End_X_WE and start_2 );
    l_end_x3_en <= ( reg_L_End_X_WE and start_3 );
    l_end_x4_en <= ( reg_L_End_X_WE and start_4 );
    l_end_x5_en <= ( reg_L_End_X_WE and start_5 );
    l_end_x6_en <= ( reg_L_End_X_WE and start_6 );
    l_end_x7_en <= ( reg_L_End_X_WE and start_7 );
	
	--ライブエンドY0-7
	l_end_y0_en <= ( reg_L_End_Y_WE and start_0 );
    l_end_y1_en <= ( reg_L_End_Y_WE and start_1 );
    l_end_y2_en <= ( reg_L_End_Y_WE and start_2 );
    l_end_y3_en <= ( reg_L_End_Y_WE and start_3 );
    l_end_y4_en <= ( reg_L_End_Y_WE and start_4 );
    l_end_y5_en <= ( reg_L_End_Y_WE and start_5 );
    l_end_y6_en <= ( reg_L_End_Y_WE and start_6 );
    l_end_y7_en <= ( reg_L_End_Y_WE and start_7 );

	--ライブサークル半径0-7
	l_circle_r0_en <= ( reg_L_Circle_R_WE and start_0 );
    l_circle_r1_en <= ( reg_L_Circle_R_WE and start_1 );
    l_circle_r2_en <= ( reg_L_Circle_R_WE and start_2 );
    l_circle_r3_en <= ( reg_L_Circle_R_WE and start_3 );
    l_circle_r4_en <= ( reg_L_Circle_R_WE and start_4 );
    l_circle_r5_en <= ( reg_L_Circle_R_WE and start_5 );
    l_circle_r6_en <= ( reg_L_Circle_R_WE and start_6 );
    l_circle_r7_en <= ( reg_L_Circle_R_WE and start_7 );

	--ライブサークル回転方向0-7
	l_circle_dir0_en <= ( reg_L_DIR_LINE_CIR_WE and start_0 );
	l_circle_dir1_en <= ( reg_L_DIR_LINE_CIR_WE and start_1 );
	l_circle_dir2_en <= ( reg_L_DIR_LINE_CIR_WE and start_2 );
	l_circle_dir3_en <= ( reg_L_DIR_LINE_CIR_WE and start_3 );
	l_circle_dir4_en <= ( reg_L_DIR_LINE_CIR_WE and start_4 );
	l_circle_dir5_en <= ( reg_L_DIR_LINE_CIR_WE and start_5 );
	l_circle_dir6_en <= ( reg_L_DIR_LINE_CIR_WE and start_6 );
	l_circle_dir7_en <= ( reg_L_DIR_LINE_CIR_WE and start_7 );

	--ダミーサークル回転方向0-14
	dummy_circle_dir0_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_0 );
	dummy_circle_dir1_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_1 );
	dummy_circle_dir2_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_2 );
	dummy_circle_dir3_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_3 );
	dummy_circle_dir4_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_4 );
	dummy_circle_dir5_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_5 );
	dummy_circle_dir6_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_6 );
	dummy_circle_dir7_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_7 );
	dummy_circle_dir8_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_8 );
    dummy_circle_dir9_en  <= ( reg_Dummy_DIR_LINE_CIR_WE and start_9 );
    dummy_circle_dir10_en <= ( reg_Dummy_DIR_LINE_CIR_WE and start_10 );
    dummy_circle_dir11_en <= ( reg_Dummy_DIR_LINE_CIR_WE and start_11 );
    dummy_circle_dir12_en <= ( reg_Dummy_DIR_LINE_CIR_WE and start_12 );
    dummy_circle_dir13_en <= ( reg_Dummy_DIR_LINE_CIR_WE and start_13 );
    dummy_circle_dir14_en <= ( reg_Dummy_DIR_LINE_CIR_WE and start_14 );

	

--カスタムスキャンフラグ
--CustomScanFlag
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_CSTM_FLAG <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( reg_CSTM_FLAG_WE = '1' )then
				reg_CSTM_FLAG <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--カスタムスキャン 回数
--SCAN_NUM
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_SCAN_NUM <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( reg_SCAN_NUM_WE = '1' )then
				reg_SCAN_NUM <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--ダミースキャン回数
--DUMMY_NUM
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_DUMMY_NUM <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( reg_DUMMY_NUM_WE = '1' )then
				reg_DUMMY_NUM <= cstm_wr_data_ff(3 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--バックスキャン回数
--BACK_SCAN_NUM
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_BACK_SCAN_NUM <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( reg_BACK_SCAN_NUM_WE = '1' )then
				reg_BACK_SCAN_NUM <= cstm_wr_data_ff(3 downto 0);
			end if;
		end if;
	end process;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--LIVE
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

	
	--ライブ本数
	--LIVE_SCAN_NUM
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_NUM <= "0001";
		elsif( FPGAclk'event and FPGAclk='1') then
			if( reg_LIVE_NUM_WE = '1' )then
				reg_LIVE_NUM <= cstm_wr_data_ff(3 downto 0);
			end if;
		end if;
	end process;
------------------------------------------------------------------------------------------
--	reg_LIVE_NUM_OUT <= reg_LIVE_NUM;

------------------------------------------------------------------------------------------
--ライブスタートX0-7

--L_Start_X0

	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X0 <= "111111111111";	--4095
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x0_en = '1' )then
				reg_L_Start_X0 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;	

------------------------------------------------------------------------------------------
--L_Start_X1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X1 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x1_en = '1' )then
				reg_L_Start_X1 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_X2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X2 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x2_en = '1' )then
				reg_L_Start_X2 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_X3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X3 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x3_en = '1' )then
				reg_L_Start_X3 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_X4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X4 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x4_en = '1' )then
				reg_L_Start_X4 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_X5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X5 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x5_en = '1' )then
				reg_L_Start_X5 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_X6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X6 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x6_en = '1' )then
				reg_L_Start_X6 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_X7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_X7 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_x7_en = '1' )then
				reg_L_Start_X7 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------

--ライブスタートY0-7

--L_Start_Y0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y0 <= "011111111111";	--2047
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y0_en = '1' )then
				reg_L_Start_Y0 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_Y1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y1 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y1_en = '1' )then
				reg_L_Start_Y1 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_Y2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y2 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y2_en = '1' )then
				reg_L_Start_Y2 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Start_Y3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y3 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y3_en = '1' )then
				reg_L_Start_Y3 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_Y4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y4 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y4_en = '1' )then
				reg_L_Start_Y4 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_Y5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y5 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y5_en = '1' )then
				reg_L_Start_Y5 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_Y6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y6 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y6_en = '1' )then
				reg_L_Start_Y6 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Start_Y7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Start_Y7 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_start_y7_en = '1' )then
				reg_L_Start_Y7 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--ライブエンドX0-7


--L_End_X0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X0 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x0_en = '1' )then
			reg_L_End_X0 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_End_X1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X1 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x1_en = '1' )then
				reg_L_End_X1 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_X2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X2 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x2_en = '1' )then
				reg_L_End_X2 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_X3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X3 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x3_en = '1' )then
				reg_L_End_X3 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_X4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X4 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x4_en = '1' )then
				reg_L_End_X4 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_End_X5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X5 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x5_en = '1' )then
				reg_L_End_X5 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_X6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X6 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x6_en = '1' )then
				reg_L_End_X6 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_X7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_X7 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_x7_en = '1' )then
				reg_L_End_X7 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--ライブエンドY0-7

--L_End_Y0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y0 <= "011111111111";	--2047
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y0_en = '1' )then
				reg_L_End_Y0 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_Y1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y1 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y1_en = '1' )then
				reg_L_End_Y1 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_Y2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y2 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y2_en = '1' )then
				reg_L_End_Y2 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_End_Y3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y3 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y3_en = '1' )then
				reg_L_End_Y3 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_Y4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y4 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y4_en = '1' )then
				reg_L_End_Y4 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_Y5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y5 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y5_en = '1' )then
				reg_L_End_Y5 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_End_Y6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y6 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y6_en = '1' )then
				reg_L_End_Y6 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_End_Y7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_End_Y7 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_end_y7_en = '1' )then
				reg_L_End_Y7 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--ライブサークル半径0-7


--L_Circle_R0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R0 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r0_en = '1' )then
				reg_L_Circle_R0 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_R1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R1 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r1_en = '1' )then
				reg_L_Circle_R1 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_R2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R2 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r2_en = '1' )then
				reg_L_Circle_R2 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_R3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R3 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r3_en = '1' )then
				reg_L_Circle_R3 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Circle_R4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R4 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r4_en = '1' )then
				reg_L_Circle_R4 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_R5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R5 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r5_en = '1' )then
				reg_L_Circle_R5 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_R6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R6 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r6_en = '1' )then
				reg_L_Circle_R6 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Circle_R7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_R7 <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_r7_en = '1' )then
				reg_L_Circle_R7 <= cstm_wr_data_ff(11 downto 0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--ライブサークル回転方向0-7


--L_Circle_DIR0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR0 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir0_en = '1' )then
				reg_L_Circle_DIR0 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_DIR1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR1 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir1_en = '1' )then
				reg_L_Circle_DIR1 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_DIR2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR2 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir2_en = '1' )then
				reg_L_Circle_DIR2 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Circle_DIR3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR3 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir3_en = '1' )then
				reg_L_Circle_DIR3 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_DIR4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR4 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir4_en = '1' )then
				reg_L_Circle_DIR4 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--L_Circle_DIR5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR5 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir5_en = '1' )then
				reg_L_Circle_DIR5 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_DIR6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR6 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir6_en = '1' )then
				reg_L_Circle_DIR6 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--L_Circle_DIR7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_L_Circle_DIR7 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir7_en = '1' )then
				reg_L_Circle_DIR7 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--ライブLine/Circle0-7

--LIVE_L_C0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C0 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir0_en = '1' )then
				reg_LIVE_L_C0 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C1 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir1_en = '1' )then
				reg_LIVE_L_C1 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--LIVE_L_C2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C2 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir2_en = '1' )then
				reg_LIVE_L_C2 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C3 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir3_en = '1' )then
				reg_LIVE_L_C3 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C4 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir4_en = '1' )then
				reg_LIVE_L_C4 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C5 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir5_en = '1' )then
				reg_LIVE_L_C5 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C6 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir6_en = '1' )then
				reg_LIVE_L_C6 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--LIVE_L_C7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_LIVE_L_C7 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( l_circle_dir7_en = '1' )then
				reg_LIVE_L_C7 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


-----------------------------------------------------------------------------
--LIVE座標セレクト
-----------------------------------------------------------------------------
	U_LIVE_XY :
	process(
		cnt_Live,
		reg_L_Start_X0,reg_L_Start_Y0,reg_L_End_X0,reg_L_End_Y0,reg_L_Circle_R0,reg_L_Circle_DIR0,reg_LIVE_L_C0,
		reg_L_Start_X1,reg_L_Start_Y1,reg_L_End_X1,reg_L_End_Y1,reg_L_Circle_R1,reg_L_Circle_DIR1,reg_LIVE_L_C1,
		reg_L_Start_X2,reg_L_Start_Y2,reg_L_End_X2,reg_L_End_Y2,reg_L_Circle_R2,reg_L_Circle_DIR2,reg_LIVE_L_C2,
		reg_L_Start_X3,reg_L_Start_Y3,reg_L_End_X3,reg_L_End_Y3,reg_L_Circle_R3,reg_L_Circle_DIR3,reg_LIVE_L_C3,
		reg_L_Start_X4,reg_L_Start_Y4,reg_L_End_X4,reg_L_End_Y4,reg_L_Circle_R4,reg_L_Circle_DIR4,reg_LIVE_L_C4,
		reg_L_Start_X5,reg_L_Start_Y5,reg_L_End_X5,reg_L_End_Y5,reg_L_Circle_R5,reg_L_Circle_DIR5,reg_LIVE_L_C5,
		reg_L_Start_X6,reg_L_Start_Y6,reg_L_End_X6,reg_L_End_Y6,reg_L_Circle_R6,reg_L_Circle_DIR6,reg_LIVE_L_C6,
		reg_L_Start_X7,reg_L_Start_Y7,reg_L_End_X7,reg_L_End_Y7,reg_L_Circle_R7,reg_L_Circle_DIR7,reg_LIVE_L_C7
	)
	begin
		case cnt_Live is
			when X"0" =>
				sig_Live_Xs <= reg_L_Start_X0;
				sig_Live_Ys <= reg_L_Start_Y0;
				sig_Live_Xe <= reg_L_End_X0;
				sig_Live_Ye <= reg_L_End_Y0;
				sig_Live_Circle     <= reg_L_Circle_R0;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR0;
				sig_LIVE_L_C        <= reg_LIVE_L_C0;
				
			when X"1" =>
				sig_Live_Xs <= reg_L_Start_X1;
				sig_Live_Ys <= reg_L_Start_Y1;
				sig_Live_Xe <= reg_L_End_X1;
				sig_Live_Ye <= reg_L_End_Y1;
				sig_Live_Circle     <= reg_L_Circle_R1;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR1;
				sig_LIVE_L_C        <= reg_LIVE_L_C1;
				
			when X"2" =>
				sig_Live_Xs <= reg_L_Start_X2;
				sig_Live_Ys <= reg_L_Start_Y2;
				sig_Live_Xe <= reg_L_End_X2;
				sig_Live_Ye <= reg_L_End_Y2;
				sig_Live_Circle     <= reg_L_Circle_R2;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR2;
				sig_LIVE_L_C        <= reg_LIVE_L_C2;
				
			when X"3" =>
				sig_Live_Xs <= reg_L_Start_X3;
				sig_Live_Ys <= reg_L_Start_Y3;
				sig_Live_Xe <= reg_L_End_X3;
				sig_Live_Ye <= reg_L_End_Y3;
				sig_Live_Circle     <= reg_L_Circle_R3;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR3;
				sig_LIVE_L_C        <= reg_LIVE_L_C3;
				
			when X"4" =>
				sig_Live_Xs <= reg_L_Start_X4;
				sig_Live_Ys <= reg_L_Start_Y4;
				sig_Live_Xe <= reg_L_End_X4;
				sig_Live_Ye <= reg_L_End_Y4;
				sig_Live_Circle     <= reg_L_Circle_R4;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR4;
				sig_LIVE_L_C        <= reg_LIVE_L_C4;
				
			when X"5" =>
				sig_Live_Xs <= reg_L_Start_X5;
				sig_Live_Ys <= reg_L_Start_Y5;
				sig_Live_Xe <= reg_L_End_X5;
				sig_Live_Ye <= reg_L_End_Y5;
				sig_Live_Circle     <= reg_L_Circle_R5;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR5;
				sig_LIVE_L_C        <= reg_LIVE_L_C5;
				
			when X"6" =>
				sig_Live_Xs <= reg_L_Start_X6;
				sig_Live_Ys <= reg_L_Start_Y6;
				sig_Live_Xe <= reg_L_End_X6;
				sig_Live_Ye <= reg_L_End_Y6;
				sig_Live_Circle     <= reg_L_Circle_R6;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR6;
				sig_LIVE_L_C        <= reg_LIVE_L_C6;
				
			when X"7" =>
				sig_Live_Xs <= reg_L_Start_X7;
				sig_Live_Ys <= reg_L_Start_Y7;
				sig_Live_Xe <= reg_L_End_X7;
				sig_Live_Ye <= reg_L_End_Y7;
				sig_Live_Circle     <= reg_L_Circle_R7;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR7;
				sig_LIVE_L_C        <= reg_LIVE_L_C7;
				
			when others => 
				sig_Live_Xs <= reg_L_Start_X0;
				sig_Live_Ys <= reg_L_Start_Y0;
				sig_Live_Xe <= reg_L_End_X0;
				sig_Live_Ye <= reg_L_End_Y0;
				sig_Live_Circle     <= reg_L_Circle_R0;
				sig_Live_Circle_DIR <= reg_L_Circle_DIR0;
				sig_LIVE_L_C        <= reg_LIVE_L_C0;
				
		end case;
	end process;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--DUMMY
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
------------------------------------------------------------------------------------------
--ダミーサークル回転方向0-14

--Dummy_Circle_DIR0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR0 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir0_en = '1' )then
				reg_Dummy_Circle_DIR0 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;
	


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR1 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir1_en = '1' )then
				reg_Dummy_Circle_DIR1 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR2 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir2_en = '1' )then
				reg_Dummy_Circle_DIR2 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR3 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir3_en = '1' )then
				reg_Dummy_Circle_DIR3 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummy_Circle_DIR4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR4 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir4_en = '1' )then
				reg_Dummy_Circle_DIR4 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummy_Circle_DIR5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR5 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir5_en = '1' )then
				reg_Dummy_Circle_DIR5 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Dummy_Circle_DIR6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR6 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir6_en = '1' )then
			reg_Dummy_Circle_DIR6 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Dummy_Circle_DIR7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR7 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir7_en = '1' )then
				reg_Dummy_Circle_DIR7 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR8
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR8 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir8_en = '1' )then
				reg_Dummy_Circle_DIR8 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Dummy_Circle_DIR9
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR9 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir9_en = '1' )then
				reg_Dummy_Circle_DIR9 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR10
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR10 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir10_en = '1' )then
				reg_Dummy_Circle_DIR10 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR11
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR11 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir11_en = '1' )then
				reg_Dummy_Circle_DIR11 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR12
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR12 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir12_en = '1' )then
				reg_Dummy_Circle_DIR12 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummy_Circle_DIR13
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR13 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir13_en = '1' )then
				reg_Dummy_Circle_DIR13 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_Circle_DIR14
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_Circle_DIR14 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir14_en = '1' )then
				reg_Dummy_Circle_DIR14 <= cstm_wr_data_ff(1);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--ダミーLine/Circle0-14
--Dummy_L_C0
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C0 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir0_en = '1' )then
				reg_Dummy_L_C0 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummy_L_C1
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C1 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir1_en = '1' )then
				reg_Dummy_L_C1 <=  cstm_wr_data_ff(0);
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Dummy_L_C2
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C2 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir2_en = '1' )then
				reg_Dummy_L_C2 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C3
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C3 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir3_en = '1' )then
				reg_Dummy_L_C3 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C4
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C4 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir4_en = '1' )then
				reg_Dummy_L_C4 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C5
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C5 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir5_en = '1' )then
				reg_Dummy_L_C5 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C6
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C6 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir6_en = '1' )then
				reg_Dummy_L_C6 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C7
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C7 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir7_en = '1')then
				reg_Dummy_L_C7 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C8
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C8 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir8_en = '1' )then
				reg_Dummy_L_C8 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C9
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C9 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir9_en = '1')then
				reg_Dummy_L_C9 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C10
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C10 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir10_en = '1' )then
				reg_Dummy_L_C10 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C11
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C11 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir11_en = '1' )then
				reg_Dummy_L_C11 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C12
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C12 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir12_en = '1' )then
				reg_Dummy_L_C12 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C13
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C13 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir13_en = '1' )then
				reg_Dummy_L_C13 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--Dummy_L_C14
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_Dummy_L_C14 <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( dummy_circle_dir14_en = '1' )then
				reg_Dummy_L_C14 <= cstm_wr_data_ff(0);
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummy座標セレクト
------------------------------------------------------------------------------------------
	U_Dummy_SEL :
	process(
		cnt_Dummy,
		reg_Dummy_Circle_DIR0,reg_Dummy_L_C0,
		reg_Dummy_Circle_DIR1,reg_Dummy_L_C1,
		reg_Dummy_Circle_DIR2,reg_Dummy_L_C2,
		reg_Dummy_Circle_DIR3,reg_Dummy_L_C3,
		reg_Dummy_Circle_DIR4,reg_Dummy_L_C4,
		reg_Dummy_Circle_DIR5,reg_Dummy_L_C5,
		reg_Dummy_Circle_DIR6,reg_Dummy_L_C6,
		reg_Dummy_Circle_DIR7,reg_Dummy_L_C7,
		reg_Dummy_Circle_DIR8,reg_Dummy_L_C8,
		reg_Dummy_Circle_DIR9,reg_Dummy_L_C9,
		reg_Dummy_Circle_DIR10,reg_Dummy_L_C10,
		reg_Dummy_Circle_DIR11,reg_Dummy_L_C11,
		reg_Dummy_Circle_DIR12,reg_Dummy_L_C12,
		reg_Dummy_Circle_DIR13,reg_Dummy_L_C13,
		reg_Dummy_Circle_DIR14,reg_Dummy_L_C14
	) begin
		case cnt_Dummy is          
			when X"0" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR0;
				sig_Dummy_L_C        <= reg_Dummy_L_C0;
			when X"1" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR1;
				sig_Dummy_L_C        <= reg_Dummy_L_C1;
			when X"2" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR2;
				sig_Dummy_L_C        <= reg_Dummy_L_C2;
			when X"3" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR3;
				sig_Dummy_L_C        <= reg_Dummy_L_C3;
			when X"4" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR4;
				sig_Dummy_L_C        <= reg_Dummy_L_C4;
			when X"5" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR5;
				sig_Dummy_L_C        <= reg_Dummy_L_C5;
			when X"6" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR6;
				sig_Dummy_L_C        <= reg_Dummy_L_C6;
			when X"7" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR7;
				sig_Dummy_L_C        <= reg_Dummy_L_C7;
			when X"8" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR8;
				sig_Dummy_L_C        <= reg_Dummy_L_C8;
			when X"9" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR9;
				sig_Dummy_L_C        <= reg_Dummy_L_C9;
			when X"A" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR10;
				sig_Dummy_L_C        <= reg_Dummy_L_C10;
			when X"B" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR11;
				sig_Dummy_L_C        <= reg_Dummy_L_C11;
			when X"C" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR12;
				sig_Dummy_L_C        <= reg_Dummy_L_C12;
			when X"D" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR13;
				sig_Dummy_L_C        <= reg_Dummy_L_C13;
			when X"E" =>
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR14;
				sig_Dummy_L_C        <= reg_Dummy_L_C14;		
			when others => 
				sig_Dummy_Circle_DIR <= reg_Dummy_Circle_DIR0;
				sig_Dummy_L_C        <= reg_Dummy_L_C0;
		end case;
	end process;



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--RAM WRITE/READ
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
-----------------------------------------------------------------------------------------
--component M4K RAM----------------------------------------------------------------------
-- Write/Read for start_X --
--	U_Start_X_RAM_ori : alt_dp_ram_12bit1024W_start_01 port map
--	(
--		wrclock		=> FPGAclk,--: IN STD_LOGIC ;
--		data		=> sig_Start_X_WD,--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		wraddress	=> sig_Start_X_WRA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		wren		=> sig_Start_X_WE,--: IN STD_LOGIC  := '1';
--		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
--		rdaddress	=> sig_Start_X_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		q			=> sig_Start_X_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--	);


--component M4K RAM----------------------------------------------------------------------
-- Write/Read for start_X --
	U_Start_X_RAM : alt_dp_ram_12bit1024W_start_01 port map
	(
		wrclock		=> FPGAclk,
		data		=> cstm_wr_data_ff(11 downto 0),
		wraddress	=> cstm_wr_adr_ff(11 downto 0),
		wren		=> reg_Start_X_WE,
		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
		rdaddress	=> sig_Start_X_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		q			=> sig_Start_X_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_Start_X_WD(11 downto 0) <= DataBusIn(11 downto 0);
--書き込みアドレス
--	sig_Start_X_WRA(11 downto 0) <= WR_ADDRES(11 downto 0);
--書き込みイネーブル
	sig_Start_X_WE <= Start_X_WE and not nWE;
--リードアドレス
	sig_Start_X_RDA <= sig_XY_ADDRESS;
--リードイネーブル
	sig_Start_X_RE <= sig_Scan_Run_Flag;
--リード出力データ
	--sig_Start_X_RDATA

-----------------------------------------------------------------------------------------
---- Write/Read for start_X --
--	U_Start_Y_RAM_ori : alt_dp_ram_12bit1024W_start_01 port map
--	(
--		wrclock		=> FPGAclk,--: IN STD_LOGIC ;
--		data		=> sig_Start_Y_WD,--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		wraddress	=> sig_Start_Y_WRA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		wren		=> sig_Start_Y_WE,--: IN STD_LOGIC  := '1';
--		rdaddress	=> sig_Start_Y_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
--		q			=> sig_Start_Y_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--	);


-- Write/Read for start_Y
	U_Start_Y_RAM : alt_dp_ram_12bit1024W_start_01 port map
	(
		wrclock		=> FPGAclk,
		data		=> cstm_wr_data_ff(11 downto 0),
		wraddress	=> cstm_wr_adr_ff(11 downto 0),
		wren		=> reg_Start_Y_WE,
		rdaddress	=> sig_Start_Y_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
		q			=> sig_Start_Y_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_Start_Y_WD(11 downto 0) <= DataBusIn(11 downto 0);
--書き込みアドレス
--	sig_Start_Y_WRA(11 downto 0) <= WR_ADDRES(11 downto 0);
--書き込みイネーブル
	sig_Start_Y_WE <= Start_Y_WE and not nWE;
--リードアドレス
	sig_Start_Y_RDA <= sig_XY_ADDRESS;
--リードイネーブル
	sig_Start_Y_RE <= sig_Scan_Run_Flag;
--リード出力データ
	--sig_Start_X_RDATA

-----------------------------------------------------------------------------------------
---- Write/Read for start_X --
--	U_End_X_RAM : alt_dp_ram_12bit1024W_end_01 port map
--	(
--		data		=> sig_End_X_WD,--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		wren		=> sig_End_X_WE,--: IN STD_LOGIC  := '1';
--		wrclock		=> FPGAclk,--: IN STD_LOGIC ;
--		wraddress	=> sig_End_X_WRA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		rdaddress	=> sig_End_X_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
--		q			=> sig_End_X_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--	);

-- Write/Read for start_X --
	U_End_X_RAM : alt_dp_ram_12bit1024W_end_01 port map
	(
		data		=> cstm_wr_data_ff(11 downto 0),
		wren		=> reg_End_X_WE,
		wrclock		=> FPGAclk,
		wraddress	=> cstm_wr_adr_ff(11 downto 0),
		rdaddress	=> sig_End_X_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
		q			=> sig_End_X_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_End_X_WD(11 downto 0) <= DataBusIn(11 downto 0);
--書き込みアドレス
--	sig_End_X_WRA(11 downto 0) <= WR_ADDRES(11 downto 0);
--書き込みイネーブル
	sig_End_X_WE <= End_X_WE and not nWE;
--リードアドレス
	sig_End_X_RDA <= sig_XY_ADDRESS;
--リードイネーブル
	sig_End_X_RE <= sig_Scan_Run_Flag;
--リード出力データ
	--sig_Start_X_RDATA

-----------------------------------------------------------------------------------------
---- Write/Read for start_X --
--	U_End_Y_RAM : alt_dp_ram_12bit1024W_end_01 port map
--	(
--		data		=> sig_End_Y_WD,--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		wraddress	=> sig_End_Y_WRA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		wrclock		=> FPGAclk,--: IN STD_LOGIC ;
--		wren		=> sig_End_Y_WE,--: IN STD_LOGIC  := '1';
--		rdaddress	=> sig_End_Y_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
--		q			=> sig_End_Y_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--	);


-- Write/Read for start_X --
	U_End_Y_RAM : alt_dp_ram_12bit1024W_end_01 port map
	(
		data		=> cstm_wr_data_ff(11 downto 0),
		wraddress	=> cstm_wr_adr_ff(11 downto 0),
		wrclock		=> FPGAclk,
		wren		=> reg_End_Y_WE,
		rdaddress	=> sig_End_Y_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
		q			=> sig_End_Y_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_End_Y_WD(11 downto 0) <= DataBusIn(11 downto 0);
--書き込みアドレス
--	sig_End_Y_WRA(11 downto 0) <= WR_ADDRES(11 downto 0);
--書き込みイネーブル
	sig_End_Y_WE <= End_Y_WE and not nWE;
--リードアドレス
	sig_End_Y_RDA <= sig_XY_ADDRESS;
--リードイネーブル
	sig_End_Y_RE <= sig_Scan_Run_Flag;
--リード出力データ
	--sig_Start_X_RDATA

-------------------------------------------------------------------------
--アドレスカウンタ
	sig_XY_ADDRESS <= cnt_Scan_Run( 11 downto 0 );
--	U_XY_ADDRESS_CNT :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1') then
--			sig_XY_ADDRESS <= (others=>'0');
--		elsif ( FPGAclk'event and FPGAclk='1') then
--			if( current_state = ST_SCAN_SET_WAIT_LAST )then
--				if(sig_SCAN_SET_RUN_RET = '1')then
--					sig_XY_ADDRESS <= back_xy_adr;
--				else
--					sig_XY_ADDRESS <= reg_SCAN_NUM(9 downto 0);
--				end if;
--			else 
--				if( GAL_CON_MOVE_END_out_2d = '1' and GAL_CON_MOVE_END_out_1d = '0') then
--					if( sig_Scan_Run_Flag = '1') then
--						if( sig_Scan_Set_Back_En = '1')then
--							sig_XY_ADDRESS <= back_xy_adr;
--						else 
--							sig_XY_ADDRESS <= sig_XY_ADDRESS + 1;
--						end if;
--					end if;
--				elsif( sig_SCAN_RUN_END = '1' or
--					 	SET_UP_RESET = '1'			)then
--					sig_XY_ADDRESS <= (others=>'0');
--				elsif( current_state = ST_SCAN_END ) then
--					sig_XY_ADDRESS <= (others=>'0');
--				end if;
--			end if;
--		end if;
--	end process;

-----------------------------------------------------------------------------------------
--component M4K RAM----------------------------------------------------------------------
-- Write/Read for Scan Circle Dir & Line/Cir --

--	U_Scan_Dir_Line_Cir : alt_dp_ram_2bit1024W_01 port map
--	(
--		data			=> sig_D_L_C_WD,--: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--		wraddress		=> sig_D_L_C_WRA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		wrclock			=> FPGAclk,--: IN STD_LOGIC ;
--		wren			=> sig_D_L_C_WE,--: IN STD_LOGIC  := '1';
--		rdaddress		=> sig_D_L_C_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--		rdclock			=> FPGAclk,--: IN STD_LOGIC ;
--		q				=> sig_D_L_C_RDATA--: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
--	);

	U_Scan_Dir_Line_Cir : alt_dp_ram_2bit1024W_01 port map
	(
		data			=> cstm_wr_data_ff(1 downto 0),
		wraddress		=> cstm_wr_adr_ff(11 downto 0),
		wrclock			=> FPGAclk,
		wren			=> reg_DIR_LINE_CIR_WE,
		rdaddress		=> sig_D_L_C_RDA,--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdclock			=> FPGAclk,--: IN STD_LOGIC ;
		q				=> sig_D_L_C_RDATA--: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_D_L_C_WD(1 downto 0) <= DataBusIn(1 downto 0);
--書き込みアドレス
--	sig_D_L_C_WRA(11 downto 0) <= WR_ADDRES(11 downto 0);
--書き込みイネーブル
	sig_D_L_C_WE <= DIR_LINE_CIR_WE and not nWE;
--リードアドレス
	sig_D_L_C_RDA <= sig_XY_ADDRESS;
--リードイネーブル
	sig_D_L_C_RE <= sig_Scan_Run_Flag;
--リード出力データ
	sig_Scan_L_C <= sig_D_L_C_RDATA(0);
	sig_Scan_Circle_DIR <= sig_D_L_C_RDATA(1);

-----------------------------------------------------------------------------------------
--component M4K RAM----------------------------------------------------------------------
---- Write/Read for Dummy&BackScan --
--	U_DM_BS_RAM : alt_dp_ram_12bit256W_01 port map
--	(
--		data		=> sig_DM_BS_WD,--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
--		wraddress	=> sig_DM_BS_WRA,--: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		wrclock		=> nWE,--: IN STD_LOGIC ;
--		wren		=> sig_Dummy_Back_Data_WE,--: IN STD_LOGIC  := '1';
--		rdaddress	=> sig_DM_BS_RDA,--: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
--		q			=> sig_DM_BS_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--	);

--component M4K RAM----------------------------------------------------------------------
-- Write/Read for Dummy&BackScan --
	U_DM_BS_RAM : alt_dp_ram_12bit256W_01 port map
	(
		data		=> cstm_wr_data_ff(11 downto 0),
		wraddress	=> reg_DM_BS_WRA,
		wrclock		=> FPGAclk,
		wren		=> reg_Dummy_Back_Data_WE,
		rdaddress	=> sig_DM_BS_RDA,--: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclock		=> FPGAclk,--: IN STD_LOGIC ;
		q			=> sig_DM_BS_RDATA --: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);


------------------------------------------------------------------------------------------
--書き込みデータ
	sig_DM_BS_WD(11 downto 0) <= DataBusIn(11 downto 0);

------------------------------------------------------------------------------------------
--書き込みアドレス
--	process(
--		WR_ADDRES(18 downto 0)
--	) begin
--		case WR_ADDRES(10 downto 7) is
--			when X"0"	=>	--ダミー Xスタート座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0);
--				
--			when X"1"	=>	--ダミー Yスタート座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"10";
--				
--			when X"2"	=>	--ダミー Xエンド座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"20";
--				
--			when X"3"	=>	--ダミー Yエンド座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"30";
--				
--			when X"4"	=>	--ダミー  サークル半径
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"40";
--			when X"5"	=>	--バックスキャン Xスタート座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"50";
--			when X"6"	=>	--バックスキャン Yスタート座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"60";
--			when X"7"	=>	--バックスキャン Xエンド座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"70";
--			when X"8"	=>	--バックスキャン Yエンド座標
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"80";
--			when X"9"	=>	--バックスキャン  サークル半径
--				sig_DM_BS_WRA <= '0' & WR_ADDRES(6 downto 0) + X"90";
--			when others=>null;
--				
--		end case;
--	end process;


	cstm_wradr_ext <= '0' & cstm_wr_adr_ff(6 downto 0);
	
--書き込みアドレス
	process( nPON_RESET, FPGAclk ) begin
		if( nPON_RESET = '0' )then
			reg_DM_BS_WRA <= (others =>'0' );
		elsif( FPGAclk'event and FPGAclk='1') then
			case cstm_wr_adr_ff(10 downto 7) is
				when X"0"	=>	--ダミー Xスタート座標
					reg_DM_BS_WRA <= cstm_wradr_ext;
				when X"1"	=>	--ダミー Yスタート座標
					reg_DM_BS_WRA <= cstm_wradr_ext + X"10";
				when X"2"	=>	--ダミー Xエンド座標	
					reg_DM_BS_WRA <= cstm_wradr_ext + X"20";
				when X"3"	=>	--ダミー Yエンド座標
					reg_DM_BS_WRA <= cstm_wradr_ext + X"30";
				when X"4"	=>	--ダミー  サークル半径	
					reg_DM_BS_WRA <= cstm_wradr_ext + X"40";
				when X"5"	=>	--バックスキャン Xスタート座標
					reg_DM_BS_WRA <= cstm_wradr_ext + X"50";
				when X"6"	=>	--バックスキャン Yスタート座標
					reg_DM_BS_WRA <= cstm_wradr_ext + X"60";
				when X"7"	=>	--バックスキャン Xエンド座標	
					reg_DM_BS_WRA <= cstm_wradr_ext + X"70";
				when X"8"	=>	--バックスキャン Yエンド座標
					reg_DM_BS_WRA <= cstm_wradr_ext + X"80";
				when X"9"	=>	--バックスキャン  サークル半径
					reg_DM_BS_WRA <= cstm_wradr_ext +  X"90";
				when others => 
					null;
			end case;
		end if;
	end process;



------------------------------------------------------------------------------------------
--書き込みイネーブル
	sig_Dummy_Back_Data_WE <= Dummy_Back_Data_WE;

------------------------------------------------------------------------------------------
--リードアドレス
	U_DM_BS_RDA :		--20090106TS
--	process( cstm_Reset, FPGAclk, sig_DUMMY_SCAN_END, sig_BACK_SCAN_END ) begin
-- 		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk ) begin
 		if( Reset = '1' ) then
		 	sig_DM_BS_RDA <= (others=>'0');
 		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_DUMMY_SCAN_END = '1' or sig_BACK_SCAN_END = '1'	)then	
		 		sig_DM_BS_RDA <= (others=>'0');
			else
 				if( reg_DM_BS_RDA_en(1) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt;
				elsif( reg_DM_BS_RDA_en(2) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"10";
				elsif( reg_DM_BS_RDA_en(3) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"20";
				elsif( reg_DM_BS_RDA_en(4) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"30";
				elsif( reg_DM_BS_RDA_en(5) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"40";
				elsif( reg_DM_BS_RDA_en(6) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"50";
				elsif( reg_DM_BS_RDA_en(7) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"60";
				elsif( reg_DM_BS_RDA_en(8) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"70";
				elsif( reg_DM_BS_RDA_en(9) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"80";
				elsif( reg_DM_BS_RDA_en(10) = '0') then
					sig_DM_BS_RDA	<= sig_DM_BS_RDA_cnt + X"90";
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--reg_DM_BS_RDA_en	
	U_reg_DM_BS_RDA_en :
--	process( cstm_Reset, FPGAclk, GAL_CON_MOVE_END_out ) begin
--		if( cstm_Reset = '1' or ( sig_Dummy_Flag='0' and sig_Back_Scan_Flag='0')) then
	process( Reset, FPGAclk ) begin
		if( Reset = '1' ) then
 			reg_DM_BS_RDA_en <= (others=>'0');
 		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_Dummy_Flag='0' and sig_Back_Scan_Flag='0' )then
				reg_DM_BS_RDA_en <= (others=>'0');
			elsif( GAL_MOVE_pedge = '1')then
 				reg_DM_BS_RDA_en <= (others=>'0');
 			elsif( sig_Dummy_Flag='1' or sig_Back_Scan_Flag='1') then
				reg_DM_BS_RDA_en(0) <= '1';
				reg_DM_BS_RDA_en(11 downto 1) <= reg_DM_BS_RDA_en(10 downto 0);
 			end if;
 		end if;
 	end process;

------------------------------------------------------------------------------------------
	U_DM_BS_RDATA :
--	process( cstm_Reset, FPGAclk ) begin
-- 		if( cstm_Reset = '1' ) then
	process( Reset, FPGAclk ) begin
 		if( Reset = '1' ) then
 			sig_Dummy_Xs	<= "111111111111";		--
 			sig_Dummy_Ys	<= "011111111111";		--
 			sig_Dummy_Xe	<= "000000000000";		--
 			sig_Dummy_Ye	<= "011111111111";		--
 			sig_Dummy_Circle_R<= "001111111111";	--
 			sig_Back_Xs		<= "011111111111";		--
 			sig_Back_Ys		<= "000000000000";		--
 			sig_Back_Xe		<= "011111111111";		--
 			sig_Back_Ye		<= "111111111111";		--
 			sig_Back_Circle_R	<= "001111111111";	--
			reg_dm_bs_end_pre   <= '0';
			reg_dm_bs_end       <= '0';
 		elsif( FPGAclk'event and FPGAclk='1') then
			reg_dm_bs_end <= reg_dm_bs_end_pre;
 			if( reg_DM_BS_RDA_en(4) = '0') then
				sig_Dummy_Xs	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(5) = '0') then
				sig_Dummy_Ys	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(6) = '0') then
				sig_Dummy_Xe	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(7) = '0') then
				sig_Dummy_Ye	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(8) = '0') then
				sig_Dummy_Circle_R	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(9) = '0') then
				sig_Back_Xs	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(10) = '0') then
				sig_Back_Ys	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(11) = '0') then
				sig_Back_Xe	<= sig_DM_BS_RDATA;
			elsif( reg_DM_BS_RDA_en(12) = '0') then
				sig_Back_Ye	<= sig_DM_BS_RDATA;
				reg_dm_bs_end_pre   <= '1';
			elsif( reg_DM_BS_RDA_en(13) = '0') then
				sig_Back_Circle_R	<= sig_DM_BS_RDATA;
				reg_dm_bs_end_pre   <= '0';
			else
				reg_dm_bs_end_pre   <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--リードイネーブル
	sig_DM_BS_RE <= sig_Dummy_Flag or sig_Back_Scan_Flag;

------------------------------------------------------------------------------------------
--リード出力データ
	--sig_Start_X_RDATA

------------------------------------------------------------------------------------------
--アドレスカウンター
--	U_DM_BS_RDA_CNT :
--	process( cstm_Reset, GAL_CON_MOVE_END_out, sig_SCAN_RUN_END, sig_DUMMY_SCAN_END, sig_BACK_SCAN_END ) begin
----		if(cstm_Reset = '1' ) then																--20090106TS
--		if( cstm_Reset = '1' or sig_DUMMY_SCAN_END = '1' or sig_BACK_SCAN_END = '1' ) then
--			sig_DM_BS_RDA_cnt <= (others=>'0');
--		elsif( GAL_CON_MOVE_END_out'event and GAL_CON_MOVE_END_out = '1' ) then
--			if( sig_Dummy_Flag = '1' or sig_Back_Scan_Flag = '1' ) then
--				sig_DM_BS_RDA_cnt <= sig_DM_BS_RDA_cnt + 1;
--			else
--				sig_DM_BS_RDA_cnt <= (others=>'0');
--			end if;
--		end if;
--	end process;

--アドレスカウンター
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			sig_DM_BS_RDA_cnt <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_DUMMY_SCAN_END = '1' or sig_BACK_SCAN_END = '1' )then
				sig_DM_BS_RDA_cnt <= (others=>'0');
			elsif( move_end_rise_edge = '1' )then
				if( sig_Dummy_Flag = '1' or sig_Back_Scan_Flag = '1' ) then
					sig_DM_BS_RDA_cnt <= sig_DM_BS_RDA_cnt + 1;
				else
					sig_DM_BS_RDA_cnt <= (others=>'0');
				end if;
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--sig_Scan_END



------------------------------------------------------------------------------------------
--各スキャンカウンタ
--liveカウンタ			
--	U_cnt_Live :
--	process( cstm_Reset, GAL_CON_MOVE_END_out, Galv_run) begin
--		if( cstm_Reset = '1' or
--			Galv_run = '0') then
--			cnt_Live <= (others=>'0');
--		elsif( GAL_CON_MOVE_END_out'event and GAL_CON_MOVE_END_out='1') then
--			if( sig_Live_Flag = '1' ) then
--				if(current_state = ST_LIVE) then
--					if( cnt_Live >= reg_LIVE_NUM - 1) then
--						cnt_Live <= (others=>'0');
--					else
--						cnt_Live <= cnt_Live + 1;
--					end if;
--				end if;
--			else
--				cnt_Live <= (others=>'0');
--			end if;
--		end if;
--	end process;

	move_end_rise_edge <= ( GAL_CON_MOVE_END_out and  not GAL_CON_MOVE_END_out_1d );




------------------------------------------------------------------------------------------
--各スキャンカウンタ
--liveカウンタ			
	U_cnt_Live :
	process( Reset, FPGAclk) begin
		if( Reset = '1' ) then
			cnt_Live <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( Galv_run = '0' )then
				cnt_Live <= (others=>'0');
			elsif( move_end_rise_edge = '1'  )then
				if( sig_Live_Flag = '1'  and current_state = ST_LIVE and ( cnt_Live >= reg_LIVE_NUM - 1))then
					cnt_Live <= (others=>'0');
				elsif( sig_Live_Flag = '1'  and current_state = ST_LIVE )then
					cnt_Live <= cnt_Live + 1;
				else
					cnt_Live <= (others=>'0');
				end if;
			end if;
		end if;
	end process;



------------------------------------------------------------------------------------------
--Dummyカウンタ
--	U_cnt_Dummy :
--	process( cstm_Reset, Galv_TRIG_in ) begin
--		if( cstm_Reset = '1' )then
--			cnt_Dummy <= (others=>'0');
--		elsif( Galv_TRIG_in'event and Galv_TRIG_in='1' ) then
--			if( sig_Dummy_Flag = '1' ) then
--				if( cnt_Dummy = reg_DUMMY_NUM ) then
--					cnt_Dummy <= (others=>'0');
--				else
--					cnt_Dummy <= cnt_Dummy + 1;
--				end if;
--			else
--				cnt_Dummy <= (others=>'0');
--			end if;
--		end if;
--	end process;


--Dummyカウンタ
	U_cnt_Dummy :
	process( Reset, FPGAclk ) begin
		if( Reset = '1' )then
			cnt_Dummy <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( move_end_rise_edge = '1') then
				if( cnt_Dummy = reg_DUMMY_NUM and sig_Dummy_Flag = '1'  ) then
					cnt_Dummy <= (others=>'0');
				elsif( sig_Dummy_Flag = '1' )then
					cnt_Dummy <= cnt_Dummy + 1;
				else
					cnt_Dummy <= (others=>'0');
				end if;
			end if;
		end if;
	end process;


------------------------------------------------------------------------------------------
--DUMMYスキャンの終了フラグ
	U_DUMMY_SCAN_END :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_DUMMY_SCAN_END <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_SCAN_RUN_END='1')then
				sig_DUMMY_SCAN_END <= '0';
			else 
				if( sig_Dummy_Flag = '1') then
					if( GAL_CON_MOVE_END_out='1' and cnt_Dummy = reg_DUMMY_NUM) then
						sig_DUMMY_SCAN_END <= '1';
					else
						sig_DUMMY_SCAN_END <= '0';
					end if;
				else
					sig_DUMMY_SCAN_END <= '0';
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Scan_Run カウンタ
	U_cnt_Scan_Run :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1')then
	process( Reset, FPGAclk) begin
		if( Reset = '1')then
			cnt_Scan_Run <= (others=>'0');
			cnt_Rep	<= (others => '0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if(sig_SCAN_RUN_END = '1')then
				cnt_Scan_Run <= (others=>'0');
				cnt_Rep	<= (others => '0');
			elsif(current_state = ST_SCAN_END )then
				cnt_Scan_Run <= (others=>'0');
				cnt_Rep	<= (others => '0');
			elsif( GAL_MOVE_pedge = '1' )then
				if( cnt_scan_run_update = '1')then
					cnt_Scan_Run <= (others=>'0');
					cnt_Rep	<= (others => '0');
				else
					if( current_state = ST_ANGIO_LIVE )then
						cnt_Scan_Run <= cnt_Scan_Run;
						cnt_Rep	<= (others => '0');
					else
							if( sig_Scan_Run_Flag = '1') then
								cnt_Scan_Run <= cnt_Scan_Run + 1;
								if( cnt_Rep = Repetition )then
									cnt_Rep	<= (others => '0');
								else
									cnt_Rep	<= cnt_Rep + 1;
								end if;
							else
								cnt_Scan_Run <= (others=>'0');
								cnt_Rep	<= (others => '0');
							end if;
						end if;
					end if;
				end if;
			end if;
	end process;

--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1')then
	process( Reset, FPGAclk) begin
		if( Reset = '1')then
			cnt_scan_run_update <= '0';
			cnt_scan_run_update_num <= ( others => '0' );
			keisen_num_offset <= (others => '0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( GAL_MOVE_pedge = '1' )then
				if( cnt_scan_run_update = '1')then
					keisen_num_offset <= cnt_scan_run_update_num ;
				end if;
			end if;

			if( keisen_update = '1' )then
				cnt_scan_run_update_num <= keisen_update_num;
			end if;

--2019.07.18 add
--Galv_run = '0'のとき、-> cnt_scan_run_update をリセットする処理を追加して対応した。
--Live停止からCap_startしたとき、cnt_scan_run_update = 1のため、cnt_Scan_Runがリセットされることにより、
--cnt_Scan_Runが最初の1回目のB_SCANをカウントアップしない問題への対応。

--
			if( Galv_run = '0' )then
				cnt_scan_run_update <= '0';
			elsif( keisen_update = '1' )then
				cnt_scan_run_update <= '1';
			elsif( GAL_MOVE_pedge = '1' )then
				if( current_state /= ST_ANGIO_LIVE )then
					cnt_scan_run_update <= '0';
				end if;
			end if;
		end if;
	end process;

--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset = '1')then
	process( Reset, FPGAclk) begin
		if( Reset = '1')then
			CAPT_OFFSET_EN <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( GAL_MOVE_pedge_2d = '1' )then
				if( sig_Scan_Run_Flag = '1' ) then
					if( cnt_Rep	= X"0" )then
						CAPT_OFFSET_EN <= '1';
					end if;
				else
					CAPT_OFFSET_EN <= '1';
				end if;
			else
				CAPT_OFFSET_EN <= '0';
			end if;
		end if;
	end process;
------------------------------------------------------------------------------------------
--Scan_RUN終了フラグ
	U_Scan_Run_END :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_SCAN_RUN_END <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_BACK_SCAN_END = '1')then
				sig_SCAN_RUN_END <= '0';
			else
				if( sig_Scan_Run_Flag = '1'	and GAL_MOVE_pedge='1' and cnt_Scan_Run = reg_SCAN_NUM)then
					sig_SCAN_RUN_END <= '1';
				else
					sig_SCAN_RUN_END <= '0';		--081225TS
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Back_Scan カウンタ
--	U_cnt_Back_Scan :
--	process(
--		cstm_Reset,
--		GAL_CON_MOVE_END_out,
--		sig_BACK_SCAN_END
--	) begin
--		if(
--			cstm_Reset = '1'
--			or
--			sig_BACK_SCAN_END = '1'
--		)then
--			cnt_Back_Scan <= (others=>'0');
--		elsif(
--			GAL_CON_MOVE_END_out'event and GAL_CON_MOVE_END_out='1'
--		) then
--			if(
--				sig_Back_Scan_Flag = '1'
--			) then
--				cnt_Back_Scan <= cnt_Back_Scan + 1;
--			else
--				cnt_Back_Scan <= (others=>'0');
--			end if;
--		end if;
--	end process;

--Back_Scan カウンタ
	U_cnt_Back_Scan :
--	process( cstm_Reset, FPGAclk ) begin
--		if( cstm_Reset = '1'  )then
	process( Reset, FPGAclk ) begin
		if( Reset = '1'  )then
			cnt_Back_Scan <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( sig_BACK_SCAN_END = '1' )then
				cnt_Back_Scan <= (others=>'0');
			elsif( move_end_rise_edge = '1') then
				if( sig_Back_Scan_Flag = '1' )then
					cnt_Back_Scan <= cnt_Back_Scan + 1;
				else
					cnt_Back_Scan <= (others=>'0');
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Back_Scan終了フラグ
	U_Back_Scan_END :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_BACK_SCAN_END <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( sig_DUMMY_SCAN_END = '1')then
				sig_BACK_SCAN_END <= '0';
			else
				if( sig_Back_Scan_Flag = '1' and GAL_CON_MOVE_END_out='1' and ( cnt_Back_Scan = '0' & reg_BACK_SCAN_NUM)) then
					sig_BACK_SCAN_END <= '1';
				else
					sig_BACK_SCAN_END <= '0';		--081225TS
				end if;
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
---出力セレクタ
	-- sig_Live_Xs
	-- sig_Dummy_Xs
	-- sig_Start_X_RDATA
	-- sig_Back_Xs
	U_XY_OUT_Sel :
--	process(
--		current_state,sig_live_b_y,
--		Galv_run,sig_Dummy_Circle_DIR,
--		sig_Scan_Circle_DIR,
--		sig_Live_Xs,sig_Live_Ys,sig_Live_Xe,sig_Live_Ye,sig_Live_Circle,sig_Live_Circle_DIR,
--		sig_Dummy_Xs,sig_Dummy_Ys,sig_Dummy_Xe,sig_Dummy_Ye,sig_Dummy_Circle_R,
--		sig_Start_X_RDATA,sig_Start_Y_RDATA,sig_End_X_RDATA,sig_End_Y_RDATA,
--		sig_Back_Xs,sig_Back_Ys,sig_Back_Xe,sig_Back_Ye,sig_Back_Circle_R
--	)

--	process( cstm_Reset, FPGAclk )begin
--		if( cstm_Reset='1' ) then
	process( Reset, FPGAclk )begin
		if( Reset='1' ) then
--			cstm_Track_en		<= '0';
			keisenNO			<= (others => '0');
 			------------------------------------------
 			cstm_Start_X	<= (others => '0');
 			cstm_Start_Y	<= (others => '0');
 			cstm_End_X		<= (others => '0');
 			cstm_End_Y		<= (others => '0');
 			cstm_Circle_R	<= (others => '0');
 			cstm_Circle_DIR	<= '0';
 			------------------------------------------
--			cstm_Live_Start_X	<=(others => '0');
--			cstm_Live_Start_Y	<=(others => '0');
-- 			cstm_Live_End_X		<=(others => '0');
-- 			cstm_Live_End_Y		<=(others => '0');
-- 			cstm_Live_Circle_R	<=(others => '0');
		elsif( FPGAclk'event and FPGAclk='1') then
			case current_state is
				------------------------------------------------------------------------------
				when ST_SETUP =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Live_Xs;
					cstm_Start_Y	<= sig_Live_Ys;
					cstm_End_X		<= sig_Live_Xe;
					cstm_End_Y		<= sig_Live_Ye;
					cstm_Circle_R	<= sig_Live_Circle;
					cstm_Circle_DIR	<= sig_Live_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Live_Xs;
--					cstm_Live_Start_Y	<=sig_Live_Ys;
--					cstm_Live_End_X		<=sig_Live_Xe;
--					cstm_Live_End_Y		<=sig_Live_Ye;
--					cstm_Live_Circle_R	<=sig_Live_Circle;
				------------------------------------------------------------------------------
				when ST_LIVE =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Live_Xs;
					cstm_Start_Y	<= sig_Live_Ys;
					cstm_End_X		<= sig_Live_Xe;
					cstm_End_Y		<= sig_Live_Ye;
					cstm_Circle_R	<= sig_Live_Circle;
					cstm_Circle_DIR	<= sig_Live_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Live_Xs;
--					cstm_Live_Start_Y	<=sig_Live_Ys;
--					cstm_Live_End_X		<=sig_Live_Xe;
--					cstm_Live_End_Y		<=sig_Live_Ye;
--					cstm_Live_Circle_R	<=sig_Live_Circle;
				------------------------------------------------------------------------------
				when ST_LIVE_B =>
					keisenNO			<= (others => '0');
					cstm_Start_X	<= X"FFF";
					if(sig_live_b_y_out(12) = '1')then
						cstm_Start_Y	<= X"000";
					else
						--cstm_Start_Y	<= X"FFF" - (sig_live_b_y(15 downto 4) + (B"0000_0000_000" & sig_live_b_y(3)));
						cstm_Start_Y	<= X"FFF" - sig_live_b_y_out(11 downto 0);
					end if;
					cstm_End_X		<= X"000";
					if(sig_live_b_y_out(12) = '1')then
						cstm_End_Y		<= X"000";
					else
						--cstm_End_Y		<= X"FFF" - (sig_live_b_y(15 downto 4) + (B"0000_0000_000" & sig_live_b_y(3)));
						cstm_End_Y		<= X"FFF" - sig_live_b_y_out(11 downto 0);
					end if;
					cstm_Circle_R	<= sig_Live_Circle;
					cstm_Circle_DIR	<= sig_Live_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<= X"FFF";
--					if(sig_live_b_y_out(12) = '1')then
--						cstm_Live_Start_Y	<= X"000";
--					else
--						--cstm_Live_Start_Y	<= X"FFF" - (sig_live_b_y(15 downto 4) + (B"0000_0000_000" & sig_live_b_y(3)));
--						cstm_Live_Start_Y	<= X"FFF" - sig_live_b_y_out(11 downto 0);
--					end if;
--					cstm_Live_End_X		<= X"000";
--					if(sig_live_b_y_out(12) = '1')then
--						cstm_Live_End_Y		<= X"000";
--					else
--						--cstm_Live_End_Y		<= X"FFF" - (sig_live_b_y(15 downto 4) + (B"0000_0000_000" & sig_live_b_y(3)));
--						cstm_Live_End_Y		<= X"FFF" - sig_live_b_y_out(11 downto 0);
--					end if;
--					cstm_Live_Circle_R	<= sig_Live_Circle;
				------------------------------------------------------------------------------
				when ST_DUMMY_SCAN =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Dummy_Xs;
					cstm_Start_Y	<= sig_Dummy_Ys;
					cstm_End_X		<= sig_Dummy_Xe;
					cstm_End_Y		<= sig_Dummy_Ye;
					cstm_Circle_R	<= sig_Dummy_Circle_R;
					cstm_Circle_DIR	<= sig_Dummy_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Dummy_Xs;
--					cstm_Live_Start_Y	<=sig_Dummy_Ys;
--					cstm_Live_End_X		<=sig_Dummy_Xe;
--					cstm_Live_End_Y		<=sig_Dummy_Ye;
--					cstm_Live_Circle_R	<=sig_Dummy_Circle_R;
				------------------------------------------------------------------------------
				when ST_SCAN_RUN =>
					keisenNO			<= sig_XY_ADDRESS + keisen_num_offset;
					------------------------------------------
					cstm_Start_X	<= sig_Start_X_RDATA;
					cstm_Start_Y	<= sig_Start_Y_RDATA;
					cstm_End_X		<= sig_End_X_RDATA;
					cstm_End_Y		<= sig_End_Y_RDATA;
					cstm_Circle_R	<= sig_End_X_RDATA;
					cstm_Circle_DIR	<= sig_Scan_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Start_X_RDATA;
--					cstm_Live_Start_Y	<=sig_Start_Y_RDATA;
--					cstm_Live_End_X		<=sig_End_X_RDATA;
--					cstm_Live_End_Y		<=sig_End_Y_RDATA;
--					cstm_Live_Circle_R	<=sig_End_X_RDATA;
				------------------------------------------------------------------------------
				when ST_BACK_SCAN =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Back_Xs;
					cstm_Start_Y	<= sig_Back_Ys;
					cstm_End_X		<= sig_Back_Xe;
					cstm_End_Y		<= sig_Back_Ye;
					cstm_Circle_R	<= sig_Back_Circle_R;
					------------------------------------------
--					cstm_Live_Start_X	<= sig_Back_Xs;
--					cstm_Live_Start_Y	<= sig_Back_Ys;
--					cstm_Live_End_X		<= sig_Back_Xe;
--					cstm_Live_End_Y		<= sig_Back_Ye;
--					cstm_Live_Circle_R	<= sig_Back_Circle_R;
				------------------------------------------------------------------------------
				when ST_ANGIO_LIVE =>
					keisenNO			<= (others => '0');
					cstm_Start_X	<= sig_Start_X_RDATA;
					cstm_Start_Y	<= sig_Start_Y_RDATA;
					cstm_End_X		<= sig_End_X_RDATA;
					cstm_End_Y		<= sig_End_Y_RDATA;
					cstm_Circle_R	<= sig_End_X_RDATA;
					cstm_Circle_DIR	<= sig_Scan_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Start_X_RDATA;
--					cstm_Live_Start_Y	<=sig_Start_Y_RDATA;
--					cstm_Live_End_X		<=sig_End_X_RDATA;
--					cstm_Live_End_Y		<=sig_End_Y_RDATA;
--					cstm_Live_Circle_R	<=sig_End_X_RDATA;
				when ST_SCAN_END =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Live_Xs;
					cstm_Start_Y	<= sig_Live_Ys;
					cstm_End_X		<= sig_Live_Xe;
					cstm_End_Y		<= sig_Live_Ye;
					cstm_Circle_R	<= sig_Live_Circle;
					cstm_Circle_DIR	<= sig_Live_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Live_Xs;
--					cstm_Live_Start_Y	<=sig_Live_Ys;
--					cstm_Live_End_X		<=sig_Live_Xe;
--					cstm_Live_End_Y		<=sig_Live_Ye;
--					cstm_Live_Circle_R	<=sig_Live_Circle;
				------------------------------------------------------------------------------
				when others =>
					keisenNO			<= (others => '0');
					------------------------------------------
					cstm_Start_X	<= sig_Live_Xs;
					cstm_Start_Y	<= sig_Live_Ys;
					cstm_End_X		<= sig_Live_Xe;
					cstm_End_Y		<= sig_Live_Ye;
					cstm_Circle_R	<= sig_Live_Circle;
					cstm_Circle_DIR	<= sig_Live_Circle_DIR;
					------------------------------------------
--					cstm_Live_Start_X	<=sig_Live_Xs;
--					cstm_Live_Start_Y	<=sig_Live_Ys;
--					cstm_Live_End_X		<=sig_Live_Xe;
--					cstm_Live_End_Y		<=sig_Live_Ye;
--					cstm_Live_Circle_R	<=sig_Live_Circle;
				------------------------------------------------------------------------------
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--Mode_OUT
	U_MODE_OUT_Sel :
--	process(
--		current_state,
--		sig_LIVE_L_C,
--		sig_DUMMY_L_C,
--		sig_Scan_L_C
--	) begin
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
 			cstm_Mode_Sel <= "0001";	--B_Scan
		elsif( FPGAclk'event and FPGAclk='1') then
			case current_state is
				when ST_SETUP =>
					cstm_Mode_Sel <= "0001";	--B_Scan
					
				when ST_LIVE =>
					if(sig_LIVE_L_C = '0') then
						cstm_Mode_Sel <= "0001";	--B_Scan
					else
						cstm_Mode_Sel <= "0010";	--Circle_Scan
					end if;
					
				when ST_LIVE_B =>
					cstm_Mode_Sel <= "0001";	--B_Scan
			
				when ST_DUMMY_SCAN =>
					if(sig_DUMMY_L_C = '0') then
						cstm_Mode_Sel <= "0001";	--B_Scan
					else
						cstm_Mode_Sel <= "0010";	--Circle_Scan
					end if;
					
				when ST_SCAN_RUN =>
					if(sig_Scan_L_C = '0') then
						cstm_Mode_Sel <= "0001";	--B_Scan
					else
						cstm_Mode_Sel <= "0010";	--Circle_Scan
					end if;
					
				when ST_BACK_SCAN =>
					cstm_Mode_Sel <= "0001";	--B_Scan
					
				when ST_SCAN_END =>
					cstm_Mode_Sel <= "0001";	--B_Scan
					
				when others => 
					cstm_Mode_Sel <= "0001";	--B_Scan
					
			end case;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_LiveResol <= (others => '0');
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_LIVE )then
				sig_LiveResol <= CSTM_LIVE_A_X_RESO;
			elsif(current_state = ST_LIVE_B) then
				sig_LiveResol <= CSTM_LIVE_B_X_RESO;
			else
				sig_LiveResol <= CSTM_LIVE_A_X_RESO;
			end if;
		end if;
	end process;

--	CSTM_LIVE_RESO <= sig_LiveResol;
------------------------------------------------------------------------------------------
--各Scan状態判定フラグ		--20090323YN
	--ライブスキャン中フラグ
	U_Live_Scan_NOW :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_LiveScanNow <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_LIVE or current_state = ST_LIVE_B) then
				sig_LiveScanNow <= '1';
			else
				sig_LiveScanNow <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	cstm_LiveScanNow_Flag <= sig_LiveScanNow;

------------------------------------------------------------------------------------------
	--ダミースキャン中フラグ
	U_Dummy_Scan_NOW :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_DummyScanNow <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_DUMMY_SCAN) then
				sig_DummyScanNow <= '1';
			else
				sig_DummyScanNow <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
--	cstm_DummyScanNow_Flag <= sig_DummyScanNow;

------------------------------------------------------------------------------------------
	--キャプチャー中フラグ
	U_Cap_Scan_NOW :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_CapScanNow <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_SCAN_RUN) then
				sig_CapScanNow <= '1';
			else
				sig_CapScanNow <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	cstm_CapScanNow_Flag <= sig_CapScanNow;

------------------------------------------------------------------------------------------
	--バックスキャン中フラグ
	U_Back_Scan_NOW :
--	process( cstm_Reset, FPGAclk) begin
--		if( cstm_Reset='1') then
	process( Reset, FPGAclk) begin
		if( Reset='1') then
			sig_BackScanNow <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( current_state = ST_BACK_SCAN ) then
				sig_BackScanNow <= '1';
			else
				sig_BackScanNow <= '0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------------------------
	cstm_BackScanNow_Flag <= sig_BackScanNow;

------------------------------------------------------------------------------------------
	--カスタムスキャン中Liveカウント数を出力
	cstm_cnt_Live <= cnt_Live;

------------------------------------------------------------------------------------------
	--解像度設定
	Resol_OUT		<= 	--カスタムスキャンのキャプチャー時
						Resol_CSTM	when (sig_CapScanNow='1')
						--カスタムスキャンのダミースキャン
						else Dum_Resol_CSTM	when (sig_DummyScanNow='1')
						--カスタムスキャンのバックスキャン
						else Back_Resol_CSTM	when (sig_BackScanNow='1')		--20090508YN
						--カスタムスキャンのライブ
						else sig_LiveResol	when (sig_CAP_START='0')
						--通常スキャンのキャプチャー時
						else Resol;
	

END RTL;
