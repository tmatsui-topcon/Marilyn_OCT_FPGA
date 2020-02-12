library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	ENTITY declaration part				****************************--
--**************************************************************************************--

entity encoder_cnt is
	port
	(
		Reset			: in std_logic;
		FPGAclk         : in std_logic;
		ENC_CNT_RST     : in std_logic;
		ENC_CNT_EN		: in std_logic;
		ENC_A			: in std_logic;
		ENC_B			: in std_logic;
		OUT_ENC_CNT_AB  : out std_logic_vector(31 downto 0);
		OUT_ENC_CNT_BA	: out std_logic_vector(31 downto 0)
	);
end encoder_cnt;

--**************************************************************************************--
--********************	ARCHITECTURE Body					****************************--
--**************************************************************************************--
architecture rtl of encoder_cnt is
--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal 		enc_cnt_ab		: std_logic_vector(31 downto 0);
	signal 		enc_cnt_ba		: std_logic_vector(31 downto 0);
	signal 		enc_a_edge		: std_logic_vector(11 downto 0);
	signal 		enc_b_edge		: std_logic_vector(11 downto 0);
	
	signal		enc_a_low		: std_logic;
	signal		enc_a_rise_edge	: std_logic;
	signal		enc_a_fall_edge	: std_logic;
	signal		enc_a_high		: std_logic;
	
	
	signal		enc_b_low		: std_logic;
	signal		enc_b_rise_edge	: std_logic;
	signal		enc_b_fall_edge	: std_logic;
	signal		enc_b_high		: std_logic;
	
	
--**************************************************************************************--
begin

	--ENC_Aのエッジ検出
	U_ENC_A_Edge :
	process( Reset,FPGAclk )begin
		if( Reset = '0' )then
			enc_a_edge <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			enc_a_edge <= enc_a_edge(10 downto 0) & ENC_A;
		end if;
	end process;

	enc_a_low 		<= '1' when((enc_a_edge(11 downto 7) = "00000") and (enc_a_edge(6 downto 1) = "000000"))else '0';  
	enc_a_rise_edge	<= '1' when((enc_a_edge(11 downto 7) = "00000") and (enc_a_edge(6 downto 1) = "111111"))else '0';
	enc_a_fall_edge	<= '1' when((enc_a_edge(11 downto 7) = "11111") and (enc_a_edge(6 downto 1) = "000000"))else '0';
	enc_a_high		<= '1' when((enc_a_edge(11 downto 7) = "11111") and (enc_a_edge(6 downto 1) = "111111"))else '0';


	--ENC_Bのエッジ検出
	U_ENC_B_Edge :
	process( Reset, FPGAclk )begin
		if( Reset = '0' )then
			enc_b_edge <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			enc_b_edge <= enc_b_edge(10 downto 0) & ENC_B;
		end if;
	end process;

	enc_b_low 		<= '1' when((enc_b_edge(11 downto 7) = "00000") and (enc_b_edge(6 downto 1) = "000000"))else '0';  
	enc_b_rise_edge	<= '1' when((enc_b_edge(11 downto 7) = "00000") and (enc_b_edge(6 downto 1) = "111111"))else '0';
	enc_b_fall_edge	<= '1' when((enc_b_edge(11 downto 7) = "11111") and (enc_b_edge(6 downto 1) = "000000"))else '0';
	enc_b_high		<= '1' when((enc_b_edge(11 downto 7) = "11111") and (enc_b_edge(6 downto 1) = "111111"))else '0';
	
	

	--ENCカウントAB
	process( Reset, FPGAclk )begin
		if( Reset = '0' )then
			enc_cnt_ab <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			if( ENC_CNT_RST = '1' )then			--フォトラプタがゼロ位置のときFWからカウンタクリア
				enc_cnt_ab <= ( others => '0');
			elsif( ENC_CNT_EN = '0' )then
				enc_cnt_ab <= enc_cnt_ab;
			--ENC_A:立ち上がり, ENC_B : L
			elsif( enc_a_rise_edge = '1' and enc_b_low = '1' )then
				enc_cnt_ab <= enc_cnt_ab + 1;
			--ENC_A:H, ENC_B:立ち上がり
			elsif( enc_a_high = '1' and enc_b_rise_edge = '1' )then
				enc_cnt_ab <= enc_cnt_ab + 1;
			--ENC_A:立下り, ENC_B:H
			elsif( enc_a_fall_edge = '1' and enc_b_high = '1' )then
				enc_cnt_ab <= enc_cnt_ab + 1;
			--ENC_A : L, ENC_B : 立下り
			elsif( enc_a_low = '1' and  enc_b_fall_edge = '1' )then
				enc_cnt_ab <= enc_cnt_ab + 1;
			end if;
		end if;
	end process;

	OUT_ENC_CNT_AB <= enc_cnt_ab;

	--ENCカウントBA
	process( Reset, FPGAclk )begin
		if( Reset = '0' )then
			enc_cnt_ba <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			if( ENC_CNT_RST = '1' )then			--フォトラプタがゼロ位置のときFWからカウンタクリア
				enc_cnt_ba <= ( others => '0');
			elsif( ENC_CNT_EN = '0' )then
				enc_cnt_ba <= enc_cnt_ba;
			--ENC_A:L, ENC_B:立ち上がり
			elsif( enc_a_low = '1' and enc_b_rise_edge = '1' )then
				enc_cnt_ba <= enc_cnt_ba + 1;
			--ENC_A:立ち上がり,ENC_B:H
			elsif( enc_a_rise_edge = '1' and enc_b_high ='1' )then
				enc_cnt_ba <= enc_cnt_ba + 1;
			--ENC_A:H, ENC_B:立下り
			elsif( enc_a_high = '1' and enc_b_fall_edge = '1' )then
				enc_cnt_ba <= enc_cnt_ba + 1;
			--ENC_A:立下り, ENC_B:L
			elsif( enc_a_fall_edge = '1' and enc_b_low = '1' )then
				enc_cnt_ba <= enc_cnt_ba + 1;
			end if;
		end if;
	end process;


	OUT_ENC_CNT_BA <= enc_cnt_ba;
	
end rtl;
