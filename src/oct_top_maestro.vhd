LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity OCT_TOP_MAESTRO IS
	port(
	D			 	: inout std_logic_vector( 15 downto 0 ) ;	-- マイコンとの接続 Data
	A 		 		: in 	std_logic_vector( 10 downto 0 ) ;	-- マイコンとの接続 Address
	nCS1n 			: in	std_logic ;							-- Chip Select (MPU->FPGA)
	nWRn3 			: in	std_logic ;
	nRD_n2 			: in	std_logic ;
	CIBT3_Hsync	 	: out	std_logic ;
	CIBT3_Vsync	 	: out	std_logic ;
	LineCCD_Trig 	: out	std_logic ;
	RETRY_FLAG1 	: out	std_logic ;
	RETRY_FLAG2 	: out	std_logic ;
	RDnWR 			: out	std_logic ;							-- SDRAM
	GPIO0_IN 		: in	std_logic ;
	SLD_PULSE		: out	std_logic ;							--SLD Pulse
	FPGA_RESET 		: in	std_logic ;							--FPGA RESET
	GPIO1_IN 		: in	std_logic ;
	GPIO2_IN 		: in	std_logic ;
	GPIO3_IN 		: in	std_logic ;
	nIRQ1_FPGA 		: out	std_logic ;
	nIRQ2_FPGA 		: out	std_logic ;
	nIRQ3_FPGA 		: out	std_logic ;
	nIRQ4_FPGA 		: out	std_logic ;
	nIRQ5_FPGA 		: out	std_logic ;
	nIRQ6_FPGA 		: out	std_logic ;
	nIRQ7_FPGA 		: out	std_logic ;
	nIRQ8_FPGA 		: out	std_logic ;
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
	nGalvX_GAIN_CS 	: out	std_logic ;
	FPGA_CLOCK 		: in	std_logic ;
	REF_POLA_RESET	:	out	std_logic; --DRV8841_RESET?
	MOT_ENABLE		:	out	std_logic;
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
	CP9					: out std_logic		
	);
end entity OCT_TOP_MAESTRO;

ARCHITECTURE RTL OF OCT_TOP_MAESTRO IS

	
	COMPONENT OCT_TOP is
		port
		(
		D			 		: inout std_logic_vector( 15 downto 0 ) ;	-- マイコンとの接続 Data
		A 		 			: in 	std_logic_vector( 10 downto 0 ) ;	-- マイコンとの接続 Address
		nCS1n 				: in	std_logic ;							-- Chip Select (MPU->FPGA)
		nWRn3 				: in	std_logic ;
		nRD_n2 				: in	std_logic ;
		CIBT3_Hsync	 		: out	std_logic ;
		CIBT3_Vsync	 		: out	std_logic ;
		LineCCD_Trig 		: out	std_logic ;
		RETRY_FLAG1 		: out	std_logic ;
		RETRY_FLAG2 		: out	std_logic ;
		RDnWR 				: out	std_logic ;							-- SDRAM
		GPIO0_IN 			: in	std_logic ;
		SLD_PULSE			: out	std_logic ;							--SLD Pulse
		FPGA_RESET 			: in	std_logic ;							--FPGA RESET
		GPIO1_IN 			: in	std_logic ;
		GPIO2_IN 			: in	std_logic ;
		GPIO3_IN 			: in	std_logic ;
		nIRQ1_FPGA 			: out	std_logic ;
		nIRQ2_FPGA 			: out	std_logic ;
		nIRQ3_FPGA 			: out	std_logic ;
		nIRQ4_FPGA 			: out	std_logic ;
		nIRQ5_FPGA 			: out	std_logic ;
		nIRQ6_FPGA 			: out	std_logic ;
		nIRQ7_FPGA 			: out	std_logic ;
		nIRQ8_FPGA 			: out	std_logic ;
		nGalvX_OS_CS 		: out	std_logic ;
		nGalvY_OS_CS 		: out	std_logic ;
		Galv_OS_SCLK 		: out	std_logic ;
		Galv_OS_DIN 		: out	std_logic ;
		nGalvX_SYNC 		: out	std_logic ;
		nGalvY_SYNC 		: out	std_logic ;
		Galv_SDIN 			: out	std_logic ;
		Galv_SCLK 			: out	std_logic ;
		Galv_GAIN_SDI 		: out	std_logic ;
		Galv_GAIN_CLK 		: out	std_logic ;
		nGalvX_GAIN_CS 		: out	std_logic ;
		FPGA_CLOCK 			: in	std_logic ;
		REF_POLA_RESET		:	out	std_logic; --DRV8841_RESET?
		MOT_ENABLE			:	out	std_logic;
		MOT_PHA				:	out	std_logic;
		MOT_DIR				:	out	std_logic;
		MOT_PWMSW			:	out	std_logic;
		PER_N				:	out	std_logic;
		PER_P				:	out	std_logic;
		PER_REF_SCLK		:	out	std_logic;
		PER_REF_DIN			:	out	std_logic;
		nPER_RES_CS			:	out	std_logic;
		POLA_IN1			:	out	std_logic;
		POLA_IN2			:	out	std_logic;	
		REF_IN1				:	out	std_logic;
		REF_IN2				:	out	std_logic;	
		OCTFOCUS_IN1		:	out	std_logic;
		OCTFOCUS_IN2		:	out	std_logic;
		SLD_REF_SCLK 		: 	out std_logic;
		SLD_REF_DIN 		: 	out std_logic;
		nSLD_REF_CS 		: 	out std_logic;
		nSLD_LIMIT_CS 		: 	out std_logic;
		nFOCUS_FAULT		:	in std_logic;
		nREF_POLA_FAULT		:	in std_logic;
		nDRV8841_SLEEP		:	out std_logic;  --ref_pola_sleep?
		LineCCD_ONOFF		:	out std_logic;
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
		CP9					: out std_logic		
		);
	end component;



begin
	U_OCT_TOP : OCT_TOP PORT MAP(
		D			 		=> D			 		,
		A 		 			=> A 		 			,
		nCS1n 				=> nCS1n 				,
		nWRn3 				=> nWRn3 				,
		nRD_n2 				=> nRD_n2 				,
		CIBT3_Hsync	 		=> CIBT3_Hsync	 		,
		CIBT3_Vsync	 		=> CIBT3_Vsync	 		,
		LineCCD_Trig 		=> LineCCD_Trig 		,
		RETRY_FLAG1 		=> RETRY_FLAG1 		    ,
		RETRY_FLAG2 		=> RETRY_FLAG2 		    ,
		RDnWR 				=> RDnWR 				,
		GPIO0_IN 			=> GPIO0_IN 			,
		SLD_PULSE			=> SLD_PULSE			,
		FPGA_RESET 			=> FPGA_RESET 			,
		GPIO1_IN 			=> GPIO1_IN 			,
		GPIO2_IN 			=> GPIO2_IN 			,
		GPIO3_IN 			=> GPIO3_IN 			,
		nIRQ1_FPGA 			=> nIRQ1_FPGA 			,
		nIRQ2_FPGA 			=> nIRQ2_FPGA 			,
		nIRQ3_FPGA 			=> nIRQ3_FPGA 			,
		nIRQ4_FPGA 			=> nIRQ4_FPGA 			,
		nIRQ5_FPGA 			=> nIRQ5_FPGA 			,
		nIRQ6_FPGA 			=> nIRQ6_FPGA 			,
		nIRQ7_FPGA 			=> nIRQ7_FPGA 			,
		nIRQ8_FPGA 			=> nIRQ8_FPGA 			,
		nGalvX_OS_CS 		=> nGalvX_OS_CS 		,
		nGalvY_OS_CS 		=> nGalvY_OS_CS 		,
		Galv_OS_SCLK 		=> Galv_OS_SCLK 		,
		Galv_OS_DIN 		=> Galv_OS_DIN 		    ,
		nGalvX_SYNC 		=> nGalvX_SYNC 		    ,
		nGalvY_SYNC 		=> nGalvY_SYNC 		    ,
		Galv_SDIN 			=> Galv_SDIN 			,
		Galv_SCLK 			=> Galv_SCLK 			,
		Galv_GAIN_SDI 		=> Galv_GAIN_SDI 		,
		Galv_GAIN_CLK 		=> Galv_GAIN_CLK 		,
		nGalvX_GAIN_CS 		=> nGalvX_GAIN_CS 		,
		FPGA_CLOCK 			=> FPGA_CLOCK 			,
		REF_POLA_RESET		=> REF_POLA_RESET		,            
		MOT_ENABLE			=> MOT_ENABLE			,
		MOT_PHA				=> MOT_PHA				,
		MOT_DIR				=> MOT_DIR				,
		MOT_PWMSW			=> MOT_PWMSW			,
		PER_N				=> PER_N				,
		PER_P				=> PER_P				,
		PER_REF_SCLK		=> PER_REF_SCLK		    ,
		PER_REF_DIN			=> PER_REF_DIN			,
		nPER_RES_CS			=> nPER_RES_CS			,
		POLA_IN1			=> POLA_IN1		        ,
		POLA_IN2			=> POLA_IN2		        ,
		REF_IN1				=> REF_IN1			    ,
		REF_IN2				=> REF_IN2			    ,
		OCTFOCUS_IN1		=> OCTFOCUS_IN1	        ,    
		OCTFOCUS_IN2		=> OCTFOCUS_IN2	        ,    
		SLD_REF_SCLK 		=> SLD_REF_SCLK 		,
		SLD_REF_DIN 		=> SLD_REF_DIN 		    ,
		nSLD_REF_CS 		=> nSLD_REF_CS 		    ,
		nSLD_LIMIT_CS 		=> nSLD_LIMIT_CS 		,
		nFOCUS_FAULT		=> nFOCUS_FAULT         ,   
		nREF_POLA_FAULT		=> nREF_POLA_FAULT      ,      
		nDRV8841_SLEEP		=> nDRV8841_SLEEP       ,     
		LineCCD_ONOFF		=> LineCCD_ONOFF		,
		SLD_ACTIVE_PERIOD	=> SLD_ACTIVE_PERIOD	,
		DIP_SW				=> DIP_SW				,
		KEISEN_TXD			=> KEISEN_TXD			,
		PD_MONITOR			=> PD_MONITOR			,
		FOCUS_SLEEP			=> FOCUS_SLEEP	        ,
		ENC_A				=> '0'                  ,
		ENC_B				=> '0'                  ,
		LCMOS_MisTrigger	=> '0'                  ,
		VH_SYNC_OUT			=> open                 ,
		OCTF_ON_OFF			=> open                 ,
		OCTF_AP				=> open                 ,
		OCTF_BP				=> open                 ,
		OCTF_AN				=> open                 ,
		OCTF_BN				=> open                 ,
		POLA_ON_OFF			=> open                 ,
		POLA_AP				=> open                 ,
		POLA_BP				=> open                 ,
		POLA_AN				=> open                 ,
		POLA_BN				=> open                 ,
		D_LINE_ON_OFF		=> open                 ,
		D_LINE_AP			=> open                 ,
		D_LINE_BP			=> open                 ,
		D_LINE_AN			=> open                 ,
		D_LINE_BN			=> open                 ,
		P_SW_ON_OFF			=> open                 ,
		P_SW_AP				=> open                 ,
		P_SW_BP				=> open                 ,
		P_SW_AN				=> open                 ,
		P_SW_BN				=> open                 ,
		CP9					=> CP9
	);
	
end RTL; 



