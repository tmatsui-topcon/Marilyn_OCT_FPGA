--**************************************************************************************--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
ENTITY GPIO IS
	PORT(
		FPGACLK		:	in std_logic;			-- クロック(20MHz)
		nFPGARST	:	in std_logic;			-- リセット信号(SHからのS/Wリセット)
		reset		:	in std_logic;
		nCS		:	in std_logic;			-- チップセレクト(外部Pull-upあり)
		nRD			:	in std_logic;			-- リード信号(外部Pull-upあり)
		nWE			:	in std_logic;			-- ライト信号(外部Pull-upあり)
		AdrsBus		:	in std_logic_vector(10 downto 0);		-- アドレス・バス
--		IN_DataBus	: in std_logic_vector(15 downto 0);		-- データ・バス(入出力)
--		OUT_DataBus	: out std_logic_vector(15 downto 0);
--		OUT_TRI_OUTEN	: out std_logic;		
		FPGA_DIPSW		:	in std_logic_vector(9 downto 0);	--DIPSW
		DataBus			: inout	std_logic_vector(15 downto 0);
		GAL_CON_MOVE_END	: in std_logic;
		
	--Retinal Function
		LAMP_COVER		:	in std_logic;	--ランプハウスカバー検知
		SHIDO_SW		:	in std_logic;	--視度補正レンズ検知
		n_EF_Detect		:	in std_logic;	--エキサイタフィルタ検知	
		n_AF_Detect_M		:	in std_logic;	--オートフォーカス下限検知
		n_AF_Detect_P		:	in std_logic;	--オートフォーカス上限検知
		n_QM_Detect	:	in std_logic;	--ミラー検知
		DSC_SyncIn:	in std_logic;	--外部デジカメ同期信号入力
		OVER_VOLTAGE	:	in std_logic;	--キセノン制御基板インターフェース
		CHARGE_OK		:	in std_logic;

	--OCT Function
		REF_SEN_IN		:	in std_logic;	--リファレンスミラー初期位置検知
		POL_SEN_IN		:	in std_logic;	--ポラライザー初期位置検知
		YA_SEN_IN		:	in std_logic;	--Y軸オートモータ初期位置検知
		AXL_SEN_IN		:	in std_logic;	--眼軸長補正モータ初期位置検知
		n_ATTENUATOR_Detect:	in std_logic;	 --前眼部位置検知		
		GPO				:	in std_logic_vector(4 downto 1);	--StingrayとのI/F(Input)	
		SLD_BUSY		:	in std_logic;	--SLD_DRIVER-PCB上R8Cビジー入力
		SLD_ERROR		:	in std_logic;	--SLD_DRIVER-PCBからのエラー入力
		IMG_B_BUSY		:	in std_logic;	--画像ボードからのビジー入力
		IMG_B_EVENT_FLAG:	in std_logic;	--画像ボードからのイベントフラグ入力
		AreaCCD_TRIG	:	in std_logic;	--画像ボードからのエリアCCDカメラ用トリガ入力
		GalvX_FAULT		:	in std_logic;	--X軸ガルバノドライバボードエラー入力
		GalvY_FAULT		:	in std_logic;	--Y軸ガルバノドライバボードエラー入力

		n_BF_Detect		:	in std_logic;	
		PAHSE_B2		:	in std_logic;	
		PAHSE_A2		:	in std_logic;	
		PAHSE_B1		:	in std_logic;	
		PAHSE_A1		:	in std_logic;	
		FI_IN			:	in std_logic;	
		SPI_BUSY		:	in std_logic;	
		SPI_READ_DATA	:	in std_logic_vector( 7 downto 0 );	

	--FPGA内部信号
		HW_Rev1			:	in std_logic_vector(3 downto 0);	--FPGA　H/Wリビジョン管理用
		HW_Rev2			:	in std_logic_vector(3 downto 0);
		HW_Rev3			:	in std_logic_vector(3 downto 0);
		HW_Rev4			:	in std_logic_vector(3 downto 0);
		FPGA_CNT		:	in std_logic_vector(15 downto 0);	--FPGA　動作確認用内部カウンタ入力
		Galv_BUSY		:	in std_logic;	--ガルバノコントローラからのビジー入力
		Back_Scan_Flag	:	in std_logic;		--ガルバノコントローラからのバックスキャン中ビジーフラグ入力

		nFOCUS_FAULT	:	in std_logic;
		nREF_POLA_FAULT	:	in std_logic;
	
	--デバック用、 ガルバノスタート、エンド座標レジスタにセット。
		cstm_Start_X	: 	in std_logic_vector(11 downto 0);
		cstm_Start_Y	:	in std_logic_vector(11 downto 0);
		cstm_End_X		:	in std_logic_vector(11 downto 0);
		cstm_End_Y		:	in std_logic_vector(11 downto 0);
			

	-- 出力ピン
		TD_ON_OFF		:	out std_logic;	--内部固視灯LCD　ON/OFF出力
		TD_A0			:	out std_logic;	--内部固視灯LCD　コマンド/データ出力
		TD_SI			:	out std_logic;	--内部固視灯LCD
		TD_SLC			:	out std_logic;	--内部固視灯LCD
		TD_CS			:	out std_logic;	--内部固視灯LCD　チップセレクト
		TD_RES			:	out std_logic;	--内部固視灯LCD　リセット出力
		LED_SCLK		:	out std_logic;	--アライメント／スプリットLED制御
		LED_DIN			:	out std_logic;		
		SPLIT_DAC_CS	:	out std_logic;		
		ALIGN_DAC_CS	:	out std_logic;		
		EXT_FIX_LED		:	out std_logic;	--外部固視灯LED　ON/OFF出力
		BUZZER_SH		:	out std_logic;		
		Bz_SH_FPGA		:	out std_logic;		
		Bz_FPGA_ON_OFF	:	out std_logic;		
		CHIN_BREAK		:	out std_logic;	--電動あご受け制御出力
		CHIN_PHASE		:	out std_logic;
		CHIN_ENABLE		:	out std_logic;
		SEL				:	out std_logic_vector(1 downto 0);		--パネルスイッチ機能選択出力
		POWER_LED		:	out std_logic;		--パワーLED制御出力

	--Retinal Function
		Vf_H_ON_OFF		:	out std_logic;		--ハロゲンランプ用ファン電源　ON/OFF出力
		Vf_H_H_L		:	out std_logic;		--ハロゲンランプ用ファン　High/Low選択出力
		REF_P_SOL		:	out std_logic_vector(2 downto 1);	--反射棒切替ソレノイド制御出力
		ANT_COMP_SOL	:	out std_logic_vector(2 downto 1);	--前眼部補正レンズ切替ソレノイド制御出力
		APER_SW_SOL		:	out std_logic_vector(2 downto 1);	--絞り切替ソレノイド制御出力		
		MIRROR_SOL			:	out std_logic_vector(2 downto 1);	--ミラー切替ソレノイド制御出力			
		IRIS_APER_SOL	:	out std_logic_vector(2 downto 1);		--虹彩絞り切替ソレノイド制御出力
		RELEASE_OUT		:	out std_logic;	--外部デジカメレリーズ信号出力
		LAMP_CNT		:	out std_logic_vector(3 downto 1);	--ハロゲンランプ光量設定出力
		LAMP_ON_OFF		:	out std_logic;	--ハロゲンランプ　ON/OFF出力
		CHARGE			:	out std_logic;	--キセノン制御基板インターフェース
		DISCHARGE		:	out std_logic;
		IGBT_TRIG		:	out std_logic;
		TRIGGER			:	out std_logic;	--キセノントリガ出力		
		FAF_CCD_ON_OFF	:	out std_logic;	--Stingray ON/OFF制御
		AF_MOT_P		:	out std_logic;	--オートフォーカスモータ制御
		AF_MOT			:	out std_logic_vector(4 downto 1);		
		GPI				:	out std_logic_vector(2 downto 1);	--StingrayとのI/F(Output)		
		Shutter1_MOT_P	:	out std_logic;		--シャッターモータ制御
		Shutter1_MOT	:	out std_logic_vector(4 downto 1);		
		Shutter2_MOT_P	:	out std_logic;		
		Shutter2_MOT	:	out std_logic_vector(4 downto 1);		

	--OCT Function
		REF_MOT_P		:	out std_logic;	--リファレンスミラーモータ制御
		REF_MOT			:	out std_logic_vector(4 downto 1);
		POL_MOT_P		:	out std_logic;	--ポラライザーモータ制御
		POL_MOT			:	out std_logic_vector(4 downto 1);
		YA_MOT_P		:	out std_logic;	--Y軸オートモータ制御
		YA_MOT			:	out std_logic_vector(4 downto 1);
		Galv_GAIN_CLK	:	out std_logic;	--ガルバノゲイン設定DPM用クロック出力
		Galv_GAIN_SDI	:	out std_logic;	--ガルバノゲイン設定DPMデータ出力
		GalvX_GAIN_CS	:	out std_logic;	--X軸ガルバノゲイン設定DPMチップセレクト
		GalvY_GAIN_CS	:	out std_logic;	--Y軸ガルバノゲイン設定DPMチップセレクト
		Galv_OS_SCLK	:	out std_logic;	--ガルバノオフセット設定DAC用クロック出力
		Galv_OS_DIN		:	out std_logic;	--ガルバノオフセット設定DACデータ出力
		GalvX_OS_CS		:	out std_logic;	--X軸ガルバノオフセット設定DACチップセレクト
		GalvY_OS_CS		:	out std_logic;	--Y軸ガルバノオフセット設定DACチップセレクト
		AreaCCD_RELEASE	:	out std_logic;	--画像ボードへのエリアCCDカメラ用レリーズ出力
		FPN_FLAG		:	out std_logic;		--FPN除去用スキャン判別フラグ入力
		Vf_L_ON_OFF		:	out std_logic;
		Vf_L_H_L		:	out std_logic;	--ラインCCDカメラ用ファン　High/Low選択出力

	--FPGA内部信号
		BLINK_Freq		:	out std_logic_vector(2 downto 0);	--外部固視灯点滅周波数設定出力
		FIX_BLINK		:	out std_logic;	--外部固視灯点灯/点滅切替
		
		--ガルバノコントローラインターフェース
		GAL_CNT_RESET	:	out std_logic;	--リセット信号
		Galv_run		:	out std_logic;	--ガルバノ動作開始信号
		CAP_START		:	out std_logic;	--キャプチャー動作開始信号
		L_R				:	out std_logic;	--左右眼出力
		START_3D		:	out std_logic;	--3D-Scanキャプチャー開始信号
		RetryFlag1_ON_OFF	:	out std_logic;		--RetryFlag
		RetryFlag2_ON_OFF	:	out std_logic;		
		C_Scan_Back_Num	:	out std_logic_vector(3 downto 0);	--3D-Scanキャプチャー終了後のBack-Scan本数選択
		V_H_3D			:	out std_logic_vector(1 downto 0);	--3D-Scanキャプチャー動作方向選択
		Mode_sel		:	out std_logic_vector(3 downto 0);	--キャプチャースキャンモード選択
		Freq_sel		:	out std_logic_vector(7 downto 0);	--H-sync周波数選択
		Start_X			:	out std_logic_vector(11 downto 0);	--スキャン開始X座標
		Start_Y			:	out std_logic_vector(11 downto 0);	--スキャン開始Y座標
		End_X			:	out std_logic_vector(11 downto 0);	--スキャン終了X座標
		End_Y			:	out std_logic_vector(11 downto 0);	--スキャン終了Y座標
		Circle_R		:	out std_logic_vector(11 downto 0);	--Circle-Scan半径選択
		Live_Resol		:	out std_logic_vector(11 downto 0);	--Live-Scan時の解像度選択
		Resolution		:	out std_logic_vector(11 downto 0);	--キャプチャー時の解像度選択
		Resol_Y			:	out std_logic_vector(11 downto 0);	--キャプチャー時のY方向解像度選択
		Live_Resol_CSTM	:	out std_logic_vector(11 downto 0);	--Live-Scan時の解像度選択（カスタムスキャン用）
		Resol_CSTM		:	out std_logic_vector(11 downto 0);	--キャプチャー時の解像度選択（カスタムスキャン用）
		Back_Resol_CSTM	:	out std_logic_vector(11 downto 0);	--Back-Scan時の解像度選択（カスタムスキャン用）
		Dum_Resol_CSTM	:	out std_logic_vector(11 downto 0);	--Dummy-Scan時の解像度選択（カスタムスキャン用）
		Dummy_Num		:	out std_logic_vector(2 downto 0);	--キャプチャー開始前のDummy-Scan数選択
		Radial_Num		:	out std_logic_vector(3 downto 0);	--Radial-Scan時のキャプチャー数選択
		Circle_Total_Num:	out std_logic_vector(5 downto 0);	--M_Circle-Scan時のキャプチャー数選択
		Circle_Dir		:	out std_logic;	--Circle-Scan回転方向選択
		L_Start_X		:	out std_logic_vector(11 downto 0);	--Live-Scan時のスキャン開始X座標
		L_Start_Y		:	out std_logic_vector(11 downto 0);	--Live-Scan時のスキャン開始Y座標
		L_End_X			:	out std_logic_vector(11 downto 0);	--Live-Scan時のスキャン終了X座標
		L_End_Y			:	out std_logic_vector(11 downto 0);	--Live-Scan時のスキャン終了Y座標
		L_Radial_R		:	out std_logic_vector(11 downto 0);	--Live-Scan時のCircle-Scan半径選択
		Web_Live_Sel	:	out std_logic;	--Web-Scan時のLive-Scan選択
		Web_Radial_R	:	out std_logic_vector(11 downto 0);	--Web-Scan中のCircle-Scan最小半径選択
		Raster_Scan_Num	:	out std_logic_vector(8 downto 0);	--Raster-Scan時のキャプチャー数選択
		Raster_Scan_Step:	out std_logic_vector(11 downto 0);	--Raster-Scan中のLine-Scan間隔選択
		Circle_Step		:	out std_logic_vector(11 downto 0);	--M_Circle/Web-Scan中のCircle-Scan間隔選択
		SLD_ON_OFF		:	out std_logic;	--SLD制御信号出力
		Adjust_Mode		:	out std_logic;	--前眼部調整モード切替
		Pulse_ON_OFF	:	out std_logic;	--SLD点灯/点滅切替
		Pulse_Mode		:	out std_logic;	--SLD工具モード切替
		SLD_M_Pos		:	out std_logic_vector(3 downto 0);	--SLD工具モード時の点灯位置選択
		Pulse_Width		:	out std_logic_vector(9 downto 0);	--SLDパルス点灯時のパルス幅選択
		SLD_Delay		:	out std_logic_vector(9 downto 0);	--SLDパルス点灯時の遅延量
		GalvX_Gain_Data	:	out std_logic_vector(7 downto 0);	--ガルバノ制御波形ゲイン設定値		
		GalvY_Gain_Data	:	out std_logic_vector(7 downto 0);	
		GalvX_Adjust	:	out std_logic_vector(11 downto 0);	--前眼部調整モード用ガルバノ座標
		GalvY_Adjust	:	out std_logic_vector(11 downto 0);	
		GalvX_OS_Data	:	out std_logic_vector(9 downto 0);	--ガルバノオフセット
		GalvY_OS_Data	:	out std_logic_vector(9 downto 0);

		EF_MOT_P		:	out std_logic							;	
		EF_CLK			:	out std_logic							;	
		EF_ENABLE		:	out std_logic							;	
		EF_RESET		:	out std_logic							;	
		EF_DATA_M		:	out std_logic							;	
		EF_MDT2			:	out std_logic							;	
		EF_MDT1			:	out std_logic							;	
		EF_TRQ2			:	out std_logic							;	
		EF_TRQ1			:	out std_logic							;	
		EF_STBY			:	out std_logic							;	
		EF_CW_CCW		:	out std_logic							;	
		EF_DM3			:	out std_logic							;	
		EF_DM2			:	out std_logic							;	
		EF_DM1			:	out std_logic							;	
		BF_MOT_P		:	out std_logic							;	
		BF_MOT			:	out std_logic_vector(3 downto 0)		;	
		ATTENUATOR_MOT_P:	out std_logic		  					;	 
		ATTENUATOR_MOT	:	out std_logic_vector(3 downto 0)  		;	 
		Bz_Capture_Timer:	out std_logic							;	-- ブザーのキャプチャ中(1) FA中(0)選択

		n_TD_DAC_CS		:	out	std_logic							;	
		TD_DAC_DIN		:	out	std_logic							;	
		TD_DAC_SCLK		:	out	std_logic							; 	
		FIX_PATTERN		:	out	std_logic_vector(3 downto 0)		;	
		KISYU      		:	out	std_logic_vector(2 downto 0)		;	
		FIX_BRIGHTNESS	:	out std_logic_vector(3 downto 0)		;	
		BF_LED_ON_OFF	:	out std_logic							;	
		Factory_Mode	:	out std_logic							;	
		WR_ADDRESS		:	out std_logic_vector(9 downto 0)		;
		WR_DATA			:	out std_logic_vector(15 downto 0)		;
		nWR_EN			:	out std_logic							;
		FOCUS_RESET			: out std_logic							;
		FOCUS_DECAY			: out std_logic							;
		REF_POLA_RESET		: out std_logic							;
		REF_POLA_DECAY		: out std_logic							;
		MOT_ENABLE			: out std_logic							;
		MOT_DECAY2			: out std_logic							;
		MOT_DECAY1			: out std_logic							;
		MOT_PHA				: out std_logic							;		
		MOT_DIR				: out std_logic							;
		MOT_PWMSW			: out std_logic							;
		PER_N				: out std_logic							;
		PER_P				: out std_logic							;
		PER_REF_SCLK		: out std_logic							; 
		PER_REF_DIN			: out std_logic							; 
		nPER_RES_CS			: out std_logic							; 
		REF_ONOFF			: out std_logic							;
		REF_DIR  			: out std_logic							;
		REF_PWM  			: out std_logic_vector(6 downto 0)		;
		POLA_ONOFF			: out std_logic							;
		POLA_DIR  			: out std_logic							;
		POLA_PWM  			: out std_logic_vector(6 downto 0)		;
		FOCUS_ONOFF			: out std_logic					 		;
		FOCUS_DIR  			: out std_logic					 		;
		FOCUS_PWM  			: out std_logic_vector(6 downto 0);
		SPI_ADR				: out std_logic_vector(23 downto 0);
		SPI_DATA			: out std_logic_vector(7 downto 0);
		SPI_ERASE			: out std_logic;
		SPI_WRITE			: out std_logic;
		SPI_READ 			: out std_logic;
		SLD_REF_SCLK 		: out std_logic;
		SLD_REF_DIN 		: out std_logic;
		nSLD_REF_CS 		: out std_logic;
		nSLD_LIMIT_CS 		: out std_logic;
		nDRV8841_SLEEP		: out std_logic;
		LineCCD_ONOFF		:	out std_logic;
		CSTM_LIVE_B_ONOFF	: out std_logic;
		CSTM_LIVE_B_F_CNT	: out std_logic_vector( 11 downto 0 );
		CSTM_LIVE_B_PITCH	: out std_logic_vector( 15 downto 0 );
		CSTM_LIVE_B_CNT		: out std_logic_vector( 11 downto 0 );
		GalvX_Gain_Data_B	: out std_logic_vector(7 downto 0);	--8bit		
		GalvY_Gain_Data_B	: out std_logic_vector(7 downto 0);	--8bit		
		CSTM_LIVE_B_RESOX	: out std_logic_vector( 11 downto 0 );
		CSTM_LIVE_B_RESOY	: out std_logic_vector( 11 downto 0 );
		CSTM_LIVE_B_OFFSETX	: out std_logic_vector( 9 downto 0 );
		CSTM_LIVE_B_OFFSETY	: out std_logic_vector( 9 downto 0 );
		V_END_WAIT_CNT		: out std_logic_vector( 12 downto 0);
		REF_PULSE			: out std_logic_vector( 15 downto 0);	-- 光路長補正モータのCaptureZlock時のパルス幅 
		Shift_X				: out std_logic_vector( 15 downto 0);
		Shift_Y				: out std_logic_vector( 15 downto 0);
		Theta				: out std_logic_vector( 15 downto 0);
		Track_en			: out std_logic;
		Track_Data_Valid	: out std_logic;
		CCDShiftX			: out std_logic_vector( 15 downto 0);
		CCDShiftY			: out std_logic_vector( 15 downto 0);
		CCDShiftGainX		: out std_logic_vector( 15 downto 0);
		CCDShiftGainY		: out std_logic_vector( 15 downto 0);
		SCAN_SET_NUM		: out std_logic_vector( 11 downto 0);
		ANGIO_SCAN			: out std_logic;
		SCAN_SET_RUN_END_ALL: out std_logic;
		SCAN_BACK_ADR		: out std_logic_vector( 11 downto 0);
		SCAN_BACK_ADR_EN	: out std_logic;
		SCAN_SET_LIVE_EN	: out std_logic;
		SCAN_WIDTH_X		: out std_logic_vector(3 downto 0);
		SCAN_WIDTH_Y		: out std_logic_vector(3 downto 0);
		keisen_update		: out std_logic;
		keisen_update_num	: out std_Logic_vector(11 downto 0);
		Repetition			: out std_logic_vector(3 downto 0);
		RAM_CONST_DATA		: out STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_ADR		: out STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_DATA_EN	: out STD_LOGIC		;
		FLASH_WR_ADDRESS	: out STD_LOGIC_VECTOR(15 downto 0);
		FLASH_WR_DATA   	: out STD_LOGIC_VECTOR(17 downto 0);
		FLASH_WR_EN     	: out STD_LOGIC;
		FLASH_RD_ADDRESS	: out STD_LOGIC_VECTOR(15 downto 0);
		FLASH_RD_DATA 		: in STD_LOGIC_VECTOR(15 downto 0);
		BOTH_WAY_SCAN		: out std_logic;
		BOTH_WAY_WAIT_TIME	: out std_logic_vector(15 downto 0);
		OVER_SCAN			: out std_logic;
		OVER_SCAN_NUM		: out std_logic_vector(7 downto 0);
		OVER_SCAN_DLY_TIME	: out std_logic_vector(15 downto 0);
		GALV_TIMING_ADJ_EN	: out std_logic;
		GALV_TIMING_ADJ_T3	: out std_logic_vector(15 downto 0);
		GALV_TIMING_ADJ_T4	: out std_logic_vector(15 downto 0);
		GALV_TIMING_ADJ_T5	: out std_logic_vector(15 downto 0);
		CSTM_WR_ADR			: out std_logic_vector(31 downto 0);
		CSTM_WR_DATA		: out std_logic_vector(15 downto 0);
		OUT_CSTM_WR_EN		: out std_logic;
--		Marilyn_mode		: out STD_LOGIC;
		VH_sync_period		: out STD_LOGIC_VECTOR(12 downto 0);
		ENC_CNT_RST			: out STD_LOGIC;
		ENC_CNT_EN			: out STD_LOGIC;
		ENC_CNT_AB			: in STD_LOGIC_VECTOR(31 downto 0);
		ENC_CNT_BA			: in STD_LOGIC_VECTOR(31 downto 0);
		OCTF_Init_speed		: out STD_LOGIC_VECTOR(13 downto 0);
		OCTF_Max_speed		: out STD_LOGIC_VECTOR(13 downto 0);
		OCTF_Motor_start			: out STD_LOGIC;
		OCTF_Total_step				: out STD_LOGIC_VECTOR(14 downto 0);
		OCTF_CW						: out STD_LOGIC;
		OCTF_Deceleration_step		: out STD_LOGIC_VECTOR(14 downto 0);
		OCTF_Increase				: out STD_LOGIC_VECTOR(13 downto 0);
		POLA_Init_speed				: out STD_LOGIC_VECTOR(13 downto 0);
		POLA_Max_speed				: out STD_LOGIC_VECTOR(13 downto 0);
		POLA_Motor_start			: out STD_LOGIC;
		POLA_Total_step				: out STD_LOGIC_VECTOR(14 downto 0);
		POLA_CW						: out STD_LOGIC;
		POLA_Deceleration_step		: out STD_LOGIC_VECTOR(14 downto 0);
		POLA_Increase				: out STD_LOGIC_VECTOR(13 downto 0);
		DelayLine_Init_speed		: out STD_LOGIC_VECTOR(13 downto 0);
		Delayline_Max_speed			: out STD_LOGIC_VECTOR(13 downto 0);
		Delayline_Motor_start		: out STD_LOGIC;
		Delayline_Total_step		: out STD_LOGIC_VECTOR(14 downto 0);
		Delayline_CW				: out STD_LOGIC;
		Delayline_Deceleration_step	: out STD_LOGIC_VECTOR(14 downto 0);
		Delayline_Increase			: out STD_LOGIC_VECTOR(13 downto 0);
		P_SW_Motor_start			: out STD_LOGIC;
		P_SW_total_step				: out STD_LOGIC_VECTOR(14 downto 0);
		P_SW_Init_speed				: out STD_LOGIC_VECTOR(13 downto 0);
		P_SW_CW						: out STD_LOGIC;
		TESTPIN_SEL					: out STD_LOGIC_VECTOR(2 downto 0)
	);


END GPIO;

ARCHITECTURE RTL OF GPIO IS

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
-- アドレスホールドレジスタ
	-- アドレスレジスタ
	signal reg_AdrsBus		: std_logic_vector(18 downto 0);		--20090107YN
	-- リード用アドレスレジスタ
	signal rdAdrsBus		: std_logic_vector(18 downto 0);		--20090107YN
	-- ライト用アドレスレジスタ
	signal wrAdrsBus		: std_logic_vector(18 downto 0);		--20090107YN

-- リード/ライト・イネーブル
	-- リード・イネーブル
	signal rdEnable			: std_logic;
	-- リード・イネーブル・カウンタ
	signal cnt_rdEnable		: std_logic_vector(2 downto 0);
	-- ライト・イネーブル
	signal wrEnable			: std_logic;
	-- リード・イネーブル・カウンタ
	signal cnt_wrEnable		: std_logic_vector(2 downto 0);


-- 入力ピンレジスタ(リードのみ)
	signal reg_FPGA_DIPSW		: std_logic_vector(9 downto 0);
	signal reg_LAMP_COVER		: std_logic;
	signal reg_SHIDO_SW			: std_logic;
	signal reg_n_EF_Detect		: std_logic;	
	signal reg_n_AF_Detect_M		: std_logic;
	signal reg_n_AF_Detect_P		: std_logic;
	signal reg_n_QM_Detect	: std_logic;		
	signal reg_DSC_SyncIn	: std_logic;
	signal reg_OVER_VOLTAGE		: std_logic;
	signal reg_CHARGE_OK		: std_logic;
	signal reg_REF_SEN_IN		: std_logic;
	signal reg_POL_SEN_IN		: std_logic;
	signal reg_YA_SEN_IN		: std_logic;
	signal reg_AXL_SEN_IN		: std_logic;
	signal reg_n_ATTENUATOR_Detect : std_logic	;	
	signal reg_GPO				: std_logic_vector(4 downto 1);
	signal reg_SLD_BUSY			: std_logic;
	signal reg_SLD_ERROR		: std_logic;
	signal reg_IMG_B_BUSY		: std_logic;
	signal reg_IMG_B_EVENT_FLAG	: std_logic;
	signal reg_AreaCCD_TRIG		: std_logic;
	signal reg_GalvX_FAULT		: std_logic;
	signal reg_GalvY_FAULT		: std_logic;
	signal reg_Galv_BUSY		: std_logic;
	signal reg_HW_Rev1			: std_logic_vector(3 downto 0);
	signal reg_HW_Rev2			: std_logic_vector(3 downto 0);
	signal reg_HW_Rev3			: std_logic_vector(3 downto 0);
	signal reg_HW_Rev4			: std_logic_vector(3 downto 0);
	signal reg_FPGA_CNT			: std_logic_vector(15 downto 0);
	signal reg_Back_Scan_Flag	: std_logic;	

	signal	reg_n_BF_Detect		: std_logic							;	
	signal	reg_PAHSE_B2		: std_logic							;	
	signal	reg_PAHSE_A2		: std_logic							;	
	signal	reg_PAHSE_B1		: std_logic							;	
	signal	reg_PAHSE_A1		: std_logic							;	
	signal	reg_FI_IN			: std_logic							;	
	signal	reg_SPI_BUSY		: std_logic							;	
	signal	reg_SPI_READ_DATA	: std_logic_vector( 7 downto 0 )	;	

-- 出力ピンレジスタ(リード/ライト可能)
	signal reg_TD_ON_OFF		: std_logic						;
	signal reg_TD_A0			: std_logic						;
	signal reg_TD_SI			: std_logic						;
	signal reg_TD_SLC			: std_logic						;
	signal reg_TD_CS			: std_logic						;
	signal reg_TD_RES			: std_logic						;
	signal reg_LED_SCLK			: std_logic						;		
	signal reg_LED_DIN			: std_logic						;		
	signal reg_SPLIT_DAC_CS		: std_logic						;		
	signal reg_ALIGN_DAC_CS		: std_logic						;		
	signal reg_EXT_FIX_LED		: std_logic						;
	signal reg_BUZZER_SH		: std_logic						;		
	signal reg_Bz_SH_FPGA		: std_logic						;		
	signal reg_Bz_FPGA_ON_OFF	: std_logic						;		
	signal reg_Bz_Capture_Timer	: std_logic						;		
	signal reg_n_TD_DAC_CS		: std_logic						;		
	signal reg_TD_DAC_DIN		: std_logic						;		
	signal reg_TD_DAC_SCLK		: std_logic						;		
	signal reg_FIX_PATTERN		: std_logic_vector(3 downto 0)	;		
	signal reg_KISYU      		: std_logic_vector(2 downto 0)	;		
	signal reg_CHIN_BREAK		: std_logic						;
	signal reg_CHIN_PHASE		: std_logic						;
	signal reg_CHIN_ENABLE		: std_logic						;
	signal reg_SEL				: std_logic_vector(1 downto 0)	;		
	signal reg_POWER_LED		: std_logic						;		
	signal reg_Vf_H_ON_OFF		: std_logic						;
	signal reg_Vf_H_H_L			: std_logic						;		
	signal reg_REF_P_SOL		: std_logic_vector(2 downto 1)	;
	signal reg_ANT_COMP_SOL		: std_logic_vector(2 downto 1)	;
	signal reg_APER_SW_SOL		: std_logic_vector(2 downto 1)	;
	signal reg_MIRROR_SOL		: std_logic_vector(2 downto 1)	;		
	signal reg_IRIS_APER_SOL	: std_logic_vector(2 downto 1)	;		
	signal reg_RELEASE_OUT		: std_logic						;
	signal reg_LAMP_CNT			: std_logic_vector(3 downto 1)	;
	signal reg_LAMP_ON_OFF		: std_logic						;
	signal reg_CHARGE			: std_logic						;
	signal reg_DISCHARGE		: std_logic						;
	signal reg_IGBT_TRIG		: std_logic						;
	signal reg_TRIGGER			: std_logic						;
	signal reg_FAF_CCD_ON_OFF	: std_logic						;   	
	signal reg_AF_MOT_P			: std_logic						;
	signal reg_AF_MOT			: std_logic_vector(4 downto 1)	;
	signal reg_LineCCD_ONOFF	: std_logic						;
	signal reg_GPI				: std_logic_vector(2 downto 1)	;		
	signal reg_Shutter2_MOT		: std_logic_vector(4 downto 1)	;		
	signal reg_Galv_GAIN_CLK	: std_logic						;
	signal reg_Galv_GAIN_SDI	: std_logic						;
	signal reg_GalvX_GAIN_CS	: std_logic						;
	signal reg_GalvY_GAIN_CS	: std_logic						;
	signal reg_Galv_OS_SCLK		: std_logic						;
	signal reg_Galv_OS_DIN		: std_logic						;
	signal reg_GalvX_OS_CS		: std_logic						;
	signal reg_GalvY_OS_CS		: std_logic						;
	signal reg_SLD_ON_OFF		: std_logic						;
	signal reg_Adjust_Mode		: std_logic						;		
	signal reg_AreaCCD_RELEASE	: std_logic						;
	signal reg_FPN_FLAG			: std_logic						;		
	signal reg_Vf_L_ON_OFF		: std_logic						;
	signal reg_Vf_L_H_L			: std_logic						;		
	signal reg_BLINK_Freq		: std_logic_vector(2 downto 0)	;
	signal reg_FIX_BLINK		: std_logic						;
	signal reg_Pulse_ON_OFF		: std_logic						;
	signal reg_Pulse_Mode		: std_logic						;
	signal reg_Pulse_Width		: std_logic_vector(9 downto 0)	;
	signal reg_SLD_Delay		: std_logic_vector(9 downto 0)	;
	signal reg_GAL_CNT_RESET	: std_logic						;
	signal reg_Galv_run			: std_logic						;
	signal reg_CAP_START		: std_logic						;
	signal reg_L_R				: std_logic						;
	signal reg_START_3D			: std_logic						;
	signal reg_RetryFlag1_ON_OFF: std_logic						;	
	signal reg_RetryFlag2_ON_OFF: std_logic						;	
	signal reg_C_Scan_Back_Num	: std_logic_vector(3 downto 0)	;	
	signal reg_V_H_3D			: std_logic_vector(1 downto 0)	;
	signal reg_Mode_sel			: std_logic_vector(3 downto 0)	;
	signal reg_Freq_sel			: std_logic_vector(7 downto 0)	;
	signal reg_Start_X			: std_logic_vector(11 downto 0)	;
	signal reg_Start_Y			: std_logic_vector(11 downto 0)	;
	signal reg_End_X			: std_logic_vector(11 downto 0)	;
	signal reg_End_Y			: std_logic_vector(11 downto 0)	;
	signal reg_Circle_R			: std_logic_vector(11 downto 0)	;
	signal reg_Live_Resol		: std_logic_vector(11 downto 0)	;
	signal reg_Resolution		: std_logic_vector(11 downto 0)	;
	signal reg_Resol_Y			: std_logic_vector(11 downto 0)	;
	signal reg_Live_Resol_CSTM	: std_logic_vector(11 downto 0)	;	
	signal reg_Resol_CSTM		: std_logic_vector(11 downto 0)	;	
	signal reg_Back_Resol_CSTM	: std_logic_vector(11 downto 0)	;	
	signal reg_Dum_Resol_CSTM	: std_logic_vector(11 downto 0)	;	
	signal reg_Dummy_Num		: std_logic_vector(2 downto 0)	;
	signal reg_Radial_Num		: std_logic_vector(3 downto 0)	;
	signal reg_Circle_Total_Num	: std_logic_vector(5 downto 0)	;
	signal reg_Circle_Dir		: std_logic						;
	signal reg_L_Start_X		: std_logic_vector(11 downto 0)	;
	signal reg_L_Start_Y		: std_logic_vector(11 downto 0)	;
	signal reg_L_End_X			: std_logic_vector(11 downto 0)	;
	signal reg_L_End_Y			: std_logic_vector(11 downto 0)	;
	signal reg_L_Radial_R		: std_logic_vector(11 downto 0)	;
	signal reg_Web_Live_Sel		: std_logic						;
	signal reg_Web_Radial_R		: std_logic_vector(11 downto 0)	;
	signal reg_Circle_Step		: std_logic_vector(11 downto 0)	;
	signal reg_Raster_Scan_Num	: std_logic_vector(8 downto 0)	;
	signal reg_Raster_Scan_Step	: std_logic_vector(11 downto 0)	;
	signal reg_GalvX_Gain_Data	: std_logic_vector(7 downto 0)	;	
	signal reg_GalvY_Gain_Data	: std_logic_vector(7 downto 0)	;	
	signal reg_GalvX_Adjust		: std_logic_vector(11 downto 0)	;	
	signal reg_GalvY_Adjust		: std_logic_vector(11 downto 0)	;	
	signal reg_GalvX_OS_Data	: std_logic_vector(9 downto 0)	;	
	signal reg_GalvY_OS_Data	: std_logic_vector(9 downto 0)	;	

	signal	reg_EF_MOT_P		: std_logic							;	
	signal	reg_EF_CLK			: std_logic							;	
	signal	reg_EF_ENABLE		: std_logic							;	
	signal	reg_EF_RESET		: std_logic							;	
	signal	reg_EF_DATA_M		: std_logic							;	
	signal	reg_EF_MDT2			: std_logic							;	
	signal	reg_EF_MDT1			: std_logic							;	
	signal	reg_EF_TRQ2			: std_logic							;	
	signal	reg_EF_TRQ1			: std_logic							;	
	signal	reg_EF_STBY			: std_logic							;	
	signal	reg_EF_CW_CCW		: std_logic							;	
	signal	reg_EF_DM3			: std_logic							;	
	signal	reg_EF_DM2			: std_logic							;	
	signal	reg_EF_DM1			: std_logic							;	
	signal	reg_Factory_Mode	: std_logic							;	
	signal	reg_bidir_out_en	: std_logic							;
	signal	DataBusOut_ff			: std_logic_vector(15 downto 0)		;
	signal 	sig_wrData 			: std_logic_vector(15 downto 0)		;

	signal	tmp_nwe				: std_logic;
	signal	tmp_nrd				: std_logic;


	signal	reg_nDRV8841_SLEEP		: std_logic;
	signal	reg_FOCUS_RESET			: std_logic;
	signal	reg_FOCUS_DECAY			: std_logic;
	signal	reg_REF_POLA_RESET		: std_logic;
	signal	reg_REF_POLA_DECAY		: std_logic;
	signal	reg_MOT_ENABLE			: std_logic;
	signal	reg_MOT_DECAY2			: std_logic;
	signal	reg_MOT_DECAY1			: std_logic;
	signal	reg_MOT_PHA				: std_logic;		
	signal	reg_MOT_DIR				: std_logic;
	signal	reg_MOT_PWMSW			: std_logic;
	signal	reg_PER_N				: std_logic;
	signal	reg_PER_P				: std_logic;
	signal	reg_PER_REF_SCLK		: std_logic; 
	signal	reg_PER_REF_DIN			: std_logic; 
	signal	reg_nPER_RES_CS			: std_logic; 
	signal	reg_REF_ONOFF			: std_logic;
	signal	reg_REF_DIR  			: std_logic;
	signal	reg_REF_PWM  			: std_logic_vector(6 downto 0);
	signal	reg_POLA_ONOFF			: std_logic;
	signal	reg_POLA_DIR  			: std_logic;
	signal	reg_POLA_PWM  			: std_logic_vector(6 downto 0);
	signal	reg_FOCUS_ONOFF			: std_logic;
	signal	reg_FOCUS_DIR  			: std_logic;
	signal	reg_FOCUS_PWM  			: std_logic_vector(6 downto 0);
	signal	reg_SLD_REF_SCLK 		: std_logic;
	signal	reg_SLD_REF_DIN 		: std_logic;
	signal	reg_nSLD_REF_CS 		: std_logic;
	signal	reg_nSLD_LIMIT_CS 		: std_logic;
	signal	reg_SPI_ADR				: std_logic_vector(23 downto 0);
	signal	reg_SPI_DATA			: std_logic_vector(7  downto 0);
	signal	reg_SPI_ERASE			: std_logic;
	signal	reg_SPI_WRITE			: std_logic;
	signal	reg_SPI_READ 			: std_logic;

	signal	reg_CSTM_LIVE_B_ONOFF	:  std_logic;
	signal	reg_CSTM_LIVE_B_F_CNT	:  std_logic_vector( 11 downto 0 );
	signal	reg_CSTM_LIVE_B_PITCH	:  std_logic_vector( 15 downto 0 );
	signal	reg_CSTM_LIVE_B_CNT		:  std_logic_vector( 11 downto 0 );
	signal	reg_GalvX_Gain_Data_B	:  std_logic_vector(7 downto 0);	
	signal	reg_GalvY_Gain_Data_B	:  std_logic_vector(7 downto 0);	
	signal	reg_CSTM_LIVE_B_RESOX	:  std_logic_vector( 11 downto 0 );
	signal	reg_CSTM_LIVE_B_RESOY	:  std_logic_vector( 11 downto 0 );
	signal	reg_CSTM_LIVE_B_OFFSETX	:  std_logic_vector( 9 downto 0 );
	signal	reg_CSTM_LIVE_B_OFFSETY	:  std_logic_vector( 9 downto 0 );
	signal	reg_V_END_WAIT_CNT		:  std_logic_vector( 12 downto 0 );
	signal	reg_REF_Pulse			:  std_logic_vector( 15 downto 0 );
	signal	reg_Shift_X				:  std_logic_vector( 15 downto 0);
	signal	reg_Shift_Y				:  std_logic_vector( 15 downto 0);
	signal	reg_Theta				:  std_logic_vector( 15 downto 0);
	signal	reg_Track_en			:  std_logic;
	signal	reg_Track_Data_Valid	:  std_logic;
	signal	reg_CCDShiftX			:  std_logic_vector( 15 downto 0);
	signal	reg_CCDShiftY			:  std_logic_vector( 15 downto 0);
	signal	reg_CCDShiftGainX		:  std_logic_vector( 15 downto 0);
	signal	reg_CCDShiftGainY		:  std_logic_vector( 15 downto 0);
	signal	reg_ANGIO_SCAN			:  std_logic;
	signal	reg_SCAN_SET_RUN_END_ALL:  std_logic;
	signal	reg_SCAN_BACK_ADR		:  std_logic_vector(11 downto 0);
	signal	reg_SCAN_BACK_ADR_EN	:  std_logic;
	signal	reg_SCAN_SET_NUM		:  std_logic_vector(11 downto 0);
	signal	reg_SCAN_SET_LIVE_EN	:  std_logic;
	signal	reg_SCAN_WIDTH_X		:  std_logic_vector(3 downto 0);
	signal	reg_SCAN_WIDTH_Y		:  std_logic_vector(3 downto 0);
	signal  reg_keisen_update		:  std_logic;
	signal	reg_keisen_update_num	:  std_logic_vector(11 downto 0);
	signal	reg_Repetition			:  std_logic_vector( 3 downto 0);
	signal	reg_RAM_CONST_DATA	 	:  std_logic_vector(15 downto 0);
	signal	reg_RAM_CONST_ADR	 	:  std_logic_vector(15 downto 0);
	signal	reg_RAM_CONST_DATA_EN	:  std_logic;
	signal 	reg_FlashWrAddress		:  std_logic_vector(15 downto 0);
	signal 	reg_FlashWrData   		:  std_logic_vector(17 downto 0);
	signal 	reg_FlashWrEn     		:  std_logic;
	signal 	reg_FlashRdAddress		:  std_logic_vector(15 downto 0);
	signal 	sig_FlashRdData   		:  std_logic_vector(15 downto 0);

	signal	reg_BOTH_WAY_SCAN		: std_logic;
	signal	reg_BOTH_WAY_WAIT_TIME	: std_logic_vector(15 downto 0);
	signal	reg_OVER_SCAN			: std_logic;
	signal	reg_OVER_SCAN_NUM		: std_logic_vector(7 downto 0);
	signal	reg_OVER_SCAN_DLY_TIME	: std_logic_vector(15 downto 0);
	signal	reg_GALV_TIMING_ADJ_EN	: std_logic;
	signal	reg_GALV_TIMING_ADJ_T3	: std_logic_vector(15 downto 0);
	signal	reg_GALV_TIMING_ADJ_T4	: std_logic_vector(15 downto 0);
	signal	reg_GALV_TIMING_ADJ_T5	: std_logic_vector(15 downto 0);

--	signal	reg_Marilyn_mode		:  std_logic;
	signal	reg_VH_sync_period		:  std_logic_vector(12 downto 0);
	signal	reg_ENC_CNT_RST			:  std_logic;
	signal	reg_ENC_CNT_EN			:  std_logic;

	signal	reg_OCTF_Init_speed		: std_logic_vector(13 downto 0);
	signal	reg_OCTF_Max_speed		: std_logic_vector(13 downto 0);
	signal	reg_OCTF_Motor_start			: std_logic;
	signal	reg_OCTF_Total_step				: std_logic_vector(14 downto 0);
	signal	reg_OCTF_CW						: std_logic;
	signal	reg_OCTF_Deceleration_step		: std_logic_vector(14 downto 0);
	signal	reg_OCTF_Increase				: std_logic_vector(13 downto 0);
	signal	reg_POLA_Init_speed				: std_logic_vector(13 downto 0);
	signal	reg_POLA_Max_speed				: std_logic_vector(13 downto 0);
	signal	reg_POLA_Motor_start			: std_logic;
	signal	reg_POLA_Total_step				: std_logic_vector(14 downto 0);
	signal	reg_POLA_CW						: std_logic;
	signal	reg_POLA_Deceleration_step		: std_logic_vector(14 downto 0);
	signal	reg_POLA_Increase				: std_logic_vector(13 downto 0);
	signal	reg_DelayLine_Init_speed		: std_logic_vector(13 downto 0);
	signal	reg_Delayline_Max_speed			: std_logic_vector(13 downto 0);
	signal	reg_Dline_Mot_start				: std_logic;
	signal	reg_Delayline_Total_step		: std_logic_vector(14 downto 0);
	signal	reg_Delayline_CW				: std_logic;
	signal	reg_Dline_Dec_step				: std_logic_vector(14 downto 0);
	signal	reg_Delayline_Increase			: std_logic_vector(13 downto 0);
	signal	reg_P_SW_Motor_start			: std_logic;
	signal	reg_P_SW_total_step				: std_logic_vector(14 downto 0);
	signal	reg_P_SW_Init_speed				: std_logic_vector(13 downto 0);
	signal	reg_P_SW_CW						: std_logic;

	signal	reg_cstm_wr_adr_upper			: std_logic_vector(31 downto 16);
	signal	reg_cstm_wr_adr_lower			: std_logic_vector(15 downto 0);
	signal	reg_cstm_wr_data				: std_logic_vector(15 downto 0);

	signal	reg_testpin_sel					: std_logic_vector(2 downto 0);

	--ライト
	signal	nWE_ff							: std_logic_vector(2 downto 0);
	signal	we								: std_logic;
	signal	we_and_cs						: std_logic;
	signal	we_ff							: std_logic_vector(1 downto 0);
	
	signal	we_pulse						: std_logic;
	
	signal	wr_adr_ff						: std_logic_vector(10 downto 0);
	signal	wr_adr_ext						: std_logic_vector(18 downto 0);
	signal	in_data_ff						: std_logic_vector(15 downto 0);
	
	signal	we_pulse_ff						: std_logic_vector(4 downto 0);
	
	--リード
	signal	nRD_ff							: std_logic_vector(17 downto 0);
	
	signal	rd_adr							: std_logic_vector(18 downto 0);
	
	signal	re								: std_logic;
	signal	tri_outen						: std_logic;
	signal	rd_data_en						: std_logic;

	signal	AdrBus_ext						: std_logic_vector(18 downto 11);

	signal	cstm_wr_en_pre					: std_logic;
	signal	cstm_wr_en						: std_logic;
	signal	cstm_wr_en_ff					: std_logic;

	signal	Galv_run_ff						: std_logic;
	signal	GAL_CON_MOVE_END_d				: std_logic;
	signal	MOVE_END_rise_edge				: std_logic;
	
	
begin

-- ************************************************************************* --
-- **********	同時処理文
-- ************************************************************************* --

	
-- アドレスホールドレジスタ
--	reg_AdrsBus <= wrAdrsBus when nWE='0' else rdAdrsBus;

	--nWEラッチ
	process(nFPGARST,FPGACLK) begin
		if( nFPGARST='0' ) then	
			nWE_ff <= (others => '1');
		elsif(FPGACLK'event and FPGACLK='1') then
			nWE_ff(2 downto 0) <= ( nWE_ff(1) & nWE_ff(0) & nWE );
		end if;
	end process;
	
	we <= ( nWE_ff(2) and not nWE_ff(1) );
	
	we_and_cs <= ( we and not nCS);
	
	--アドレス、データラッチ
	process(nFPGARST,FPGACLK) begin
		if( nFPGARST='0' ) then	
			wr_adr_ff	<= (others => '0');
			in_data_ff	<= (others => '0');			
		elsif(FPGACLK'event and FPGACLK='1') then	
			if( we = '1' )then
				wr_adr_ff 	<= AdrsBus;
				in_data_ff	<= DataBus;
			end if;
		end if;
	end process;

	AdrBus_ext(18 downto 11) <= (others => '0');	
	wr_adr_ext(18 downto 0) <= AdrBus_ext(18 downto 11) & wr_adr_ff(10 downto 0);
	
	
	process(nFPGARST,FPGACLK) begin
		if( nFPGARST='0' ) then	
			we_ff 		<= (others => '0');
			we_pulse_ff <= (others => '0');
		elsif(FPGACLK'event and FPGACLK='1') then	
			we_ff(1 downto 0) 		<= ( we_ff(0) & we_and_cs );
			we_pulse_ff(4 downto 0) <= ( we_pulse_ff(3 downto 0) & we_pulse );
		end if;
	end process;

	--We信号 2サイクルHighパルス生成
	we_pulse <= ( we_ff(1) or we_ff(0));
	
	--nRD ラッチ
	process(nFPGARST,FPGACLK) begin
		if( nFPGARST='0' ) then	
			nRD_ff <= (others => '1');
		elsif(FPGACLK'event and FPGACLK='1') then	
			nRD_ff(17 downto 0) <= (  nRD_ff(16 downto 0) & nRD );
		end if;
	end process;


	re <= '0' when ( nRD_ff(17 downto 2) = "1111111111111111" ) else '1';
	
	
	--トライステート アウトイネーブル生成
	tri_outen <= (re and not nCS);
	
	--RDデータ取得イネーブル信号
	rd_data_en <= (nRD_ff(2) and (not nRD_ff(1)) );

	cstm_wr_en_pre <= '1' when ( wr_adr_ext = B"000" & X"003B" ) else '0';
	
	cstm_wr_en		<= ( cstm_wr_en_pre and we_pulse_ff(4));

	
	--CSTM_WR_EN生成
	process(nFPGARST,FPGACLK) begin
		if( nFPGARST='0' ) then	
			cstm_wr_en_ff <= '0';
		elsif(FPGACLK'event and FPGACLK='1') then
			if( cstm_wr_en = '1' )then
				cstm_wr_en_ff <= '1';
			else
				cstm_wr_en_ff <= '0';
			end if;
		end if;
	end process;
	
	OUT_CSTM_WR_EN <= cstm_wr_en_ff;



--入力ピン
	--各入力データをレジスタへ格納
	reg_FPGA_DIPSW		<= FPGA_DIPSW;
	reg_LAMP_COVER		<= LAMP_COVER;
	reg_SHIDO_SW		<= SHIDO_SW;
	reg_n_EF_Detect		<= n_EF_Detect;		
	reg_n_AF_Detect_M	<= n_AF_Detect_P;	
	reg_n_AF_Detect_P	<= n_AF_Detect_M;	
	reg_n_QM_Detect		<= n_QM_Detect;		
	reg_DSC_SyncIn		<= DSC_SyncIn;		
	reg_OVER_VOLTAGE	<= OVER_VOLTAGE;
	reg_CHARGE_OK		<= CHARGE_OK;
	reg_REF_SEN_IN		<= REF_SEN_IN;
	reg_POL_SEN_IN		<= POL_SEN_IN;
	reg_YA_SEN_IN		<= YA_SEN_IN;
	reg_AXL_SEN_IN		<= AXL_SEN_IN;
	reg_n_ATTENUATOR_Detect<= n_ATTENUATOR_Detect;	
	reg_GPO				<= GPO;		
	reg_SLD_BUSY		<= SLD_BUSY;
	reg_SLD_ERROR		<= SLD_ERROR;
	reg_IMG_B_BUSY		<= IMG_B_BUSY;
	reg_IMG_B_EVENT_FLAG<= IMG_B_EVENT_FLAG;
	reg_AreaCCD_TRIG	<= AreaCCD_TRIG;
	reg_GalvX_FAULT		<= GalvX_FAULT;
	reg_GalvY_FAULT		<= GalvY_FAULT;
	reg_Galv_BUSY		<= Galv_BUSY;
	reg_HW_Rev1			<= HW_Rev1;
	reg_HW_Rev2			<= HW_Rev2;
	reg_HW_Rev3			<= HW_Rev3;
	reg_HW_Rev4			<= HW_Rev4;
	reg_FPGA_CNT		<= FPGA_CNT;
	reg_Back_Scan_Flag	<= Back_Scan_Flag;		
	reg_n_BF_Detect		<= n_BF_Detect;	
	reg_PAHSE_B2		<= PAHSE_B2;	
	reg_PAHSE_A2		<= PAHSE_A2;	
	reg_PAHSE_B1		<= PAHSE_B1;	
	reg_PAHSE_A1		<= PAHSE_A1;	
	reg_FI_IN			<= FI_IN;		
	reg_SPI_BUSY		<= SPI_BUSY;		
	reg_SPI_READ_DATA	<= SPI_READ_DATA;	




--出力ピン
	--各レジスタのデータを出力
	TD_ON_OFF			<= reg_TD_ON_OFF		;
	TD_A0				<= reg_TD_A0			;
	TD_SI				<= reg_TD_SI			;
	TD_SLC				<= reg_TD_SLC			;
	TD_CS				<= reg_TD_CS			;
	TD_RES				<= reg_TD_RES			;
	LED_SCLK			<= reg_LED_SCLK			;		
	LED_DIN				<= reg_LED_DIN			;		
	SPLIT_DAC_CS		<= reg_SPLIT_DAC_CS		;		
	ALIGN_DAC_CS		<= reg_ALIGN_DAC_CS		;		
	EXT_FIX_LED			<= reg_EXT_FIX_LED		;
	BUZZER_SH			<= reg_BUZZER_SH		;		
	Bz_SH_FPGA			<= reg_Bz_SH_FPGA		;		
	Bz_FPGA_ON_OFF		<= reg_Bz_FPGA_ON_OFF	;		
	Bz_Capture_Timer	<= reg_Bz_Capture_Timer	;		
	n_TD_DAC_CS			<= reg_n_TD_DAC_CS		;		
	TD_DAC_DIN			<= reg_TD_DAC_DIN		;		
	TD_DAC_SCLK			<= reg_TD_DAC_SCLK		;		
	FIX_PATTERN			<= reg_FIX_PATTERN		;		
	KISYU      			<= reg_KISYU      		;		
	CHIN_BREAK			<= reg_CHIN_BREAK		;
	CHIN_PHASE			<= reg_CHIN_PHASE		;
	CHIN_ENABLE			<= reg_CHIN_ENABLE		;
	SEL					<= reg_SEL				;		
	POWER_LED			<= reg_POWER_LED		;		
	Vf_H_ON_OFF			<= reg_Vf_H_ON_OFF		;
	Vf_H_H_L			<= reg_Vf_H_H_L			;		
	REF_P_SOL			<= reg_REF_P_SOL		;
	ANT_COMP_SOL		<= reg_ANT_COMP_SOL		;
	APER_SW_SOL			<= reg_APER_SW_SOL		;
	MIRROR_SOL			<= reg_MIRROR_SOL		;		
	IRIS_APER_SOL		<= reg_IRIS_APER_SOL	;		
	RELEASE_OUT			<= reg_RELEASE_OUT		;
	LAMP_CNT			<= reg_LAMP_CNT			;
	LAMP_ON_OFF			<= reg_LAMP_ON_OFF		;
	CHARGE				<= reg_CHARGE			;
	DISCHARGE			<= reg_DISCHARGE		;
	IGBT_TRIG			<= reg_IGBT_TRIG		;
	TRIGGER				<= reg_TRIGGER			;
	FAF_CCD_ON_OFF		<= reg_FAF_CCD_ON_OFF	;		
	AF_MOT_P			<= reg_AF_MOT_P			;
	AF_MOT				<= reg_AF_MOT			;
	LineCCD_ONOFF		<= reg_LineCCD_ONOFF		;
	GPI					<= reg_GPI				;		
	Shutter1_MOT_P		<= '0'					;		
	Shutter1_MOT		<= "0000"				;		
	Shutter2_MOT_P		<= '0'					;		
	Shutter2_MOT		<= "0000"				;		
	REF_MOT_P			<= '0'					;
	REF_MOT				<= "0000"				;
	POL_MOT_P			<= '0'					;
	POL_MOT				<= "0000"				;
	YA_MOT_P			<= '0'					;
	YA_MOT				<= "0000"				;
	Galv_GAIN_CLK		<= reg_Galv_GAIN_CLK	;
	Galv_GAIN_SDI		<= reg_Galv_GAIN_SDI	;
	GalvX_GAIN_CS		<= reg_GalvX_GAIN_CS	;
	GalvY_GAIN_CS		<= reg_GalvY_GAIN_CS	;
	Galv_OS_SCLK		<= reg_Galv_OS_SCLK		;
	Galv_OS_DIN			<= reg_Galv_OS_DIN		;
	GalvX_OS_CS			<= reg_GalvX_OS_CS		;
	GalvY_OS_CS			<= reg_GalvY_OS_CS		;
	SLD_ON_OFF			<= reg_SLD_ON_OFF		;
	Adjust_Mode			<= reg_Adjust_Mode		;		
	AreaCCD_RELEASE		<= reg_AreaCCD_RELEASE	;
	FPN_FLAG			<= reg_FPN_FLAG			;		
	Vf_L_ON_OFF			<= reg_Vf_L_ON_OFF		;
	Vf_L_H_L			<= reg_Vf_L_H_L			;		
	BLINK_Freq			<= reg_BLINK_Freq		;
	FIX_BLINK			<= reg_FIX_BLINK		;
	Pulse_ON_OFF		<= reg_Pulse_ON_OFF		;
	Pulse_Mode			<= reg_Pulse_Mode		;
	SLD_M_Pos			<= "0001"				;
	Pulse_Width			<= reg_Pulse_Width		;
	SLD_Delay			<= reg_SLD_Delay		;
	GAL_CNT_RESET		<= reg_GAL_CNT_RESET	;
--	Galv_run			<= reg_Galv_run			;
	Galv_run			<= Galv_run_ff			;

	CAP_START			<= reg_CAP_START		;
	L_R					<= not reg_L_R				;
	START_3D			<= reg_START_3D			;
	RetryFlag1_ON_OFF	<= reg_RetryFlag1_ON_OFF;		
	RetryFlag2_ON_OFF	<= reg_RetryFlag2_ON_OFF;		
	C_Scan_Back_Num		<= reg_C_Scan_Back_Num	;
	V_H_3D				<= reg_V_H_3D			;
	Mode_sel			<= reg_Mode_sel			;
	Freq_sel			<= reg_Freq_sel			;
	Start_X				<= reg_Start_X			;
	Start_Y				<= reg_Start_Y			;
	End_X				<= reg_End_X			;
	End_Y				<= reg_End_Y			;
	Circle_R			<= reg_Circle_R			;
	Live_Resol			<= reg_Live_Resol		;
	Resolution			<= reg_Resolution		;
	Resol_Y				<= reg_Resol_Y			;
	Live_Resol_CSTM		<= reg_Live_Resol_CSTM	;		
	Resol_CSTM			<= reg_Resol_CSTM		;		
	Back_Resol_CSTM		<= reg_Back_Resol_CSTM	;		
	Dum_Resol_CSTM		<= reg_Dum_Resol_CSTM	;		
	Dummy_Num			<= reg_Dummy_Num		;
	Radial_Num			<= reg_Radial_Num		;
	Circle_Total_Num	<= reg_Circle_Total_Num	;
	Circle_Dir			<= reg_Circle_Dir		;
	L_Start_X			<= reg_L_Start_X		;
	L_Start_Y			<= reg_L_Start_Y		;
	L_End_X				<= reg_L_End_X			;
	L_End_Y				<= reg_L_End_Y			;
	L_Radial_R			<= reg_L_Radial_R		;
	Web_Live_Sel		<= reg_Web_Live_Sel		;
	Web_Radial_R		<= reg_Web_Radial_R		;
	Circle_Step			<= reg_Circle_Step		;
	Raster_Scan_Num		<= reg_Raster_Scan_Num	;
	Raster_Scan_Step	<= reg_Raster_Scan_Step	;
	GalvX_Gain_Data		<= reg_GalvX_Gain_Data	;	
	GalvY_Gain_Data		<= reg_GalvY_Gain_Data	;	
	GalvX_Adjust		<= reg_GalvX_Adjust		;	
	GalvY_Adjust		<= reg_GalvY_Adjust		;	
	GalvX_OS_Data		<= reg_GalvX_OS_Data	;	
	GalvY_OS_Data		<= reg_GalvY_OS_Data	;	
	EF_MOT_P			<= reg_EF_MOT_P			;	
	EF_CLK				<= reg_EF_CLK			;	
	EF_ENABLE			<= reg_EF_ENABLE		;	
	EF_RESET			<= reg_EF_RESET			;	
	EF_DATA_M			<= reg_EF_DATA_M		;	
	EF_MDT2				<= reg_EF_MDT2			;	
	EF_MDT1				<= reg_EF_MDT1			;	
	EF_TRQ2				<= reg_EF_TRQ2			;	
	EF_TRQ1				<= reg_EF_TRQ1			;	
	EF_STBY				<= reg_EF_STBY			;	
	EF_CW_CCW			<= reg_EF_CW_CCW		;	
	EF_DM3				<= reg_EF_DM3			;	
	EF_DM2				<= reg_EF_DM2			;	
	EF_DM1				<= reg_EF_DM1			;	
	BF_MOT_P			<= '0'					;	
	BF_MOT				<= (others => '0')		;	
	ATTENUATOR_MOT_P	<= '0'					;	
	ATTENUATOR_MOT		<= (others => '0')		;	
	FIX_BRIGHTNESS		<= X"A"					;	
	BF_LED_ON_OFF		<= '0'					;	
	Factory_Mode		<= reg_Factory_Mode		;	
	WR_ADDRESS			<= wrAdrsBus(9 downto 0);
	WR_DATA				<= sig_wrData			; 
	nWR_EN				<= not wrEnable			; 
	nDRV8841_SLEEP		<= reg_nDRV8841_SLEEP;
	FOCUS_RESET			<= reg_FOCUS_RESET	;
	FOCUS_DECAY			<= reg_FOCUS_DECAY	;
	REF_POLA_RESET		<= reg_REF_POLA_RESET;
	REF_POLA_DECAY		<= reg_REF_POLA_DECAY;
	MOT_ENABLE			<= reg_MOT_ENABLE	;
	MOT_DECAY2			<= reg_MOT_DECAY2	;
	MOT_DECAY1			<= reg_MOT_DECAY1	;
	MOT_PHA				<= reg_MOT_PHA		;		
	MOT_DIR				<= reg_MOT_DIR		;
	MOT_PWMSW			<= reg_MOT_PWMSW	;
	PER_N				<= reg_PER_N		;
	PER_P				<= reg_PER_P		;
	PER_REF_SCLK		<= reg_PER_REF_SCLK	; 
	PER_REF_DIN			<= reg_PER_REF_DIN	; 
	nPER_RES_CS			<= reg_nPER_RES_CS	; 
	REF_ONOFF			<= reg_REF_ONOFF	;
	REF_DIR  			<= reg_REF_DIR  	;
	REF_PWM  			<= reg_REF_PWM  	;
	POLA_ONOFF			<= reg_POLA_ONOFF	;
	POLA_DIR  			<= reg_POLA_DIR  	;
	POLA_PWM  			<= reg_POLA_PWM  	;
	FOCUS_ONOFF			<= reg_FOCUS_ONOFF	;
	FOCUS_DIR  			<= reg_FOCUS_DIR  	;
	FOCUS_PWM  			<= reg_FOCUS_PWM  	;
	SLD_REF_SCLK 		<= reg_SLD_REF_SCLK;
	SLD_REF_DIN 		<= reg_SLD_REF_DIN ;
	nSLD_REF_CS 		<= reg_nSLD_REF_CS ;
	nSLD_LIMIT_CS 		<= reg_nSLD_LIMIT_CS ;
	SPI_ADR				<= reg_SPI_ADR		;
	SPI_DATA			<= reg_SPI_DATA		;
	SPI_ERASE			<= reg_SPI_ERASE	;
	SPI_WRITE			<= reg_SPI_WRITE	;
	SPI_READ 			<= reg_SPI_READ 	;
	CSTM_LIVE_B_ONOFF	<=	reg_CSTM_LIVE_B_ONOFF	;
	CSTM_LIVE_B_F_CNT	<=	reg_CSTM_LIVE_B_F_CNT	;
	CSTM_LIVE_B_PITCH	<=	reg_CSTM_LIVE_B_PITCH	;
	CSTM_LIVE_B_CNT		<=	reg_CSTM_LIVE_B_CNT		;
	GalvX_Gain_Data_B	<=	reg_GalvX_Gain_Data_B	;	
	GalvY_Gain_Data_B	<=	reg_GalvY_Gain_Data_B	;	
	CSTM_LIVE_B_RESOX	<=	reg_CSTM_LIVE_B_RESOX	;
	CSTM_LIVE_B_RESOY	<=	reg_CSTM_LIVE_B_RESOY	;
	CSTM_LIVE_B_OFFSETX	<=	reg_CSTM_LIVE_B_OFFSETX	;
	CSTM_LIVE_B_OFFSETY	<=	reg_CSTM_LIVE_B_OFFSETY	;
	V_END_WAIT_CNT		<=	reg_V_END_WAIT_CNT		;
	REF_PULSE     		<=	reg_REF_Pulse			;
	Shift_X				<=	reg_Shift_X				;
	Shift_Y				<=	reg_Shift_Y				;
	Theta				<=	reg_Theta				;
	Track_en			<= 	reg_Track_en			;
	Track_Data_Valid	<= 	reg_Track_Data_Valid	;
	CCDShiftX			<=  reg_CCDShiftX			;
	CCDShiftY			<=  reg_CCDShiftY			;
	CCDShiftGainX		<=  reg_CCDShiftGainX		;
	CCDShiftGainY		<=  reg_CCDShiftGainY		;
	SCAN_SET_NUM		<=	reg_SCAN_SET_NUM		;
	ANGIO_SCAN			<=  reg_ANGIO_SCAN			;
	SCAN_SET_RUN_END_ALL<=	reg_SCAN_SET_RUN_END_ALL;
	SCAN_BACK_ADR		<=	reg_SCAN_BACK_ADR		;
	SCAN_BACK_ADR_EN	<=	reg_SCAN_BACK_ADR_EN	;
	SCAN_SET_LIVE_EN	<=	reg_SCAN_SET_LIVE_EN	;
	SCAN_WIDTH_X		<= 	reg_SCAN_WIDTH_X		;
	SCAN_WIDTH_Y		<= 	reg_SCAN_WIDTH_Y		;
	keisen_update		<=	reg_keisen_update		;
	keisen_update_num	<=	reg_keisen_update_num	;
	Repetition			<=	reg_Repetition			;
	RAM_CONST_DATA		<=	reg_RAM_CONST_DATA	 	;
	RAM_CONST_ADR		<=	reg_RAM_CONST_ADR	 	;
	RAM_CONST_DATA_EN	<=	reg_RAM_CONST_DATA_EN	;

	FLASH_WR_ADDRESS	<=	reg_FlashWrAddress		;
	FLASH_WR_DATA   	<=	reg_FlashWrData   		;
	FLASH_WR_EN     	<=	reg_FlashWrEn     		;
	FLASH_RD_ADDRESS	<=	reg_FlashRdAddress		;
	sig_FlashRdData    	<=	FLASH_RD_DATA 			;

	BOTH_WAY_SCAN		<=	reg_BOTH_WAY_SCAN;
	BOTH_WAY_WAIT_TIME	<=	reg_BOTH_WAY_WAIT_TIME;
	OVER_SCAN			<=	reg_OVER_SCAN;
	OVER_SCAN_NUM		<=	reg_OVER_SCAN_NUM;
	OVER_SCAN_DLY_TIME	<=	reg_OVER_SCAN_DLY_TIME;
	GALV_TIMING_ADJ_EN	<=	reg_GALV_TIMING_ADJ_EN;
	GALV_TIMING_ADJ_T3	<=	reg_GALV_TIMING_ADJ_T3;
	GALV_TIMING_ADJ_T4	<=	reg_GALV_TIMING_ADJ_T4;
	GALV_TIMING_ADJ_T5	<=	reg_GALV_TIMING_ADJ_T5;

--	Marilyn_mode		<= reg_Marilyn_mode		;
	VH_sync_period		<= reg_VH_sync_period	;
	ENC_CNT_RST			<= reg_ENC_CNT_RST		;
	ENC_CNT_EN			<= reg_ENC_CNT_EN		;
	OCTF_Init_speed		<= reg_OCTF_Init_speed		;
	OCTF_Max_speed		<= reg_OCTF_Max_speed	    ;
	OCTF_Motor_start			<= reg_OCTF_Motor_start		        ;
	OCTF_Total_step				<= reg_OCTF_Total_step			    ;
	OCTF_CW						<= reg_OCTF_CW					    ;
	OCTF_Deceleration_step		<= reg_OCTF_Deceleration_step	    ;
	OCTF_Increase				<= reg_OCTF_Increase	        ;
	POLA_Init_speed				<= reg_POLA_Init_speed	    ;
	POLA_Max_speed				<= reg_POLA_Max_speed	    ;
	POLA_Motor_start			<= reg_POLA_Motor_start		        ;
	POLA_Total_step				<= reg_POLA_Total_step			    ;
	POLA_CW						<= reg_POLA_CW					    ;
	POLA_Deceleration_step		<= reg_POLA_Deceleration_step	    ;
	POLA_Increase				<= reg_POLA_Increase	        ;
	DelayLine_Init_speed		<= reg_DelayLine_Init_speed	;
	Delayline_Max_speed			<= reg_Delayline_Max_speed	;
	Delayline_Motor_start		<= reg_Dline_Mot_start		;
	Delayline_Total_step		<= reg_Delayline_Total_step		    ;
	Delayline_CW				<= reg_Delayline_CW				    ;
    Delayline_Deceleration_step	<= reg_Dline_Dec_step	;
    Delayline_Increase			<= reg_Delayline_Increase	;
    P_SW_Motor_start			<= reg_P_SW_Motor_start			;
    P_SW_total_step				<= reg_P_SW_total_step			;
    P_SW_Init_speed				<= reg_P_SW_Init_speed	;
	P_SW_CW						<= reg_P_SW_CW					;
	CSTM_WR_ADR					<= reg_cstm_wr_adr_upper & reg_cstm_wr_adr_lower;
	CSTM_WR_DATA        		<= reg_cstm_wr_data;
	TESTPIN_SEL					<= reg_testpin_sel;



	MOVE_END_rise_edge <= not GAL_CON_MOVE_END_d and GAL_CON_MOVE_END;
	
--	--Live停止後 B_Scanの途中で終了してしまう不具合対応
	process( reset, FPGACLK) begin
		if( reset = '1') then
			Galv_run_ff <= '0';
			GAL_CON_MOVE_END_d <= '0';
		elsif ( FPGACLK'event and FPGACLK='1') then
			GAL_CON_MOVE_END_d <= GAL_CON_MOVE_END;
			if( reg_Galv_run = '0' and  MOVE_END_rise_edge = '1' )then
				Galv_run_ff <= '0';
			elsif(  reg_Galv_run = '1' )then
				Galv_run_ff <= '1';
			end if;
		end if;
	end process;






-- ************************************************************************* --
-- **********	TriState バッファの設定		****************************************
-- ************************************************************************* --
--	process(nFPGARST,FPGACLK) begin
--		if(nFPGARST='0') then						
--			tmp_nwe <= '1';
--			tmp_nrd <= '1';
--		elsif(FPGACLK'event and FPGACLK='1') then
--			tmp_nwe <= nWE;
--			tmp_nrd <= nRD;
--		end if;
--	end process;
--
--	process(nFPGARST,FPGACLK) begin
--		if(nFPGARST='0') then						
--			reg_bidir_out_en <=  '0';		
--			sig_wrData <= (others => '0');
--		elsif(FPGACLK'event and FPGACLK='1') then
--			if( nRD = '0')then
--				sig_wrData <= (others => '0');
--			else
--				sig_wrData <= DataBus;
--			end if;
--							  
--			if(nCS='0')then
--				if(nRD='0')then
--					reg_bidir_out_en <=  '1';		
--				end if;
--			else
--				reg_bidir_out_en <=  '0';		
--			end if;
--		end if;
--	end process;


-- ************************************************************************* --
-- **********	アドレスの取得		****************************************
-- ************************************************************************* --

-- リード・アドレスの取得
--	U_RD_ADRS :
--	process(
--		nFPGARST,
--		nRD
--	) begin
--		if(
--			nFPGARST='0'
--		) then						-- リセット時(非同期リセット)
--			rdAdrsBus <= (others=>'0');				-- リード用アドレスレジスタ　クリア
--		elsif(
--			nRD'event and nRD='0'
--		) then			-- リード信号がアサート
----			rdAdrsBus(7 downto 0) <= AdrsBus(8 downto 1);	-- アドレス取得		--20090507YN
--			rdAdrsBus(9 downto 0) <= AdrsBus(9 downto 0);	-- アドレス取得		--20090507YN
--		--else			--20090507YN
--			--値保持	--20090507YN
--		end if;
--	end process;
--
---- ライト・アドレスの取得
--	U_WR_ADRS :
--	process(
--		nFPGARST,
--		nWE
--	) begin
--		if(
--			nFPGARST='0'
--		) then						-- リセット時(非同期リセット)
--			wrAdrsBus <= (others=>'0');				-- ライト用アドレスレジスタ　クリア
--		elsif(
--			nWE'event and nWE='0'
--		) then			-- ライト信号がアサート
--			wrAdrsBus(9 downto 0) <= AdrsBus(9 downto 0);	-- アドレス取得		--20090507YN
--		--else			--20090507YN
--			--値保持	--20090507YN
--		end if;
--
--	end process;

-- ************************************************************************* --
-- **********	リード/ライト・イネーブル		****************************
-- ************************************************************************* --

-- リード・イネーブル
--	U_RD_EN:process(nFPGARST,FPGACLK,cnt_rdEnable) begin
--
--	-- *****	リセット時動作	***** --
--		if(nFPGARST='0') then			-- リセット時(非同期リセット)
--			rdEnable <= '0';			-- リード・イネーブル　クリア
--		elsif(FPGACLK'event and FPGACLK='1') then
--			if(cnt_rdEnable="111") then				-- カウント上限
--				rdEnable <= '0';			-- リード・イネーブル　クリア
--			elsif(cnt_rdEnable(1)='1' or cnt_rdEnable(2)='1') then
--				rdEnable <= '1';			-- リード・イネーブル　セット
--			else
--				rdEnable <= '0';			-- リード・イネーブル　クリア
--			end if;
----		else
----			rdEnable <= '0';				-- リード・イネーブル　クリア
--		end if;
--
--	end process;
--
--	U_cnt_RD_EN:process(nFPGARST,FPGACLK,nRD) begin
--
--	-- *****	リセット時動作	***** --
--		if(nFPGARST='0') then							-- リセット時(非同期リセット)
--			cnt_rdEnable <=  (others=>'0');				-- カウンタ　クリア
--		elsif(FPGACLK'event and FPGACLK='1') then
--			if(nRD='0') then							-- カウントアップ　スタート
--				if(cnt_rdEnable="111") then				-- カウント上限
--					cnt_rdEnable <=  (others=>'1');		-- カウンタ　クリア
--				else
--					cnt_rdEnable <= cnt_rdEnable + '1';	-- カウントアップ
--				end if;
--			else
--				cnt_rdEnable <=  (others=>'0');			-- カウンタ　クリア
--			end if;
--		end if;
--
--	end process;
--
---- ライト・イネーブル
--	U_WR_EN:process(nFPGARST,FPGACLK,cnt_wrEnable) begin
--
--	-- *****	リセット時動作	***** --
--		if(nFPGARST='0') then			-- リセット時(非同期リセット)
--			wrEnable <= '0';			-- ライト・イネーブル　クリア
--		elsif(FPGACLK'event and FPGACLK='1') then
--			if(tmp_nwe = '0') then
--				if(cnt_wrEnable = "111")then
--					wrEnable <= '0';			-- ライト・イネーブル　クリア
--				elsif(cnt_wrEnable(1)='1'or cnt_wrEnable(2)='1') then
--					wrEnable <= '1';			-- ライト・イネーブル　セット
--				else
--					wrEnable <= '0';			-- ライト・イネーブル　クリア
--				end if;
--			else
--				wrEnable <= '0';				-- ライト・イネーブル　クリア
--			end if;
--		end if;
--
--	end process;
--
--	U_cnt_WR_EN:process(nFPGARST,FPGACLK) begin
--
--	-- *****	リセット時動作	***** --
--		if(nFPGARST='0') then							-- リセット時(非同期リセット)
--			cnt_wrEnable <=  (others=>'0');				-- カウンタ　クリア
--		elsif(FPGACLK'event and FPGACLK='1') then
--			--if(nWE='0') then							-- カウントアップ　スタート
--			if(tmp_nwe = '0') then							-- カウントアップ　スタート
--				if(cnt_wrEnable="111") then				-- カウント上限
--					cnt_wrEnable <=  (others=>'1');		-- カウンタ　クリア
--				else
--					cnt_wrEnable <= cnt_wrEnable + '1';	-- カウントアップ
--				end if;
--			else
--				cnt_wrEnable <=  (others=>'0');			-- カウンタ　クリア
--			end if;
--		end if;
--
--	end process;
--
--
	rd_adr <= AdrBus_ext(18 downto 11) & AdrsBus(10 downto 0);

-- ************************************************************************* --
-- **********	データのリード/ライト		********************************
-- ************************************************************************* --
	--データリード
	U_READ:process(FPGACLK,nCS,rdEnable,reg_AdrsBus) begin
		if(FPGACLK'event and FPGACLK='1') then
--			if(nCS='0') then					-- チップセレクト　アサート
--				if(rdEnable='1') then		-- リード・イネーブル　アサート
--					case reg_AdrsBus is
			if( rd_data_en = '1' )then
				case rd_adr is


				--アクセスサイズ：32bit
				--入力ピン アドレス：H'3800_0000	入力アドレス：H'3800_0000
					when B"000_0000_0000_0000_0000" =>		
						DataBusOut_ff(15 downto 12) <= reg_HW_Rev1;
						DataBusOut_ff(11 downto 8)  <= reg_HW_Rev2;
						DataBusOut_ff(7 downto 4)	 <= reg_HW_Rev3;
						DataBusOut_ff(3 downto 0)	 <= reg_HW_Rev4;

				--入力ピン アドレス：H'3800_0001	入力アドレス：H'3800_0002
					when B"000_0000_0000_0000_0001" =>		
						DataBusOut_ff(15 downto 10) <= (others=>'0');		
						DataBusOut_ff(9 downto 0) <= reg_FPGA_DIPSW;

				--入力ピン アドレス：H'3800_0002	入力アドレス：H'3800_0004		
					when B"000_0000_0000_0000_0010" =>		
						DataBusOut_ff(15 downto 6) <= (others=>'0');		
						DataBusOut_ff(5 downto 0)  <= (others=>'0');		

				--入力ピン アドレス：H'3800_0003	入力アドレス：H'3800_0006
					when B"000_0000_0000_0000_0011" =>		
						DataBusOut_ff(15) <= reg_LAMP_COVER;
						DataBusOut_ff(14) <= reg_SHIDO_SW;
						DataBusOut_ff(13) <= reg_n_EF_Detect;			
						DataBusOut_ff(12) <= reg_n_AF_Detect_P;		
						DataBusOut_ff(11) <= reg_n_AF_Detect_M;		
						DataBusOut_ff(10) <= reg_n_QM_Detect;			
						DataBusOut_ff( 9) <= reg_n_BF_Detect;			
						DataBusOut_ff(8 downto 4) <= (others=>'0');	
						DataBusOut_ff( 3) <= reg_PAHSE_B2;				
						DataBusOut_ff( 2) <= reg_PAHSE_A2;				
						DataBusOut_ff( 1) <= reg_PAHSE_B1;				
						DataBusOut_ff( 0) <= reg_PAHSE_A1;				

				--入力ピン アドレス：H'3800_0004	入力アドレス：H'3800_0008
					when B"000_0000_0000_0000_0100" =>		
						DataBusOut_ff(15) <= reg_DSC_SyncIn;			
						DataBusOut_ff(14) <= reg_OVER_VOLTAGE;
						DataBusOut_ff(13) <= reg_CHARGE_OK;
						DataBusOut_ff(12) <= reg_FI_IN;				
						DataBusOut_ff(11 downto 9) <= (others=>'0');
						DataBusOut_ff(8)  <= reg_SPI_BUSY;
						DataBusOut_ff(7 downto 0) <= reg_SPI_READ_DATA( 7 downto 0 );

				--入力ピン アドレス：H'3800_0005	入力アドレス：H'3800_000A
					when B"000_0000_0000_0000_0101" =>					
						DataBusOut_ff(15) <= reg_REF_SEN_IN;
						DataBusOut_ff(14) <= reg_POL_SEN_IN;
						DataBusOut_ff(13) <= reg_YA_SEN_IN;
						DataBusOut_ff(12 downto 11) <= (others=>'0');		
						--DataBusOut_ff(12) <= reg_AXL_SEN_IN;				
						DataBusOut_ff(10) <= reg_n_ATTENUATOR_Detect;				
						DataBusOut_ff(9 downto 4) <= (others=>'0');			
						DataBusOut_ff(3 downto 0) <= reg_GPO;		

				--入力ピン アドレス：H'3800_0006	入力アドレス：H'3800_000C
					when B"000_0000_0000_0000_0110" =>		
						DataBusOut_ff(15) <= reg_SLD_BUSY;
						DataBusOut_ff(14) <= reg_SLD_ERROR;
						DataBusOut_ff(13 downto 2) <= (others=>'0');
						DataBusOut_ff(1)  <= nFOCUS_FAULT;
						DataBusOut_ff(0)  <= nREF_POLA_FAULT;

				--入力ピン アドレス：H'3800_0007	入力アドレス：H'3800_000E
					when B"000_0000_0000_0000_0111" =>		
						DataBusOut_ff(15) <= reg_IMG_B_BUSY;
						DataBusOut_ff(14) <= reg_IMG_B_EVENT_FLAG;
						DataBusOut_ff(13) <= reg_AreaCCD_TRIG;
						DataBusOut_ff(12 downto 0) <= (others=>'0');				

				--入力ピン アドレス：H'3800_0008	入力アドレス：H'3800_0010
					when B"000_0000_0000_0000_1000" =>		
						DataBusOut_ff(15) <= reg_GalvX_FAULT;
						DataBusOut_ff(14) <= reg_GalvY_FAULT;
						DataBusOut_ff(13) <= reg_Galv_BUSY;
						DataBusOut_ff(12) <= reg_Back_Scan_Flag;		
						DataBusOut_ff(11 downto 0) <= (others=>'0');		

				--入力ピン アドレス：H'3800_0009-0000E	入力アドレス：H'3800_0012-001C	未使用
					when B"000_0000_0000_0000_1001" =>		
						DataBusOut_ff(15 downto 0) <= (others => '0');
				--入力ピン アドレス：H'3800_000F	入力アドレス：H'3800_001E
					when B"000_0000_0000_0000_1111" =>		
						DataBusOut_ff(15 downto 0) <= reg_FPGA_CNT;

				--出力ピン アドレス：H'3800_0010	入力アドレス：H'3800_0020
					when B"000_0000_0000_0001_0000" =>		
						DataBusOut_ff(15) 			<= 	reg_TD_ON_OFF	;
						DataBusOut_ff(14) 			<= 	reg_TD_A0		;
						DataBusOut_ff(13) 			<= 	reg_TD_SI		;
						DataBusOut_ff(12) 			<= 	reg_TD_SLC		;
						DataBusOut_ff(11) 			<= 	reg_TD_CS		;
						DataBusOut_ff(10) 			<= 	reg_TD_RES		;
						DataBusOut_ff(9 downto 0) 	<= 	(others=>'0')	;			
						DataBusOut_ff(9 downto 3) 	<= 	(others=>'0')	;	
						DataBusOut_ff(7)  			<= 	'0'				;	
						DataBusOut_ff(6)  			<= 	'0'				;	
						DataBusOut_ff(5)  			<= 	'0'				;	
						DataBusOut_ff(4)  			<= 	'0'				;	
						DataBusOut_ff(3)  			<= 	'0'				;	
						DataBusOut_ff(2)  			<= 	'0'				;	
						DataBusOut_ff(1)  			<= 	'0'				;	
						DataBusOut_ff(0)  			<= 	'0'				;	
						DataBusOut_ff(9)			<=	reg_n_TD_DAC_CS	;	
						DataBusOut_ff(8)			<=	reg_TD_DAC_DIN	;	
						DataBusOut_ff(7)			<=	reg_TD_DAC_SCLK	;	
						DataBusOut_ff(6 downto 3)	<=	reg_FIX_PATTERN	;	
						DataBusOut_ff(2)  			<= 	reg_POWER_LED	;	
						DataBusOut_ff(1 downto 0) 	<= 	reg_SEL			;	

				--出力ピン アドレス：H'3800_0011	入力アドレス：H'3800_0022
					when B"000_0000_0000_0001_0001" =>		
						DataBusOut_ff(15 downto 14) <= (others=>'0');		
						DataBusOut_ff(13) <= reg_EXT_FIX_LED;
						DataBusOut_ff(12) <= reg_BUZZER_SH;		
						DataBusOut_ff(11) <= reg_CHIN_BREAK;
						DataBusOut_ff(10) <= reg_CHIN_PHASE;
						DataBusOut_ff(9)  <= reg_CHIN_ENABLE;
						DataBusOut_ff(8)  <= reg_LAMP_ON_OFF;
						DataBusOut_ff(7 downto 5) <= reg_LAMP_CNT;
						DataBusOut_ff(4)  <= reg_CHARGE;
						DataBusOut_ff(3)  <= reg_DISCHARGE;
						DataBusOut_ff(2)  <= reg_IGBT_TRIG;
						DataBusOut_ff(1)  <= reg_TRIGGER;
						DataBusOut_ff(0)  <= reg_FAF_CCD_ON_OFF;		

				--出力ピン アドレス：H'3800_0012	入力アドレス：H'3800_0024
					when B"000_0000_0000_0001_0010" =>		
						DataBusOut_ff(15) 			<= reg_Vf_H_ON_OFF		;
						DataBusOut_ff(14) 			<= reg_Vf_H_H_L			;		
						DataBusOut_ff(13) 			<= reg_Vf_L_ON_OFF		;
						DataBusOut_ff(12) 			<= reg_Vf_L_H_L			;		
						DataBusOut_ff(11) 			<= '0'					;		
						DataBusOut_ff(10 downto 8) <= reg_KISYU			;		
						DataBusOut_ff(7  downto 5)	<= reg_BLINK_Freq		;
						DataBusOut_ff(4)  			<= reg_FIX_BLINK		;
						DataBusOut_ff(3) 			<= reg_Bz_SH_FPGA		;		
						DataBusOut_ff(2) 			<= reg_Bz_FPGA_ON_OFF	;		
						DataBusOut_ff(1) 			<= reg_Bz_Capture_Timer	;		
						DataBusOut_ff(0) 			<= reg_Factory_Mode		;		 

				--出力ピン アドレス：H'3800_0013	入力アドレス：H'3800_0026
					when B"000_0000_0000_0001_0011" =>		
						DataBusOut_ff(15 downto 14)	<= reg_REF_P_SOL;
						DataBusOut_ff(13 downto 12)	<= reg_ANT_COMP_SOL;
						DataBusOut_ff(11 downto 10)	<= reg_APER_SW_SOL;
						DataBusOut_ff(9 downto 8)		<= reg_MIRROR_SOL;		
						DataBusOut_ff(7 downto 6)		<= reg_IRIS_APER_SOL;	
						DataBusOut_ff(5 downto 4)		<= (others=>'0');			
						DataBusOut_ff(7 downto 0)		<= (others=>'0');			
						DataBusOut_ff(3)				<= reg_LED_SCLK;		
						DataBusOut_ff(2)				<= reg_LED_DIN;			
						DataBusOut_ff(1)				<= reg_SPLIT_DAC_CS;	
						DataBusOut_ff(0)				<= reg_ALIGN_DAC_CS;	

				--出力ピン アドレス：H'3800_0014	入力アドレス：H'3800_0028
					when B"000_0000_0000_0001_0100" =>		
						DataBusOut_ff(15) <= reg_RELEASE_OUT;
						DataBusOut_ff(14) <= reg_AF_MOT_P;
						DataBusOut_ff(13 downto 10) <= reg_AF_MOT;
						DataBusOut_ff(9 downto 5) <= (others => '0'); 	
						DataBusOut_ff(4) <= reg_LineCCD_ONOFF; 	
						DataBusOut_ff(3 downto 2) <= (others => '0'); 	
						DataBusOut_ff(1 downto 0) <= reg_GPI;		

				--出力ピン アドレス：H'3800_0015	入力アドレス：H'3800_002A
					when B"000_0000_0000_0001_0101" =>		
						DataBusOut_ff(15) 				<= reg_nDRV8841_SLEEP;
						DataBusOut_ff(13) 				<= reg_FOCUS_RESET;
						DataBusOut_ff(12) 				<= reg_FOCUS_DECAY;
						DataBusOut_ff(9) 				<= reg_REF_POLA_RESET;
						DataBusOut_ff(8) 				<= reg_REF_POLA_DECAY;
						DataBusOut_ff(5)			 	<= reg_MOT_ENABLE;
						DataBusOut_ff(4)  				<= reg_MOT_DECAY2;
						DataBusOut_ff(3) 			 	<= reg_MOT_DECAY1;
						DataBusOut_ff(2) 	 			<= reg_MOT_PHA;	
						DataBusOut_ff(1)			  	<= reg_MOT_DIR;
						DataBusOut_ff(0)  				<= reg_MOT_PWMSW;

				--出力ピン アドレス：H'3800_0016	入力アドレス：H'3800_002C
					when B"000_0000_0000_0001_0110" =>		
						DataBusOut_ff(15 downto 2) <= (others =>'0');
						DataBusOut_ff(1)  	<= reg_SPI_WRITE	;	--20100517MN
						DataBusOut_ff(0)  	<= reg_SPI_ERASE	;	--20100517MN

				--出力ピン アドレス：H'3800_0017	入力アドレス：H'3800_002E
					when B"000_0000_0000_0001_0111" =>		
						DataBusOut_ff(15) 				<= reg_Galv_GAIN_CLK;
						DataBusOut_ff(14) 				<= reg_Galv_GAIN_SDI;
						DataBusOut_ff(13) 				<= reg_GalvX_GAIN_CS;
						DataBusOut_ff(12) 				<= reg_GalvY_GAIN_CS;
						DataBusOut_ff(11) 				<= reg_Galv_OS_SCLK;
						DataBusOut_ff(10) 				<= reg_Galv_OS_DIN;
						DataBusOut_ff(9)  				<= reg_GalvX_OS_CS;
						DataBusOut_ff(8)  				<= reg_GalvY_OS_CS;
						DataBusOut_ff(7 downto 5)  	<= (others=>'0');
						DataBusOut_ff(4)  				<= reg_PER_N;
						DataBusOut_ff(3)  				<= reg_PER_P;
						DataBusOut_ff(2)  				<= reg_PER_REF_SCLK; 
						DataBusOut_ff(1)  				<= reg_PER_REF_DIN; 
						DataBusOut_ff(0)  				<= reg_nPER_RES_CS; 

				--出力ピン アドレス：H'3800_0018	入力アドレス：H'3800_0030
					when B"000_0000_0000_0001_1000" =>		
						DataBusOut_ff(15) 			<= reg_SLD_ON_OFF;
						DataBusOut_ff(14) 			<= '0';		
						DataBusOut_ff(14) 			<= reg_Adjust_Mode;		
						DataBusOut_ff(13) 			<= reg_Pulse_ON_OFF;
						DataBusOut_ff(12) 			<= reg_Pulse_Mode;
						DataBusOut_ff(11) 			<= reg_SLD_REF_SCLK;
						DataBusOut_ff(10) 			<= reg_SLD_REF_DIN;
						DataBusOut_ff(9 ) 			<= reg_nSLD_REF_CS;
						DataBusOut_ff(8)  			<= reg_nSLD_LIMIT_CS;
						DataBusOut_ff(7 downto 0)  <= reg_Pulse_Width(7 downto 0);

				--出力ピン アドレス：H'3800_0019	入力アドレス：H'3800_0032
					when B"000_0000_0000_0001_1001" =>		
						DataBusOut_ff(15) <= reg_AreaCCD_RELEASE;
						DataBusOut_ff(14) <= reg_FPN_FLAG;					
						DataBusOut_ff(13) <= reg_EF_MOT_P;					
						DataBusOut_ff(12) <= reg_EF_CLK;					
						DataBusOut_ff(11) <= reg_EF_ENABLE;				
						DataBusOut_ff(10) <= reg_EF_RESET;					
						DataBusOut_ff( 9) <= reg_EF_DATA_M;					
						DataBusOut_ff( 8) <= reg_EF_MDT2;					
						DataBusOut_ff( 7) <= reg_EF_MDT1;					
						DataBusOut_ff( 6) <= reg_EF_TRQ2;					
						DataBusOut_ff( 5) <= reg_EF_TRQ1;					
						DataBusOut_ff( 4) <= reg_EF_STBY;					
						DataBusOut_ff( 3) <= reg_EF_CW_CCW;				
						DataBusOut_ff( 2) <= reg_EF_DM3;					
						DataBusOut_ff( 1) <= reg_EF_DM2;					
						DataBusOut_ff( 0) <= reg_EF_DM1;					

				--出力ピン アドレス：H'3800_001A	入力アドレス：H'3800_0034
					when B"000_0000_0000_0001_1010" =>		
						DataBusOut_ff(15) <= reg_GAL_CNT_RESET;
						DataBusOut_ff(14) <= reg_Galv_run;
						DataBusOut_ff(13) <= reg_CAP_START;
						DataBusOut_ff(12) <= reg_L_R;
						DataBusOut_ff(11) <= reg_START_3D;
						DataBusOut_ff(10 downto 8) <= (others=>'0');		
						DataBusOut_ff(10) <= reg_RetryFlag1_ON_OFF;		
						DataBusOut_ff(9) <= reg_RetryFlag2_ON_OFF;		
						DataBusOut_ff(8) <= '0';		
						DataBusOut_ff(7 downto 4) <= reg_C_Scan_Back_Num;		
						DataBusOut_ff(3 downto 2) <= (others=>'0');		
						DataBusOut_ff(1 downto 0) <= reg_V_H_3D;

				--出力ピン アドレス：H'3800_001B	入力アドレス：H'3800_0036
					when B"000_0000_0000_0001_1011" =>		
						DataBusOut_ff(15 downto 12) <= reg_Mode_sel;
						DataBusOut_ff(11) <= '0';		
						DataBusOut_ff(10) <= '0';
						DataBusOut_ff(9 downto 8)  <= (others=>'0');		
						DataBusOut_ff(11 downto 8)  <= (others=>'0');		
						DataBusOut_ff(7 downto 0)  <= reg_Freq_sel;

				--出力ピン アドレス：H'3800_001C	入力アドレス：H'3800_0038
					when B"000_0000_0000_0001_1100" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Start_X;

				--出力ピン アドレス：H'3800_001D	入力アドレス：H'3800_003A
					when B"000_0000_0000_0001_1101" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Start_Y;

				--出力ピン アドレス：H'3800_001E	入力アドレス：H'3800_003C
					when B"000_0000_0000_0001_1110" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_End_X;

				--出力ピン アドレス：H'3800_001F	入力アドレス：H'3800_003E
					when B"000_0000_0000_0001_1111" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_End_Y;

				--出力ピン アドレス：H'3800_0020	入力アドレス：H'3800_0040
					when B"000_0000_0000_0010_0000" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Circle_R;

				--出力ピン アドレス：H'3800_0021	入力アドレス：H'3800_0042
					when B"000_0000_0000_0010_0001" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Live_Resol;

				--出力ピン アドレス：H'3800_0022	入力アドレス：H'3800_0044
					when B"000_0000_0000_0010_0010" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Resolution;

				--出力ピン アドレス：H'3800_0023	入力アドレス：H'3800_0046
					when B"000_0000_0000_0010_0011" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Resol_Y;

				--出力ピン アドレス：H'3800_0024	入力アドレス：H'3800_0048
					when B"000_0000_0000_0010_0100" =>		
						DataBusOut_ff(15 downto 13) <= reg_Dummy_Num;
						DataBusOut_ff(12) <= '0';
						DataBusOut_ff(11 downto 8)  <= reg_Radial_Num;
						DataBusOut_ff(7 downto 1)  <= (others=>'0');
						DataBusOut_ff(0)  <= reg_Circle_Dir;

				--出力ピン アドレス：H'3800_0025	入力アドレス：H'3800_004A
					when B"000_0000_0000_0010_0101" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_L_Start_X;

				--出力ピン アドレス：H'3800_0026	入力アドレス：H'3800_004C
					when B"000_0000_0000_0010_0110" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_L_Start_Y;

				--出力ピン アドレス：H'3800_0027	入力アドレス：H'3800_004E
					when B"000_0000_0000_0010_0111" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_L_End_X;

				--出力ピン アドレス：H'3800_0028	入力アドレス：H'3800_0050
					when B"000_0000_0000_0010_1000" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_L_End_Y;

				--出力ピン アドレス：H'3800_0029	入力アドレス：H'3800_0052
					when B"000_0000_0000_0010_1001" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_L_Radial_R;

				--出力ピン アドレス：H'3800_002A	入力アドレス：H'3800_0054
					when B"000_0000_0000_0010_1010" =>		
						DataBusOut_ff(15) <= reg_Web_Live_Sel;
						DataBusOut_ff(14 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Web_Radial_R;

				--出力ピン アドレス：H'3800_002B	入力アドレス：H'3800_0056
					when B"000_0000_0000_0010_1011" =>		
--reso d							DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						--DataBusOut_ff(13) <= tmp_nwe;
						--DataBusOut_ff(12) <= tmp_nrd;
						DataBusOut_ff(11 downto 0)  <= reg_Circle_Step;

				--出力ピン アドレス：H'3800_002C	入力アドレス：H'3800_0058
					when B"000_0000_0000_0010_1100" =>		
						DataBusOut_ff(15 downto 9) <= (others=>'0');
						DataBusOut_ff(8 downto 0)  <= reg_Raster_Scan_Num;

				--出力ピン アドレス：H'3800_002D	入力アドレス：H'3800_005A
					when B"000_0000_0000_0010_1101" =>		
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Raster_Scan_Step;

				--出力ピン アドレス：H'3800_002E	入力アドレス：H'3800_005C
					when B"000_0000_0000_0010_1110" =>		
						DataBusOut_ff(15 downto 14) <= (others=>'0');
						DataBusOut_ff(13 downto 8)  <= reg_Circle_Total_Num;
						DataBusOut_ff(7 downto 6)   <= (others=>'0');		
						DataBusOut_ff(5 downto 0)   <= (others=>'0');

				--出力ピン アドレス：H'3800_002F	入力アドレス：H'3800_005E		
					when B"000_0000_0000_0010_1111" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Live_Resol_CSTM;

				--出力ピン アドレス：H'3800_0030	入力アドレス：H'3800_0060		
					when B"000_0000_0000_0011_0000" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Resol_CSTM;

				--出力ピン アドレス：H'3800_0031	入力アドレス：H'3800_0062	
					when B"000_0000_0000_0011_0001" =>
						DataBusOut_ff(15 downto 8) <= reg_GalvX_Gain_Data_B;
						DataBusOut_ff(7 downto 0) <= reg_GalvX_Gain_Data;

				--出力ピン アドレス：H'3800_0032	入力アドレス：H'3800_0064	
					when B"000_0000_0000_0011_0010" =>
						DataBusOut_ff(15 downto 8) <= reg_GalvY_Gain_Data_B;
						DataBusOut_ff(7 downto 0) <= reg_GalvY_Gain_Data;

				--出力ピン アドレス：H'3800_0033	入力アドレス：H'3800_0066	
					when B"000_0000_0000_0011_0011" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0) <= reg_GalvX_Adjust;

				--出力ピン アドレス：H'3800_0034	入力アドレス：H'3800_0068	
					when B"000_0000_0000_0011_0100" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0) <= reg_GalvY_Adjust;

				--出力ピン アドレス：H'3800_0035	入力アドレス：H'3800_006A		
					when B"000_0000_0000_0011_0101" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Back_Resol_CSTM;

				--出力ピン アドレス：H'3800_0036	入力アドレス：H'3800_006C		
					when B"000_0000_0000_0011_0110" =>
						DataBusOut_ff(15 downto 12) <= (others=>'0');
						DataBusOut_ff(11 downto 0)  <= reg_Dum_Resol_CSTM;

				--出力ピン アドレス：H'3800_0037	入力アドレス：H'3800_006E		
					when B"000_0000_0000_0011_0111" =>
						DataBusOut_ff(15 downto 12) <= reg_Repetition;
						DataBusOut_ff(11 downto 10) <= (others=>'0');
						DataBusOut_ff(9 downto 0)   <= reg_GalvX_OS_Data;

				--出力ピン アドレス：H'3800_0038	入力アドレス：H'3800_0070		
					when B"000_0000_0000_0011_1000" =>
						DataBusOut_ff(15 downto 10) <= (others=>'0');
						DataBusOut_ff(9 downto 0)   <= reg_GalvY_OS_Data;
				--出力ピン アドレス：H'3800_0039
					when B"000" & X"0039" =>
						DataBusOut_ff(15 downto 0) <= reg_cstm_wr_adr_upper;
				--出力ピン アドレス：H'3800_003A
					when B"000" & X"003A" =>
						DataBusOut_ff(15 downto 0) <= reg_cstm_wr_adr_lower;
				--出力ピン アドレス：H'3800_003B
					when B"000" & X"003B" =>
						DataBusOut_ff(15 downto 0) <= reg_cstm_wr_data;
				--出力ピン アドレス：H'3800_003C	入力アドレス：H'3800_0078		
					when B"000_0000_0000_0011_1100" =>
						DataBusOut_ff(15 downto 9) 	<= (others=>'0');
						DataBusOut_ff(8          )   	<= reg_REF_ONOFF;
						DataBusOut_ff(7          )   	<= reg_REF_DIR;
						DataBusOut_ff(6 downto 0 )   	<= reg_REF_PWM;

				--出力ピン アドレス：H'3800_003D	入力アドレス：H'3800_007A		
					when B"000_0000_0000_0011_1101" =>
						DataBusOut_ff(15 downto 9) 	<= (others=>'0');
						DataBusOut_ff(8          )   	<= reg_POLA_ONOFF;
						DataBusOut_ff(7          )   	<= reg_POLA_DIR;
						DataBusOut_ff(6 downto 0 )   	<= reg_POLA_PWM;

				--出力ピン アドレス：H'3800_003E	入力アドレス：H'3800_007C		
					when B"000_0000_0000_0011_1110" =>
						DataBusOut_ff(15 downto 9) 	<= (others=>'0');
						DataBusOut_ff(8          )   	<= reg_FOCUS_ONOFF;
						DataBusOut_ff(7          )   	<= reg_FOCUS_DIR;
						DataBusOut_ff(6 downto 0 )   	<= reg_FOCUS_PWM;

				--出力ピン アドレス：H'3800_003F	入力アドレス：H'3800_007E		
					when B"000_0000_0000_0011_1111" =>
						DataBusOut_ff(15 downto 8) 	<= reg_SPI_ADR( 7 downto 0);
						DataBusOut_ff(7 downto 0 )   	<= reg_SPI_DATA( 7 downto 0 );

				--出力ピン アドレス：H'3800_0040	入力アドレス：H'3800_0080		
					when B"000_0000_0000_0100_0000" =>
						DataBusOut_ff(15 downto 0 )   	<= reg_SPI_ADR( 23 downto 8 );

				--出力ピン アドレス：H'3800_0041	入力アドレス：H'3800_0082
					when B"000_0000_0000_0100_0001" =>
						DataBusOut_ff(15 )   			<= reg_CSTM_LIVE_B_ONOFF;
						DataBusOut_ff(14 downto 12)	<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= reg_CSTM_LIVE_B_F_CNT(11 downto 0);

				--出力ピン アドレス：H'3800_0042	入力アドレス：H'3800_0084
					when B"000_0000_0000_0100_0010" =>
						DataBusOut_ff(15 downto 0)		<= reg_CSTM_LIVE_B_PITCH(15 downto 0);

				--出力ピン アドレス：H'3800_0043	入力アドレス：H'3800_0086
					when B"000_0000_0000_0100_0011" =>
						DataBusOut_ff(15 downto 12)	<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= reg_CSTM_LIVE_B_CNT(11 downto 0);

				--出力ピン アドレス：H'3800_0044	入力アドレス：H'3800_0088
					when B"000_0000_0000_0100_0100" =>
						DataBusOut_ff(15 downto 12)	<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= reg_CSTM_LIVE_B_RESOX(11 downto 0);

				--出力ピン アドレス：H'3800_0045	入力アドレス：H'3800_008a
					when B"000_0000_0000_0100_0101" =>
						DataBusOut_ff(15 downto 12)	<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= reg_CSTM_LIVE_B_RESOY(11 downto 0);

				--出力ピン アドレス：H'3800_0046	入力アドレス：H'3800_008c
					when B"000_0000_0000_0100_0110" =>
						DataBusOut_ff(15 downto 10)	<= (others => '0');
						DataBusOut_ff(9 downto 0)		<= reg_CSTM_LIVE_B_OFFSETX(9 downto 0);

				--出力ピン アドレス：H'3800_0047	入力アドレス：H'3800_008E
					when B"000_0000_0000_0100_0111" =>
						DataBusOut_ff(15 downto 10)	<= (others => '0');
						DataBusOut_ff(9 downto 0)		<= reg_CSTM_LIVE_B_OFFSETY(9 downto 0);

				--出力ピン アドレス：H'3800_0048	入力アドレス：H'3800_0090
					when B"000_0000_0000_0100_1000" =>
						DataBusOut_ff(15 downto 13)	<= (others => '0');
						DataBusOut_ff(12 downto 0)		<= reg_V_END_WAIT_CNT(12 downto 0);

				--出力ピン アドレス：H'3800_0049	入力アドレス：H'3800_0092
					when B"000_0000_0000_0100_1001" =>
						DataBusOut_ff(15 downto 0)		<= reg_REF_Pulse(15 downto 0);

				--出力ピン アドレス：H'3800_004a	入力アドレス：H'3800_0094
					when B"000_0000_0000_0100_1010" =>
						DataBusOut_ff(15 downto 0)		<= reg_Shift_X(15 downto 0);

				--出力ピン アドレス：H'3800_004b	入力アドレス：H'3800_0096
					when B"000_0000_0000_0100_1011" =>
						DataBusOut_ff(15 downto 0)		<= reg_Shift_Y(15 downto 0);

				--出力ピン アドレス：H'3800_004c	入力アドレス：H'3800_0098
					when B"000_0000_0000_0100_1100" =>
						DataBusOut_ff(15 downto 0)		<= reg_Theta(15 downto 0);

				--出力ピン アドレス：H'3800_004d	入力アドレス：H'3800_009a
					when B"000_0000_0000_0100_1101" =>
						DataBusOut_ff(15 downto 9) <= (others => '0');
						DataBusOut_ff(8)		<= reg_Track_Data_Valid;
						DataBusOut_ff(7 downto 1) <= (others => '0');
						DataBusOut_ff(0)		<= reg_Track_en;

				--出力ピン アドレス：H'3800_004e	入力アドレス：H'3800_009c
					when B"000_0000_0000_0100_1110" =>
						DataBusOut_ff(15 downto 0)		<= reg_CCDShiftX(15 downto 0);

				--出力ピン アドレス：H'3800_004f	入力アドレス：H'3800_009e
					when B"000_0000_0000_0100_1111" =>
						DataBusOut_ff(15 downto 0)		<= reg_CCDShiftY(15 downto 0);

				--出力ピン アドレス：H'3800_0050	入力アドレス：H'3800_00a0
					when B"000_0000_0000_0101_0000" =>
						DataBusOut_ff(15 downto 0)		<= reg_CCDShiftGainX(15 downto 0);

				--出力ピン アドレス：H'3800_0051	入力アドレス：H'3800_00a2
					when B"000_0000_0000_0101_0001" =>
						DataBusOut_ff(15 downto 0)		<= reg_CCDShiftGainY(15 downto 0);

				--出力ピン アドレス：H'3800_0052	入力アドレス：H'3800_00a4
					when B"000_0000_0000_0101_0010" =>
						DataBusOut_ff(11 downto 0)		<= reg_SCAN_SET_NUM(11 downto 0);
						DataBusOut_ff(14 downto 12)	<= (others => '0');
						DataBusOut_ff(15)				<= reg_ANGIO_SCAN;

				--出力ピン アドレス：H'3800_0053	入力アドレス：H'3800_00a6
					when B"000_0000_0000_0101_0011" =>
						DataBusOut_ff(11 downto 0)		<= reg_SCAN_BACK_ADR(11 downto 0);
						DataBusOut_ff(12)				<= '0';
						DataBusOut_ff(13)				<= reg_SCAN_SET_LIVE_EN;
						DataBusOut_ff(14)				<= reg_SCAN_BACK_ADR_EN;
						DataBusOut_ff(15)				<= reg_SCAN_SET_RUN_END_ALL;

				--出力ピン アドレス：H'3800_0054	入力アドレス：H'3800_00a8
					when B"000_0000_0000_0101_0100" =>
						DataBusOut_ff(3 downto 0)		<= reg_SCAN_WIDTH_X(3 downto 0);
						DataBusOut_ff(11 downto 8)		<= reg_SCAN_WIDTH_Y(3 downto 0);
						DataBusOut_ff(15 downto 12)	<= (others => '0');

				--出力ピン アドレス：H'3800_0055	入力アドレス：H'3800_00aa
					when B"000_0000_0000_0101_0101" =>
						DataBusOut_ff(15 downto 12)    <= (others => '0');
						DataBusOut_ff(11 downto 0)		<= reg_keisen_update_num( 11 downto 0 );

				--出力ピン アドレス：H'3800_0056	入力アドレス：H'3800_00ac
					when B"000_0000_0000_0101_0110" =>
						DataBusOut_ff(15 downto 0)    <= (others => '0');

				--出力ピン アドレス：H'3800_0057	入力アドレス：H'3800_00ae
					when B"000_0000_0000_0101_0111" =>
						DataBusOut_ff(15 downto 0)    <= (others => '0');

				--出力ピン アドレス：H'3800_005C	入力アドレス：H'3800_00b8	
					when B"000_0000_0000_0101_1100" =>
						DataBusOut_ff(15 downto 0)		<= sig_FlashRdData(15 downto 0)   	;


				--出力ピン アドレス：H'3800_005d	入力アドレス：H'3800_00ba
					when B"000_0000_0000_0101_1101" =>
						DataBusOut_ff(15 downto 1)	<= (others => '0');
						DataBusOut_ff(0)			<= reg_BOTH_WAY_SCAN;

				--出力ピン アドレス：H'3800_005e	入力アドレス：H'3800_00bc
					when B"000_0000_0000_0101_1110" =>
						DataBusOut_ff(15 downto 0)	<= reg_BOTH_WAY_WAIT_TIME;

				--出力ピン アドレス：H'3800_005f	入力アドレス：H'3800_00be
					when B"000_0000_0000_0101_1111" =>
						DataBusOut_ff(15 downto 9)	<= (others => '0');
						DataBusOut_ff(8)			<= reg_OVER_SCAN;
						DataBusOut_ff(7 downto 0)	<= reg_OVER_SCAN_NUM;

				--出力ピン アドレス：H'3800_0060	入力アドレス：H'3800_00c0
					when B"000_0000_0000_0110_0000" =>
						DataBusOut_ff(15 downto 0)	<= reg_OVER_SCAN_DLY_TIME;

				--出力ピン アドレス：H'3800_0061	入力アドレス：H'3800_00c2
					when B"000_0000_0000_0110_0001" =>
						DataBusOut_ff(15 downto 1)	<= (others => '0');
						DataBusOut_ff(0)			<= reg_GALV_TIMING_ADJ_EN;

				--出力ピン アドレス：H'3800_0062	入力アドレス：H'3800_00c4
					when B"000_0000_0000_0110_0010" =>
						DataBusOut_ff(15 downto 0)	<= reg_GALV_TIMING_ADJ_T3;

				--出力ピン アドレス：H'3800_0063	入力アドレス：H'3800_00c6
					when B"000_0000_0000_0110_0011" =>
						DataBusOut_ff(15 downto 0)	<= reg_GALV_TIMING_ADJ_T4;

				--出力ピン アドレス：H'3800_0064	入力アドレス：H'3800_00c8
					when B"000_0000_0000_0110_0100" =>
						DataBusOut_ff(15 downto 0)	<= reg_GALV_TIMING_ADJ_T5;




				--出力ピン アドレス：H'3800_0067	入力アドレス：H'3800_00ce
					when B"000_0000_0000_0110_0111" =>
--						DataBusOut_ff(15)			<= reg_Marilyn_mode;
						DataBusOut_ff(15)			<= '0';
						DataBusOut_ff(14)			<= reg_ENC_CNT_RST;
						DataBusOut_ff(13)			<= reg_ENC_CNT_EN;
						DataBusOut_ff(12)			<= '0';
						DataBusOut_ff(11 downto 10)<= reg_Pulse_Width(9 downto 8);
						DataBusOut_ff(9 downto 0)  <= reg_SLD_Delay;

				--出力ピン アドレス：H'3800_0068	入力アドレス：H'3800_00D0
					when B"000_0000_0000_0110_1000" =>
						DataBusOut_ff(15 downto 11)		<= (others => '0');
						DataBusOut_ff(12 downto 0)		<= reg_VH_sync_period(12 downto 0);

				--出力ピン アドレス：H'3800_0069	入力アドレス：H'3800_00D2
					when B"000_0000_0000_0110_1001" =>
						DataBusOut_ff(15 downto 0)		<= ENC_CNT_AB(31 downto 16);

				--出力ピン アドレス：H'3800_006A	入力アドレス：H'3800_00D4	
					when B"000_0000_0000_0110_1010" =>
						DataBusOut_ff(15 downto 0)		<= ENC_CNT_AB(15 downto 0);

				--出力ピン アドレス：H'3800_006B	入力アドレス：H'3800_00D6
					when B"000_0000_0000_0110_1011" =>
						DataBusOut_ff(15 downto 0)		<= ENC_CNT_BA(31 downto 16);

				--出力ピン アドレス：H'3800_006C	入力アドレス：H'3800_00D8
					when B"000_0000_0000_0110_1100" =>
						DataBusOut_ff(15 downto 0)		<= ENC_CNT_BA(15 downto 0);
				--出力ピン アドレス：H'3800_006D	入力アドレス：H'3800_00DA
        			when B"000_0000_0000_0110_1101" =>
        				DataBusOut_ff(15 downto 14)		<= (others => '0');
        				DataBusOut_ff(13 downto 0)		<= reg_OCTF_Init_speed;
        		--出力ピン アドレス：H'3800_006E	入力アドレス :H'3800_00DC
					when B"000_0000_0000_0110_1110" => 
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_OCTF_Max_speed;
				--出力ピン アドレス : H'3800_006F 入力アドレス :H'3800_00DE
					when B"000_0000_0000_0110_1111" =>
						DataBusOut_ff(15)				<= reg_OCTF_Motor_start;
						DataBusOut_ff(14 downto 0)		<= reg_OCTF_Total_step;
				--出力ピン アドレス : H'3800_0070 入力アドレス :H'3800_00E0
					when B"000_0000_0000_0111_0000" =>
						DataBusOut_ff(15)				<= reg_OCTF_CW				  ;
        		        DataBusOut_ff(14 downto 0)     <= reg_OCTF_Deceleration_step ;
				--出力ピン アドレス : H'3800_0071 入力アドレス :H'38000_00E2
					when B"000_0000_0000_0111_0001" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_OCTF_Increase;
				--出力ピン アドレス : H'3800_0072 入力アドレス :H'38000_00E4
					when B"000_0000_0000_0111_0010" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_POLA_Init_speed;
				--出力ピン アドレス : H'3800_0073 入力アドレス :H'38000_00E6
					when B"000_0000_0000_0111_0011" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_POLA_Max_speed;
				--出力ピン アドレス : H'3800_0074 入力アドレス :H'38000_00E8
					when B"000_0000_0000_0111_0100" =>
						DataBusOut_ff(15)				<= reg_POLA_Motor_start;
				        DataBusOut_ff(14 downto 0)     <= reg_POLA_Total_step;
				--出力ピン アドレス : H'3800_0075 入力アドレス : H'38000_00EA
					when B"000_0000_0000_0111_0101" =>
						DataBusOut_ff(15)				<= reg_POLA_CW;
				        DataBusOut_ff(14 downto 0)     <= reg_POLA_Deceleration_step;
				--出力ピン アドレス : H'3800_0076 入力アドレス : H'38000_00EC
					when B"000_0000_0000_0111_0110" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_POLA_Increase;
				--出力ピン アドレス : H'3800_0077 入力アドレス : H'38000_00EE
					when B"000_0000_0000_0111_0111" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_DelayLine_Init_speed;
				--出力ピン アドレス : H'3800_0078 入力アドレス : H'38000_00F0
					when B"000_0000_0000_0111_1000" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_Delayline_Max_speed;
				--出力ピン アドレス : H'3800_0079 入力アドレス : H'38000_00F2
					when B"000_0000_0000_0111_1001" =>
						DataBusOut_ff(15)				<= reg_Dline_Mot_start;
						DataBusOut_ff(14 downto 0)		<= reg_Delayline_Total_step;
				--出力ピン アドレス : H'3800_007A 入力アドレス : H'38000_00F4
					when B"000_0000_0000_0111_1010" =>
						DataBusOut_ff(15)				<= reg_Delayline_CW;
						DataBusOut_ff(14 downto 0)      <= reg_Dline_Dec_step;
				--出力ピン アドレス : H'3800_007B 入力アドレス : H'3800_00F6
					when B"000_0000_0000_0111_1011" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_Delayline_Increase;
				--出力ピン アドレス : H'3800_007C 入力アドレス : H'3800_00F8
					when B"000_0000_0000_0111_1100" =>
						DataBusOut_ff(15)				<= reg_P_SW_Motor_start;
						DataBusOut_ff(14 downto 0)     <= reg_P_SW_total_step;
				--出力ピン アドレス : H'3800_007D 入力アドレス : H'3800_00FA
					when B"000_0000_0000_0111_1101" =>
						DataBusOut_ff(15 downto 14)		<= (others => '0');
						DataBusOut_ff(13 downto 0)		<= reg_P_SW_Init_speed;
				--出力ピン アドレス : H'3800_007E 入力アドレス : H'3800_00FC
					when B"000_0000_0000_0111_1110" =>
						DataBusOut_ff(15)				<= reg_P_SW_CW;
						DataBusOut_ff(14 downto 0)		<= (others => '0');
				--出力ピン アドレス : H'3800_007F 入力アドレス : H'3800_00FE
					when B"000_0000_0000_0111_1111" =>
						DataBusOut_ff(15)				<= '0';
						DataBusOut_ff(14 downto 12)		<= reg_testpin_sel;
						DataBusOut_ff(11 downto 0)		<= cstm_Start_X;
				--出力ピン アドレス : H'3800_0080 入力アドレス : H'3800_0100
					when B"000_0000_0000_1000_0000" =>
						DataBusOut_ff(15 downto 12)		<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= cstm_Start_Y;
				--出力ピン アドレス : H'3800_0081 入力アドレス : H'3800_0102
					when B"000_0000_0000_1000_0001" =>
						DataBusOut_ff(15 downto 12)		<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= cstm_End_X;
				--出力ピン アドレス : H'3800_0082 入力アドレス : H'3800_0104
					when B"000_0000_0000_1000_0010" => 
						DataBusOut_ff(15 downto 12)		<= (others => '0');
						DataBusOut_ff(11 downto 0)		<= cstm_End_Y;
					when others =>
							null;
							DataBusOut_ff(15 downto 0) <= (others=>'0');

					end case;
				end if;
--			else
--				DataBusOut_ff <= (others=>'Z');
			end if;
---		end if;
	end process;

-- ************************************************************************* --
-- **********	同時処理文
-- ************************************************************************* --
	
--	DataBus 			<= DataBusOut_ff when reg_bidir_out_en='1' else (others => 'Z');
	DataBus 			<= DataBusOut_ff when tri_outen='1' else (others => 'Z');


-- データのライト
	U_WRITE:process(nFPGARST,FPGACLK,nCS,wrEnable,reg_AdrsBus) begin

	-- *****	リセット時動作	***** --
		if(nFPGARST='0') then					-- リセット時(非同期リセット)
		-- 出力ピンレジスタの初期化
			reg_TD_ON_OFF		<= '0';
			reg_TD_A0 			<= '0';
			reg_TD_SI 			<= '0';
			reg_TD_SLC 			<= '0';
			reg_TD_CS			<= '1';
			reg_TD_RES 			<= '1';
			reg_LED_SCLK		<= '0';		
			reg_LED_DIN			<= '0';		
			reg_SPLIT_DAC_CS	<= '1';		
			reg_ALIGN_DAC_CS	<= '1';		
			reg_EXT_FIX_LED		<= '0';
			reg_BUZZER_SH		<= '0';		
			reg_Bz_SH_FPGA		<= '0';		
			reg_Bz_FPGA_ON_OFF	<= '0';		
			reg_Bz_Capture_Timer<= '0';		--20091210MN
			reg_CHIN_BREAK		<= '0';
			reg_CHIN_PHASE		<= '0';
			reg_CHIN_ENABLE		<= '1';		
			reg_SEL				<= "01";		
			reg_POWER_LED		<= '1';		
			reg_Vf_H_ON_OFF		<= '0';
			reg_Vf_H_H_L		<= '0';		
			reg_REF_P_SOL		<= "00";
			reg_ANT_COMP_SOL	<= "00";
			reg_APER_SW_SOL		<= "00";
			reg_MIRROR_SOL		<= "00";		
			reg_IRIS_APER_SOL	<= "00";		
			reg_RELEASE_OUT		<= '0';
			reg_LAMP_CNT		<= "001";
			reg_LAMP_ON_OFF		<= '0';
			reg_CHARGE			<= '0';
			reg_DISCHARGE		<= '0';
			reg_IGBT_TRIG		<= '0';
			reg_TRIGGER			<= '0';
			reg_FAF_CCD_ON_OFF	<= '0';		
			reg_AF_MOT_P 		<= '0';
			reg_AF_MOT			<= "0000";
			reg_LineCCD_ONOFF	<= '0';
			reg_GPI				<= "00";		
			reg_Galv_GAIN_CLK	<= '0';
			reg_Galv_GAIN_SDI	<= '0';
			reg_GalvX_GAIN_CS	<= '1';
			reg_GalvY_GAIN_CS	<= '1';
			reg_Galv_OS_SCLK 	<= '0';
			reg_Galv_OS_DIN 	<= '0';
			reg_GalvX_OS_CS		<= '1';
			reg_GalvY_OS_CS		<= '1';
			reg_SLD_ON_OFF		<= '0';
			reg_Adjust_Mode		<= '0';		
			reg_AreaCCD_RELEASE	<= '0';
			reg_FPN_FLAG		<= '0';		
			reg_Vf_L_ON_OFF		<= '0';
			reg_Vf_L_H_L		<= '1';		
			reg_BLINK_Freq		<= "000";
			reg_FIX_BLINK		<= '0';
			reg_Pulse_ON_OFF	<= '0';
			reg_Pulse_Mode		<= '0';
			reg_Pulse_Width		<= "00" & X"64";
			reg_SLD_Delay		<= "00" & X"00";
			reg_GAL_CNT_RESET	<= '1';
			reg_Galv_run 		<= '0';
			reg_CAP_START		<= '0';
			reg_L_R 			<= '0';
			reg_START_3D 		<= '0';
			reg_RetryFlag1_ON_OFF	<= '0';		
			reg_RetryFlag2_ON_OFF	<= '0';		
			reg_C_Scan_Back_Num	<= "0011";		--20081217YN
			reg_V_H_3D 			<= "00";
			reg_Mode_sel 		<= "0001";
			reg_Freq_sel		<= "00011011";
			reg_Start_X 		<= X"BFF";
			reg_Start_Y 		<= X"7FF";
			reg_End_X 			<= X"3FF";
			reg_End_Y 			<= X"7FF";
			reg_Circle_R 		<= X"7FF";
			reg_Live_Resol		<= X"3FF";
			reg_Resolution		<= X"3FF";
			reg_Resol_Y 		<= X"600";
			reg_Live_Resol_CSTM	<= X"3FF";		
			reg_Resol_CSTM		<= X"3FF";		
			reg_Back_Resol_CSTM	<= X"3FF";		
			reg_Dum_Resol_CSTM	<= X"3FF";		
			reg_Dummy_Num		<= "000";
			reg_Radial_Num		<= "0000";
			reg_Circle_Total_Num<= "000010";
			reg_Circle_Dir		<= '0';
			reg_L_Start_X 		<= X"BFF";
			reg_L_Start_Y 		<= X"7FF";
			reg_L_End_X 		<= X"7FF";
			reg_L_End_Y 		<= X"7FF";
			reg_L_Radial_R 		<= X"7FF";
			reg_Web_Live_Sel	<= '0';
			reg_Web_Radial_R	<= X"5FF";
			reg_Circle_Step 	<= X"0CC";
			reg_Raster_Scan_Num	<= "000100000";
			reg_Raster_Scan_Step<= X"02A";
			reg_GalvX_Gain_Data	<= X"00";
			reg_GalvY_Gain_Data	<= X"00";
			reg_GalvX_Adjust	<= X"7FF";	--12bit		
			reg_GalvY_Adjust	<= X"7FF";	--12bit		
			reg_GalvX_OS_Data	<= B"01_1111_1111";
			reg_GalvY_OS_Data	<= B"01_1111_1111";

			reg_Repetition		<= ( others => '0');

			reg_EF_MOT_P			<= '0'				;	
			reg_EF_CLK				<= '0'				;	
			reg_EF_ENABLE			<= '0'				;	
			reg_EF_RESET			<= '0'				;	
			reg_EF_DATA_M			<= '0'				;	
			reg_EF_MDT2				<= '0'				;	
			reg_EF_MDT1				<= '0'				;	
			reg_EF_TRQ2				<= '0'				;	
			reg_EF_TRQ1				<= '0'				;	
			reg_EF_STBY				<= '0'				;	
			reg_EF_CW_CCW			<= '0'				;	
			reg_EF_DM3				<= '0'				;	
			reg_EF_DM2				<= '0'				;	
			reg_EF_DM1				<= '0'				;	

			reg_n_TD_DAC_CS			<= '1'				;	
			reg_TD_DAC_DIN			<= '0'				;	
			reg_TD_DAC_SCLK			<= '0'				;	
			reg_FIX_PATTERN			<= (others => '0')	;	
			reg_KISYU				<= (others => '0')	;	
			reg_Factory_Mode		<= '0'				;	
			reg_nDRV8841_SLEEP		<= '0';
			reg_FOCUS_RESET			<= '1';
			reg_FOCUS_DECAY			<= '0';
			reg_REF_POLA_RESET		<= '1';
			reg_REF_POLA_DECAY		<= '0';
			reg_MOT_ENABLE			<= '0';
			reg_MOT_DECAY2			<= '0';
	 		reg_MOT_DECAY1			<= '0';
			reg_MOT_PHA				<= '0';		
			reg_MOT_DIR				<= '0';
			reg_MOT_PWMSW			<= '1';
			reg_PER_N				<= 	'0'  ;
			reg_PER_P				<= 	'0'  ;
			reg_PER_REF_SCLK		<= 	'0'  ; 
			reg_PER_REF_DIN			<= 	'0'  ; 
			reg_nPER_RES_CS			<= 	'1'  ; 
			reg_REF_ONOFF			<= 	'0'	;
			reg_REF_DIR  			<= 	'0'	;
			reg_REF_PWM  			<= (others => '0');
			reg_POLA_ONOFF			<= 	'0'	;
			reg_POLA_DIR  			<= 	'0'	;
			reg_POLA_PWM  			<= (others => '0');
			reg_FOCUS_ONOFF			<= 	'0'	;
			reg_FOCUS_DIR  			<= 	'0'	;
			reg_FOCUS_PWM  			<= (others => '0');
			reg_SLD_REF_SCLK 		<= '0';
			reg_SLD_REF_DIN 		<= '0';
			reg_nSLD_REF_CS 		<= '0';
			reg_nSLD_LIMIT_CS 		<= '0';
			reg_SPI_ADR				<= (others => '0');
			reg_SPI_DATA			<= (others => '0');
			reg_SPI_ERASE			<= '0';
			reg_SPI_WRITE			<= '0';
			reg_SPI_READ 			<= '0';
			reg_CSTM_LIVE_B_ONOFF	<= '0';
			reg_CSTM_LIVE_B_F_CNT	<= (others => '0');
			reg_CSTM_LIVE_B_PITCH	<= X"0203";
			reg_CSTM_LIVE_B_CNT		<= X"00f";
			reg_GalvX_Gain_Data_B	<= X"AE";	--8bit		
			reg_GalvY_Gain_Data_B	<= X"AE";	--8bit		
			reg_CSTM_LIVE_B_RESOX	<= X"1ff";
			reg_CSTM_LIVE_B_RESOY	<= X"07f";
			reg_CSTM_LIVE_B_OFFSETX	<= B"10_0000_0000";
			reg_CSTM_LIVE_B_OFFSETY	<= B"10_0000_0000";
			reg_V_END_WAIT_CNT		<= B"0_0000_0000_1100";
			reg_REF_Pulse			<= (others => '0');
			reg_Shift_X				<= (others => '0');
			reg_Shift_Y				<= (others => '0');
			reg_Theta				<= (others => '0');
			reg_Track_en			<= '0';
			reg_Track_Data_Valid	<= '0';
			reg_CCDShiftX			<= (others => '0');
			reg_CCDShiftY			<= (others => '0');
			reg_CCDShiftGainX		<= (others => '0');
			reg_CCDShiftGainY		<= (others => '0');
			reg_SCAN_SET_NUM		<= (others => '0');
			reg_ANGIO_SCAN			<= '0';
			reg_SCAN_SET_RUN_END_ALL<= '0';
			reg_SCAN_BACK_ADR		<= (others=>'0');
			reg_SCAN_BACK_ADR_EN	<= '0';
			reg_SCAN_SET_LIVE_EN	<= '0';
			reg_SCAN_WIDTH_X		<= ( others => '0');
			reg_SCAN_WIDTH_Y		<= ( others => '0');
			reg_keisen_update		<= '0';
			reg_keisen_update_num	<= ( others => '0');
			reg_Repetition			<= (others => '0');
			reg_RAM_CONST_DATA	 	<= ( others => '0');
			reg_RAM_CONST_ADR	 	<= ( others => '0');
			reg_RAM_CONST_DATA_EN	<= '0';
			reg_FlashWrAddress		<= (others => '0');
			reg_FlashWrData   		<= (others => '0');
			reg_FlashWrEn     		<= '0';
			reg_BOTH_WAY_SCAN		<= '0';
			reg_BOTH_WAY_WAIT_TIME	<= X"1770"; -- 300us
			reg_OVER_SCAN			<= '0';
			reg_OVER_SCAN_NUM		<= X"00";
			reg_OVER_SCAN_DLY_TIME	<= X"0300"; -- 153.6us
			reg_GALV_TIMING_ADJ_EN	<= '1'; 
			reg_GALV_TIMING_ADJ_T3	<= X"1F40";	-- 400us
			reg_GALV_TIMING_ADJ_T4	<= X"5DC0";	-- 1200us
			reg_GALV_TIMING_ADJ_T5	<= X"1F40";	-- 400us
--			reg_Marilyn_mode		<= '0';
			reg_VH_sync_period		<= "1010010100011";
			reg_ENC_CNT_RST			<= '0';
			reg_ENC_CNT_EN			<= '0';
			reg_OCTF_Init_speed					<= "00" & X"1F4";--500pps
			reg_OCTF_Max_speed	        		<= "00" & X"708"; --1800pps
			reg_OCTF_Motor_start		        <= '0';
			reg_OCTF_Total_step			        <= "000" & X"001";
			reg_OCTF_CW					        <= '0';
			reg_OCTF_Deceleration_step	        <= "000" & X"25D"; --605step
			reg_OCTF_Increase	        		<= (others => '0');
			reg_POLA_Init_speed	        		<= "00" & X"1F4";--500pps
			reg_POLA_Max_speed	       			<= "00" & X"44C"; --1100pps
			reg_POLA_Motor_start		        <= '0';
			reg_POLA_Total_step			        <= "000" & X"001";
			reg_POLA_CW					        <= '0';
			reg_POLA_Deceleration_step	        <= "000" & X"026"; --38step
			reg_POLA_Increase	        		<= (others => '0');
			reg_DelayLine_Init_speed	    	<= "00" & X"1F4";--500pps
			reg_Delayline_Max_speed	    		<= "00" & X"7D0"; --2000pps
			reg_Dline_Mot_start		   			 <= '0';
			reg_Delayline_Total_step		    <=  "000" & X"001";
			reg_Delayline_CW				    <= '0';
			reg_Dline_Dec_step	   				 <= "000" & X"2C8";
			reg_Delayline_Increase	   			<= (others => '0');
			reg_P_SW_Motor_start			    <= '0';
			reg_P_SW_total_step			    	<= "000" & X"001";
			reg_P_SW_Init_speed	   				<= "00" & X"258"; --600pps
			reg_P_SW_CW							<= '0';
		elsif(FPGACLK'event and FPGACLK='1') then
--			if(nCS='0') then					-- チップセレクト　アサート
--				if(wrEnable='1') then		-- ライト・イネーブル　アサート
--					case reg_AdrsBus is

			if(we_pulse_ff(4) = '1') then		-- ライト・イネーブル　アサート
				case wr_adr_ext is
				--出力ピン アドレス：H'3800_0010	入力アドレス：H'3800_0020
					when B"000_0000_0000_0001_0000" =>		
						reg_TD_ON_OFF 	<= in_data_ff(15)			;
						reg_TD_A0		<= in_data_ff(14)			;
						reg_TD_SI		<= in_data_ff(13)			;
						reg_TD_SLC 		<= in_data_ff(12)			;
						reg_TD_CS		<= in_data_ff(11)			;
						reg_TD_RES		<= in_data_ff(10)			;
						reg_n_TD_DAC_CS	<= in_data_ff(9)				;		
						reg_TD_DAC_DIN	<= in_data_ff(8)				;		
						reg_TD_DAC_SCLK	<= in_data_ff(7)				;		
						reg_FIX_PATTERN	<= in_data_ff(6 downto 3)	;		
						reg_POWER_LED	<= in_data_ff(2)				;		
						reg_SEL			<= in_data_ff(1 downto 0)	;		

				--出力ピン アドレス：H'3800_0011	入力アドレス：H'3800_0022
					when B"000_0000_0000_0001_0001" =>		
						reg_EXT_FIX_LED	<= in_data_ff(13);
						reg_BUZZER_SH	<= in_data_ff(12);		
						reg_CHIN_BREAK	<= in_data_ff(11);
						reg_CHIN_PHASE	<= in_data_ff(10);
						reg_CHIN_ENABLE	<= in_data_ff(9);
						reg_LAMP_ON_OFF	<= in_data_ff(8);
						reg_LAMP_CNT	<= in_data_ff(7 downto 5);
						reg_CHARGE		<= in_data_ff(4);
						reg_DISCHARGE	<= in_data_ff(3);
						reg_IGBT_TRIG	<= in_data_ff(2);
						reg_TRIGGER		<= in_data_ff(1);
						reg_FAF_CCD_ON_OFF	<= in_data_ff(0);		

				--出力ピン アドレス：H'3800_0012	入力アドレス：H'3800_0024
					when B"000_0000_0000_0001_0010" =>		
						reg_Vf_H_ON_OFF		<= in_data_ff(15)			;
						reg_Vf_H_H_L 		<= in_data_ff(14)			;		
						reg_Vf_L_ON_OFF		<= in_data_ff(13)			;
						reg_Vf_L_H_L		<= in_data_ff(12)			;		
						reg_KISYU			<= in_data_ff(10 downto 8)	;		
						reg_BLINK_Freq		<= in_data_ff(7  downto 5)	;
						reg_FIX_BLINK		<= in_data_ff(4)				;
						reg_Bz_SH_FPGA		<= in_data_ff(3)				;		
						reg_Bz_FPGA_ON_OFF	<= in_data_ff(2)				;		
						reg_Bz_Capture_Timer<= in_data_ff(1)				;		
						reg_Factory_Mode	<= in_data_ff(0)				;		

				--出力ピン アドレス：H'3800_0013	入力アドレス：H'3800_0026
					when B"000_0000_0000_0001_0011" =>		
						reg_REF_P_SOL	<= in_data_ff(15 downto 14);
						reg_ANT_COMP_SOL<= in_data_ff(13 downto 12);
						reg_APER_SW_SOL	<= in_data_ff(11 downto 10);
						reg_MIRROR_SOL	<= in_data_ff(9 downto 8);		
						reg_IRIS_APER_SOL	<= in_data_ff(7 downto 6);		
						reg_LED_SCLK	<= in_data_ff(3);		
						reg_LED_DIN		<= in_data_ff(2);		
						reg_SPLIT_DAC_CS<= in_data_ff(1);		
						reg_ALIGN_DAC_CS<= in_data_ff(0);		

				--出力ピン アドレス：H'3800_0014	入力アドレス：H'3800_0028
					when B"000_0000_0000_0001_0100" =>		
						reg_RELEASE_OUT		<= in_data_ff(15);
						reg_AF_MOT_P 		<= in_data_ff(14);
						reg_AF_MOT			<= in_data_ff(13 downto 10);
						reg_LineCCD_ONOFF	<= in_data_ff(4);
						reg_GPI				<= in_data_ff(1 downto 0);		

				--出力ピン アドレス：H'3800_0015	入力アドレス：H'3800_002A
					when B"000_0000_0000_0001_0101" =>		
						reg_nDRV8841_SLEEP	<= in_data_ff(15);
						reg_FOCUS_RESET		<= in_data_ff(13);
						reg_FOCUS_DECAY		<= in_data_ff(12);
						reg_REF_POLA_RESET	<= in_data_ff(9) ;
						reg_REF_POLA_DECAY	<= in_data_ff(8) ;
						reg_MOT_ENABLE		<= in_data_ff(5) ;
						reg_MOT_DECAY2		<= in_data_ff(4) ;
					 	reg_MOT_DECAY1		<= in_data_ff(3) ;
						reg_MOT_PHA			<= in_data_ff(2) ;		
						reg_MOT_DIR			<= in_data_ff(1) ;
						reg_MOT_PWMSW		<= in_data_ff(0) ;

				--出力ピン アドレス：H'3800_0016	入力アドレス：H'3800_002C
					when B"000_0000_0000_0001_0110" =>		
						reg_SPI_READ 		<= in_data_ff( 2)  	;	
						reg_SPI_WRITE		<= in_data_ff( 1)  	;	
						reg_SPI_ERASE		<= in_data_ff( 0)	;	

				--出力ピン アドレス：H'3800_0017	入力アドレス：H'3800_002E
					when B"000_0000_0000_0001_0111" =>		
						reg_Galv_GAIN_CLK	<= 	in_data_ff(15)	;
						reg_Galv_GAIN_SDI	<= 	in_data_ff(14)	;
						reg_GalvX_GAIN_CS	<= 	in_data_ff(13)	;
						reg_GalvY_GAIN_CS	<= 	in_data_ff(12)	;
						reg_Galv_OS_SCLK	<= 	in_data_ff(11)	;
						reg_Galv_OS_DIN		<= 	in_data_ff(10)	;
						reg_GalvX_OS_CS		<= 	in_data_ff(9)	;
						reg_GalvY_OS_CS		<= 	in_data_ff(8)	;
						reg_PER_N			<= 	in_data_ff(4)  ;
						reg_PER_P			<= 	in_data_ff(3)  ;
						reg_PER_REF_SCLK	<= 	in_data_ff(2)  ; 
						reg_PER_REF_DIN		<= 	in_data_ff(1)  ; 
						reg_nPER_RES_CS		<= 	in_data_ff(0)  ; 

				--出力ピン アドレス：H'3800_0018	入力アドレス：H'3800_0030
					when B"000_0000_0000_0001_1000" =>		
						reg_SLD_ON_OFF		<= in_data_ff(15);
						reg_Adjust_Mode		<= in_data_ff(14);		
						reg_Pulse_ON_OFF	<= in_data_ff(13);
						reg_Pulse_Mode		<= in_data_ff(12);
						reg_SLD_REF_SCLK 	<= in_data_ff(11);
						reg_SLD_REF_DIN 	<= in_data_ff(10);
						reg_nSLD_REF_CS 	<= in_data_ff(9 );
						reg_nSLD_LIMIT_CS 	<= in_data_ff(8 );
						reg_Pulse_Width(7 downto 0)		<= in_data_ff(7 downto 0);

				--出力ピン アドレス：H'3800_0019	入力アドレス：H'3800_0032	未使用
					when B"000_0000_0000_0001_1001" =>		
						reg_AreaCCD_RELEASE		<= in_data_ff(15) ;
						reg_FPN_FLAG			<= in_data_ff(14) ;			
						reg_EF_MOT_P			<= in_data_ff(13) ; 			
						reg_EF_CLK				<= in_data_ff(12) ; 			
						reg_EF_ENABLE			<= in_data_ff(11) ; 			
						reg_EF_RESET			<= in_data_ff(10) ; 			
						reg_EF_DATA_M			<= in_data_ff( 9) ; 			
						reg_EF_MDT2				<= in_data_ff( 8) ; 			
						reg_EF_MDT1				<= in_data_ff( 7) ; 			
						reg_EF_TRQ2				<= in_data_ff( 6) ; 			
						reg_EF_TRQ1				<= in_data_ff( 5) ; 			
						reg_EF_STBY				<= in_data_ff( 4) ; 			
						reg_EF_CW_CCW			<= in_data_ff( 3) ; 			
						reg_EF_DM3				<= in_data_ff( 2) ; 			
						reg_EF_DM2				<= in_data_ff( 1) ; 			
						reg_EF_DM1				<= in_data_ff( 0) ; 			

				--出力ピン アドレス：H'3800_001A	入力アドレス：H'3800_0034
					when B"000_0000_0000_0001_1010" =>		
						reg_GAL_CNT_RESET		<= in_data_ff(15);
						reg_Galv_run			<= in_data_ff(14);
						reg_CAP_START			<= in_data_ff(13);
						reg_L_R					<= in_data_ff(12);
						reg_START_3D			<= in_data_ff(11);
						reg_RetryFlag1_ON_OFF	<= in_data_ff(10);		
						reg_RetryFlag2_ON_OFF	<= in_data_ff(9);		
						reg_C_Scan_Back_Num		<= in_data_ff(7 downto 4);		--20081217YN
						reg_V_H_3D				<= in_data_ff(1 downto 0);

				--出力ピン アドレス：H'3800_001B	入力アドレス：H'3800_0036
					when B"000_0000_0000_0001_1011" =>		
						reg_Mode_sel	<= in_data_ff(15 downto 12);
						reg_Freq_sel	<= in_data_ff(7 downto 0);

				--出力ピン アドレス：H'3800_001C	入力アドレス：H'3800_0038
					when B"000_0000_0000_0001_1100" =>		
						reg_Start_X	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_001D	入力アドレス：H'3800_003A
					when B"000_0000_0000_0001_1101" =>		
						reg_Start_Y	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_001E	入力アドレス：H'3800_003C
					when B"000_0000_0000_0001_1110" =>		
						reg_End_X	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_001F	入力アドレス：H'3800_003E
					when B"000_0000_0000_0001_1111" =>		
						reg_End_Y	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0020	入力アドレス：H'3800_0040
					when B"000_0000_0000_0010_0000" =>		
						reg_Circle_R	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0021	入力アドレス：H'3800_0042
					when B"000_0000_0000_0010_0001" =>		
						reg_Live_Resol	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0022	入力アドレス：H'3800_0044
					when B"000_0000_0000_0010_0010" =>		
						reg_Resolution	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0023	入力アドレス：H'3800_0046
					when B"000_0000_0000_0010_0011" =>		
						reg_Resol_Y	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0024	入力アドレス：H'3800_0048
					when B"000_0000_0000_0010_0100" =>		
						reg_Dummy_Num	 <= in_data_ff(15 downto 13);
						reg_Radial_Num	 <= in_data_ff(11 downto 8);
						reg_Circle_Dir	 <= in_data_ff(0);

				--出力ピン アドレス：H'3800_0025	入力アドレス：H'3800_004A
					when B"000_0000_0000_0010_0101" =>		
						reg_L_Start_X	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0026	入力アドレス：H'3800_004C
					when B"000_0000_0000_0010_0110" =>		
						reg_L_Start_Y	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0027	入力アドレス：H'3800_004E
					when B"000_0000_0000_0010_0111" =>		
						reg_L_End_X	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0028	入力アドレス：H'3800_0050
					when B"000_0000_0000_0010_1000" =>		
						reg_L_End_Y	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0029	入力アドレス：H'3800_0052
					when B"000_0000_0000_0010_1001" =>		
						reg_L_Radial_R	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_002A	入力アドレス：H'3800_0054
					when B"000_0000_0000_0010_1010" =>		
						reg_Web_Live_Sel	<= in_data_ff(15);
						reg_Web_Radial_R	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_002B	入力アドレス：H'3800_0056
					when B"000_0000_0000_0010_1011" =>		
						reg_Circle_Step	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_002C	入力アドレス：H'3800_0058
					when B"000_0000_0000_0010_1100" =>		
						reg_Raster_Scan_Num	<= in_data_ff(8 downto 0);

				--出力ピン アドレス：H'3800_002D	入力アドレス：H'3800_005A
					when B"000_0000_0000_0010_1101" =>		
						reg_Raster_Scan_Step	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_002E	入力アドレス：H'3800_005C
					when B"000_0000_0000_0010_1110" =>		
						reg_Circle_Total_Num	<= in_data_ff(13 downto 8);

				--出力ピン アドレス：H'3800_002F	入力アドレス：H'3800_005E		
					when B"000_0000_0000_0010_1111" =>
						reg_Live_Resol_CSTM	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0030	入力アドレス：H'3800_0060		
					when B"000_0000_0000_0011_0000" =>
						reg_Resol_CSTM	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0031	入力アドレス：H'3800_0062	
					when B"000_0000_0000_0011_0001" =>
						reg_GalvX_Gain_Data_B	<= in_data_ff(15 downto 8);
						reg_GalvX_Gain_Data	<= in_data_ff(7 downto 0);

				--出力ピン アドレス：H'3800_0032	入力アドレス：H'3800_0064	
					when B"000_0000_0000_0011_0010" =>
						reg_GalvY_Gain_Data_B	<= in_data_ff(15 downto 8);
						reg_GalvY_Gain_Data	<= in_data_ff(7 downto 0);

				--出力ピン アドレス：H'1800_0033		
					when B"000_0000_0000_0011_0011" =>
						reg_GalvX_Adjust <= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'1800_0034		
					when B"000_0000_0000_0011_0100" =>
						reg_GalvY_Adjust <= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0035		
					when B"000_0000_0000_0011_0101" =>
						reg_Back_Resol_CSTM	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0036		
					when B"000_0000_0000_0011_0110" =>
						reg_Dum_Resol_CSTM	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0037		
					when B"000_0000_0000_0011_0111" =>
						reg_Repetition		<= in_data_ff(15 downto 12);
						reg_GalvX_OS_Data	<= in_data_ff(9 downto 0);

				--出力ピン アドレス：H'3800_0038		
					when B"000_0000_0000_0011_1000" =>
						reg_GalvY_OS_Data	<= in_data_ff(9 downto 0);
				--出力ピン アドレス：H'3800_0039
					when B"000" & X"0039" =>
						reg_cstm_wr_adr_upper <= in_data_ff(15 downto 0);
				--出力ピン アドレス：H'3800_003A
					when B"000" & X"003A" =>
						reg_cstm_wr_adr_lower <= in_data_ff(15 downto 0);
				--出力ピン アドレス：H'3800_003B
					when B"000" & X"003B" =>
						reg_cstm_wr_data	  <= in_data_ff(15 downto 0);
				--出力ピン アドレス：H'3800_003C	入力アドレス：H'3800_0078		
					when B"000_0000_0000_0011_1100" =>
						reg_REF_ONOFF	<= in_data_ff(8          )  ;
						reg_REF_DIR  	<= in_data_ff(7          )  ;
						reg_REF_PWM  	<= in_data_ff(6 downto 0 )  ;

				--出力ピン アドレス：H'3800_003D	入力アドレス：H'3800_007A		
					when B"000_0000_0000_0011_1101" =>
						reg_POLA_ONOFF	<= in_data_ff(8          )   	;
						reg_POLA_DIR  	<= in_data_ff(7          )   	;
						reg_POLA_PWM  	<= in_data_ff(6 downto 0 )   	;

				--出力ピン アドレス：H'3800_003E	入力アドレス：H'3800_007C		
					when B"000_0000_0000_0011_1110" =>
						reg_FOCUS_ONOFF	<= in_data_ff(8          )  ;
						reg_FOCUS_DIR  	<= in_data_ff(7          )  ;
						reg_FOCUS_PWM  	<= in_data_ff(6 downto 0 )  ;

				--出力ピン アドレス：H'3800_003F	入力アドレス：H'3800_007E		
					when B"000_0000_0000_0011_1111" =>
						reg_SPI_ADR(7 downto 0)		<= in_data_ff(15 downto 8)  ;
						reg_SPI_DATA  				<= in_data_ff(7 downto 0 )  ;

				--出力ピン アドレス：H'3800_0040	入力アドレス：H'3800_0080		
					when B"000_0000_0000_0100_0000" =>
						reg_SPI_ADR(23 downto 8)		<= in_data_ff(15 downto 0)  ;

				--出力ピン アドレス：H'3800_0041	入力アドレス：H'3800_0082	
					when B"000_0000_0000_0100_0001" =>
						reg_CSTM_LIVE_B_ONOFF			<= in_data_ff(15)  ;
						reg_CSTM_LIVE_B_F_CNT(11 downto 0)	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0042	入力アドレス：H'3800_0084	
					when B"000_0000_0000_0100_0010" =>
						reg_CSTM_LIVE_B_PITCH(15 downto 0)	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0043	入力アドレス：H'3800_0086	
					when B"000_0000_0000_0100_0011" =>
						reg_CSTM_LIVE_B_CNT(11 downto 0)	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0044	入力アドレス：H'3800_0088	
					when B"000_0000_0000_0100_0100" =>
						reg_CSTM_LIVE_B_RESOX(11 downto 0)	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0045	入力アドレス：H'3800_008a	
					when B"000_0000_0000_0100_0101" =>
						reg_CSTM_LIVE_B_RESOY(11 downto 0)	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0046	入力アドレス：H'3800_008c	
					when B"000_0000_0000_0100_0110" =>
						reg_CSTM_LIVE_B_OFFSETX(9 downto 0)	<= in_data_ff(9 downto 0);

				--出力ピン アドレス：H'3800_0047	入力アドレス：H'3800_008e	
					when B"000_0000_0000_0100_0111" =>
						reg_CSTM_LIVE_B_OFFSETY(9 downto 0)	<= in_data_ff(9 downto 0);

				--出力ピン アドレス：H'3800_0048	入力アドレス：H'3800_0090	
					when B"000_0000_0000_0100_1000" =>
						reg_V_END_WAIT_CNT(12 downto 0)	<= in_data_ff(12 downto 0);

				--出力ピン アドレス：H'3800_0049	入力アドレス：H'3800_0092	
					when B"000_0000_0000_0100_1001" =>
						reg_REF_Pulse(15 downto 0)	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_004a	入力アドレス：H'3800_0094	
					when B"000_0000_0000_0100_1010" =>
						reg_Shift_X(15 downto 0)	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_004b	入力アドレス：H'3800_0096	
					when B"000_0000_0000_0100_1011" =>
						reg_Shift_Y(15 downto 0)	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_004c	入力アドレス：H'3800_0098	
					when B"000_0000_0000_0100_1100" =>
						reg_Theta(15 downto 0)	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_004d	入力アドレス：H'3800_009a	
					when B"000_0000_0000_0100_1101" =>
						reg_Track_Data_Valid	<= in_data_ff(8);
						reg_Track_en			<= in_data_ff(0);

				--出力ピン アドレス：H'3800_004e	入力アドレス：H'3800_009c	
					when B"000_0000_0000_0100_1110" =>
						reg_CCDShiftX	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_004f	入力アドレス：H'3800_009e	
					when B"000_0000_0000_0100_1111" =>
						reg_CCDShiftY	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0050	入力アドレス：H'3800_00a0	
					when B"000_0000_0000_0101_0000" =>
						reg_CCDShiftGainX	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0051	入力アドレス：H'3800_00a2	
					when B"000_0000_0000_0101_0001" =>
						reg_CCDShiftGainY	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0052	入力アドレス：H'3800_00a4	
					when B"000_0000_0000_0101_0010" =>
						reg_SCAN_SET_NUM	<= in_data_ff(11 downto 0);
						reg_ANGIO_SCAN		<= in_data_ff(15);

				--出力ピン アドレス：H'3800_0053	入力アドレス：H'3800_00a6	
					when B"000_0000_0000_0101_0011" =>
						reg_SCAN_BACK_ADR		<= in_data_ff(11 downto 0);
						reg_SCAN_SET_LIVE_EN	<= in_data_ff(13);
						reg_SCAN_BACK_ADR_EN	<= in_data_ff(14);
						reg_SCAN_SET_RUN_END_ALL<= in_data_ff(15);

				--出力ピン アドレス：H'3800_0054	入力アドレス：H'3800_00a8	
					when B"000_0000_0000_0101_0100" =>
						reg_SCAN_WIDTH_X		<= in_data_ff(3 downto 0);
						reg_SCAN_WIDTH_Y		<= in_data_ff(11 downto 8);

				--出力ピン アドレス：H'3800_0055	入力アドレス：H'3800_00aa	
					when B"000_0000_0000_0101_0101" =>
						reg_keisen_update		<= in_data_ff(15);
						reg_keisen_update_num 	<= in_data_ff(11 downto 0);

				--出力ピン アドレス：H'3800_0056	入力アドレス：H'3800_00ac	
					when B"000_0000_0000_0101_0110" =>
						reg_RAM_CONST_ADR 		<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0057	入力アドレス：H'3800_00ae	
					when B"000_0000_0000_0101_0111" =>
						reg_RAM_CONST_DATA 		<= in_data_ff(15 downto 0);
						reg_RAM_CONST_DATA_EN	<= '1';

				--出力ピン アドレス：H'3800_0058	入力アドレス：H'3800_00b0	
					when B"000_0000_0000_0101_1000" =>
						reg_FlashWrAddress		<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0059	入力アドレス：H'3800_00b2	
					when B"000_0000_0000_0101_1001" =>
						reg_FlashWrData(15 downto 0)  	<= in_data_ff(15 downto 0);
						reg_FlashWrEn					<= '1';

				--出力ピン アドレス：H'3800_005A	入力アドレス：H'3800_00b4	
					when B"000_0000_0000_0101_1010" =>
						reg_FlashWrData(17 downto 16)	<= in_data_ff(1 downto 0);

				--出力ピン アドレス：H'3800_005B	入力アドレス：H'3800_00b6	
					when B"000_0000_0000_0101_1011" =>
						reg_FlashRdAddress		<= in_data_ff(15 downto 0);


				--出力ピン アドレス：H'3800_005d	入力アドレス：H'3800_00ba
					when B"000_0000_0000_0101_1101" =>
						reg_BOTH_WAY_SCAN		<= in_data_ff(0);

				--出力ピン アドレス：H'3800_005e	入力アドレス：H'3800_00bc
					when B"000_0000_0000_0101_1110" =>
						reg_BOTH_WAY_WAIT_TIME	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_005f	入力アドレス：H'3800_00be
					when B"000_0000_0000_0101_1111" =>
						reg_OVER_SCAN			<= in_data_ff(8);
						reg_OVER_SCAN_NUM		<= in_data_ff(7 downto 0);

				--出力ピン アドレス：H'3800_0060	入力アドレス：H'3800_00c0
					when B"000_0000_0000_0110_0000" =>
						reg_OVER_SCAN_DLY_TIME	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0061	入力アドレス：H'3800_00c2
					when B"000_0000_0000_0110_0001" =>
						reg_GALV_TIMING_ADJ_EN	<= in_data_ff(0);

				--出力ピン アドレス：H'3800_0062	入力アドレス：H'3800_00c4
					when B"000_0000_0000_0110_0010" =>
						reg_GALV_TIMING_ADJ_T3	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0063	入力アドレス：H'3800_00c6
					when B"000_0000_0000_0110_0011" =>
						reg_GALV_TIMING_ADJ_T4	<= in_data_ff(15 downto 0);

				--出力ピン アドレス：H'3800_0064	入力アドレス：H'3800_00c8
					when B"000_0000_0000_0110_0100" =>
						reg_GALV_TIMING_ADJ_T5	<= in_data_ff(15 downto 0);



				--出力ピン アドレス：H'3800_0067	入力アドレス：H'3800_00ce
					when B"000_0000_0000_0110_0111" =>
--						reg_Marilyn_mode		<= in_data_ff(15);
						reg_ENC_CNT_RST			<= in_data_ff(14);
						reg_ENC_CNT_EN			<= in_data_ff(13);
						reg_Pulse_Width(9 downto 8) <= in_data_ff(11 downto 10);
						reg_SLD_Delay			<= in_data_ff(9 downto 0);

				--出力ピン アドレス：H'3800_0068	入力アドレス：H'3800_00D0
					when B"000_0000_0000_0110_1000" =>
						reg_VH_sync_period	<= in_data_ff(12 downto 0);
				--出力ピン アドレス：H'3800_006D	入力アドレス：H'3800_00DA
					when B"000_0000_0000_0110_1101" =>
						reg_OCTF_Init_speed <= in_data_ff(13 downto 0);
				--出力ピン アドレス：H'3800_006E	入力アドレス :H'3800_00DC
					when B"000_0000_0000_0110_1110" => 
						reg_OCTF_Max_speed <= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_006F 入力アドレス :H'3800_00DE
					when B"000_0000_0000_0110_1111" =>
						reg_OCTF_Motor_start	  <= in_data_ff(15);
						reg_OCTF_Total_step		  <= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_0070 入力アドレス :H'3800_00E0
					when B"000_0000_0000_0111_0000" =>
						reg_OCTF_CW				  	<= in_data_ff(15);
						reg_OCTF_Deceleration_step	<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_0071 入力アドレス :H'38000_00E2
					when B"000_0000_0000_0111_0001" =>
						reg_OCTF_Increase			<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0072 入力アドレス :H'38000_00E4
					when B"000_0000_0000_0111_0010" =>
						reg_POLA_Init_speed			<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0073 入力アドレス :H'38000_00E6
					when B"000_0000_0000_0111_0011" =>
						reg_POLA_Max_speed			<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0074 入力アドレス :H'38000_00E8
					when B"000_0000_0000_0111_0100" =>
						reg_POLA_Motor_start		<= in_data_ff(15);
						reg_POLA_Total_step			<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_0075 入力アドレス : H'38000_00EA
					when B"000_0000_0000_0111_0101" =>
						reg_POLA_CW					<= in_data_ff(15);
						reg_POLA_Deceleration_step	<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_0076 入力アドレス : H'38000_00EC
					when B"000_0000_0000_0111_0110" =>
						reg_POLA_Increase			<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0077 入力アドレス : H'38000_00EE
					when B"000_0000_0000_0111_0111" =>
						reg_DelayLine_Init_speed 	<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0078 入力アドレス : H'38000_00F0
					when B"000_0000_0000_0111_1000" =>
						reg_Delayline_Max_speed	<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_0079 入力アドレス : H'38000_00F2
					when B"000_0000_0000_0111_1001" =>
						reg_Dline_Mot_start			<= in_data_ff(15);
						reg_Delayline_Total_step	<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_007A 入力アドレス : H'38000_00F4
					when B"000_0000_0000_0111_1010" =>
						reg_Delayline_CW			<= in_data_ff(15);
						reg_Dline_Dec_step			<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_007B 入力アドレス : H'3800_00F6
					when B"000_0000_0000_0111_1011" =>
						reg_Delayline_Increase		<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_007C 入力アドレス : H'3800_00F8
					when B"000_0000_0000_0111_1100" =>
						reg_P_SW_Motor_start		<= in_data_ff(15);
						reg_P_SW_total_step			<= in_data_ff(14 downto 0);
				--出力ピン アドレス : H'3800_007D 入力アドレス : H'3800_00FA
					when B"000_0000_0000_0111_1101" =>
						reg_P_SW_Init_speed			<= in_data_ff(13 downto 0);
				--出力ピン アドレス : H'3800_007E 入力アドレス : H'3800_00FC
					when B"000_0000_0000_0111_1110" =>
						reg_P_SW_CW					<= in_data_ff(15);
				--出力ピン アドレス : H'3800_007F 入力アドレス : H'3800_00FE
					when B"000_0000_0000_0111_1111" =>
						reg_testpin_sel				<= in_data_ff(14 downto 12);
					when others => null;

					end case;
--				else
--					reg_FOCUS_PWM  	<= (others => '0') ;
--					reg_REF_PWM  	<= (others => '0') ;
--					reg_POLA_PWM  	<= (others => '0') ;
--					reg_SPI_ERASE	<= '0';
--					reg_SPI_WRITE	<= '0';
--					reg_SPI_READ 	<= '0';
--					reg_REF_Pulse	<= (others => '0') ;
--					reg_SCAN_SET_LIVE_EN	<= '0';
--					reg_SCAN_BACK_ADR_EN	<= '0';
--					reg_SCAN_SET_RUN_END_ALL<= '0';
--					reg_Track_Data_Valid	<= '0';
----					reg_CAP_START		<= '0';
--					reg_keisen_update	<= '0';
--					reg_RAM_CONST_DATA_EN	<= '0';
--					reg_FlashWrEn			<= '0';
--				end if;
			else
				reg_FOCUS_PWM  	<= (others => '0') ;
				reg_REF_PWM  	<= (others => '0') ;
				reg_POLA_PWM  	<= (others => '0') ;
				reg_SPI_ERASE	<= '0';
				reg_SPI_WRITE	<= '0';
				reg_SPI_READ 	<= '0';
				reg_REF_Pulse	<= (others => '0') ;
				reg_SCAN_SET_LIVE_EN	<= '0';
				reg_SCAN_BACK_ADR_EN	<= '0';
				reg_SCAN_SET_RUN_END_ALL<= '0';
				reg_Track_Data_Valid	<= '0';
--				reg_CAP_START		<= '0';
				reg_keisen_update	<= '0';
				reg_RAM_CONST_DATA_EN	<= '0';
				reg_FlashWrEn			<= '0';
			end if;
		end if;

	end process;


	
	

end RTL;
