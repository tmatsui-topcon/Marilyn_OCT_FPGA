library ieee;
library lpm;
library altera_mf;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
entity comp_SLD_gen is
	port
	(
		Reset 			: in std_logic;
		FPGAclk 		: in std_logic;							--20MHz
		SLD_ON_OFF		: in std_logic;
		PULSE_ON_OFF	: in std_logic;
		SLD_Delay		: in std_logic_vector(9 downto 0);		--SLD遅延
		PULSE_Width 	: in std_logic_vector(9 downto 0);
		HSYNC_IN		: in std_logic;
		OUT_SLD_PULSE	: out std_logic
	);
end comp_SLD_gen;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture rtl of comp_SLD_gen is
--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	
	signal hsync_d				: std_logic;
	signal hsync_rise_edge		: std_logic;
	signal sld_delay_ext		: std_logic_vector(11 downto 0);
	signal SLD_rise_t			: std_logic_vector(11 downto 0);
	signal SLD_fall_t			: std_logic_vector(11 downto 0);
	
	signal sld_cnt				: std_logic_vector(11 downto 0);
	signal sld_out_pre			: std_logic;
--**************************************************************************************--
begin

	sld_delay_ext <= "00" & SLD_Delay;

	--レジスタ値からSLD立ち上がり、立ち下がり位置を計算する
	U_Pulse_Width :
	process(Reset,FPGAclk) begin
		if(Reset='1') then
			hsync_d    <= '0';
			SLD_rise_t <= B"0000_0000_0000";
			SLD_fall_t <= B"0000_0000_0000";
		elsif (FPGAclk'event and FPGAclk = '1') then
			hsync_d    <= HSYNC_IN;
			SLD_rise_t <= sld_delay_ext + B"0000_0001_0001"; 
			SLD_fall_t <= sld_delay_ext + B"0000_0001_0001" + (PULSE_Width*"10");
		end if;
	end process;

	hsync_rise_edge <= (HSYNC_IN and not hsync_d);
	
	--カウンタ
	process(Reset,FPGAclk) begin
		if (Reset='1') then
			sld_cnt <= (others=>'0');
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( hsync_rise_edge = '1' )then
				sld_cnt <= (others=>'0');
			elsif (sld_cnt = SLD_fall_t) then  --Overflow抑止
				sld_cnt <= sld_cnt;
			else
				sld_cnt <= sld_cnt + 1;
			end if;
		end if;
	end process;

	--SLDパルス(負極性)生成
	process(Reset,FPGAclk) begin
		if(Reset='1') then
			sld_out_pre <= '1';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( SLD_ON_OFF = '0') then        -- SLD消灯
				sld_out_pre <= '1';
			elsif( PULSE_ON_OFF = '0') then   -- SLD常時点灯
				sld_out_pre <= '0';
			else	                          -- SLDパルス出力
				if( hsync_rise_edge = '1' )then
					sld_out_pre <= '1';
				elsif(sld_cnt = SLD_fall_t) then --PULSE_Width=0のときパルスを出力しないため、riseよりfallを優先
					sld_out_pre <= '1';
				elsif(sld_cnt = SLD_rise_t) then
					sld_out_pre <= '0';
				end if;
			end if;
		end if;
	end process;

	OUT_SLD_PULSE <= sld_out_pre;




------------------------------------------------------------------------------------------
end rtl;
