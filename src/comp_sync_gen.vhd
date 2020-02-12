library ieee;
library lpm;
library altera_mf;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
entity comp_sync_gen is
	port
	(
		RESET 				: in std_logic;
		FPGAclk 			: in std_logic;	
		VH_GEN_EN			: in std_logic;
		OVER_SCAN			: in std_logic;
		OVER_SCAN_DLY_TIME	: in std_logic_vector(15 downto 0); --オーバースキャン時のB-SCAN開始遅延時間、(設定値*0.05)us
		VH_SYNC_PERIOD		: in std_logic_vector(15 downto 0); --VH_GEN_EN↑からSYNC出力までの遅延時間、(設定値*0.05)us
		HSYNC_T				: in std_logic_vector(11 downto 0); --H-Sync周期、(設定値*0.05)us
		HSYNC_NUM			: in std_logic_vector(12 downto 0);
		V_END_WAIT_CNT		: in std_logic_vector(12 downto 0);
		OUT_VSYNC			: out std_logic;
		OUT_HSYNC			: out std_logic;
		OUT_VH_SYNC			: out std_logic;
		OUT_HSYNC_END		: out std_logic;
		OUT_V_END_FLG		: out std_logic
	);
end comp_sync_gen;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture rtl of comp_sync_gen is

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	
--	constant c_vh_v_rise_t	: std_logic_vector(12 downto 0)	:= '0' & X"000";  -- VHsync信号のV 立ち上がりタイミング
	constant c_vh_v_rise_t	: std_logic_vector(15 downto 0)	:= X"0000";  -- VHsync信号のV 立ち上がりタイミング

--	constant c_vh_v_width_t	: std_logic_vector(12 downto 0)	:= '0' & X"0C8";  -- VHsync信号のV High幅
	constant c_vh_v_width_t	: std_logic_vector(15 downto 0)	:= X"00C8";  -- VHsync信号のV High幅
	
	
--	constant c_vh_v_low_t	: std_logic_vector(12 downto 0)	:= '0' & X"064";  -- VHsync信号のV Low幅
	constant c_vh_v_low_t	: std_logic_vector(15 downto 0)	:= X"0064";  -- VHsync信号のV Low幅

	constant c_h_rise_t		: std_logic_vector(11 downto 0)	:= X"001";        -- Hsync 立ち上がりタイミング
	constant c_h_width_t	: std_logic_vector(11 downto 0)	:= X"064";        -- Hsync High幅
--	constant c_v_width_t	: std_logic_vector(12 downto 0)	:= '0' & X"3EA";  -- Vsync信号の High幅
	constant c_v_width_t	: std_logic_vector(15 downto 0)	:= X"03EA";  -- Vsync信号の High幅

	constant c_vh_v_fall_t	: std_logic_vector(15 downto 0)	:= c_vh_v_rise_t + c_vh_v_width_t; -- VHsync信号のV 立下りタイミング
--	constant c_vh_v_end		: std_logic_vector(12 downto 0)	:= c_vh_v_width_t + c_vh_v_low_t; -- VHsync信号のV High幅＋Low幅
	constant c_vh_v_end		: std_logic_vector(15 downto 0)	:= c_vh_v_width_t + c_vh_v_low_t; -- VHsync信号のV High幅＋Low幅

	constant c_h_fall_t		: std_logic_vector(11 downto 0)	:= c_h_rise_t + c_h_width_t;  -- Hsync 立下りタイミング
	constant c_v_fall_t		: std_logic_vector(15 downto 0)	:= c_vh_v_rise_t + c_v_width_t; -- Vsync信号の立下りタイミング

	
	signal vh_gen_en_wait	: std_logic_vector(15 downto 0);
--	signal wait_cnt			: std_logic_vector(12 downto 0);
	signal wait_cnt			: std_logic_vector(15 downto 0);

--	signal vh_v_rise_t		: std_logic_vector(12 downto 0);
	signal vh_v_rise_t		: std_logic_vector(15 downto 0);

--	signal vh_v_fall_t		: std_logic_vector(12 downto 0);
	signal vh_v_fall_t		: std_logic_vector(15 downto 0);

--	signal vh_v_end			: std_logic_vector(12 downto 0);
	signal vh_v_end			: std_logic_vector(15 downto 0);

--	signal v_fall_t			: std_logic_vector(12 downto 0);
	signal v_fall_t			: std_logic_vector(15 downto 0);

	
	signal vh_vcnt			: std_logic_vector(12 downto 0);
	signal vh_vcnt_end		: std_logic;
	signal hsync_t_cnt		: std_logic_vector(11 downto 0);
	signal vhsync_pre		: std_logic;
	signal hsync_pre		: std_logic;
	signal vcnt				: std_logic_vector(12 downto 0);
	signal vsync_pre		: std_logic;
	signal v_cnt_end 		: std_logic;
	signal hcnt_en			: std_logic;
	signal vh_sync_gen		: std_logic;
	signal hsync_gen		: std_logic;
	signal vsync_gen		: std_logic;
	signal hsync_pulse_cnt	: std_logic_vector(12 downto 0);
	signal hsync_d			: std_logic;
	signal sync_end			: std_logic;
	signal hsync_fall_edge	: std_logic;
	
	signal track_live_en	: std_logic;
	signal v_end_flg			: std_logic;
	signal track_cnt_scan	: std_logic_vector(12 downto 0);
	signal cnt_1ms			: std_logic_vector(14 downto 0);
	
--**************************************************************************************--
begin



	process(RESET,FPGAclk) begin
		if( RESET='1' ) then	
			vh_gen_en_wait <= (others => '0');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( OVER_SCAN = '1' )then
				vh_gen_en_wait <= OVER_SCAN_DLY_TIME;
			else
				vh_gen_en_wait <= VH_SYNC_PERIOD;
			end if;
		end if;
	end process;
	
	

	--レジスタ値からVHsync Vsync立ち上がり、立下り位置を計算する。
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			vh_v_rise_t <= (others=>'0');
			vh_v_fall_t <= (others=>'0');
			vh_v_end	<= (others=>'0');
			v_fall_t	<= (others=>'0');
		elsif (FPGAclk'event and FPGAclk = '1') then
			--最終段でラッチするため、VH_SYNC_PERIOD -2
			vh_v_rise_t <= (vh_gen_en_wait -2)  + c_vh_v_rise_t;	--VHsync V信号立ち上がりタイミング
			vh_v_fall_t <= (vh_gen_en_wait -2)  + c_vh_v_fall_t;	--VHsync V信号立下りタイミング
			vh_v_end	<= (vh_gen_en_wait -2)  + c_vh_v_end;		--VHsync V信号 High幅＋Low幅
			v_fall_t	<= (vh_gen_en_wait -2)  + c_v_fall_t;		--Vsync 立下りタイミング
		end if;
	end process;
	

	--Wait カウンタ
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			wait_cnt <= (others=>'0');
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				wait_cnt <= (others=>'0');
			--Vsync 立下りタイミングのとき、カウントホールド
			elsif( wait_cnt = v_fall_t )then
				wait_cnt <= wait_cnt;
			else
				wait_cnt <= wait_cnt + 1;
			end if;
		end if;
	end process;


	--Hsyncカウントイネーブル
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			hcnt_en <= '0';
		elsif(FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				hcnt_en <= '0';
			--VHsyncV信号( High幅＋Low幅)のとき、イネーブル信号出力
			elsif( wait_cnt = vh_v_end -2 )then
				hcnt_en <= '1';
			end if;
		end if;
	end process;


	--Hsync周期カウント
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			hsync_t_cnt <= (others=>'0');
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				hsync_t_cnt <= (others=>'0');
			elsif( hcnt_en = '1' )then
				if( hsync_t_cnt = HSYNC_T -1 )then
					hsync_t_cnt <= (others=>'0');
				else
					hsync_t_cnt <= hsync_t_cnt + 1;
				end if;
			end if;
		end if;
	end process;

	hsync_fall_edge <= ( hsync_d and not hsync_pre);

	--HSYNC出力パルスの立下りエッジをカウントする。
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			hsync_pulse_cnt <= (others => '0');
			hsync_d   <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			hsync_d <= hsync_pre;
			if( VH_GEN_EN = '0' )then
				hsync_pulse_cnt <= (others => '0');
			elsif( hcnt_en = '1' )then
				if( hsync_fall_edge = '1' )then
					hsync_pulse_cnt <= hsync_pulse_cnt + '1';
				end if;
			end if;
		end if;
	end process;
	
	
	--OUT_HSYNC_END信号生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			sync_end <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( hsync_pulse_cnt = HSYNC_NUM + 1 )then
				sync_end <= '1';
			else
				sync_end <= '0';
			end if;
		end if;
	end process;

	OUT_HSYNC_END <= sync_end;


	--VHSYNC信号のV信号生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			vhsync_pre <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				vhsync_pre <= '0';
			elsif( wait_cnt = vh_v_rise_t )then
				vhsync_pre <= '1';
			elsif( wait_cnt = vh_v_fall_t  )then
				vhsync_pre <= '0';
			end if;
		end if;
	end process;
	
	--HSYNC生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			hsync_pre <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				hsync_pre <= '0';
			elsif( hsync_t_cnt = c_h_rise_t )then
				hsync_pre <= '1';
			elsif( hsync_t_cnt = c_h_fall_t )then
				hsync_pre <= '0';
			end if;
		end if;
	end process;


	--VSYNC生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			vsync_pre <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( VH_GEN_EN = '0' )then
				vsync_pre <= '0';
			elsif( wait_cnt = vh_v_rise_t )then
				vsync_pre <= '1';
			elsif( wait_cnt = v_fall_t )then
				vsync_pre <= '0';
			end if;
		end if;
	end process;

	

	
	--SYNC信号生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			vh_sync_gen <= '0';
			hsync_gen  <= '0';
			vsync_gen  <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			vh_sync_gen <= vhsync_pre or hsync_pre;
			hsync_gen  <= hsync_pre;
			vsync_gen  <= vsync_pre;
		end if;
	end process;
	
	
	
	track_cnt_scan <= ( HSYNC_NUM + 2 ) - V_END_WAIT_CNT;
	
	--TRACK EN生成
	process(RESET,FPGAclk) begin
		if( RESET = '1' )then
			v_end_flg <= '0';
		elsif (FPGAclk'event and FPGAclk = '1') then
			if( hsync_pulse_cnt = track_cnt_scan )then
				v_end_flg <= '1';
			elsif( cnt_1ms = "100111000100001" )then
				v_end_flg <= '0';
			end if;
		end if;
	end process;
	
	process( RESET, FPGAclk ) begin
		if( RESET='1' ) then
			cnt_1ms <= (others=>'0');
		elsif( FPGAclk'event and FPGAclk='1' ) then
			if( v_end_flg = '1') then		
				cnt_1ms	<= cnt_1ms + '1';
			else
				cnt_1ms <= (others=>'0');	
			end if;
		end if;
	end process;
	
	

	OUT_V_END_FLG <= v_end_flg;
	

	
	OUT_VSYNC	<= vsync_gen;
	OUT_HSYNC	<= hsync_gen;
	OUT_VH_SYNC <= vh_sync_gen;

end rtl;
