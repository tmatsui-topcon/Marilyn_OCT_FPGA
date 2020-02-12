library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	ENTITY declaration part				****************************--
--**************************************************************************************--
entity stepmotor_ctrl is
	port
	(
		Reset						: in STD_LOGIC;
		FPGAclk						: in STD_LOGIC;							--20MHz
		Motor_ctrl_sel				: in STD_LOGIC;							--0: 1-2相励磁 , 1:2-2相励磁
		Deceleration_step			: in STD_LOGIC_VECTOR(14 downto 0);		--減速ステップ数[パルス]
		Total_step					: in STD_LOGIC_VECTOR(14 downto 0);		--総移動ステップ数[パルス]
		Init_speed					: in STD_LOGIC_VECTOR(13 downto 0);		--初速ステップ間隔[ns]
		Max_speed					: in STD_LOGIC_VECTOR(13 downto 0);		--最高速ステップ間隔[ns]
		Step_increase				: in STD_LOGIC_VECTOR(13 downto 0);		--１ステップに増減する間隔
		STEP_CW						: in STD_LOGIC;
		Start						: in STD_LOGIC;
		Motro_on					: out STD_LOGIC;						--ステッピングモータへ励磁開始信号
		Motor_AP					: out STD_LOGIC;						--ステッピングモータA+相制御信号
		Motor_BP					: out STD_LOGIC;						--ステッピングモータB+相制御信号
		Motor_AN					: out STD_LOGIC;						--ステッピングモータA-相制御信号
		Motor_BN					: out STD_LOGIC;						--ステッピングモータB-相制御信号
		IRQ_OUT						: out STD_LOGIC							--モータ制御終了後IRQ端子に割り込み出力
	);
end stepmotor_ctrl;

--**************************************************************************************--
--********************	architecture Body					****************************--
--**************************************************************************************--
architecture rtl of stepmotor_ctrl is

	component divide_step_cycle is
		port
		(
			clock		: in STD_LOGIC ;
			denom		: in STD_LOGIC_VECTOR (13 downto 0);
			numer		: in STD_LOGIC_VECTOR (24 downto 0);
			quotient	: out STD_LOGIC_VECTOR (24 downto 0);
			remain		: out STD_LOGIC_VECTOR (13 downto 0)
		);
	end component;


	constant c_20MHz	: std_logic_vector(24 downto 0)	:= "1001100010010110100000000";


	signal	start_pulse_det		: std_logic_vector(1 downto 0);
	signal	start_pulse_ff		: std_logic;
	signal	step_pps			: std_logic_vector(13 downto 0);
	signal	step_pps_clip		: std_logic_vector(13 downto 0);	
	signal	step_cycle			: std_logic_vector(24 downto 0);
	signal	step_cycle_ff		: std_logic_vector(15 downto 0);

	signal	step_cycle_cnt		: std_logic_vector(15 downto 0);
	signal	r_step_cnt			: std_logic_vector(14 downto 0);
	signal	sig_decel_duration	: std_logic;
	signal	r_motor_ctrl_cnt	: std_logic_vector( 2 downto 0);
	
	signal	r_motor_phase		: std_logic_vector(3 downto 0);
	
	signal r_irq_ff				: std_logic;
	
	signal r_irq_cnt			: std_logic_vector(4 downto 0);

	signal wait_cnt				: std_logic_vector(7 downto 0);

	signal motor_ctrl_cnt_en	: std_logic;
	
	signal Deceleration_step_ff : std_logic_vector(14 downto 0);
	signal total_step_ff		: std_logic_vector(14 downto 0);
	signal Init_speed_ff		: std_logic_vector(13 downto 0);
	signal Max_speed_ff			: std_logic_vector(13 downto 0);
	signal Step_increase_ff		: std_logic_vector(13 downto 0);
	signal STEP_CW_ff			: std_logic;
	
--**************************************************************************************--
begin

	
	Motro_on				<= start_pulse_ff;
	Motor_AP	        	<= r_motor_phase(3);
	Motor_BP	       		<= r_motor_phase(2);
	Motor_AN       			<= r_motor_phase(1);
    Motor_BN      			<= r_motor_phase(0);
    
    IRQ_OUT					<= r_irq_ff;
    


	--レジスタラッチ
	process( Reset, FPGAclk	)begin
		if( Reset = '0' )then
			Deceleration_step_ff 	<= (others => '0');
			total_step_ff		    <= (others => '0');
			Init_speed_ff		    <= (others => '0');
			Max_speed_ff			<= (others => '0');
			Step_increase_ff	    <= (others => '0');
			STEP_CW_ff			    <= '0';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( start_pulse_ff = '0')then
				Deceleration_step_ff <= Deceleration_step	;
				total_step_ff		 <= Total_step			;
				Init_speed_ff		 <= Init_speed			;
				Max_speed_ff		 <= Max_speed			;
				Step_increase_ff	 <= Step_increase		;
				STEP_CW_ff			 <= STEP_CW				;
			end if;
		end if;
	end process;

    --モータ制御終了後、割り込み端子 IRQに制御終了信号を出力する。
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_irq_ff <= '0';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--パルス幅、1.55usになったとき、ディアサート
			if( r_irq_cnt = "11111")then 
				r_irq_ff <= '0';
			--総移動ステップ数に達したとき,アサートする
			elsif( (r_step_cnt = total_step_ff ) and (step_cycle_cnt = step_cycle_ff)and (start_pulse_det(0) = '1') )then 
				r_irq_ff <= '1';
			end if;
		end if;
	end process;

    
    --IRQ割り込み信号 pulse幅設定, 31pulse(50ns X 31 = 1.55us)
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_irq_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( r_irq_ff ='0')then
				r_irq_cnt <= (others => '0');
			else
				r_irq_cnt <= r_irq_cnt + '1';	
			end if;
		end if;
	end process;
   	

	--FWから設定される制御スタート信号の立ち上がりエッジ
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			start_pulse_det <= "00";
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( start_pulse_ff = '0' )then
				start_pulse_det <= start_pulse_det(0) & Start;
			end if;
		end if;
	end process;
	

	--リセット解除後、Wait 
	process( Reset, FPGAclk	)begin
		if( Reset = '0' )then
			wait_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( wait_cnt = X"FF")then
				wait_cnt <= wait_cnt;
			else
				wait_cnt <= wait_cnt + '1';
			end if;
		end if;
	end process;
	

	--モータ制御スタート信号生成
	--FWからのスタート信号を受けときアサートする。
	--総移動ステップに達したときディアサート
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			start_pulse_ff <= '0';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--総移動ステップ数に達したとき,start信号をディアサートする。
			if((r_step_cnt = total_step_ff ) and (step_cycle_cnt = step_cycle_ff))then 
				start_pulse_ff <= '0';
				--FWからの制御開始信号を受けたとき、start信号をアサートする。
			elsif( start_pulse_det = "01" )then 
				start_pulse_ff <= '1';
			end if;
		end if;
	end process;
	

	
	
	
	
	--PPS設定
--	U_Step_length_set :
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_pps <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( start_pulse_ff = '0' )then
				step_pps <= Init_speed_ff;
			--1ステップ終了
			elsif(  step_cycle_cnt = X"0064" )then
				--最高速までディクリメントする
				if( sig_decel_duration = '0' and ( Max_speed_ff > step_pps ))then
					step_pps <= step_pps + Step_increase_ff;
				--減速期間、初速までインクリメントする
				elsif( sig_decel_duration = '1' and ( step_pps > Init_speed_ff ))then
					step_pps <= step_pps  - Step_increase_ff;	
				end if;
			end if;
		end if;
	end process;


	--最高速,初速でクリップする。
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_pps_clip <= (others =>'0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--最高速超えた場合
			if( step_pps  > Max_speed_ff )then
				step_pps_clip <= Max_speed_ff;
			--初速下回った場合
			elsif( Init_speed_ff > step_pps )then
				step_pps_clip <= Init_speed_ff;
			else
				step_pps_clip <= step_pps;
			end if;
		end if;
	end process;

	U_div_step_cycle : divide_step_cycle port map (
		clock		=> FPGAclk,
		denom	    => step_pps_clip,
		numer	    => c_20MHz,
		quotient    => step_cycle,
		remain		=> open
	);
	
	--除算結果をレジスタに格納
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_cycle_ff <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( wait_cnt /= X"FF")then
				step_cycle_ff <= (others => '0');
			elsif( start_pulse_ff = '0'   )then 
				step_cycle_ff <= step_cycle(15 downto 0);
			elsif( step_cycle_cnt = step_cycle_ff )then
				step_cycle_ff <= step_cycle(15 downto 0);
			end if;
		end if;
	end process;
	
	

	
	--ステップ間隔カウント
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_cycle_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--FWからモータ制御開始検出 カウンタクリア
			if( start_pulse_ff = '0' )then 
				step_cycle_cnt <= (others => '0');
			--1ステップ終了でカウントクリア
			elsif( step_cycle_cnt = step_cycle_ff )then 
				step_cycle_cnt <= (others => '0');
			else
				step_cycle_cnt <= step_cycle_cnt + '1';
			end if;
		end if;
	end process;
	

	--ステップ数カウント
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_step_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--FWからモータ制御開始検出 カウンタクリア
			if( start_pulse_ff = '0' )then 
				r_step_cnt <= "000000000000001";
			--1ステップ終了
			elsif( step_cycle_cnt = step_cycle_ff )then 
				if( r_step_cnt = total_step_ff )then
					r_step_cnt <= "000000000000001";
				else
					r_step_cnt <= r_step_cnt + '1';
				end if;
			end if;
		end if;
	end process;


	--減速開始ステップ : 総移動ステップ数 - 減速ステップ数
--	sig_decel_duration <= '0' when ( r_step_cnt < total_step_ff- Deceleration_step_ff ) else '1';
	sig_decel_duration <= '1' when ((total_step_ff- Deceleration_step_ff ) <= r_step_cnt) else '0';
	

	motor_ctrl_cnt_en <= '1' when ((step_cycle_cnt = step_cycle_ff) and (r_step_cnt /= total_step_ff ) and (start_pulse_det(0) = '1') ) else '0';

	--ステッピングモータ制御カウンタ
	--A相,B相,A-相、B-相の励磁パターンを決定するカウンタ。
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_motor_ctrl_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--( (1ステップ終了かつ、総移動ステップに達していないとき)または、FWからスタートを受けたとき )
			if( ( motor_ctrl_cnt_en = '1' ) or (start_pulse_det = "01" ) )then
				--CCW方向のとき、ディクリメント
				if( STEP_CW_ff = '1' )then
					r_motor_ctrl_cnt <= r_motor_ctrl_cnt - '1';
				--CW方向のとき、インクリメント
				else 
					r_motor_ctrl_cnt <= r_motor_ctrl_cnt + '1';	
				end if;
			end if;
		end if;
	end process;




	--制御パルス生成
	--	U_Mort_Ctrl_phase :
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_motor_phase <= "1000";
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--2-2相励磁制御
			if( Motor_ctrl_sel = '1' )then
				case  r_motor_ctrl_cnt(1 downto 0) is
					when "00" => 
						r_motor_phase <= "1100";
					when "01" => 
						r_motor_phase <= "0110";
					when "10" => 
						r_motor_phase <= "0011";
					when "11" => 
						r_motor_phase <= "1001";
					when others =>
						r_motor_phase <= "1100";
				end case;
			--1-2相励磁制御
			else
				case  r_motor_ctrl_cnt is
					when "000" => 
						r_motor_phase <= "1000";
					when "001" => 
						r_motor_phase <= "1100";
					when "010" => 
						r_motor_phase <= "0100";
					when "011" => 
						r_motor_phase <= "0110";
					when "100" =>
						r_motor_phase <= "0010";
					when "101" =>
						r_motor_phase <= "0011";
					when "110" =>
						r_motor_phase <= "0001";
					when "111" =>
						r_motor_phase <= "1001";
					when others =>
						r_motor_phase <= "1000";
				end case;
			end if;
		end if;
	end process;


end rtl;

