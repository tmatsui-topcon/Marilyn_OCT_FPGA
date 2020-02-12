--**************************************************************************************--
--********************	Library declaration part			****************************--
--**************************************************************************************--
LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
ENTITY OCT_TOP IS
	PORT
	(
	D			 	: inout std_logic_vector( 15 downto 0 ) ;	-- マイコンとの接続 Data
--	IN_DataBus				: in std_logic_vector(15 downto 0);
--	OUT_DataBus			    : out std_logic_vector(15 downto 0);
--	OUT_TRI_OUTEN		    : out std_logic;

	A 		 		: in 	std_logic_vector( 10 downto 0 ) ;	-- マイコンとの接続 Address
--	TDI 			: in	std_logic ;							-- JTAG
--	nHSWAPEN 		: in	std_logic ;
	nCS1n 			: in	std_logic ;							-- Chip Select (MPU->FPGA)
	nWRn3 			: in	std_logic ;
	nRD_n2 			: in	std_logic ;
	CIBT3_Hsync	 	: out	std_logic ;
	CIBT3_Vsync	 	: out	std_logic ;
	LineCCD_Trig 	: out	std_logic ;
--	SDRAM_CKE 		: in	std_logic ;
	RETRY_FLAG1 	: out	std_logic ;
	RETRY_FLAG2 	: out	std_logic ;
--	RETRY_FLAG3 	: out	std_logic ;
	RDnWR 			: out	std_logic ;							-- SDRAM
	GPIO0_IN 		: in	std_logic ;
--	nWE1_2 			: out	std_logic ;
--	nWE0_2 			: out	std_logic ;
	SLD_PULSE		: out	std_logic ;							--SLD Pulse
	FPGA_RESET 		: in	std_logic ;							--FPGA RESET
	GPIO1_IN 		: in	std_logic ;
	GPIO2_IN 		: in	std_logic ;
	GPIO3_IN 		: in	std_logic ;
--	M0 				: in	std_logic ;							-- コンフィグレーション用モード選択
--	M1 				: in	std_logic ;							-- コンフィグレーション用モード選択
	nIRQ1_FPGA 		: out	std_logic ;
	nIRQ2_FPGA 		: out	std_logic ;
	nIRQ3_FPGA 		: out	std_logic ;
	nIRQ4_FPGA 		: out	std_logic ;
	nIRQ5_FPGA 		: out	std_logic ;
	nIRQ6_FPGA 		: out	std_logic ;
	nIRQ7_FPGA 		: out	std_logic ;
	nIRQ8_FPGA 		: out	std_logic ;
--	SPI_DIN 		: in	std_logic ;
--	SPI_MOSI 		: out	std_logic ;
--	SPI_CSOB 		: out	std_logic ;
--	SPI_CCLK 		: out	std_logic ;
	nGalvX_OS_CS 	: out	std_logic ;
	nGalvY_OS_CS 	: out	std_logic ;
	Galv_OS_SCLK 	: out	std_logic ;
	Galv_OS_DIN 	: out	std_logic ;
	nGalvX_SYNC 	: out	std_logic ;
	nGalvY_SYNC 	: out	std_logic ;
	Galv_SDIN 		: out	std_logic ;
	Galv_SCLK 		: out	std_logic ;
	Galv_GAIN_SDI 	: out	std_logic ;
	Galv_GAIN_CLK 	: out	std_logic ;
--	nGalvY_GAIN_CS 	: out	std_logic ;
	nGalvX_GAIN_CS 	: out	std_logic ;
	FPGA_CLOCK 		: in	std_logic ;
--	FOCUS_RESET		:	out	std_logic;
--	FOCUS_DECAY		:	out	std_logic;
	REF_POLA_RESET	:	out	std_logic; --DRV8841_RESET?
--	REF_POLA_DECAY	:	out	std_logic;
	MOT_ENABLE		:	out	std_logic;
--	MOT_DECAY2		:	out	std_logic;
--	MOT_DECAY1		:	out	std_logic;
	MOT_PHA			:	out	std_logic;
	MOT_DIR			:	out	std_logic;
	MOT_PWMSW		:	out	std_logic;
	PER_N			:	out	std_logic;
	PER_P			:	out	std_logic;
	PER_REF_SCLK	:	out	std_logic;
	PER_REF_DIN		:	out	std_logic;
	nPER_RES_CS		:	out	std_logic;
	POLA_IN1		:	out	std_logic;
	POLA_IN2		:	out	std_logic;	
	REF_IN1			:	out	std_logic;
	REF_IN2			:	out	std_logic;	
	OCTFOCUS_IN1	:	out	std_logic;
	OCTFOCUS_IN2	:	out	std_logic;
	SLD_REF_SCLK 		: 	out std_logic;
	SLD_REF_DIN 		: 	out std_logic;
	nSLD_REF_CS 		: 	out std_logic;
	nSLD_LIMIT_CS 		: 	out std_logic;
	nFOCUS_FAULT	:	in std_logic;
	nREF_POLA_FAULT	:	in std_logic;
	nDRV8841_SLEEP	:	out std_logic;  --ref_pola_sleep?
	LineCCD_ONOFF	:	out std_logic;
	SLD_ACTIVE_PERIOD	:	out std_logic;
	DIP_SW				:	in std_logic_vector(3 downto 0);
	KEISEN_TXD			: out std_logic;			-- Retry Flag3
	PD_MONITOR			: in std_logic;
	FOCUS_SLEEP			: out std_logic;
	ENC_A				: in std_logic;
	ENC_B				: in std_logic;
	LCMOS_MisTrigger	: in std_logic;
	VH_SYNC_OUT			: out std_logic;
	OCTF_ON_OFF			: out std_logic;
	OCTF_AP				: out std_logic;
	OCTF_BP				: out std_logic;
	OCTF_AN				: out std_logic;
	OCTF_BN				: out std_logic;
	POLA_ON_OFF			: out std_logic;
	POLA_AP				: out std_logic;
	POLA_BP				: out std_logic;
	POLA_AN				: out std_logic;
	POLA_BN				: out std_logic;
	D_LINE_ON_OFF		: out std_logic;
	D_LINE_AP			: out std_logic;
	D_LINE_BP			: out std_logic;
	D_LINE_AN			: out std_logic;
	D_LINE_BN			: out std_logic;
	P_SW_ON_OFF			: out std_logic;
	P_SW_AP				: out std_logic;
	P_SW_BP				: out std_logic;
	P_SW_AN				: out std_logic;
	P_SW_BN				: out std_logic;
	CP8					: out std_logic;
	CP9					: out std_logic;
	CP10				: out std_logic;
	CP11				: out std_logic;
	CP12				: out std_logic
);
END OCT_TOP;

ARCHITECTURE RTL OF OCT_TOP IS

	COMPONENT GPIO is
		PORT
		(
		-- クロック(20MHz)
		FPGACLK		:	in std_logic;
		-- リセット信号(SHからのS/Wリセット)
		nFPGARST	:	in std_logic;
		reset		:	in std_logic;
		-- チップセレクト(外部Pull-upあり)
		nCS			:	in std_logic;
		-- リード信号(外部Pull-upあり)
		nRD			:	in std_logic;
		-- ライト信号(外部Pull-upあり)
		nWE			:	in std_logic;
		-- アドレス・バス
		AdrsBus		:	in std_logic_vector(10 downto 0);		--20090107YN
		-- データ・バス(入出力)
--		DataBus		:	inout std_logic_vector(15 downto 0);

--		IN_DataBus				: in std_logic_vector(15 downto 0);
--		OUT_DataBus				: out std_logic_vector(15 downto 0);
--		OUT_TRI_OUTEN	: out std_logic;
		FPGA_DIPSW		:	in std_logic_vector(9 downto 0);
		DataBus				: inout std_logic_vector(15 downto 0);
		GAL_CON_MOVE_END	: in std_logic;
		
	-- 入力ピン
	--Common Function
		--パネルスイッチ入力
		--DIPSW

	--Retinal Function
		--ランプハウスカバー検知
		LAMP_COVER		:	in std_logic;
		--視度補正レンズ検知
		SHIDO_SW		:	in std_logic;
		--エキサイタフィルタ検知
		n_EF_Detect		:	in std_logic;		--20081216YN
		--オートフォーカス下限検知
		n_AF_Detect_M		:	in std_logic;
		--オートフォーカス上限検知
		n_AF_Detect_P		:	in std_logic;
		--ミラー検知
		n_QM_Detect	:	in std_logic;		--20081216YN
		--外部デジカメ同期信号入力
		DSC_SyncIn:	in std_logic;
		--キセノン制御基板インターフェース
		OVER_VOLTAGE	:	in std_logic;
		CHARGE_OK		:	in std_logic;

	--OCT Function
		--リファレンスミラー初期位置検知
		REF_SEN_IN		:	in std_logic;
		--ポラライザー初期位置検知
		POL_SEN_IN		:	in std_logic;
		--Y軸オートモータ初期位置検知
		YA_SEN_IN		:	in std_logic;
		--眼軸長補正モータ初期位置検知
		AXL_SEN_IN		:	in std_logic;
		--シャッター検知
		--前眼部位置検知
		n_ATTENUATOR_Detect:	in std_logic;	--20091021MN --20091210MN
		--StingrayとのI/F(Input)		--20100402YN
		GPO				:	in std_logic_vector(4 downto 1);		--20100402YN
		--SLD_DRIVER-PCB上R8Cビジー入力
		SLD_BUSY		:	in std_logic;
		--SLD_DRIVER-PCBからのエラー入力
		SLD_ERROR		:	in std_logic;
		--画像ボードからのビジー入力
		IMG_B_BUSY		:	in std_logic;
		--画像ボードからのイベントフラグ入力
		IMG_B_EVENT_FLAG:	in std_logic;
		--画像ボードからのエリアCCDカメラ用トリガ入力
		AreaCCD_TRIG	:	in std_logic;
		--X軸ガルバノドライバボードエラー入力
		GalvX_FAULT		:	in std_logic;
		--Y軸ガルバノドライバボードエラー入力
		GalvY_FAULT		:	in std_logic;

		n_BF_Detect		:	in std_logic;	--20091021MN
		PAHSE_B2		:	in std_logic;	--20091021MN
		PAHSE_A2		:	in std_logic;	--20091021MN
		PAHSE_B1		:	in std_logic;	--20091021MN
		PAHSE_A1		:	in std_logic;	--20091021MN
		FI_IN			:	in std_logic;	--20091021MN
		SPI_BUSY		:	in std_logic;	--20121023MN
		SPI_READ_DATA	:	in std_logic_vector( 7 downto 0 );	--20121023MN

	--FPGA内部信号
		--FPGA　H/Wリビジョン管理用
		HW_Rev1			:	in std_logic_vector(3 downto 0);
		HW_Rev2			:	in std_logic_vector(3 downto 0);
		HW_Rev3			:	in std_logic_vector(3 downto 0);
		HW_Rev4			:	in std_logic_vector(3 downto 0);
		--FPGA　動作確認用内部カウンタ入力
		FPGA_CNT		:	in std_logic_vector(15 downto 0);
		--ガルバノコントローラからのビジー入力
		Galv_BUSY		:	in std_logic;
		--ガルバノコントローラからのバックスキャン中ビジーフラグ入力
		Back_Scan_Flag	:	in std_logic;		--20081217YN

		nFOCUS_FAULT	:	in std_logic;
		nREF_POLA_FAULT	:	in std_logic;

		--デバック用、 ガルバノスタート、エンド座標レジスタにセット。
		cstm_Start_X	: 	in std_logic_vector(11 downto 0);
		cstm_Start_Y	:	in std_logic_vector(11 downto 0);
		cstm_End_X		:	in std_logic_vector(11 downto 0);
		cstm_End_Y		:	in std_logic_vector(11 downto 0);

	-- 出力ピン
	--Common Function
		--内部固視灯LCD　ON/OFF出力
		TD_ON_OFF		:	out std_logic;
		--内部固視灯LCD　コマンド/データ出力
		TD_A0			:	out std_logic;
		--内部固視灯LCD
		TD_SI			:	out std_logic;
		--内部固視灯LCD
		TD_SLC			:	out std_logic;
		--内部固視灯LCD　チップセレクト
		TD_CS			:	out std_logic;
		--内部固視灯LCD　リセット出力
		TD_RES			:	out std_logic;
		--アライメント／スプリットLED制御
		LED_SCLK		:	out std_logic;		--20090107YN
		LED_DIN			:	out std_logic;		--20090107YN
		SPLIT_DAC_CS	:	out std_logic;		--20090107YN
		ALIGN_DAC_CS	:	out std_logic;		--20090107YN
		--外部固視灯LED　ON/OFF出力
		EXT_FIX_LED		:	out std_logic;
		--ブザー制御出力
		BUZZER_SH		:	out std_logic;		--20090118YN
		Bz_SH_FPGA		:	out std_logic;		--20090118YN
		Bz_FPGA_ON_OFF	:	out std_logic;		--20090118YN
		--電動あご受け制御出力
		CHIN_BREAK		:	out std_logic;
		CHIN_PHASE		:	out std_logic;
		CHIN_ENABLE		:	out std_logic;
		--パネルスイッチ機能選択出力
		SEL				:	out std_logic_vector(1 downto 0);		--20090107YN
		--パワーLED制御出力
		POWER_LED		:	out std_logic;		--20090107YN

	--Retinal Function
		--ハロゲンランプ用ファン電源　ON/OFF出力
		Vf_H_ON_OFF		:	out std_logic;
		--ハロゲンランプ用ファン　High/Low選択出力
		Vf_H_H_L		:	out std_logic;		--20081216YN
		--反射棒切替ソレノイド制御出力
		REF_P_SOL		:	out std_logic_vector(2 downto 1);
		--前眼部補正レンズ切替ソレノイド制御出力
		ANT_COMP_SOL	:	out std_logic_vector(2 downto 1);
		--絞り切替ソレノイド制御出力
		APER_SW_SOL		:	out std_logic_vector(2 downto 1);
		--ミラー切替ソレノイド制御出力		--20100402YN
		MIRROR_SOL			:	out std_logic_vector(2 downto 1);		--20100402YN
		--虹彩絞り切替ソレノイド制御出力		--20100331YN
		IRIS_APER_SOL	:	out std_logic_vector(2 downto 1);		--20100331YN
		--外部デジカメレリーズ信号出力
		RELEASE_OUT		:	out std_logic;
		--ハロゲンランプ光量設定出力
		LAMP_CNT		:	out std_logic_vector(3 downto 1);
		--ハロゲンランプ　ON/OFF出力
		LAMP_ON_OFF		:	out std_logic;
		--キセノン制御基板インターフェース
		CHARGE			:	out std_logic;
		DISCHARGE		:	out std_logic;
		IGBT_TRIG		:	out std_logic;
		--キセノントリガ出力
		TRIGGER			:	out std_logic;
		--Stingray ON/OFF制御		--20100402YN
		FAF_CCD_ON_OFF	:	out std_logic;		--20100402YN
		--オートフォーカスモータ制御
		AF_MOT_P		:	out std_logic;
		AF_MOT			:	out std_logic_vector(4 downto 1);
		--StingrayとのI/F(Output)		--20100402YN
		GPI				:	out std_logic_vector(2 downto 1);		--20100402YN
		--シャッターモータ制御
		Shutter1_MOT_P	:	out std_logic;		--20081216YN
		Shutter1_MOT	:	out std_logic_vector(4 downto 1);		--20081216YN
		Shutter2_MOT_P	:	out std_logic;		--20081216YN
		Shutter2_MOT	:	out std_logic_vector(4 downto 1);		--20081216YN

	--OCT Function
		--リファレンスミラーモータ制御
		REF_MOT_P		:	out std_logic;
		REF_MOT			:	out std_logic_vector(4 downto 1);
		--ポラライザーモータ制御
		POL_MOT_P		:	out std_logic;
		POL_MOT			:	out std_logic_vector(4 downto 1);
		--Y軸オートモータ制御
		YA_MOT_P		:	out std_logic;
		YA_MOT			:	out std_logic_vector(4 downto 1);
		--ガルバノゲイン設定DPM用クロック出力
		Galv_GAIN_CLK	:	out std_logic;
		--ガルバノゲイン設定DPMデータ出力
		Galv_GAIN_SDI	:	out std_logic;
		--X軸ガルバノゲイン設定DPMチップセレクト
		GalvX_GAIN_CS	:	out std_logic;
		--Y軸ガルバノゲイン設定DPMチップセレクト
		GalvY_GAIN_CS	:	out std_logic;
		--ガルバノオフセット設定DAC用クロック出力
		Galv_OS_SCLK	:	out std_logic;
		--ガルバノオフセット設定DACデータ出力
		Galv_OS_DIN		:	out std_logic;
		--X軸ガルバノオフセット設定DACチップセレクト
		GalvX_OS_CS		:	out std_logic;
		--Y軸ガルバノオフセット設定DACチップセレクト
		GalvY_OS_CS		:	out std_logic;
		--画像ボードへのエリアCCDカメラ用レリーズ出力
		AreaCCD_RELEASE	:	out std_logic;
		--FPN除去用スキャン判別フラグ入力
		FPN_FLAG		:	out std_logic;		--20090206YN
		Vf_L_ON_OFF		:	out std_logic;
		--ラインCCDカメラ用ファン　High/Low選択出力
		Vf_L_H_L		:	out std_logic;		--20081216YN

	--FPGA内部信号
		--外部固視灯点滅周波数設定出力
		BLINK_Freq		:	out std_logic_vector(2 downto 0);
		--外部固視灯点灯/点滅切替
		FIX_BLINK		:	out std_logic;
		--ガルバノコントローラインターフェース
		--リセット信号
		GAL_CNT_RESET	:	out std_logic;
		--ガルバノ動作開始信号
		Galv_run		:	out std_logic;
		--キャプチャー動作開始信号
		CAP_START		:	out std_logic;
		--左右眼出力
		L_R				:	out std_logic;
		--3D-Scanキャプチャー開始信号
		START_3D		:	out std_logic;
		--RetryFlag
		RetryFlag1_ON_OFF	:	out std_logic;		--20090406YN
		RetryFlag2_ON_OFF	:	out std_logic;		--20090406YN
		--3D-Scanキャプチャー終了後のBack-Scan本数選択
		C_Scan_Back_Num	:	out std_logic_vector(3 downto 0);		--20081217YN
		--3D-Scanキャプチャー動作方向選択
		V_H_3D			:	out std_logic_vector(1 downto 0);
		--キャプチャースキャンモード選択
		Mode_sel		:	out std_logic_vector(3 downto 0);
		--H-sync周波数選択
		Freq_sel		:	out std_logic_vector(7 downto 0);
		--スキャン開始X座標
		Start_X			:	out std_logic_vector(11 downto 0);
		--スキャン開始Y座標
		Start_Y			:	out std_logic_vector(11 downto 0);
		--スキャン終了X座標
		End_X			:	out std_logic_vector(11 downto 0);
		--スキャン終了Y座標
		End_Y			:	out std_logic_vector(11 downto 0);
		--Circle-Scan半径選択
		Circle_R		:	out std_logic_vector(11 downto 0);
		--Live-Scan時の解像度選択
		Live_Resol		:	out std_logic_vector(11 downto 0);
		--キャプチャー時の解像度選択
		Resolution		:	out std_logic_vector(11 downto 0);
		--キャプチャー時のY方向解像度選択
		Resol_Y			:	out std_logic_vector(11 downto 0);
		--Live-Scan時の解像度選択（カスタムスキャン用）
		Live_Resol_CSTM	:	out std_logic_vector(11 downto 0);		--20090107YN
		--キャプチャー時の解像度選択（カスタムスキャン用）
		Resol_CSTM		:	out std_logic_vector(11 downto 0);		--20090107YN
		--Back-Scan時の解像度選択（カスタムスキャン用）
		Back_Resol_CSTM	:	out std_logic_vector(11 downto 0);		--20090508YN
		--Dummy-Scan時の解像度選択（カスタムスキャン用）
		Dum_Resol_CSTM	:	out std_logic_vector(11 downto 0);		--20090508YN
		--キャプチャー開始前のDummy-Scan数選択
		Dummy_Num		:	out std_logic_vector(2 downto 0);
		--Radial-Scan時のキャプチャー数選択
		Radial_Num		:	out std_logic_vector(3 downto 0);
		--M_Circle-Scan時のキャプチャー数選択
		Circle_Total_Num:	out std_logic_vector(5 downto 0);
		--Circle-Scan回転方向選択
		Circle_Dir		:	out std_logic;
		--Live-Scan時のスキャン開始X座標
		L_Start_X		:	out std_logic_vector(11 downto 0);
		--Live-Scan時のスキャン開始Y座標
		L_Start_Y		:	out std_logic_vector(11 downto 0);
		--Live-Scan時のスキャン終了X座標
		L_End_X			:	out std_logic_vector(11 downto 0);
		--Live-Scan時のスキャン終了Y座標
		L_End_Y			:	out std_logic_vector(11 downto 0);
		--Live-Scan時のCircle-Scan半径選択
		L_Radial_R		:	out std_logic_vector(11 downto 0);
		--Web-Scan時のLive-Scan選択
		Web_Live_Sel	:	out std_logic;
		--Web-Scan中のCircle-Scan最小半径選択
		Web_Radial_R	:	out std_logic_vector(11 downto 0);
		--Raster-Scan時のキャプチャー数選択
		Raster_Scan_Num	:	out std_logic_vector(8 downto 0);
		--Raster-Scan中のLine-Scan間隔選択
		Raster_Scan_Step:	out std_logic_vector(11 downto 0);
		--M_Circle/Web-Scan中のCircle-Scan間隔選択
		Circle_Step		:	out std_logic_vector(11 downto 0);
		--SLD制御信号出力
		SLD_ON_OFF		:	out std_logic;
		--前眼部調整モード切替		--20090421YN
		Adjust_Mode		:	out std_logic;		--20090421YN
		--SLD点灯/点滅切替
		Pulse_ON_OFF	:	out std_logic;
		--SLD工具モード切替
		Pulse_Mode		:	out std_logic;
		--SLD工具モード時の点灯位置選択
		SLD_M_Pos		:	out std_logic_vector(3 downto 0);		--20090127YN
		--SLDパルス点灯時のパルス幅選択
		Pulse_Width		:	out std_logic_vector(9 downto 0);
		--SLDパルス点灯時の遅延量
		SLD_Delay		:	out std_logic_vector(9 downto 0);
		--ガルバノ制御波形ゲイン設定値		--20090325YN
		GalvX_Gain_Data	:	out std_logic_vector(7 downto 0);	--8bit		--20090325YN
		GalvY_Gain_Data	:	out std_logic_vector(7 downto 0);	--8bit		--20090325YN
		--前眼部調整モード用ガルバノ座標		--20090421YN
		GalvX_Adjust	:	out std_logic_vector(11 downto 0);	--12bit		--20090421YN
		GalvY_Adjust	:	out std_logic_vector(11 downto 0);	--12bit		--20090421YN
		--ガルバノオフセット					--20090713MN
		GalvX_OS_Data	:	out std_logic_vector(9 downto 0);	--10bit		--20090713MN
		GalvY_OS_Data	:	out std_logic_vector(9 downto 0);	--10bit		--20090713MN

		EF_MOT_P		:	out std_logic							;	--20091021MN
		EF_CLK			:	out std_logic							;	--20091021MN
		EF_ENABLE		:	out std_logic							;	--20091021MN
		EF_RESET		:	out std_logic							;	--20091021MN
		EF_DATA_M		:	out std_logic							;	--20091021MN
		EF_MDT2			:	out std_logic							;	--20091021MN
		EF_MDT1			:	out std_logic							;	--20091021MN
		EF_TRQ2			:	out std_logic							;	--20091021MN
		EF_TRQ1			:	out std_logic							;	--20091021MN
		EF_STBY			:	out std_logic							;	--20091021MN
		EF_CW_CCW		:	out std_logic							;	--20091021MN
		EF_DM3			:	out std_logic							;	--20091021MN
		EF_DM2			:	out std_logic							;	--20091021MN
		EF_DM1			:	out std_logic							;	--20091021MN
		BF_MOT_P		:	out std_logic							;	--20091021MN
		BF_MOT			:	out std_logic_vector(3 downto 0)		;	--20091021MN
		ATTENUATOR_MOT_P:	out std_logic		  					;	--20091021MN --20091210MN
		ATTENUATOR_MOT	:	out std_logic_vector(3 downto 0)  		;	--20091021MN --20091210MN
	-- ブザーのキャプチャ中(1) FA中(0)選択
		Bz_Capture_Timer:	out std_logic							;	--20091210MN

		n_TD_DAC_CS		:	out	std_logic							;	--20100421MN
		TD_DAC_DIN		:	out	std_logic							;	--20100421MN
		TD_DAC_SCLK		:	out	std_logic							; 	--20100421MN
		FIX_PATTERN		:	out	std_logic_vector(3 downto 0)		;	--20100421MN
		KISYU      		:	out	std_logic_vector(2 downto 0)		;	--20100421MN
		FIX_BRIGHTNESS	:	out std_logic_vector(3 downto 0)		;	--20100517MN
		BF_LED_ON_OFF	:	out std_logic							;	--20100517MN
		Factory_Mode	:	out std_logic							;	--20100806MN
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
		GalvX_Gain_Data_B	: out std_logic_vector(7 downto 0);	--8bit		--20090325YN
		GalvY_Gain_Data_B	: out std_logic_vector(7 downto 0);	--8bit		--20090325YN
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
		keisen_update_num	: out std_logic_vector(11 downto 0);
		Repetition			: out std_logic_vector( 3 downto 0);
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
	end component;

	COMPONENT comp_CustomScan is
		PORT
		(
			FPGAclk				: IN STD_LOGIC;		--20MHz
			Reset				: IN STD_LOGIC;
			nPON_RESET			: IN STD_LOGIC;
			Galv_run			: IN STD_LOGIC;
			CAP_START			: IN STD_LOGIC;
			nWE					: IN std_logic;
			DataBusIn			: IN std_logic_vector(15 downto 0);
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
			CIBT_ALMOST_FULL	: IN std_logic;
			ANGIO_SCAN			: IN std_logic;
			keisen_update		: IN std_logic;
			keisen_update_num	: IN std_logic_vector(11 downto 0);
			Repetition			: IN std_logic_vector( 3 downto 0);
			CSTM_WR_ADR			: IN STD_LOGIC_VECTOR( 31 downto 0);
			CSTM_WR_DATA		: IN STD_LOGIC_VECTOR( 15 downto 0);
			CSTM_WR_EN			: IN STD_LOGIC;
			Resol				: IN STD_LOGIC_VECTOR(11 downto 0);
			Resol_CSTM			: IN STD_LOGIC_VECTOR(11 downto 0);
			Dum_Resol_CSTM		: IN STD_LOGIC_VECTOR(11 downto 0);
			Back_Resol_CSTM		: IN STD_LOGIC_VECTOR(11 downto 0);
			cstm_CSTM_FLAG		: OUT STD_LOGIC;
			cstm_Mode_Sel		: OUT STD_LOGIC_VECTOR(3 downto 0);
			cstm_Galv_run		: OUT STD_LOGIC;
--			cstm_CAP_START		: OUT STD_LOGIC;
--			cstm_INT_CAP_START	: OUT STD_LOGIC;
			cstm_Start_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Start_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_End_X			: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_End_Y			: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Circle_R		: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Circle_DIR		: OUT STD_LOGIC;
--			cstm_Live_Start_X	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Start_Y	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Circle_R	: OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_TRIG_EN		: OUT STD_LOGIC;
			cstm_LiveScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
--			cstm_DummyScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
			cstm_CapScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
			cstm_BackScanNow_Flag	: OUT STD_LOGIC;		--20090323YN
			cstm_cnt_Live		: OUT STD_LOGIC_VECTOR(3 downto 0);	--20090323YN
			cstm_param_en		: OUT STD_LOGIC;
--			CSTM_LIVE_RESO		: OUT STD_LOGIC_VECTOR(11 downto 0);
			LIVE_B_ENABLE 		: OUT STD_LOGIC;
			LIVE_B_RETRY1		: OUT STD_LOGIC;
			LIVE_B_RETRY2		: OUT STD_LOGIC;
			keisenNO			: OUT STD_LOGIC_VECTOR(11 downto 0);
			CAPT_OFFSET_EN		: OUT STD_LOGIC;
			Scan_Run_Flag		: OUT STD_LOGIC;
			Resol_OUT			: OUT STD_LOGIC_VECTOR(11 downto 0)
		);
	end component;

	component GAL_CON IS
		PORT
		(
			FPGAclk			: IN STD_LOGIC;		--20MHz
			Reset			: IN STD_LOGIC;
			Mode_sel		: IN STD_LOGIC_VECTOR(3 downto 0);
			Freq_Sel		: IN STD_LOGIC_VECTOR(7 downto 0);
			Start_X			: IN STD_LOGIC_VECTOR(11 downto 0);
			Start_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
			End_X			: IN STD_LOGIC_VECTOR(11 downto 0);
			End_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
			Circle_R		: IN STD_LOGIC_VECTOR(11 downto 0);
--			Live_Start_X	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_Start_Y	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_End_X		: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_End_Y		: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_Circle_R	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			L_R				: IN STD_LOGIC;
			Galv_run		: IN STD_LOGIC;
--			CAP_START		: IN STD_LOGIC;
--			Live_Resol		: IN STD_LOGIC_VECTOR(11 downto 0);
			Resolution		: IN STD_LOGIC_VECTOR(11 downto 0);
--			Dummy_Fram_Num	: IN STD_LOGIC_VECTOR(2 downto 0);
--			Resol_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
--			V_H_3D			: IN STD_LOGIC_VECTOR(1 downto 0);
--			C_Scan_Back_Num : IN STD_LOGIC_VECTOR(3 downto 0);		--20081017TS
--			Radial_Scan_Num : IN STD_LOGIC_VECTOR(3 downto 0);		--20070330TS
--			Circle_Total_Num	: IN STD_LOGIC_VECTOR(5 downto 0);		--20080508YN
--			START_3D		: IN STD_LOGIC;
--			Web_Radial_R	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--			Web_Circle_R_Step	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--			Web_Live_Sel	: IN STD_LOGIC;		--0:Circle_Live 1:Line_Live		--20070329TS
--			Raster_Scan_Num	: IN STD_LOGIC_VECTOR(8 downto 0);		--20070404TS
--			Raster_Scan_Step	: IN STD_LOGIC_VECTOR(11 downto 0);		--20070404TS
			Circle_Direction	: IN STD_LOGIC;		--20070329TS
--			SLD_ON_OFF		: IN STD_LOGIC;		--1:ON 0:OFF		--20070329TS
--			PULSE_ON_OFF	: IN STD_LOGIC;		--1:PULSE 0:C/W		--20070329TS
--			PULSE_Width		: IN STD_LOGIC_VECTOR(9 downto 0);		--20070830YN
--			SLD_Delay		: IN STD_LOGIC_VECTOR(9 downto 0);
			Adjust_Mode		: IN STD_LOGIC;		--1:Adjust_Mode 0:Normal_Mode		--20090421YN
--			PULSE_Mode		: IN STD_LOGIC;		--1:MEASURE 0:NORMAL		--20070902YN
--			SLD_M_Pos		: IN STD_LOGIC_VECTOR(3 downto 0);		--20090206YN
			GalvX_Adjust	: IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
			GalvY_Adjust	: IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
--			Custom_Scan_On	: IN STD_LOGIC;		--1=Custom Scan 0=Normal		--20081023TS
--			GalvX_Gain_Data	: IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--			GalvY_Gain_Data	: IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--			GalvX_Gain_Data_B	: IN STD_LOGIC_VECTOR(7 downto 0);
--			GalvY_Gain_Data_B	: IN STD_LOGIC_VECTOR(7 downto 0);
--			cstm_LiveScanNOW_Flag	: IN STD_LOGIC;		--20090326YN_1
--			cstm_cnt_Live	: IN STD_LOGIC_VECTOR(3 downto 0);		--20090326YN_1
--			RetryFlag1_ON_OFF	: IN STD_LOGIC;		--20090326YN_1
--			RetryFlag2_ON_OFF	: IN STD_LOGIC;		--20090326YN_1
			cstm_param_en		: IN STD_LOGIC;		--20091006MN		--20091119YN
--			CSTM_LIVE_B_F_CNT	: IN STD_LOGIC_VECTOR(11 downto 0);
--			CSTM_LIVE_B_ENABLE	: IN STD_LOGIC;
--			CSTM_LIVE_B_ONOFF	: IN STD_LOGIC;
			V_END_WAIT_CNT		: IN STD_LOGIC_VECTOR( 12 downto 0);
--			LiveBRetry1			: IN STD_LOGIC;
--			LiveBRetry2			: IN STD_LOGIC;
			RAM_CONST_DATA		: IN STD_LOGIC_VECTOR(15 downto 0);
			RAM_CONST_ADR		: IN STD_LOGIC_VECTOR(15 downto 0);
			RAM_CONST_DATA_EN	: IN STD_LOGIC		;
			BOTH_WAY_SCAN		: IN STD_LOGIC;
			BOTH_WAY_WAIT_TIME	: IN STD_LOGIC_VECTOR( 15 downto 0);
			OVER_SCAN			: IN STD_LOGIC;
			OVER_SCAN_NUM		: IN STD_LOGIC_VECTOR(7 downto 0);
--			OVER_SCAN_DLY_TIME	: IN STD_LOGIC_VECTOR( 15 downto 0);
			GALV_TIMING_ADJ_EN	: IN STD_LOGIC;
			GALV_TIMING_ADJ_T3	: IN STD_LOGIC_VECTOR(15 downto 0);
			GALV_TIMING_ADJ_T4	: IN STD_LOGIC_VECTOR(15 downto 0);
			GALV_TIMING_ADJ_T5	: IN STD_LOGIC_VECTOR(15 downto 0);
			HSYNC_END			: IN STD_LOGIC;
			SLD					: IN STD_LOGIC;
--			VH_sync_period		: IN STD_LOGIC_VECTOR(12 downto 0);
			HSYNC_T				: OUT STD_LOGIC_VECTOR(11 downto 0);
			HSYNC				: IN STD_LOGIC;
			X_galv				: OUT STD_LOGIC_VECTOR(11 downto 0);
			Y_galv				: OUT STD_LOGIC_VECTOR(11 downto 0);
--			Hsync_out			: OUT STD_LOGIC;
--			Vsync_out			: OUT STD_LOGIC;
--			TRIG				: OUT STD_LOGIC;
--			Busy_out			: OUT STD_LOGIC;
--			V_End_Flag_OUT		: OUT STD_LOGIC;		-- 1:end		--20070329TS
--			SLD_out				: OUT STD_LOGIC;		--20070329TS
--			BackScan_Busy_out	: OUT STD_LOGIC;		--20081017TS
			CSTM_MOVE_END_out	: OUT STD_LOGIC;		--20081031TS
--			RetryFlag1_OUT		: OUT STD_LOGIC;		--20090326YN_1
--			RetryFlag2_OUT		: OUT STD_LOGIC;		--20090326YN_1
--			SLD_Gen_EN			: OUT STD_LOGIC;		--20090903MN
--			Inter_Reset			: OUT STD_LOGIC;
			VH_GEN_EN_OUT		: OUT STD_LOGIC;
			HSYNC_NUM_OUT		: OUT STD_LOGIC_VECTOR(12 downto 0)
		);
	end component;


	
--	COMPONENT comp_CSTM_SEL is
--		PORT
--		(
--			Mode_sel		: IN STD_LOGIC_VECTOR(3 downto 0);
--			Galv_run		: IN STD_LOGIC;
--			CAP_START		: IN STD_LOGIC;
--			Start_X			: IN STD_LOGIC_VECTOR(11 downto 0);
--			Start_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
--			End_X			: IN STD_LOGIC_VECTOR(11 downto 0);
--			End_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
--			Circle_R		: IN STD_LOGIC_VECTOR(11 downto 0);
--			Circle_Direction	: IN STD_LOGIC;
--			L_Start_X		: IN std_logic_vector(11 downto 0);
--			L_Start_Y		: IN std_logic_vector(11 downto 0);
--			L_End_X			: IN std_logic_vector(11 downto 0);
--			L_End_Y			: IN std_logic_vector(11 downto 0);
--			L_Radial_R		: IN std_logic_vector(11 downto 0);
--			Live_Resol_CSTM	: IN std_logic_vector(11 downto 0);		--20090106YN
--			Resolution		: IN std_logic_vector(11 downto 0);		--add 081224TS
--			Resol_CSTM		: IN std_logic_vector(11 downto 0);		--20090106YN
--			Back_Resol_CSTM	: IN std_logic_vector(11 downto 0);		--20090508YN
--			Dum_Resol_CSTM	: IN std_logic_vector(11 downto 0);		--20090508YN
--			cstm_CSTM_FLAG		: IN STD_LOGIC;
--			cstm_Mode_sel		: IN STD_LOGIC_VECTOR(3 downto 0);
--			cstm_Galv_Run		: IN STD_LOGIC;
--			cstm_CAP_Start		: IN STD_LOGIC;
--			cstm_INT_CAP_START	: IN STD_LOGIC;
--			cstm_Start_X		: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Start_Y		: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_End_X			: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_End_Y			: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Circle_R		: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Circle_DIR		: IN STD_LOGIC;
--			cstm_Live_Start_X	: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Start_Y	: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_X		: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_Y		: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Circle_R	: IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_LiveScanNow_Flag	: IN STD_LOGIC;		--20090323YN
--			cstm_DummyScanNow_Flag	: IN STD_LOGIC;		--20090323YN
--			cstm_CapScanNow_Flag	: IN STD_LOGIC;		--20090323YN
--			cstm_BackScanNow_Flag	: IN STD_LOGIC;		--20090323YN
--			gal_Mode_sel	: OUT STD_LOGIC_VECTOR(3 downto 0);
--			gal_Galv_run	: OUT STD_LOGIC;
--			gal_CAP_START	: OUT STD_LOGIC;
--			gal_Start_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Start_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_End_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_End_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Circle_R	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Circle_Direction : OUT STD_LOGIC;
--			gal_L_Start_X	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_Start_Y	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_End_X		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_End_Y		: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_Circle_R	: OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Resol_OUT	: OUT STD_LOGIC_VECTOR(11 downto 0)
--		);
--	end component;

--	COMPONENT GPIO_cstm IS
--
--		PORT(
--			FPGACLK		: IN STD_LOGIC;		-- クロック(20MHz)
--			Reset		: IN STD_LOGIC;		-- リセット信号
--
--			nCS6		: IN STD_LOGIC;		-- チップセレクト
--			nRD			: IN STD_LOGIC;		-- リード信号
--			nWE			: IN STD_LOGIC;		-- ライト信号
--			AdrsBus		: IN STD_LOGIC_VECTOR(7 downto 0);		-- アドレス・バス		--20090106YN
--			DataBusIn	: IN STD_LOGIC_VECTOR(15 downto 0);		-- データ・バス(入力)
--			Galv_BUSY		: IN std_logic;
--			WR_ADDRES_OUT		: OUT STD_LOGIC_VECTOR(18 downto 0);	--12bit
--			CSTM_FLAG_WE		: OUT STD_LOGIC;
--			SCAN_NUM_WE			: OUT STD_LOGIC;
--			DUMMY_NUM_WE		: OUT STD_LOGIC;
--			BACK_SCAN_NUM_WE	: OUT STD_LOGIC;
--			LIVE_NUM_WE			: OUT STD_LOGIC;
--			L_Start_X_WE		: OUT STD_LOGIC;
--			L_Start_Y_WE		: OUT STD_LOGIC;
--			L_End_X_WE			: OUT STD_LOGIC;
--			L_End_Y_WE			: OUT STD_LOGIC;
--			L_Circle_R_WE		: OUT STD_LOGIC;
--			L_DIR_LINE_CIR_WE	: OUT STD_LOGIC;
--			DIR_LINE_CIR_WE		: OUT STD_LOGIC;
--			Start_X_WE			: OUT STD_LOGIC;
--			Start_Y_WE			: OUT STD_LOGIC;
--			End_X_WE			: OUT STD_LOGIC;
--			End_Y_WE			: OUT STD_LOGIC;
--			Dummy_DIR_LINE_CIR_WE	: OUT STD_LOGIC;
--			Back_Scan_DIR_LINE_CIR_WE	: OUT STD_LOGIC;
--			Dummy_Back_Data_WE	: OUT STD_LOGIC;
--			DBUS_HOLD_OUT		: OUT STD_LOGIC_VECTOR(15 downto 0);
--			cstm_nWE			: OUT STD_LOGIC
--		);
--	end component;

	component GALV_DAC_PSC is
		port(
			FPGAclk		:	in	std_logic;
			Reset		:	in	std_logic;
			GALV_X		:	in	std_logic_vector( 11 downto 0 );
			GALV_Y		:	in	std_logic_vector( 11 downto 0 );
			nSYNC_X		:	out	std_logic;
			nSYNC_Y		:	out	std_logic;
			SCLK		:	out	std_logic;
			nCLR		:	out	std_logic;
			SDIN		:	out	std_logic
		);
	end component;

	component comp_TRIG_SEL IS
		PORT (
			FPGAclk 	: IN STD_LOGIC;						--20MHz
			Reset 		: IN STD_LOGIC;
			TRIG_IN		: IN STD_LOGIC;	--from galv_con
			TRIG_EN		: IN STD_LOGIC;
			Custom_Flag : IN STD_LOGIC;
			TRIG_OUT 	: OUT STD_LOGIC
		);
	end component;

	component GAL_GAIN IS
		PORT (
			FPGAclk 			: 	IN 	STD_LOGIC;						--20MHz
			Reset 				: 	IN 	STD_LOGIC;
			GalvX_Gain_Data		:	IN	STD_LOGIC_VECTOR(7 downto 0);
			GalvY_Gain_Data		:	IN	STD_LOGIC_VECTOR(7 downto 0);
			GalvX_Gain_Data_B	:	IN	STD_LOGIC_VECTOR(7 downto 0);
			GalvY_Gain_Data_B	:	IN	STD_LOGIC_VECTOR(7 downto 0);
			VSync_End			:	IN	STD_LOGIC;
			Galv_Run			:	IN	STD_LOGIC;
			SEL					:	IN	STD_LOGIC;
			Galv_Gain_SDI 		:	OUT	STD_LOGIC;
			Galv_Gain_CLK		:	OUT	STD_LOGIC;
			nGalvX_Gain_CS		:	OUT	STD_LOGIC;
			nGalvY_Gain_CS		:	OUT	STD_LOGIC
		);
	end component;

	component GAL_OFFSET IS
		PORT (
			FPGAclk 			: 	IN 	STD_LOGIC;						--20MHz
			Reset 				: 	IN 	STD_LOGIC;
			GalvX_Offset_Data	:	IN	STD_LOGIC_VECTOR(9 downto 0);
			GalvY_Offset_Data	:	IN	STD_LOGIC_VECTOR(9 downto 0);
			GalvX_Offset_Data_B	:	IN	STD_LOGIC_VECTOR(9 downto 0);
			GalvY_Offset_Data_B	:	IN	STD_LOGIC_VECTOR(9 downto 0);
			VSync_End			:	IN	STD_LOGIC;
			Galv_Run			:	IN	STD_LOGIC;
			SEL					:	IN	STD_LOGIC;
			Galv_Offset_SDI 	:	OUT	STD_LOGIC;
			Galv_Offset_CLK		:	OUT	STD_LOGIC;
			nGalvX_Offset_CS	:	OUT	STD_LOGIC;
			nGalvY_Offset_CS	:	OUT	STD_LOGIC
		);
	end component;

	component H_W_Rev is
		port(
			H_W_Rev_1	:	out	std_logic_vector(3 downto 0);
			H_W_Rev_2	:	out	std_logic_vector(3 downto 0);
			H_W_Rev_3	:	out	std_logic_vector(3 downto 0);
			H_W_Rev_4	:	out	std_logic_vector(3 downto 0)
		);
	end component;

	component FPGA_CNT_GEN is
		port(
			CLK				: in std_logic;							-- 20MHz
			n_RESET			: in std_logic;							-- Low Active
			FPGA_CNT		: out std_logic_vector(15 downto 0)		--16bit
		);
	end component;

	COMPONENT PWM_GEN is
		PORT
		(		
			FPGAclk		:	in	std_logic;
			nReset		:	in	std_logic;
			PWM			:	in	std_logic_vector( 6 downto 0 );
			ONOFF		:	in	std_logic;
			DIR			:	in	std_logic;
			Pulse_A		:	out	std_logic;
			Pulse_B		:	out	std_logic
		);
	END COMPONENT;

	COMPONENT PWM_GEN_REF is
		PORT
		(		
			FPGAclk		:	in	std_logic;
			nReset		:	in	std_logic;
			PWM			:	in	std_logic_vector( 6 downto 0 );
			PULSE		:	in	std_logic_vector(15 downto 0 );
			ONOFF		:	in	std_logic;
			DIR			:	in	std_logic;
			Pulse_A		:	out	std_logic;
			Pulse_B		:	out	std_logic
		);
	END COMPONENT;

	COMPONENT SLD_SMPL_TRG IS
		PORT
		(
			FPGAclk 		: 	IN 	STD_LOGIC;						--20MHz
			Reset 			: 	IN 	STD_LOGIC;
			Vsync			:	IN	STD_LOGIC;
			Pulse_out		:	OUT	STD_LOGIC
			
			);
	END COMPONENT;

	COMPONENT SPI_COM is
		PORT
		(
			FPGAclk		:	in	std_logic;
			nReset		:	in	std_logic;
			ROM_ADR		:	in	std_logic_vector( 23 downto 0 );
			ROM_DATA	:	in	std_logic_vector( 7 downto 0 );
			ROM_ERASE	:	in	std_logic;
			ROM_WRITE	:	in	std_logic;
			ROM_READ 	:	in	std_logic;
			SPI_DIN		:	in	std_logic;
			BUSY   		:	out	std_logic;
			READ_DATA	:	out std_logic_vector( 7 downto 0);
			SPI_CSOB	:	out	std_logic;
			SPI_MOSI	:	out	std_logic;
			SPI_CCLK	:	out	std_logic
			
			);
	END COMPONENT;

	COMPONENT SEND_KEISEN is
		PORT
		(
			FPGAclk			:	in	std_logic;
			Reset			:	in	std_logic;
			SEND_DATA_EN	:	in 	std_logic;
			SEND_DATA		:	in	std_logic_vector( 15 downto 0 );
	
			RECIEVE_DATA_EN	:	out std_logic;
			RECIEVE_DATA	:	out std_logic_vector( 15 downto 0);
			
			RXD				:	in	std_logic;
			TXD				:	out	std_logic
		
		);
	END COMPONENT;

	COMPONENT FLASH_LOADER is 
		port
  		(
    		FpgaClk 			: in std_logic;
			RST					: in std_logic;
    
    		RegFileWrAddress    : in std_logic_vector(15 downto 0);
    		RegFileWrData       : in std_logic_vector(17 downto 0);
    		RegFileWrEn         : in std_logic;
    		RegFileRdAddress    : in std_logic_vector(15 downto 0);
    		RegFileRdData       : out std_logic_vector(15 downto 0)
  		);
	END COMPONENT;


	--ENCODER_CNT 
	COMPONENT encoder_cnt is
		port
		(
			Reset				: IN STD_LOGIC;
			FPGAclk         	: IN STD_LOGIC;
			ENC_CNT_RST     	: IN STD_LOGIC;
			ENC_CNT_EN			: IN STD_LOGIC;
			ENC_A				: IN STD_LOGIC;
			ENC_B				: IN STD_LOGIC;
			OUT_ENC_CNT_AB      : OUT STD_LOGIC_VECTOR(31 downto 0);
			OUT_ENC_CNT_BA		: OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;
	
	--1-2相励磁ステッピングモータコントローラ
	COMPONENT stepmotor_ctrl is
		port
		(
		Reset						: IN STD_LOGIC;
		FPGAclk						: IN STD_LOGIC;							--20MHz
		Motor_ctrl_sel				: IN STD_LOGIC;							---0: 1-2相励磁 , 1:2-2相励磁
		Deceleration_step			: IN STD_LOGIC_VECTOR(14 downto 0);		--減速ステップ数[パルス]
		Total_step					: IN STD_LOGIC_VECTOR(14 downto 0);		--総移動ステップ数[パルス]
		Init_speed					: IN STD_LOGIC_VECTOR(13 downto 0);		--初速ステップ間隔[ns]
		Max_speed					: IN STD_LOGIC_VECTOR(13 downto 0);		--最高速ステップ間隔[ns]
		Step_increase				: IN STD_LOGIC_VECTOR(13 downto 0);		--１ステップに増減する間隔
		STEP_CW						: IN STD_LOGIC;
		Start						: IN STD_LOGIC;
		Motro_on					: OUT STD_LOGIC;						--ステッピングモータへ励磁開始信号
		Motor_AP					: OUT STD_LOGIC;						--ステッピングモータA+相制御信号
		Motor_BP					: OUT STD_LOGIC;						--ステッピングモータB+相制御信号
		Motor_AN					: OUT STD_LOGIC;						--ステッピングモータA-相制御信号
		Motor_BN					: OUT STD_LOGIC;						--ステッピングモータB-相制御信号
		IRQ_OUT						: OUT STD_LOGIC							--モータ制御終了後IRQ端子に割り込み出力		
		);
	END COMPONENT;



	--Linesensor GPOエラー処理
	COMPONENT linesensor_err_det is
		port
		(
		Reset				: IN STD_LOGIC;
		FPGAclk         	: IN STD_LOGIC;
		LCMOS_MisTrigger	: IN STD_LOGIC;
		HSYNC_IN			: IN STD_LOGIC;
		VSYNC_IN			: IN STD_LOGIC;
		OUT_MisTrigger_det	: OUT STD_LOGIC
		);
	END COMPONENT;
	

	COMPONENT comp_sync_gen IS
	PORT
	(
		Reset 				: IN STD_LOGIC;
		FPGAclk 			: IN STD_LOGIC;	
		VH_GEN_EN			: IN STD_LOGIC;
		OVER_SCAN			: IN STD_LOGIC;
		OVER_SCAN_DLY_TIME	: IN STD_LOGIC_VECTOR(15 downto 0);
		VH_SYNC_PERIOD		: IN STD_LOGIC_VECTOR(15 downto 0); --VH_GEN_EN↑からSYNC出力までの遅延時間、(設定値*0.05)us
		HSYNC_T				: IN STD_LOGIC_VECTOR(11 downto 0); --H-Sync周期、(設定値*0.05)us
		HSYNC_NUM			: IN STD_LOGIC_VECTOR(12 downto 0);
		V_END_WAIT_CNT		: IN STD_LOGIC_VECTOR(12 downto 0);
		OUT_VSYNC			: OUT STD_LOGIC;
		OUT_HSYNC			: OUT STD_LOGIC;
		OUT_VH_SYNC			: OUT STD_LOGIC;
		OUT_HSYNC_END		: OUT STD_LOGIC;
		OUT_V_END_FLG		: OUT STD_LOGIC
	);
	END COMPONENT;
			
	COMPONENT comp_SLD_gen IS	--20070329TS	--20070830YN
	PORT
	(
		Reset 			: IN STD_LOGIC;
		FPGAclk 		: IN STD_LOGIC;							--20MHz
		SLD_ON_OFF		: IN STD_LOGIC;
		PULSE_ON_OFF	: IN STD_LOGIC;
		SLD_Delay		: IN STD_LOGIC_VECTOR(9 downto 0);		--SLD遅延
		PULSE_Width 	: IN STD_LOGIC_VECTOR(9 downto 0);
		HSYNC_IN		: IN STD_LOGIC;
		OUT_SLD_PULSE	: OUT STD_LOGIC
	);
	END COMPONENT;



	signal	FPGAclk							:	std_logic;
	signal	nFPGARST 						:	std_logic;
	signal	pFPGARST						:	std_logic;
	signal	sig_HW_Rev1						:	std_logic_vector(3 downto 0);
	signal	sig_HW_Rev2						:	std_logic_vector(3 downto 0);
	signal	sig_HW_Rev3						:	std_logic_vector(3 downto 0);
	signal	sig_HW_Rev4						:	std_logic_vector(3 downto 0);
	signal	sig_FPGA_CNT					:	std_logic_vector(15 downto 0);
	signal	sig_BackScan_Flag				:	std_logic;
	signal	sig_GAL_CNT_RESET				: 	std_logic;
	signal	sig_galv_run					: 	std_logic;
	signal	sig_cap_start					:	std_logic;
	signal	sig_L_R							:	std_logic;
	signal	sig_START_3D					:	std_logic;
	signal	sig_RetryFlag1_ON_OFF			:	std_logic;
	signal	sig_RetryFlag2_ON_OFF			:	std_logic;
	signal	C_Scan_Back_Num					:	std_logic_vector(3 downto 0);
	signal	sig_V_H_3D						:	std_logic_vector(1 downto 0);
	signal	sig_mode_sel					:	std_logic_vector(3 downto 0);
	signal	sig_Freq_sel					:	std_logic_vector(7 downto 0);
	signal	sig_start_x						:	std_logic_vector(11 downto 0);
	signal	sig_start_y						:	std_logic_vector(11 downto 0);
	signal	sig_end_x						:	std_logic_vector(11 downto 0);
	signal	sig_end_y						:	std_logic_vector(11 downto 0);
	signal	sig_circle_r					:	std_logic_vector(11 downto 0);
	signal	sig_Live_Resol					:	std_logic_vector(11 downto 0);
	signal	sig_resolution					:	std_logic_vector(11 downto 0);
	signal	sig_Resol_Y						:	std_logic_vector(11 downto 0);
	signal	sig_live_resol_cstm				:	std_logic_vector(11 downto 0);
	signal	sig_resol_cstm					:	std_logic_vector(11 downto 0);
	signal	sig_back_resol_cstm				:	std_logic_vector(11 downto 0);
	signal	sig_dum_resol_cstm				:	std_logic_vector(11 downto 0);
	signal	sig_Dummy_Num					:	std_logic_vector(2 downto 0);
	signal	sig_Radial_Num					:	std_logic_vector(3 downto 0);
	signal	sig_Circle_Total_Num			:	std_logic_vector(5 downto 0);
	signal	sig_circle_dir					:	std_logic;
	signal	sig_l_start_x					:	std_logic_vector(11 downto 0);
	signal	sig_l_start_y					:	std_logic_vector(11 downto 0);
	signal	sig_l_end_x						:	std_logic_vector(11 downto 0);
	signal	sig_l_end_y						:	std_logic_vector(11 downto 0);
	signal	sig_l_radial_r					:	std_logic_vector(11 downto 0);
	signal	sig_Web_Live_Sel				:	std_logic;
	signal	sig_Web_Radial_R				:	std_logic_vector(11 downto 0);
	signal	sig_Raster_Scan_Num				:	std_logic_vector(8 downto 0);
	signal	sig_Raster_Scan_Step			:	std_logic_vector(11 downto 0);
	signal	sig_Circle_Step					:	std_logic_vector(11 downto 0);
	signal	sig_SLD_ON_OFF					:	std_logic;
	signal	sig_Adjust_Mode					:	std_logic;
	signal	sig_Pulse_ON_OFF				:	std_logic;
	signal	sig_Pulse_Mode					:	std_logic;
	signal	sig_SLD_M_Pos					:	std_logic_vector(3 downto 0);
	signal	sig_Pulse_Width					:	std_logic_vector(9 downto 0);
	signal	sig_SLD_Delay					:	std_logic_vector(9 downto 0);
	signal	sig_GalvX_Gain_Data				:	std_logic_vector(7 downto 0);	--8bit	
	signal	sig_GalvY_Gain_Data				:	std_logic_vector(7 downto 0);	--8bit
	signal	sig_GalvX_Adjust				:	std_logic_vector(11 downto 0);	--12bit
	signal	sig_GalvY_Adjust				:	std_logic_vector(11 downto 0);	--12bit
	signal	sig_GalvX_Offset_Data			: 	std_logic_vector(9 downto 0);	--10bit
	signal	sig_GalvY_Offset_Data			:	std_logic_vector(9 downto 0);	--10bit
	signal	sig_WR_ADDRES					: 	std_logic_vector(18 downto 0);
	signal	sig_CSTM_FLAG_WE				: 	STD_LOGIC;
	signal	sig_SCAN_NUM_WE					:	std_logic;
	signal	sig_DUMMY_NUM_WE				:	std_logic;
	signal	sig_BACK_SCAN_NUM_WE			:	std_logic;
	signal	sig_LIVE_NUM_WE					:	STD_LOGIC;
	signal	sig_L_Start_X_WE 				:	std_logic;
	signal	sig_L_Start_Y_WE				:	STD_LOGIC;
	signal	sig_L_End_X_WE					:	STD_LOGIC;
	signal	sig_L_End_Y_WE					:	STD_LOGIC;
	signal	sig_Circle_R_WE					:	STD_LOGIC;
	signal	sig_L_DIE_LINE_CIR_WE			:	STD_LOGIC;
	signal	sig_DIR_LINE_CIR_WE				:	STD_LOGIC;
	signal	sig_Start_X_WE					:	STD_LOGIC;
	signal	sig_Start_Y_WE					:	STD_LOGIC;
	signal	sig_End_X_WE					:	STD_LOGIC;
	signal	sig_End_Y_WE					:	STD_LOGIC;
	signal	sig_Dummy_DIR_LINE_CIR_WE		:	STD_LOGIC;
	signal	sig_Back_Scan_DIR_LINE_CIR_WE	:	STD_LOGIC;
	signal	sig_Dummy_Back_Data_WE			:	STD_LOGIC;
	signal	sig_DBUS_HOLD					:	STD_LOGIC_VECTOR(15 downto 0);
	signal	sig_cstm_nWE					:	std_logic;
	signal	sig_cstm_CSTM_FLAG				:	STD_LOGIC;
	signal	sig_cstm_Mode_Sel				:	STD_LOGIC_VECTOR(3 downto 0);
	signal	sig_cstm_Galcv_Run				:	STD_LOGIC;
	signal	sig_cstm_CAP_Start				:	STD_LOGIC;
	signal	sig_cstm_INT_CAP_START			:	STD_LOGIC;
	signal	sig_cstm_Start_X				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Start_Y				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_End_X					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_End_Y					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Circle_R				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Circle_DIR				:	STD_LOGIC;
	signal	sig_cstm_Live_Start_X			:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Live_Start_Y			:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Live_End_X				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Live_End_Y				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_Live_Cirle_R			:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_cstm_LiveScanNow_Flag		:	STD_LOGIC;		--20090323YN
	signal	sig_cstm_DummyScanNow_Flag		:	STD_LOGIC;		--20090323YN
	signal	sig_cstm_CapScanNow_Flag		:	STD_LOGIC;		--20090323YN
	signal	sig_cstm_BackScanNow_Flag		:	STD_LOGIC;		--20090323YN
	signal	sig_gal_Mode_sel				:	STD_LOGIC_VECTOR(3 downto 0);
	signal	sig_gal_Galv_run				:	STD_LOGIC;
	signal	sig_gal_CAP_START				:	STD_LOGIC;
	signal	sig_gal_Start_X					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_Start_Y					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_End_X					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_End_Y					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_Circle_R				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_Circle_Direction		:	STD_LOGIC;
	signal	sig_gal_L_Start_X				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_L_Start_Y				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_L_End_X					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_L_End_Y					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_L_Circle_R				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_gal_Resol_OUT				:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_C_Scan_Back_Num				:	STD_LOGIC_VECTOR(3 downto 0);
	signal	sig_cstm_cnt_Live				:	STD_LOGIC_VECTOR(3 downto 0);	
	signal	sig_cstm_param_en				:	STD_LOGIC;
	signal	sig_X_galv						:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_Y_galv						:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_Galv_TRIG					:	STD_LOGIC;
	signal	sig_Galv_BUSY					:	STD_LOGIC;
	signal	sig_V_END_FLAG					:	STD_LOGIC;	
	signal 	sig_GAL_CON_MOVE_END_out		:	STD_LOGIC;
	signal	sig_cstm_trig_en				:	STD_LOGIC;
	signal	sig_DataBusIn					:	STD_LOGIC_VECTOR( 15 downto 0 );
	signal	sig_WR_ADDRESS					:	STD_LOGIC_VECTOR( 9 downto 0);
	signal	sig_WR_DATA						:	STD_LOGIC_VECTOR( 15 downto 0);
	signal	sig_nWR_EN						:	STD_LOGIC;
	signal	sig_REF_ONOFF					:	STD_LOGIC;
	signal	sig_REF_DIR  					:	STD_LOGIC;
	signal	sig_REF_PWM  					:	STD_LOGIC_VECTOR( 6 downto 0);
	signal	sig_POLA_ONOFF					:	STD_LOGIC;
	signal	sig_POLA_DIR  					:	STD_LOGIC;
	signal	sig_POLA_PWM  					:	STD_LOGIC_VECTOR( 6 downto 0);
	signal	sig_FOCUS_ONOFF					:	STD_LOGIC;
	signal	sig_FOCUS_DIR  					:	STD_LOGIC;
	signal	sig_FOCUS_PWM  					:	STD_LOGIC_VECTOR( 6 downto 0);
	signal	sig_vsync						:	STD_LOGIC;
	signal	sig_hsync						:	STD_LOGIC;
	signal	sig_SLD_SMPL_TRG				:	STD_LOGIC;
	signal	sld_pulse_out					:	STD_LOGIC;
	signal	sig_SPI_BUSY   					:	STD_LOGIC;
	signal	sig_SPI_READ_DATA				:	STD_LOGIC_VECTOR( 7 downto 0);
	signal	sig_SPI_ADR						:	STD_LOGIC_VECTOR(23 downto 0);
	signal	sig_SPI_DATA					:	STD_LOGIC_VECTOR( 7 downto 0);
	signal	sig_SPI_ERASE					:	STD_LOGIC;
	signal	sig_SPI_WRITE					:	STD_LOGIC;
	signal	sig_SPI_READ 					:	STD_LOGIC;
	signal	sig_CSTM_LIVE_B_ONOFF			:	STD_LOGIC;
	signal	sig_CSTM_LIVE_B_F_CNT			:	STD_LOGIC_VECTOR( 11 downto 0 );
	signal	sig_CSTM_LIVE_B_PITCH			:	STD_LOGIC_VECTOR( 15 downto 0 );
	signal	sig_CSTM_LIVE_B_CNT				:	STD_LOGIC_VECTOR( 11 downto 0 );
	signal	sig_GalvX_Gain_Data_B			:	STD_LOGIC_VECTOR(7 downto 0);	--8bit		--20090325YN
	signal	sig_GalvY_Gain_Data_B			:	STD_LOGIC_VECTOR(7 downto 0);	--8bit		--20090325YN
	signal	sig_CSTM_LIVE_B_RESOX			:	STD_LOGIC_VECTOR( 11 downto 0 );
	signal	sig_CSTM_LIVE_B_RESOY			:	STD_LOGIC_VECTOR( 11 downto 0 );
	signal	sig_CSTM_LIVE_B_OFFSETX			:	STD_LOGIC_VECTOR( 9 downto 0 );
	signal	sig_CSTM_LIVE_B_OFFSETY			:	STD_LOGIC_VECTOR( 9 downto 0 );
	signal	sig_cstm_live_reso				:	STD_LOGIC_VECTOR( 11 downto 0 );
	signal	sig_live_b_enable				:	STD_LOGIC;
	signal	sig_live_b_retry1				:	STD_LOGIC;
	signal	sig_live_b_retry2				:	STD_LOGIC;
	signal	sig_v_end_wait_cnt				:	STD_LOGIC_VECTOR( 12 downto 0);
	signal	sig_REF_Pulse					:	STD_LOGIC_VECTOR( 15 downto 0);

	signal	sig_SCAN_SET_RUN_END_ALL		:	STD_LOGIC;
	signal	sig_ANGIO_SCAN					:	STD_LOGIC;
	signal	sig_keisenNO					:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_keisen_update				:	STD_LOGIC;
	signal	sig_keisen_update_num			:	STD_LOGIC_VECTOR(11 downto 0);
	signal	sig_Repetition					:	STD_LOGIC_VECTOR(3 downto 0);
	signal  sig_CAPT_OFFSET_EN				:	STD_LOGIC;
	signal  sig_ram_const_data				:	STD_LOGIC_VECTOR(15 downto 0);
	signal  sig_ram_const_adr				:	STD_LOGIC_VECTOR(15 downto 0);
	signal	sig_ram_const_data_en			:	STD_LOGIC;
	signal  sig_SLD_ACTIVE_PERIOD			:	STD_LOGIC;

	signal		sig_RegFileWrAddress         : STD_LOGIC_VECTOR(15 downto 0);
	signal		sig_RegFileWrData            : STD_LOGIC_VECTOR(17 downto 0);
	signal		sig_RegFileWrEn              : STD_LOGIC;
	signal		sig_RegFileRdAddress         : STD_LOGIC_VECTOR(15 downto 0);
	signal		sig_RegFileRdData            : STD_LOGIC_VECTOR(15 downto 0);         
	signal		sig_KEISEN_TXD				 : STD_LOGIC;
	
	signal	sig_BOTH_WAY_SCAN		: std_logic;
	signal	sig_BOTH_WAY_SCAN_CapScan		: std_logic;
	signal	sig_BOTH_WAY_WAIT_TIME	: std_logic_vector(15 downto 0);
	signal	sig_OVER_SCAN			: std_logic;
	signal	sig_OVER_SCAN_CapScan	: std_logic;
	signal	sig_OVER_SCAN_NUM		: std_logic_vector(7 downto 0);
	signal	sig_OVER_SCAN_DLY_TIME	: std_logic_vector(15 downto 0);
	signal	sig_GALV_TIMING_ADJ_EN	: std_logic;
	signal	sig_GALV_TIMING_ADJ_EN_CapScan	: std_logic;
	signal	sig_GALV_TIMING_ADJ_T3	: std_logic_vector(15 downto 0);
	signal	sig_GALV_TIMING_ADJ_T4	: std_logic_vector(15 downto 0);
	signal	sig_GALV_TIMING_ADJ_T5	: std_logic_vector(15 downto 0);

	signal	sig_cstm_wr_adr			: std_logic_vector(31 downto 0);
	signal	sig_cstm_wr_data		: std_logic_vector(15 downto 0);
	signal	sig_cstm_wr_enable		: std_logic;



	--VH_SYNC
	signal		sig_VH_sync_period		: STD_LOGIC_VECTOR(12 downto 0);
	signal		sig_VH_sync_period_ext	: STD_LOGIC_VECTOR(15 downto 0);
	
	--Encoere cnt
	signal		sig_ENC_CNT_RST		: STD_LOGIC;
	signal		sig_ENC_CNT_EN		: STD_LOGIC;
	signal		sig_ENC_CNT_AB		: STD_LOGIC_VECTOR(31 downto 0);
	signal		sig_ENC_CNT_BA		: STD_LOGIC_VECTOR(31 downto 0);

	--OCTF Stepping motor_ctrl
	signal		sig_OCTF_Init_speed				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_OCTF_Max_speed				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_OCTF_Motor_start			: STD_LOGIC;
	signal		sig_OCTF_Total_step				: STD_LOGIC_VECTOR(14 downto 0);
	signal		sig_OCTF_CW						: STD_LOGIC;
	signal		sig_OCTF_Dec_step				: STD_LOGIC_VECTOR(14 downto 0);
	signal		sig_OCTF_Increase				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_OCTF_irq_out				: STD_LOGIC;
	signal		sig_OCTF_ON_OFF					: STD_LOGIC;
	signal		sig_OCTF_AP                     : STD_LOGIC;
	signal		sig_OCTF_BP                     : STD_LOGIC;
	signal		sig_OCTF_AN                     : STD_LOGIC;
	signal		sig_OCTF_BN                     : STD_LOGIC;
	
	--POLA Stepping motor ctrl
	signal		sig_POLA_Init_speed				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_POLA_Max_speed				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_POLA_Motor_start			: STD_LOGIC;
	signal		sig_POLA_Total_step				: STD_LOGIC_VECTOR(14 downto 0);
	signal		sig_POLA_CW						: STD_LOGIC;
	signal		sig_POLA_Dec_step				: STD_LOGIC_VECTOR(14 downto 0);
	signal		sig_POLA_Increase				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_POLA_irq_out				: STD_LOGIC;
	signal		sig_POLA_ON_OFF					: STD_LOGIC;
	signal		sig_POLA_AP                     : STD_LOGIC;
	signal		sig_POLA_BP                     : STD_LOGIC;
	signal		sig_POLA_AN                     : STD_LOGIC;
	signal		sig_POLA_BN                     : STD_LOGIC;
	                                            
	--Delay Line Stepping motor ctrl
	signal		sig_DelayLine_Init_speed		: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_Delayline_Max_speed			: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_Dline_Mot_start				: STD_LOGIC;
    signal		sig_Delayline_Total_step		: STD_LOGIC_VECTOR(14 downto 0);
    signal		sig_Delayline_CW				: STD_LOGIC;
    signal		sig_Dline_Dec_step				: STD_LOGIC_VECTOR(14 downto 0);
    signal		sig_Delayline_Increase			: STD_LOGIC_VECTOR(13 downto 0);
    signal		sig_Delayline_irq_out			: STD_LOGIC;
	
	signal		sig_D_LINE_ON_OFF				: STD_LOGIC;
	signal		sig_D_LINE_AP                   : STD_LOGIC;
	signal		sig_D_LINE_BP                   : STD_LOGIC;
	signal		sig_D_LINE_AN                   : STD_LOGIC;
	signal		sig_D_LINE_BN                   : STD_LOGIC;
	
	
	--P_SW stepping motor ctrl
    signal		sig_P_SW_Motor_start			: STD_LOGIC;
    signal		sig_P_SW_total_step				: STD_LOGIC_VECTOR(14 downto 0);
    signal		sig_P_SW_Init_speed				: STD_LOGIC_VECTOR(13 downto 0);
	signal		sig_P_SW_CW						: STD_LOGIC;
	signal		sig_P_SW_irq_out				: STD_LOGIC;

	signal		sig_P_SW_ON_OFF					: STD_LOGIC;
	signal		sig_P_SW_AP                     : STD_LOGIC;
	signal		sig_P_SW_BP                     : STD_LOGIC;
	signal		sig_P_SW_AN                     : STD_LOGIC;
	signal		sig_P_SW_BN                     : STD_LOGIC;


	signal		sig_stp_mtr_ctl_end_ff			: STD_LOGIC;
	
	
	--Line Sensor Err detect
	signal		sig_Inter_Reset					: STD_LOGIC;
	signal		sig_MisTrigger_det				: STD_LOGIC;

	signal		sig_vh_gen_en					: STD_LOGIC;

	signal		sig_Hsync_num					: STD_LOGIC_VECTOR(12 downto 0);

	signal		sig_hsync_end					: STD_LOGIC;

	signal		sig_Hsync_T						: STD_LOGIC_VECTOR(11 downto 0);

	signal		sig_resolution_out				: STD_LOGIC_VECTOR(11 downto 0);

	signal		sig_Scan_Run_Flag				: STD_LOGIC;

	signal		sig_testpin_sel					: STD_LOGIC_VECTOR(2 downto 0);

	signal		MIX_EXT_FW_RST					: STD_LOGIC;

begin
	FPGAclk			<= FPGA_CLOCK;
	nFPGARST 		<= FPGA_RESET;							--FPGA RESET
	MIX_EXT_FW_RST 	<= sig_GAL_CNT_RESET or not nFPGARST;
	pFPGARST        <= not nFPGARST;

	--IRQ1、Stepping motor駆動終了をFWへ通知する。(Low Active)
	--(OCT合焦,POLA,Delay Line,光路切替 Stepping Motorで共用する。)
	nIRQ1_FPGA 		<= sig_stp_mtr_ctl_end_ff;

	nIRQ2_FPGA 		<= sig_V_END_FLAG;
	nIRQ3_FPGA 		<= sig_SLD_SMPL_TRG	;
	
	--IRQ4、 Line Sensor GPOエラー検出をFWへ通知する。(Low Active)
	nIRQ4_FPGA 		<= sig_MisTrigger_det;
	nIRQ5_FPGA 		<= sld_pulse_out;
	nIRQ6_FPGA 		<= '1'		;
	nIRQ7_FPGA 		<= '1'		;
	nIRQ8_FPGA 		<= '0'	;
	RDnWR 			<= '0'		;
--	nWE0_2			<= '1'		;
--	nWE1_2			<= '1'		;
	CIBT3_Hsync		<= sig_hsync;
	CIBT3_Vsync	 	<= sig_vsync;
	SLD_PULSE		<= sld_pulse_out;
--	ADD				<= (others => '1') when nHSWAPEN = '1' else (others => 'Z');							-- SDRAM
--	DATA			<= (others => '1') when nHSWAPEN = '1' else (others => 'Z');							-- SDRAM
	FOCUS_SLEEP		<= '1';
	SLD_ACTIVE_PERIOD<=  '0'	;
--	GPIO2_IN 		<= '0'; --sig_KEISEN_TXD;
	KEISEN_TXD		<= sig_KEISEN_TXD;


	sig_BOTH_WAY_SCAN_CapScan      <= sig_BOTH_WAY_SCAN      and sig_cstm_CapScanNow_Flag;
	sig_OVER_SCAN_CapScan          <= sig_OVER_SCAN          and sig_cstm_CapScanNow_Flag;
	sig_GALV_TIMING_ADJ_EN_CapScan <= sig_GALV_TIMING_ADJ_EN and sig_cstm_CapScanNow_Flag;



	--debug PIN assign
	process(sig_testpin_sel,sig_hsync,sig_OCTF_AP,sig_D_LINE_AP,sig_P_SW_AP,sig_POLA_AP)begin
		case sig_testpin_sel is
			when "000"  => CP8 <= sig_hsync;
			when "001"  => CP8 <= sig_OCTF_AP;
			when "010"  => CP8 <= sig_D_LINE_AP;
			when "011"  => CP8 <= sig_P_SW_AP;
			when "100"  => CP8 <= sig_POLA_AP;
			when others => CP8 <= sig_hsync;
		end case;
	end process;
	
	process(sig_testpin_sel,sig_Scan_Run_Flag,sig_OCTF_BP,sig_D_LINE_BP,sig_P_SW_BP,sig_POLA_BP)begin
		case sig_testpin_sel is
			when "000"  => CP9 <= sig_Scan_Run_Flag;
			when "001"  => CP9 <= sig_OCTF_BP;
			when "010"  => CP9 <= sig_D_LINE_BP;
			when "011"  => CP9 <= sig_P_SW_BP;
			when "100"  => CP9 <= sig_POLA_BP;
			when others => CP9 <= sig_Scan_Run_Flag;
		end case;
	end process;
	
	process(sig_testpin_sel,sig_MisTrigger_det,sig_OCTF_AN,sig_D_LINE_AN,sig_P_SW_AN,sig_POLA_AN)begin
		case sig_testpin_sel is
			when "000"  => CP10 <= sig_MisTrigger_det;
			when "001"  => CP10 <= sig_OCTF_AN;
			when "010"  => CP10 <= sig_D_LINE_AN;
			when "011"  => CP10 <= sig_P_SW_AN;
			when "100"  => CP10 <= sig_POLA_AN;
			when others => CP10 <= sig_MisTrigger_det;
		end case;
	end process;
	
	process(sig_testpin_sel,sig_hsync,sig_OCTF_BN,sig_D_LINE_BN,sig_P_SW_BN,sig_POLA_BN)begin
		case sig_testpin_sel is
			when "000"  => CP11 <= sig_hsync;
			when "001"  => CP11 <= sig_OCTF_BN;
			when "010"  => CP11 <= sig_D_LINE_BN;
			when "011"  => CP11 <= sig_P_SW_BN;
			when "100"  => CP11 <= sig_POLA_BN;
			when others => CP11 <= sig_hsync;
		end case;
	end process;
	
	process(sig_testpin_sel,sig_OCTF_ON_OFF,sig_D_LINE_ON_OFF,sig_P_SW_ON_OFF,sig_POLA_ON_OFF)begin
		case sig_testpin_sel is
			when "000"  => CP12 <= '0';
			when "001"  => CP12 <= sig_OCTF_ON_OFF;
			when "010"  => CP12 <= sig_D_LINE_ON_OFF;
			when "011"  => CP12 <= sig_P_SW_ON_OFF;
			when "100"  => CP12 <= sig_POLA_ON_OFF;
			when others => CP12 <=  '0';
		end case;
	end process;
	

	U_GPIO : GPIO PORT MAP (
			FPGACLK				=>	FPGAclk, 					--	in std_logic;
			nFPGARST			=>	nFPGARST,					--	in std_logic,
			reset				=>	MIX_EXT_FW_RST,
			nCS					=>	nCS1n,						-- チップセレクト
			nRD					=>	nRD_n2,						--  IN STD_LOGIC;	-- リード信号
			nWE					=>	nWRn3,						-- IN STD_LOGIC;	-- ライト信号
			AdrsBus				=>	A(10 downto 0),				--	in std_logic_vector(15 downto 1),	
			DataBus				=>	D(15 downto 0),				--	inout std_logic_vector(15 downto 0),
			GAL_CON_MOVE_END	=> sig_GAL_CON_MOVE_END_out,

		
			
--			IN_DataBus			=> IN_DataBus				,
--			OUT_DataBus         => OUT_DataBus              ,
--			OUT_TRI_OUTEN		=> OUT_TRI_OUTEN     ,

			FPGA_DIPSW(9 downto 4)			=>	B"00_0000",			--	in std_logic_vector(9 downto 0);
			FPGA_DIPSW(3 downto 0)			=> DIP_SW(3 downto 0),
			LAMP_COVER			=>	'0',						--	in std_logic,
			SHIDO_SW			=>	'0',						--	in std_logic,
			n_EF_Detect			=>	'1',						--	in std_logic,
			n_AF_Detect_M		=>	'1',						--	in std_logic,
			n_AF_Detect_P		=>	'1',						--	in std_logic,
			n_QM_Detect			=>	'1',						--	in std_logic,
			DSC_SyncIn			=>	'0',						--	in std_logic,
			OVER_VOLTAGE		=>	'0',						--	in std_logic,
			CHARGE_OK			=>	'0',						--	in std_logic,
			REF_SEN_IN			=>	'0',						--	in std_logic,
			POL_SEN_IN			=>	'0',						--	in std_logic,
			YA_SEN_IN			=>	'0',						--	in std_logic,
			AXL_SEN_IN			=>	'0',						--	in std_logic,
			n_ATTENUATOR_Detect	=>	'1',						--	in std_logic,
			GPO					=>	"0000",						--	in std_logic_vector(4 downto 1),
			SLD_BUSY			=>	'0',
			SLD_ERROR			=>	'0',
			IMG_B_BUSY			=>	'0',
			IMG_B_EVENT_FLAG	=>	'0',
			AreaCCD_TRIG		=>	'0',						--	in std_logic,
			GalvX_FAULT			=>	'0',
			GalvY_FAULT			=>	'0',
			n_BF_Detect			=>	'0',						--	in std_logic,
			PAHSE_B2			=>	'0',						--	in std_logic,
			PAHSE_A2			=>	'0',						--	in std_logic,
			PAHSE_B1			=>	'0',						--	in std_logic,
			PAHSE_A1			=>	'0',						--	in std_logic,
			FI_IN				=>	'0',						--	in std_logic,
			SPI_BUSY   			=>	sig_SPI_BUSY   		,
			SPI_READ_DATA		=>	sig_SPI_READ_DATA	,
			HW_Rev1				=>	sig_HW_Rev1,				--	in std_logic_vector(3 downto 0),
			HW_Rev2				=>	sig_HW_Rev2,				--	in std_logic_vector(3 downto 0),
			HW_Rev3				=>	sig_HW_Rev3,				--	in std_logic_vector(3 downto 0),
			HW_Rev4				=>	sig_HW_Rev4,				--	in std_logic_vector(3 downto 0),
			FPGA_CNT			=>	sig_FPGA_CNT,				--	in std_logic_vector(15 downto 0),
			Galv_BUSY			=>	sig_Galv_BUSY,				--	in std_logic;
			Back_Scan_Flag		=>	sig_BackScan_Flag,			--	in std_logic,
			nFOCUS_FAULT		=>	nFOCUS_FAULT,
			nREF_POLA_FAULT		=>	nREF_POLA_FAULT,
			cstm_Start_X		=>	sig_cstm_Start_X,	
			cstm_Start_Y		=>  sig_cstm_Start_Y,	
			cstm_End_X			=>  sig_cstm_End_X,		
			cstm_End_Y			=>  sig_cstm_End_Y,		
			GAL_CNT_RESET		=>	sig_GAL_CNT_RESET,			--out std_logic;
			Galv_run			=>	sig_galv_run,				--out std_logic;
			CAP_START			=>	sig_cap_start,				--	out std_logic;
			L_R					=>	sig_L_R,					--	out std_logic;
			START_3D			=>	sig_START_3D,				--	out std_logic;
			RetryFlag1_ON_OFF	=>	sig_RetryFlag1_ON_OFF,		--	out std_logic;
			RetryFlag2_ON_OFF	=>	sig_RetryFlag2_ON_OFF,		--	out std_logic;
			C_Scan_Back_Num		=>	sig_C_Scan_Back_Num,		--	out std_logic_vector(3 downto 0);
			V_H_3D				=>	sig_V_H_3D,					--	out std_logic_vector(1 downto 0);
			Mode_sel			=>	sig_mode_sel,				--	out std_logic_vector(3 downto 0);
			Freq_sel			=>	sig_Freq_sel,				--	out std_logic_vector(7 downto 0);
			Start_X				=>	sig_start_x,				--	out std_logic_vector(11 downto 0);
			Start_Y				=>	sig_start_y,				--	out std_logic_vector(11 downto 0);
			End_X				=>	sig_end_x,					--	out std_logic_vector(11 downto 0);
			End_Y				=>	sig_end_y,					--	out std_logic_vector(11 downto 0);
			Circle_R			=>	sig_circle_r,				--	out std_logic_vector(11 downto 0);
			Live_Resol			=>	sig_Live_Resol,				--	out std_logic_vector(11 downto 0);
			Resolution			=>	sig_resolution,				--	out std_logic_vector(11 downto 0);
			Resol_Y				=>	sig_Resol_Y,				--	out std_logic_vector(11 downto 0);
			Live_Resol_CSTM		=>	sig_live_resol_cstm,		--	out std_logic_vector(11 downto 0);
			Resol_CSTM			=>	sig_resol_cstm,				--	out std_logic_vector(11 downto 0);
			Back_Resol_CSTM		=>	sig_back_resol_cstm,		--	out std_logic_vector(11 downto 0);
			Dum_Resol_CSTM		=>	sig_dum_resol_cstm,			--	out std_logic_vector(11 downto 0);
			Dummy_Num			=>	sig_Dummy_Num,				--	out std_logic_vector(2 downto 0);
			Radial_Num			=>	sig_Radial_Num,				--	out std_logic_vector(3 downto 0);
			Circle_Total_Num	=>	sig_Circle_Total_Num,		--	out std_logic_vector(5 downto 0);
			Circle_Dir			=>	sig_circle_dir,				--	out std_logic;
			L_Start_X			=>	sig_l_start_x,				--	out std_logic_vector(11 downto 0);
			L_Start_Y			=>	sig_l_start_y,				--	out std_logic_vector(11 downto 0);
			L_End_X				=>	sig_l_end_x,				--	out std_logic_vector(11 downto 0);
			L_End_Y				=>	sig_l_end_y,				--	out std_logic_vector(11 downto 0);
			L_Radial_R			=>	sig_l_radial_r,				--	out std_logic_vector(11 downto 0);
			Web_Live_Sel		=>	sig_Web_Live_Sel,			--	out std_logic;
			Web_Radial_R		=>	sig_Web_Radial_R,			--	out std_logic_vector(11 downto 0);
			Raster_Scan_Num		=>	sig_Raster_Scan_Num,		--	out std_logic_vector(8 downto 0);
			Raster_Scan_Step	=>	sig_Raster_Scan_Step,		--	out std_logic_vector(11 downto 0);
			Circle_Step			=>	sig_Circle_Step,			--	out std_logic_vector(11 downto 0);
			SLD_ON_OFF			=>	sig_SLD_ON_OFF,				--	out std_logic;
			Adjust_Mode			=>	sig_Adjust_Mode,			--	out std_logic;	
			Pulse_ON_OFF		=>	sig_Pulse_ON_OFF,			--		out std_logic;
			Pulse_Mode			=>	sig_Pulse_Mode,				--	out std_logic;
			SLD_M_Pos			=>	sig_SLD_M_Pos,				--	out std_logic_vector(3 downto 0);
			Pulse_Width			=>	sig_Pulse_Width,			--	out std_logic_vector(7 downto 0);
			SLD_Delay			=>	sig_SLD_Delay,				--	out std_logic_vector(7 downto 0);
			GalvX_Gain_Data		=>	sig_GalvX_Gain_Data,		--	out std_logic_vector(7 downto 0);
			GalvY_Gain_Data		=>	sig_GalvY_Gain_Data,		--	out std_logic_vector(7 downto 0);
			GalvX_Adjust		=>	sig_GalvX_Adjust,			--	out std_logic_vector(11 downto 0);
			GalvY_Adjust		=>	sig_GalvY_Adjust,			--	out std_logic_vector(11 downto 0);
			GalvX_OS_Data		=>	sig_GalvX_Offset_Data,		--out std_logic_vector(9 downto 0),	--10bit	
			GalvY_OS_Data		=>	sig_GalvY_Offset_Data,		--	out std_logic_vector(9 downto 0),	--10bit
			WR_ADDRESS			=>	sig_WR_ADDRESS,
			WR_DATA				=>	sig_WR_DATA,
			nWR_EN				=>	sig_nWR_EN,

--			FOCUS_RESET			=>	FOCUS_RESET			,
--			FOCUS_DECAY			=>	FOCUS_DECAY			,
			REF_POLA_RESET		=>	REF_POLA_RESET		,
--			REF_POLA_DECAY		=>	REF_POLA_DECAY		,
			MOT_ENABLE			=>	MOT_ENABLE			,
--			MOT_DECAY2			=>	MOT_DECAY2			,
--			MOT_DECAY1			=>	MOT_DECAY1			,
			MOT_PHA				=>	MOT_PHA				,
			MOT_DIR				=>	MOT_DIR				,
			MOT_PWMSW			=>	MOT_PWMSW			,
			PER_N				=>	PER_N				,
			PER_P				=>	PER_P				,
			PER_REF_SCLK		=>	PER_REF_SCLK		,
			PER_REF_DIN			=>	PER_REF_DIN			,
			nPER_RES_CS			=>	nPER_RES_CS			,
			REF_ONOFF			=>	sig_REF_ONOFF		,
			REF_DIR  			=>	sig_REF_DIR  		,
			REF_PWM  			=>	sig_REF_PWM  		,
			POLA_ONOFF			=>	sig_POLA_ONOFF		,
			POLA_DIR  			=>	sig_POLA_DIR  		,
			POLA_PWM  			=>	sig_POLA_PWM  		,
			FOCUS_ONOFF			=>	sig_FOCUS_ONOFF		,
			FOCUS_DIR  			=>	sig_FOCUS_DIR  		,
			FOCUS_PWM  			=>	sig_FOCUS_PWM  		,
			SPI_ADR				=>	sig_SPI_ADR			,
			SPI_DATA			=>	sig_SPI_DATA		,
			SPI_ERASE			=>	sig_SPI_ERASE		,
			SPI_WRITE			=>	sig_SPI_WRITE		,
			SPI_READ 			=>	sig_SPI_READ 		,
			SLD_REF_SCLK 		=> 	SLD_REF_SCLK		,
			SLD_REF_DIN 		=> 	SLD_REF_DIN 		,
			nSLD_REF_CS 		=> 	nSLD_REF_CS ,
			nSLD_LIMIT_CS 		=> 	nSLD_LIMIT_CS ,
			nDRV8841_SLEEP		=>	nDRV8841_SLEEP,
			LineCCD_ONOFF		=>	LineCCD_ONOFF		,
			CSTM_LIVE_B_ONOFF	=>	sig_CSTM_LIVE_B_ONOFF			,
			CSTM_LIVE_B_F_CNT	=>	sig_CSTM_LIVE_B_F_CNT			,
			CSTM_LIVE_B_PITCH	=>	sig_CSTM_LIVE_B_PITCH			,
			CSTM_LIVE_B_CNT		=>	sig_CSTM_LIVE_B_CNT				,
			GalvX_Gain_Data_B	=>	sig_GalvX_Gain_Data_B			,	--8bit		--20090325YN
			GalvY_Gain_Data_B	=>	sig_GalvY_Gain_Data_B			,	--8bit		--20090325YN
			CSTM_LIVE_B_RESOX	=>	sig_CSTM_LIVE_B_RESOX			,
			CSTM_LIVE_B_RESOY	=>	sig_CSTM_LIVE_B_RESOY			,
			CSTM_LIVE_B_OFFSETX	=>	sig_CSTM_LIVE_B_OFFSETX			,
			CSTM_LIVE_B_OFFSETY	=>	sig_CSTM_LIVE_B_OFFSETY			,
			V_END_WAIT_CNT		=>	sig_v_end_wait_cnt				,
			REF_PULSE			=>	sig_REF_Pulse					,
			SCAN_SET_RUN_END_ALL=>	sig_SCAN_SET_RUN_END_ALL		,
			ANGIO_SCAN			=>	sig_ANGIO_SCAN					,
			keisen_update		=>	sig_keisen_update				,
			keisen_update_num	=>	sig_keisen_update_num			,
			Repetition			=>  sig_Repetition					,
			RAM_CONST_DATA		=>	sig_ram_const_data				,
			RAM_CONST_ADR		=>	sig_ram_const_adr				,
			RAM_CONST_DATA_EN	=>	sig_ram_const_data_en			,
			FLASH_WR_ADDRESS	=> 	sig_RegFileWrAddress         	,
			FLASH_WR_DATA   	=> 	sig_RegFileWrData            	,
			FLASH_WR_EN     	=> 	sig_RegFileWrEn              	,
			FLASH_RD_ADDRESS	=> 	sig_RegFileRdAddress         	,
			FLASH_RD_DATA 		=> 	sig_RegFileRdData            , 
			BOTH_WAY_SCAN		=> 	sig_BOTH_WAY_SCAN			,
			BOTH_WAY_WAIT_TIME	=> 	sig_BOTH_WAY_WAIT_TIME		,
			OVER_SCAN			=> 	sig_OVER_SCAN				,
			OVER_SCAN_NUM		=> 	sig_OVER_SCAN_NUM			,
			OVER_SCAN_DLY_TIME	=> 	sig_OVER_SCAN_DLY_TIME		,
			GALV_TIMING_ADJ_EN	=> 	sig_GALV_TIMING_ADJ_EN		,
			GALV_TIMING_ADJ_T3	=> 	sig_GALV_TIMING_ADJ_T3		,
			GALV_TIMING_ADJ_T4	=> 	sig_GALV_TIMING_ADJ_T4		,
			GALV_TIMING_ADJ_T5	=> 	sig_GALV_TIMING_ADJ_T5		,
			CSTM_WR_ADR			=>	sig_cstm_wr_adr				,
            CSTM_WR_DATA		=>	sig_cstm_wr_data            ,
            OUT_CSTM_WR_EN		=>	sig_cstm_wr_enable          ,
			VH_sync_period				=>  sig_VH_sync_period				,
			ENC_CNT_RST		    		=> 	sig_ENC_CNT_RST					,
			ENC_CNT_EN		    		=> 	sig_ENC_CNT_EN					,
			ENC_CNT_AB   				=> 	sig_ENC_CNT_AB					,
			ENC_CNT_BA					=>  sig_ENC_CNT_BA					,
			OCTF_Init_speed				=> 	sig_OCTF_Init_speed,
			OCTF_Max_speed				=>  sig_OCTF_Max_speed		,
			OCTF_Motor_start			=>  sig_OCTF_Motor_start			,
			OCTF_Total_step				=>  sig_OCTF_Total_step				,
			OCTF_CW						=>  sig_OCTF_CW						,
			OCTF_Deceleration_step		=>  sig_OCTF_Dec_step		,
			OCTF_Increase				=>  sig_OCTF_Increase		,
			POLA_Init_speed				=>  sig_POLA_Init_speed		,
			POLA_Max_speed				=>  sig_POLA_Max_speed		,
			POLA_Motor_start			=>  sig_POLA_Motor_start			,
			POLA_Total_step				=>  sig_POLA_Total_step				,
			POLA_CW						=>  sig_POLA_CW						,
			POLA_Deceleration_step		=>  sig_POLA_Dec_step		,
			POLA_Increase				=>  sig_POLA_Increase		,
			DelayLine_Init_speed		=>  sig_DelayLine_Init_speed	,
			Delayline_Max_speed			=>  sig_Delayline_Max_speed	,
			Delayline_Motor_start		=>  sig_Dline_Mot_start		,
			Delayline_Total_step		=>  sig_Delayline_Total_step		,
			Delayline_CW				=>  sig_Delayline_CW				,
			Delayline_Deceleration_step	=>  sig_Dline_Dec_step	,
			Delayline_Increase			=>  sig_Delayline_Increase	,
			P_SW_Motor_start			=>  sig_P_SW_Motor_start			,
			P_SW_total_step				=>  sig_P_SW_total_step			,
			P_SW_Init_speed				=>  sig_P_SW_Init_speed	,
			P_SW_CW						=>  sig_P_SW_CW					,
			TESTPIN_SEL					=> 	sig_testpin_sel
			);


--	U_GPIO_cstm : GPIO_cstm PORT MAP(
--			FPGACLK						=>	FPGAclk,						-- IN STD_LOGIC;	-- クロック(20MHz)
--			Reset						=>	sig_GAL_CNT_RESET,				-- IN STD_LOGIC;	-- リセット信号
--
--			nCS6						=>	nCS1n,							-- チップセレクト
--			nRD							=>	nRD_n2,							--  IN STD_LOGIC;	-- リード信号
----			nWE							=>	nWRn3,							-- IN STD_LOGIC;	-- ライト信号
----			AdrsBus						=>	A( 7 downto 0),					-- アドレス・バス
----			DataBusIn					=>	D(15 downto 0),					-- データ・バス(入力)
--			nWE							=>	sig_nWR_EN,						-- IN STD_LOGIC;	-- ライト信号
--			AdrsBus						=>	sig_WR_ADDRESS( 7 downto 0),	-- アドレス・バス
--			DataBusIn					=>	sig_WR_DATA(15 downto 0),		-- データ・バス(入力)
--			Galv_BUSY					=>	sig_Galv_BUSY,					-- IN std_logic;
--			WR_ADDRES_OUT				=>	sig_WR_ADDRES,					-- OUT STD_LOGIC_VECTOR(18 downto 0);	--12bit
--			CSTM_FLAG_WE				=>	sig_CSTM_FLAG_WE,				-- OUT STD_LOGIC;
--			SCAN_NUM_WE					=>	sig_SCAN_NUM_WE,				-- OUT STD_LOGIC;
--			DUMMY_NUM_WE				=>	sig_DUMMY_NUM_WE,				-- OUT STD_LOGIC;
--			BACK_SCAN_NUM_WE			=>	sig_BACK_SCAN_NUM_WE,			-- OUT STD_LOGIC;
--			LIVE_NUM_WE					=>	sig_LIVE_NUM_WE,				-- OUT STD_LOGIC;
--			L_Start_X_WE				=>	sig_L_Start_X_WE,				-- OUT STD_LOGIC;
--			L_Start_Y_WE				=>	sig_L_Start_Y_WE,				-- OUT STD_LOGIC;
--			L_End_X_WE					=>	sig_L_End_X_WE,					-- OUT STD_LOGIC;
--			L_End_Y_WE					=>	sig_L_End_Y_WE,					-- OUT STD_LOGIC;
--			L_Circle_R_WE				=>	sig_Circle_R_WE,				-- OUT STD_LOGIC;
--			L_DIR_LINE_CIR_WE			=>	sig_L_DIE_LINE_CIR_WE,			-- OUT STD_LOGIC;
--			DIR_LINE_CIR_WE				=>	sig_DIR_LINE_CIR_WE,			-- OUT STD_LOGIC;
--			Start_X_WE					=>	sig_Start_X_WE,					-- OUT STD_LOGIC;
--			Start_Y_WE					=>	sig_Start_Y_WE,					-- OUT STD_LOGIC;
--			End_X_WE					=>	sig_End_X_WE,					-- OUT STD_LOGIC;
--			End_Y_WE					=>	sig_End_Y_WE,					-- OUT STD_LOGIC;
--			Dummy_DIR_LINE_CIR_WE		=>	sig_Dummy_DIR_LINE_CIR_WE,		-- OUT STD_LOGIC;
--			Back_Scan_DIR_LINE_CIR_WE	=>	sig_Back_Scan_DIR_LINE_CIR_WE,	-- OUT STD_LOGIC;
--			Dummy_Back_Data_WE			=>	sig_Dummy_Back_Data_WE,			-- OUT STD_LOGIC;
--			DBUS_HOLD_OUT				=>	sig_DBUS_HOLD,					-- OUT STD_LOGIC_VECTOR(15 downto 0)
--			cstm_nWE					=>	sig_cstm_nWE
--		);

--	U_comp_CSTM_SEL : comp_CSTM_SEL  PORT MAP(
--			Mode_sel					=>	sig_mode_sel,				-- IN STD_LOGIC_VECTOR(3 downto 0);
--			Galv_run					=>	sig_galv_run, 				-- IN STD_LOGIC;
--			CAP_START					=>	sig_cap_start,				--: IN STD_LOGIC;
--			Start_X						=>	sig_start_x,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Start_Y						=>	sig_start_y,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			End_X						=>	sig_end_x,					-- IN STD_LOGIC_VECTOR(11 downto 0);
--			End_Y						=>	sig_end_y,					-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Circle_R					=>	sig_circle_r,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Circle_Direction			=>	sig_circle_dir,				-- IN STD_LOGIC;
--			L_Start_X					=>	sig_l_start_x,				-- IN std_logic_vector(11 downto 0);
--			L_Start_Y					=>	sig_l_start_y,				-- IN std_logic_vector(11 downto 0);
--			L_End_X						=>	sig_l_end_x,				-- IN std_logic_vector(11 downto 0);
--			L_End_Y						=>	sig_l_end_y,				-- IN std_logic_vector(11 downto 0);
--			L_Radial_R					=>	sig_l_radial_r,				-- IN std_logic_vector(11 downto 0);
--			Live_Resol_CSTM				=>	sig_cstm_live_reso,		-- IN std_logic_vector(11 downto 0);		--20090106YN
--			Resolution					=>	sig_resolution,				-- IN std_logic_vector(11 downto 0);		--add 081224TS
--			Resol_CSTM					=>	sig_resol_cstm,				-- IN std_logic_vector(11 downto 0);		--20090106YN
--			Back_Resol_CSTM				=>	sig_back_resol_cstm,		-- IN std_logic_vector(11 downto 0);		--20090508YN
--			Dum_Resol_CSTM				=>	sig_dum_resol_cstm,			-- IN std_logic_vector(11 downto 0);		--20090508YN
--			cstm_CSTM_FLAG				=>	sig_cstm_CSTM_FLAG,			-- IN STD_LOGIC;
--			cstm_Mode_sel				=>	sig_cstm_Mode_Sel,			-- IN STD_LOGIC_VECTOR(3 downto 0);
--			cstm_Galv_Run				=>	sig_cstm_Galcv_Run,			-- IN STD_LOGIC;
--			cstm_CAP_Start				=>	sig_cstm_CAP_Start,			-- IN STD_LOGIC;
--			cstm_INT_CAP_START			=>	sig_cstm_INT_CAP_START,		-- IN STD_LOGIC;
--			cstm_Start_X				=>	sig_cstm_Start_X,			-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Start_Y				=>	sig_cstm_Start_Y,			-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_End_X					=>	sig_cstm_End_X,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_End_Y					=>	sig_cstm_End_Y,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Circle_R				=>	sig_cstm_Circle_R,			-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Circle_DIR				=>	sig_cstm_Circle_DIR,		-- IN STD_LOGIC;
--			cstm_Live_Start_X			=>	sig_cstm_Live_Start_X,		-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Start_Y			=>	sig_cstm_Live_Start_Y,		-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_X				=>	sig_cstm_Live_End_X,		-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_Y				=>	sig_cstm_Live_End_Y,		-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Circle_R			=>	sig_cstm_Live_Cirle_R,		-- IN STD_LOGIC_VECTOR(11 downto 0);
--			cstm_LiveScanNow_Flag		=>	sig_cstm_LiveScanNow_Flag,	-- IN STD_LOGIC;		--20090323YN
--			cstm_DummyScanNow_Flag		=>	sig_cstm_DummyScanNow_Flag,	-- IN STD_LOGIC;		--20090323YN
--			cstm_CapScanNow_Flag		=>	sig_cstm_CapScanNow_Flag,	-- IN STD_LOGIC;		--20090323YN
--			cstm_BackScanNow_Flag		=>	sig_cstm_BackScanNow_Flag,	-- IN STD_LOGIC;		--20090323YN
--			gal_Mode_sel				=>	sig_gal_Mode_sel,			-- OUT STD_LOGIC_VECTOR(3 downto 0);
--			gal_Galv_run				=>	sig_gal_Galv_run,			-- OUT STD_LOGIC;
--			gal_CAP_START				=>	sig_gal_CAP_START,			-- OUT STD_LOGIC;
--			gal_Start_X					=>	sig_gal_Start_X,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Start_Y					=>	sig_gal_Start_Y,			--  OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_End_X					=>	sig_gal_End_X,				-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_End_Y					=>	sig_gal_End_Y,				-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Circle_R				=>	sig_gal_Circle_R,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Circle_Direction 		=>	sig_gal_Circle_Direction,	-- OUT STD_LOGIC;
--			gal_L_Start_X				=>	sig_gal_L_Start_X,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_Start_Y				=>	sig_gal_L_Start_Y,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_End_X					=>	sig_gal_L_End_X,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_End_Y					=>	sig_gal_L_End_Y,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_L_Circle_R				=>	sig_gal_L_Circle_R,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			gal_Resol_OUT				=>	sig_gal_Resol_OUT			-- OUT STD_LOGIC_VECTOR(11 downto 0)
--		);


	--エンコーダカウントモジュール
	U_encoder_cnt : encoder_cnt port map(
		Reset				=> nFPGARST,
		FPGAclk         	=> FPGAclk,
		ENC_CNT_RST     	=> sig_ENC_CNT_RST,
		ENC_CNT_EN			=> sig_ENC_CNT_EN,
		ENC_A	        	=> ENC_A,
		ENC_B	        	=> ENC_B,
		OUT_ENC_CNT_AB      => sig_ENC_CNT_AB,
		OUT_ENC_CNT_BA		=> sig_ENC_CNT_BA
		);

	--Linesensor GPOエラー処理
	U_err_det : linesensor_err_det PORT MAP(
		Reset					=>	MIX_EXT_FW_RST,
		FPGAclk         	    =>	FPGAclk,
		LCMOS_MisTrigger	    =>	LCMOS_MisTrigger,
		HSYNC_IN				=>	sig_hsync,
		VSYNC_IN				=>  sig_Vsync,
		OUT_MisTrigger_det	    =>	sig_MisTrigger_det
	);

	--OCT合焦モータコントローラ(1-2相励磁)
	U_OCT_stp : stepmotor_ctrl PORT MAP (
		Reset						=> nFPGARST,
		FPGAclk						=> FPGAclk,
		Motor_ctrl_sel				=> '0', --1-2相励磁
		Deceleration_step			=> sig_OCTF_Dec_step,
		Total_step					=> sig_OCTF_Total_step,
		Init_speed					=> sig_OCTF_Init_speed,
		Max_speed					=> sig_OCTF_Max_speed,
		Step_increase				=> sig_OCTF_Increase,
		STEP_CW						=> sig_OCTF_CW,
		Start						=> sig_OCTF_Motor_start,
		Motro_on					=> sig_OCTF_ON_OFF,
		Motor_AP					=> sig_OCTF_AP,
		Motor_BP					=> sig_OCTF_BP,
		Motor_AN					=> sig_OCTF_AN,
		Motor_BN					=> sig_OCTF_BN,
		IRQ_OUT						=> sig_OCTF_irq_out
	);


	 OCTF_ON_OFF	<=  sig_OCTF_ON_OFF;
	 OCTF_AP        <=  sig_OCTF_AP;
	 OCTF_BP        <=  sig_OCTF_BP;
	 OCTF_AN        <=  sig_OCTF_AN;
     OCTF_BN        <=  sig_OCTF_BN;


	--Delaylineモータコントローラ(1-2相励磁)
	U_delayline_stp : stepmotor_ctrl PORT MAP (
		Reset						=> nFPGARST,
		FPGAclk						=> FPGAclk,
		Motor_ctrl_sel				=> '0', --1-2相励磁
		Deceleration_step			=> sig_Dline_Dec_step,
		Total_step					=> sig_Delayline_Total_step,
		Init_speed					=> sig_DelayLine_Init_speed,
		Max_speed					=> sig_Delayline_Max_speed,
		Step_increase				=> sig_Delayline_Increase,
		STEP_CW						=> sig_Delayline_CW,
		Start						=> sig_Dline_Mot_start,
		Motro_on					=> sig_D_LINE_ON_OFF,
		Motor_AP					=> sig_D_LINE_AP,
		Motor_BP					=> sig_D_LINE_BP,
		Motor_AN					=> sig_D_LINE_AN,
		Motor_BN					=> sig_D_LINE_BN,
		IRQ_OUT						=> sig_Delayline_irq_out
	);


	D_LINE_ON_OFF	<= sig_D_LINE_ON_OFF;
	D_LINE_AP       <= sig_D_LINE_AP;
    D_LINE_BP       <= sig_D_LINE_BP;
    D_LINE_AN       <= sig_D_LINE_AN;
    D_LINE_BN       <= sig_D_LINE_BN;


	--POLAモータコントローラ(1-2相励磁)
	U_POLA_stp : stepmotor_ctrl PORT MAP (
		Reset						=> nFPGARST,
		FPGAclk						=> FPGAclk,
		Motor_ctrl_sel				=> '0', --1-2相励磁
		Deceleration_step			=> sig_POLA_Dec_step,
		Total_step					=> sig_POLA_Total_step,
		Init_speed					=> sig_POLA_Init_speed,
		Max_speed					=> sig_POLA_Max_speed,
		Step_increase				=> sig_POLA_Increase,
		STEP_CW						=> sig_POLA_CW,
		Start						=> sig_POLA_Motor_start,
		Motro_on					=> sig_POLA_ON_OFF,
		Motor_AP					=> sig_POLA_AP,
		Motor_BP					=> sig_POLA_BP,
		Motor_AN					=> sig_POLA_AN,
		Motor_BN					=> sig_POLA_BN,
		IRQ_OUT						=> sig_POLA_irq_out
		
	);

	POLA_ON_OFF <= sig_POLA_ON_OFF;
    POLA_AP     <= sig_POLA_AP    ;
    POLA_BP     <= sig_POLA_BP    ;
    POLA_AN     <= sig_POLA_AN    ;
    POLA_BN     <= sig_POLA_BN    ;



	--光路切替モータコントローラ(2相励磁)
	U_P_SW_stp : stepmotor_ctrl PORT MAP (
		Reset						=> nFPGARST,
		FPGAclk						=> FPGAclk,
		Motor_ctrl_sel				=> '1', --2-2相励磁
		Deceleration_step			=> "000000000000000",
		Total_step					=> sig_P_SW_total_step,
		Init_speed					=> sig_P_SW_Init_speed,
		Max_speed					=> sig_P_SW_Init_speed,
		Step_increase				=> "00000000000000",
		STEP_CW						=> sig_P_SW_CW,
		Start						=> sig_P_SW_Motor_start,
		Motro_on					=> sig_P_SW_ON_OFF,
		Motor_AP					=> sig_P_SW_AP,
		Motor_BP					=> sig_P_SW_BP,
		Motor_AN					=> sig_P_SW_AN,
		Motor_BN					=> sig_P_SW_BN,
		IRQ_OUT						=> sig_P_SW_irq_out
	);

	P_SW_ON_OFF	<= sig_P_SW_ON_OFF;
	P_SW_AP     <= sig_P_SW_AP    ;
	P_SW_BP     <= sig_P_SW_BP    ;
	P_SW_AN     <= sig_P_SW_AN    ;
	P_SW_BN     <= sig_P_SW_BN    ;
	
	
	
	
	


	--IRQ1 ステッピングモータ制御終了割り込み, OCT合焦,POLA,Delaylin,光路切替で共用
	process( nFPGARST, FPGAclk	)begin
		if( nFPGARST = '0' )then
			sig_stp_mtr_ctl_end_ff <= '1';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( sig_OCTF_irq_out = '1' or sig_Delayline_irq_out = '1' or sig_POLA_irq_out = '1' or sig_P_SW_irq_out = '1' )then
				sig_stp_mtr_ctl_end_ff <= '0';
			else
				sig_stp_mtr_ctl_end_ff <= '1';
			end if;
		end if;
	end process;
	

	U_CustomScan : comp_CustomScan PORT MAP(
			FPGAclk						=> FPGAclk,								--IN STD_LOGIC;		--20MHz
			Reset						=>	MIX_EXT_FW_RST, --IN STD_LOGIC,
			nPON_RESET					=>	nFPGARST,
			Galv_run					=>	sig_Galv_run,					-- IN STD_LOGIC,
			CAP_START					=>	sig_CAP_START,					-- IN STD_LOGIC,
			nWE							=>	sig_cstm_nWE,					-- IN std_logic,
			DataBusIn					=>	sig_DBUS_HOLD,					-- IN std_logic_vector(15 downto 0),
			WR_ADDRES					=>	sig_WR_ADDRES,					-- IN std_logic_vector(18 downto 0),
			CSTM_FLAG_WE				=>	sig_CSTM_FLAG_WE,				-- IN std_logic,
			SCAN_NUM_WE					=>	sig_SCAN_NUM_WE,				-- IN std_logic,
			DUMMY_NUM_WE				=>	sig_DUMMY_NUM_WE,				-- IN std_logic,
			BACK_SCAN_NUM_WE			=>	sig_BACK_SCAN_NUM_WE,			-- IN std_logic,
			LIVE_NUM_WE					=>	sig_LIVE_NUM_WE,				-- IN std_logic,
			L_Start_X_WE				=>	sig_L_Start_X_WE, 				-- IN std_logic,
			L_Start_Y_WE				=>	sig_L_Start_Y_WE,				-- IN std_logic,
			L_End_X_WE					=>	sig_L_End_X_WE,					-- IN std_logic,
			L_End_Y_WE					=>	sig_L_End_Y_WE,					-- IN std_logic,
			L_Circle_R_WE				=>	sig_Circle_R_WE,				-- IN std_logic,
			L_DIR_LINE_CIR_WE			=>	sig_L_DIE_LINE_CIR_WE,			-- IN std_logic,
			DIR_LINE_CIR_WE				=>	sig_DIR_LINE_CIR_WE,			-- IN std_logic,
			Start_X_WE					=>	sig_Start_X_WE,					-- IN std_logic,
			Start_Y_WE					=>	sig_Start_Y_WE,					-- IN std_logic,
			End_X_WE					=>	sig_End_X_WE,					-- IN std_logic,
			End_Y_WE					=>	sig_End_Y_WE,					-- IN std_logic,
			Dummy_DIR_LINE_CIR_WE		=>	sig_Dummy_DIR_LINE_CIR_WE,		-- IN std_logic,
			Back_Scan_DIR_LINE_CIR_WE	=>	sig_Back_Scan_DIR_LINE_CIR_WE,	-- IN std_logic,
			Dummy_Back_Data_WE			=>	sig_Dummy_Back_Data_WE,			-- IN std_logic,
			Galv_TRIG_in				=>	sig_Galv_TRIG,					-- IN std_logic,
			GAL_CON_Busy_out			=>	sig_Galv_BUSY,					-- IN std_logic;
			GAL_CON_MOVE_END_out		=> 	sig_GAL_CON_MOVE_END_out,		-- IN std_logic,
			CSTM_LIVE_A_X_RESO			=>	sig_live_resol_cstm,
			CSTM_LIVE_B_X_RESO			=>	sig_CSTM_LIVE_B_RESOX			,
			CSTM_LIVE_B_CNT				=>	sig_CSTM_LIVE_B_CNT				,
			CSTM_LIVE_B_RESO			=>	sig_CSTM_LIVE_B_RESOY			,
			CSTM_LIVE_B_PITCH			=>	sig_CSTM_LIVE_B_PITCH			,
			CSTM_LIVE_B_ONOFF			=>	sig_CSTM_LIVE_B_ONOFF			,
			SCAN_SET_RUN_END_ALL		=>	sig_SCAN_SET_RUN_END_ALL		,
			ANGIO_SCAN					=>	sig_ANGIO_SCAN					,
--			CIBT_ALMOST_FULL			=>	CIBT_ALMOST_FULL				,
			CIBT_ALMOST_FULL			=>	GPIO1_IN 						,
			keisen_update				=>	sig_keisen_update				,
			keisen_update_num			=>	sig_keisen_update_num			,
			Repetition					=>  sig_Repetition					,
			CSTM_WR_ADR					=>	sig_cstm_wr_adr					,
			CSTM_WR_DATA				=>	sig_cstm_wr_data                ,
			CSTM_WR_EN					=>	sig_cstm_wr_enable              ,
			Resol						=>	sig_resolution					,
			Resol_CSTM					=>	sig_Resol_CSTM					,
			Dum_Resol_CSTM				=>	sig_Dum_Resol_CSTM				,
			Back_Resol_CSTM				=>	sig_Back_Resol_CSTM				,
			cstm_CSTM_FLAG				=>	sig_cstm_CSTM_FLAG,				-- OUT STD_LOGIC;
			cstm_Mode_Sel				=>	sig_cstm_Mode_Sel,				-- OUT STD_LOGIC_VECTOR(3 downto 0);
			cstm_Galv_run				=>	sig_cstm_Galcv_Run,				-- OUT STD_LOGIC;
--			cstm_CAP_START				=>	sig_cstm_CAP_Start,				-- OUT STD_LOGIC;
--			cstm_INT_CAP_START			=>	sig_cstm_INT_CAP_START,			-- OUT STD_LOGIC;
			cstm_Start_X				=>	sig_cstm_Start_X,				-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Start_Y				=>	sig_cstm_Start_Y,				-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_End_X					=>	sig_cstm_End_X,					-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_End_Y					=>	sig_cstm_End_Y,					-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Circle_R				=>	sig_cstm_Circle_R,				-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_Circle_DIR				=>	sig_cstm_Circle_DIR,			-- OUT STD_LOGIC;
--			cstm_Live_Start_X			=>	sig_cstm_Live_Start_X,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Start_Y			=>	sig_cstm_Live_Start_Y,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_X				=>	sig_cstm_Live_End_X,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_End_Y				=>	sig_cstm_Live_End_Y,			--OUT STD_LOGIC_VECTOR(11 downto 0);
--			cstm_Live_Circle_R			=>	sig_cstm_Live_Cirle_R,			-- OUT STD_LOGIC_VECTOR(11 downto 0);
			cstm_TRIG_EN				=>	sig_cstm_trig_en,				-- OUT STD_LOGIC,
			cstm_LiveScanNow_Flag		=>	sig_cstm_LiveScanNow_Flag,		-- OUT STD_LOGIC;		--20090323YN
--			cstm_DummyScanNow_Flag		=>	sig_cstm_DummyScanNow_Flag,		-- OUT STD_LOGIC;		--20090323YN
			cstm_CapScanNow_Flag		=>	sig_cstm_CapScanNow_Flag,		-- OUT STD_LOGIC;		--20090323YN
			cstm_BackScanNow_Flag		=>	sig_cstm_BackScanNow_Flag,		-- OUT STD_LOGIC;		--20090323YN
			cstm_cnt_Live				=>	sig_cstm_cnt_Live,				-- OUT STD_LOGIC_VECTOR(3 downto 0);	--20090323YN
			cstm_param_en				=>	sig_cstm_param_en,				-- OUT STD_LOGIC
--			CSTM_LIVE_RESO				=>	sig_cstm_live_reso,
			LIVE_B_ENABLE 				=>	sig_live_b_enable,
			LIVE_B_RETRY1				=>	sig_live_b_retry1,
			LIVE_B_RETRY2				=>	sig_live_b_retry2,
			keisenNO					=> 	sig_keisenNO,
			CAPT_OFFSET_EN				=>  sig_CAPT_OFFSET_EN,
			Scan_Run_Flag				=> 	sig_Scan_Run_Flag,
			Resol_OUT					=>	sig_resolution_out
		);

	U_GAL_CON : GAL_CON  PORT MAP(
			FPGAclk					=>	FPGAclk, 					-- IN STD_LOGIC;		--20MHz
			Reset					=>	MIX_EXT_FW_RST, 			--IN STD_LOGIC;
--			Mode_sel				=>	sig_gal_Mode_sel,			-- IN STD_LOGIC_VECTOR(3 downto 0);
			Mode_sel				=>	sig_cstm_Mode_Sel,			-- IN STD_LOGIC_VECTOR(3 downto 0);
			Freq_Sel				=>	sig_Freq_sel,				-- IN STD_LOGIC_VECTOR(7 downto 0);
--			Start_X					=>	sig_gal_Start_X,			-- IN STD_LOGIC_VECTOR(11 downto 0);
			Start_X					=>	sig_cstm_Start_X,			-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Start_Y					=>	sig_gal_Start_Y,			--  IN STD_LOGIC_VECTOR(11 downto 0);
			Start_Y					=>	sig_cstm_Start_Y,			--  IN STD_LOGIC_VECTOR(11 downto 0);
--			End_X					=>	sig_gal_End_X,				-- IN STD_LOGIC_VECTOR(11 downto 0);
			End_X					=>	sig_cstm_End_X,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			End_Y					=>	sig_gal_End_Y,				-- IN STD_LOGIC_VECTOR(11 downto 0);
			End_Y					=>	sig_cstm_End_Y,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Circle_R				=>	sig_gal_Circle_R,			-- IN STD_LOGIC_VECTOR(11 downto 0);
			Circle_R				=>	sig_cstm_Circle_R,			-- IN STD_LOGIC_VECTOR(11 downto 0);

--			Live_Start_X			=>	sig_gal_L_Start_X,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_Start_Y			=>	sig_gal_L_Start_Y,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_End_X				=>	sig_gal_L_End_X,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_End_Y				=>	sig_gal_L_End_Y,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			Live_Circle_R			=>	sig_gal_L_Circle_R,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070621TS
--			L_R						=>	not sig_L_R,				-- IN STD_LOGIC;
--			Galv_run				=>	sig_gal_Galv_run,			-- IN STD_LOGIC;
			Galv_run				=>	sig_cstm_Galcv_Run,			-- IN STD_LOGIC;

--			CAP_START				=>	sig_gal_CAP_START,			-- IN STD_LOGIC;
--			Live_Resol				=>	sig_Live_Resol,				-- IN STD_LOGIC_VECTOR(11 downto 0);
--			Resolution				=>	sig_gal_Resol_OUT, 			-- IN STD_LOGIC_VECTOR(11 downto 0);
			Resolution				=>	sig_resolution_out, 		-- IN STD_LOGIC_VECTOR(11 downto 0);

--			Dummy_Fram_Num			=>	sig_Dummy_Num,				-- IN STD_LOGIC_VECTOR(2 downto 0);
--			Resol_Y					=>	sig_Resol_Y,				--IN STD_LOGIC_VECTOR(11 downto 0);
--			V_H_3D					=>	sig_V_H_3D,					-- IN STD_LOGIC_VECTOR(1 downto 0);
--			C_Scan_Back_Num 		=>	sig_C_Scan_Back_Num,		-- IN STD_LOGIC_VECTOR(3 downto 0);		--20081017TS
--			Radial_Scan_Num 		=>	sig_Radial_Num,				-- IN STD_LOGIC_VECTOR(3 downto 0);		--20070330TS
--			Circle_Total_Num		=>	sig_Circle_Total_Num,		-- IN STD_LOGIC_VECTOR(5 downto 0);		--20080508YN
--			START_3D				=>	sig_START_3D,				-- IN STD_LOGIC;
--			Web_Radial_R			=>	sig_Web_Radial_R,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--			Web_Circle_R_Step		=>	sig_Circle_Step,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070329TS
--			Web_Live_Sel			=>	sig_Web_Live_Sel,			-- IN STD_LOGIC;		--0:Circle_Live 1:Line_Live		--20070329TS
--			Raster_Scan_Num			=>	sig_Raster_Scan_Num,		-- IN STD_LOGIC_VECTOR(8 downto 0);		--20070404TS
--			Raster_Scan_Step		=>	sig_Raster_Scan_Step,		-- IN STD_LOGIC_VECTOR(11 downto 0);		--20070404TS
--			Circle_Direction		=>	sig_gal_Circle_Direction,	-- IN STD_LOGIC;		--20070329TS
			Circle_Direction		=>	sig_cstm_Circle_DIR,		-- IN STD_LOGIC;

--			SLD_ON_OFF				=>	sig_SLD_ON_OFF,				-- IN STD_LOGIC;		--1:ON 0:OFF		--20070329TS
--			PULSE_ON_OFF			=>	sig_Pulse_ON_OFF,			-- IN STD_LOGIC;		--1:PULSE 0:C/W		--20070329TS
--			PULSE_Width				=>	sig_Pulse_Width,			-- IN STD_LOGIC_VECTOR(7 downto 0);		--20070830YN
--			SLD_Delay				=>	sig_SLD_Delay,				-- IN STD_LOGIC_VECTOR(7 downto 0);
			Adjust_Mode				=>	sig_Adjust_Mode,			-- IN STD_LOGIC;		--1:Adjust_Mode 0:Normal_Mode		--20090421YN
--			PULSE_Mode				=>	sig_Pulse_Mode,				-- IN STD_LOGIC;		--1:MEASURE 0:NORMAL		--20070902YN
--			SLD_M_Pos				=>	sig_SLD_M_Pos,				-- IN STD_LOGIC_VECTOR(3 downto 0);		--20090206YN
			GalvX_Adjust			=>	sig_GalvX_Adjust,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
			GalvY_Adjust			=>	sig_GalvY_Adjust,			-- IN STD_LOGIC_VECTOR(11 downto 0);		--20090421YN
--			Custom_Scan_On			=>	sig_cstm_CSTM_FLAG,			-- IN STD_LOGIC;		--1=Custom Scan 0=Normal		--20081023TS
--			GalvX_Gain_Data			=>	sig_GalvX_Gain_Data,		-- IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--			GalvY_Gain_Data			=>	sig_GalvY_Gain_Data,		-- IN STD_LOGIC_VECTOR(7 downto 0);		--20090323YN
--			GalvX_Gain_Data_B		=>	sig_GalvX_Gain_Data_B,		-- IN STD_LOGIC_VECTOR(7 downto 0);	
--			GalvY_Gain_Data_B		=>	sig_GalvY_Gain_Data_B,		-- IN STD_LOGIC_VECTOR(7 downto 0);
--			cstm_LiveScanNOW_Flag	=>	sig_cstm_LiveScanNow_Flag,	-- IN STD_LOGIC;		--20090326YN_1
--			cstm_cnt_Live			=>	sig_cstm_cnt_Live,			-- IN STD_LOGIC_VECTOR(3 downto 0);		--20090326YN_1
--			RetryFlag1_ON_OFF		=>	sig_RetryFlag1_ON_OFF,		-- IN STD_LOGIC;		--20090326YN_1
--			RetryFlag2_ON_OFF		=>	sig_RetryFlag2_ON_OFF,		-- IN STD_LOGIC;		--20090326YN_1
--			LiveBRetry1				=>	sig_live_b_retry1,
--			LiveBRetry2				=>	sig_live_b_retry2,
			cstm_param_en			=>	sig_cstm_param_en,			-- IN STD_LOGIC;		--20091006MN		--20091119YN
--			CSTM_LIVE_B_F_CNT		=>	sig_CSTM_LIVE_B_F_CNT,
--			CSTM_LIVE_B_ENABLE		=>	sig_live_b_enable,
--			CSTM_LIVE_B_ONOFF		=>	sig_CSTM_LIVE_B_ONOFF			,
			V_END_WAIT_CNT			=>	sig_v_end_wait_cnt,
			RAM_CONST_DATA			=>	sig_ram_const_data				,
			RAM_CONST_ADR			=>	sig_ram_const_adr				,
			RAM_CONST_DATA_EN		=>	sig_ram_const_data_en			,
			BOTH_WAY_SCAN			=>	sig_BOTH_WAY_SCAN_CapScan,
			BOTH_WAY_WAIT_TIME		=>	sig_BOTH_WAY_WAIT_TIME,
			OVER_SCAN				=>	sig_OVER_SCAN_CapScan,
			OVER_SCAN_NUM			=>	sig_OVER_SCAN_NUM,
--			OVER_SCAN_DLY_TIME		=>	sig_OVER_SCAN_DLY_TIME,
			GALV_TIMING_ADJ_EN		=>	sig_GALV_TIMING_ADJ_EN_CapScan,
			GALV_TIMING_ADJ_T3		=>	sig_GALV_TIMING_ADJ_T3,
			GALV_TIMING_ADJ_T4		=>	sig_GALV_TIMING_ADJ_T4,
			GALV_TIMING_ADJ_T5		=>	sig_GALV_TIMING_ADJ_T5,
			HSYNC_END				=>	sig_hsync_end,
			SLD						=>	sld_pulse_out,
--			VH_sync_period			=>	sig_VH_sync_period(12 downto 0),
			HSYNC_T					=>	sig_Hsync_T,
			HSYNC					=>	sig_hsync,			
			X_galv					=>	sig_X_galv,					-- OUT STD_LOGIC_VECTOR(11 downto 0);
			Y_galv					=>	sig_Y_galv,					-- OUT STD_LOGIC_VECTOR(11 downto 0);
--			Hsync_out				=>	sig_hsync,				-- CIBT3 Hsync OUT STD_LOGIC;
--			Vsync_out				=>	sig_vsync,				-- CIBT3 Vsync OUT STD_LOGIC;
--			TRIG					=>	sig_Galv_TRIG,				-- OUT STD_LOGIC;
--			Busy_out				=>	sig_Galv_BUSY,				-- OUT STD_LOGIC;
--			V_End_Flag_OUT		 	=>	sig_V_END_FLAG,				--OUT STD_LOGIC;		-- 1:end		--20070329TS
--			SLD_out					=>	sld_pulse_out,				-- SLD Pulse OUT STD_LOGIC;		--20070329TS
--			BackScan_Busy_out		=>	sig_BackScan_Flag,			-- OUT STD_LOGIC;		--20081017TS
			CSTM_MOVE_END_out		=> 	sig_GAL_CON_MOVE_END_out,	-- OUT STD_LOGIC;		--20081031TS
--			RetryFlag1_OUT			=>	RETRY_FLAG1,				-- OUT STD_LOGIC;		--20090326YN_1
--			RetryFlag2_OUT			=>	RETRY_FLAG2,				-- OUT STD_LOGIC;		--20090326YN_1
--			SLD_Gen_EN				=>	sig_SLD_ACTIVE_PERIOD,			-- OUT STD_LOGIC			--20090903MN
--			Inter_Reset				=>	sig_Inter_Reset,
			VH_GEN_EN_OUT			=>	sig_vh_gen_en,
			HSYNC_NUM_OUT			=>	sig_Hsync_num
		);

	

	sig_VH_sync_period_ext <= "000" & sig_VH_sync_period;

	U_comp_sync_gen : comp_sync_gen port map(
		Reset 				=> MIX_EXT_FW_RST,
		FPGAclk 		    => FPGAclk,
		VH_GEN_EN		    => sig_vh_gen_en,
		OVER_SCAN			=> sig_OVER_SCAN,
		OVER_SCAN_DLY_TIME	=> sig_OVER_SCAN_DLY_TIME,
		VH_SYNC_PERIOD	    => sig_VH_sync_period_ext,
		HSYNC_NUM			=> sig_Hsync_num(12 downto 0),
		HSYNC_T			    => sig_Hsync_T(11 downto 0),
		V_END_WAIT_CNT		=> sig_v_end_wait_cnt,
		OUT_VSYNC		    => sig_Vsync,
		OUT_HSYNC		    => sig_Hsync,
		OUT_VH_SYNC		    => VH_SYNC_OUT,
		OUT_HSYNC_END		=> sig_hsync_end,
		OUT_V_END_FLG       => sig_V_END_FLAG
	);

	U_comp_SLD_gen : comp_SLD_gen port map(
		Reset			=> MIX_EXT_FW_RST,
		FPGAclk			=> FPGAclk,
		SLD_ON_OFF		=> sig_SLD_ON_OFF,
		PULSE_ON_OFF	=> sig_Pulse_ON_OFF,
		SLD_Delay		=> sig_SLD_Delay,
		PULSE_Width		=> sig_Pulse_Width,
		HSYNC_IN		=> sig_Hsync,
		OUT_SLD_PULSE	=> sld_pulse_out
		);


	U_GALV_DAC_PSC : GALV_DAC_PSC port map(
			FPGAclk		=>	FPGAclk,				--	in	std_logic;
			Reset		=>	MIX_EXT_FW_RST,		--	in	std_logic;
			GALV_X		=>	sig_X_galv,				--	in	std_logic_vector( 11 downto 0 );
			GALV_Y		=>	sig_Y_galv,				--	in	std_logic_vector( 11 downto 0 );
			nSYNC_X		=>	nGalvX_SYNC,			--	out	std_logic,
			nSYNC_Y		=>	nGalvY_SYNC,			--	out	std_logic,
			SCLK		=>	Galv_SCLK,				--	out	std_logic,
			nCLR		=>	open,
			SDIN		=>	Galv_SDIN				--	out	std_logic
		);

	U_comp_TRIG_SEL : comp_TRIG_SEL PORT MAP (
			FPGAclk 	=> 	FPGAclk,				-- IN STD_LOGIC;						--20MHz
			Reset 		=>	MIX_EXT_FW_RST, 		--IN STD_LOGIC;
			TRIG_IN		=>	sig_Galv_TRIG,			-- IN STD_LOGIC;	--from galv_con
			TRIG_EN		=> 	sig_cstm_trig_en,		-- IN STD_LOGIC;
			Custom_Flag =>	sig_cstm_CSTM_FLAG,		-- IN STD_LOGIC;
			TRIG_OUT 	=>	LineCCD_Trig			-- OUT STD_LOGIC
		);

	U_GAL_GAIN : GAL_GAIN PORT MAP(
			FPGAclk 			=>	FPGAclk,				-- 	IN 	STD_LOGIC;						--20MHz
			Reset 				=>	MIX_EXT_FW_RST,		-- 	IN 	STD_LOGIC;
			GalvX_Gain_Data		=>	sig_GalvX_Gain_Data,	--	IN	STD_LOGIC_VECTOR(7 downto 0);
			GalvY_Gain_Data		=>	sig_GalvY_Gain_Data,	--	IN	STD_LOGIC_VECTOR(7 downto 0);
			GalvX_Gain_Data_B	=>	sig_GalvX_Gain_Data_B,
			GalvY_Gain_Data_B	=>	sig_GalvY_Gain_Data_B,
			VSync_End			=>	sig_V_END_FLAG,			--	IN	STD_LOGIC;
--			Galv_Run			=>	sig_gal_Galv_run,		--		IN	STD_LOGIC;
			Galv_Run			=>	sig_cstm_Galcv_Run,		--		IN	STD_LOGIC;

			SEL					=>	sig_live_b_enable,
			Galv_Gain_SDI 		=>	Galv_GAIN_SDI,			--	OUT	STD_LOGIC;
			Galv_Gain_CLK		=>	Galv_GAIN_CLK,			--	OUT	STD_LOGIC;
			nGalvX_Gain_CS		=>	nGalvX_GAIN_CS,			--	OUT	STD_LOGIC;
			nGalvY_Gain_CS		=>	open			--	OUT	STD_LOGIC
		);

	U_GAL_OFFSET : GAL_OFFSET PORT MAP(
			FPGAclk 			=>	FPGAclk,				-- 	IN 	STD_LOGIC;						--20MHz
			Reset 				=>	MIX_EXT_FW_RST,		-- 	IN 	STD_LOGIC;
			GalvX_Offset_Data	=>	sig_GalvX_Offset_Data,	--	IN	STD_LOGIC_VECTOR(9 downto 0);
			GalvY_Offset_Data	=>	sig_GalvY_Offset_Data,	--	IN	STD_LOGIC_VECTOR(9 downto 0);
			GalvX_Offset_Data_B	=>	sig_CSTM_LIVE_B_OFFSETX,
			GalvY_Offset_Data_B	=>	sig_CSTM_LIVE_B_OFFSETY,
--			VSync_End			=>	sig_V_END_FLAG,			--	IN	STD_LOGIC;
			VSync_End			=>	sig_CAPT_OFFSET_EN,			--	IN	STD_LOGIC;
--			Galv_Run			=>	sig_gal_Galv_run,		--		IN	STD_LOGIC;
			Galv_Run			=>	sig_cstm_Galcv_Run,		--		IN	STD_LOGIC;

			SEL					=>	sig_live_b_enable,
			Galv_Offset_SDI 	=>	Galv_OS_DIN,			--	OUT	STD_LOGIC;
			Galv_Offset_CLK		=>	Galv_OS_SCLK,			--	OUT	STD_LOGIC;
			nGalvX_Offset_CS	=>	nGalvX_OS_CS,			--	OUT	STD_LOGIC;
			nGalvY_Offset_CS	=>	nGalvY_OS_CS				--	OUT	STD_LOGIC
		);
	U_SLD_SMPL_TRG : SLD_SMPL_TRG PORT MAP(
			FPGAclk 		=>	FPGAclk				,		-- : 	IN 	STD_LOGIC;						--20MHz
			Reset 			=>	MIX_EXT_FW_RST	,		-- : 	IN 	STD_LOGIC;
			Vsync			=>	sig_vsync			,		-- :	IN	STD_LOGIC;
			Pulse_out		=>	sig_SLD_SMPL_TRG			-- :	OUT	STD_LOGIC
		);

	U_H_W_Rev : H_W_Rev port map(
			H_W_Rev_1	=>	sig_HW_Rev1,	--out	std_logic_vector(3 downto 0);
			H_W_Rev_2	=>	sig_HW_Rev2,	--out	std_logic_vector(3 downto 0);
			H_W_Rev_3	=>	sig_HW_Rev3,	--out	std_logic_vector(3 downto 0);
			H_W_Rev_4	=>	sig_HW_Rev4		--out	std_logic_vector(3 downto 0)
		);
	U_FPGA_CNT_GEN : FPGA_CNT_GEN port map(
			CLK				=>	FPGAclk,		-- in std_logic;							-- 20MHz
			n_RESET			=>	nFPGARST, 		--in std_logic;							-- Low Active
			FPGA_CNT		=>	sig_FPGA_CNT	-- out std_logic_vector(15 downto 0)		--16bit
		);

	U_FOCUS_PWM_GEN : PWM_GEN port map(
			FPGAclk		=>	FPGAclk				,
			nReset		=>	nFPGARST			,
			PWM			=>	sig_FOCUS_PWM		,
			ONOFF		=>	sig_FOCUS_ONOFF		,
			DIR			=>	sig_FOCUS_DIR		,
			Pulse_A		=>	OCTFOCUS_IN1		,
			Pulse_B		=>	OCTFOCUS_IN2		
		);

	U_REF_PWM_GEN : PWM_GEN_REF port map(
			FPGAclk		=>	FPGAclk				,
			nReset		=>	nFPGARST			,
			PWM			=>	sig_REF_PWM			,
			PULSE		=>	sig_REF_Pulse		,
			ONOFF		=>	sig_REF_ONOFF		,
			DIR			=>	sig_REF_DIR			,
			Pulse_A		=>	REF_IN1				,
			Pulse_B		=>	REF_IN2		
		);

	U_POLA_PWM_GEN : PWM_GEN port map(
			FPGAclk		=>	FPGAclk				,
			nReset		=>	nFPGARST			,
			PWM			=>	sig_POLA_PWM		,
			ONOFF		=>	sig_POLA_ONOFF		,
			DIR			=>	sig_POLA_DIR		,
			Pulse_A		=>	POLA_IN1			,
			Pulse_B		=>	POLA_IN2		
		);
--	U_SPI_COM : SPI_COM port map(
--			FPGAclk		=>	FPGAclk		,
--			nReset		=>	not sig_GAL_CNT_RESET or nFPGARST		,
--			ROM_ADR		=>	sig_SPI_ADR		,
--			ROM_DATA	=>	sig_SPI_DATA	,
--			ROM_ERASE	=>	sig_SPI_ERASE	,
--			ROM_WRITE	=>	sig_SPI_WRITE	,
--			ROM_READ 	=>	sig_SPI_READ 	,
--			SPI_MOSI	=>	SPI_MOSI	,
--			BUSY   		=>	sig_SPI_BUSY   		,
--			READ_DATA	=>	sig_SPI_READ_DATA	,
--			SPI_CSOB	=>	SPI_CSOB	,
--			SPI_DIN		=>	SPI_DIN		,
--			SPI_CCLK	=>	SPI_CCLK	
--		);

	U_SEND_KEISEN : SEND_KEISEN port map
		(
			FPGAclk			=>	FPGAclk		,
			Reset			=>	MIX_EXT_FW_RST,
			SEND_DATA_EN	=>	sig_cstm_param_en,
			SEND_DATA		=>	B"0000" & sig_keisenNO,
	
			RECIEVE_DATA_EN	=>	open,
			RECIEVE_DATA	=>	open,
			
			RXD				=>	'0',
			TXD				=>	sig_KEISEN_TXD
		
		);
	U_FLASH_LOADER : FLASH_LOADER port map
  		(
    		FpgaClk 			=> FPGAclk		,
--			RST					=> MIX_EXT_FW_RST,
    		RST					=> pFPGARST						,
    		RegFileWrAddress    => sig_RegFileWrAddress         ,
    		RegFileWrData       => sig_RegFileWrData            ,
    		RegFileWrEn         => sig_RegFileWrEn              ,
    		RegFileRdAddress    => sig_RegFileRdAddress         ,
    		RegFileRdData       => sig_RegFileRdData             
  		);

end RTL;
