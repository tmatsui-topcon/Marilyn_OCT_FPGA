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
		Motor_ctrl_sel				: in STD_LOGIC;							--0: 1-2���㎥ , 1:2-2���㎥
		Deceleration_step			: in STD_LOGIC_VECTOR(14 downto 0);		--�����X�e�b�v��[�p���X]
		Total_step					: in STD_LOGIC_VECTOR(14 downto 0);		--���ړ��X�e�b�v��[�p���X]
		Init_speed					: in STD_LOGIC_VECTOR(13 downto 0);		--�����X�e�b�v�Ԋu[ns]
		Max_speed					: in STD_LOGIC_VECTOR(13 downto 0);		--�ō����X�e�b�v�Ԋu[ns]
		Step_increase				: in STD_LOGIC_VECTOR(13 downto 0);		--�P�X�e�b�v�ɑ�������Ԋu
		STEP_CW						: in STD_LOGIC;
		Start						: in STD_LOGIC;
		Motro_on					: out STD_LOGIC;						--�X�e�b�s���O���[�^�֗㎥�J�n�M��
		Motor_AP					: out STD_LOGIC;						--�X�e�b�s���O���[�^A+������M��
		Motor_BP					: out STD_LOGIC;						--�X�e�b�s���O���[�^B+������M��
		Motor_AN					: out STD_LOGIC;						--�X�e�b�s���O���[�^A-������M��
		Motor_BN					: out STD_LOGIC;						--�X�e�b�s���O���[�^B-������M��
		IRQ_OUT						: out STD_LOGIC							--���[�^����I����IRQ�[�q�Ɋ��荞�ݏo��
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
    


	--���W�X�^���b�`
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

    --���[�^����I����A���荞�ݒ[�q IRQ�ɐ���I���M�����o�͂���B
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_irq_ff <= '0';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--�p���X���A1.55us�ɂȂ����Ƃ��A�f�B�A�T�[�g
			if( r_irq_cnt = "11111")then 
				r_irq_ff <= '0';
			--���ړ��X�e�b�v���ɒB�����Ƃ�,�A�T�[�g����
			elsif( (r_step_cnt = total_step_ff ) and (step_cycle_cnt = step_cycle_ff)and (start_pulse_det(0) = '1') )then 
				r_irq_ff <= '1';
			end if;
		end if;
	end process;

    
    --IRQ���荞�ݐM�� pulse���ݒ�, 31pulse(50ns X 31 = 1.55us)
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
   	

	--FW����ݒ肳��鐧��X�^�[�g�M���̗����オ��G�b�W
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			start_pulse_det <= "00";
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( start_pulse_ff = '0' )then
				start_pulse_det <= start_pulse_det(0) & Start;
			end if;
		end if;
	end process;
	

	--���Z�b�g������AWait 
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
	

	--���[�^����X�^�[�g�M������
	--FW����̃X�^�[�g�M�����󂯂Ƃ��A�T�[�g����B
	--���ړ��X�e�b�v�ɒB�����Ƃ��f�B�A�T�[�g
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			start_pulse_ff <= '0';
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--���ړ��X�e�b�v���ɒB�����Ƃ�,start�M�����f�B�A�T�[�g����B
			if((r_step_cnt = total_step_ff ) and (step_cycle_cnt = step_cycle_ff))then 
				start_pulse_ff <= '0';
				--FW����̐���J�n�M�����󂯂��Ƃ��Astart�M�����A�T�[�g����B
			elsif( start_pulse_det = "01" )then 
				start_pulse_ff <= '1';
			end if;
		end if;
	end process;
	

	
	
	
	
	--PPS�ݒ�
--	U_Step_length_set :
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_pps <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			if( start_pulse_ff = '0' )then
				step_pps <= Init_speed_ff;
			--1�X�e�b�v�I��
			elsif(  step_cycle_cnt = X"0064" )then
				--�ō����܂Ńf�B�N�������g����
				if( sig_decel_duration = '0' and ( Max_speed_ff > step_pps ))then
					step_pps <= step_pps + Step_increase_ff;
				--�������ԁA�����܂ŃC���N�������g����
				elsif( sig_decel_duration = '1' and ( step_pps > Init_speed_ff ))then
					step_pps <= step_pps  - Step_increase_ff;	
				end if;
			end if;
		end if;
	end process;


	--�ō���,�����ŃN���b�v����B
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_pps_clip <= (others =>'0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--�ō����������ꍇ
			if( step_pps  > Max_speed_ff )then
				step_pps_clip <= Max_speed_ff;
			--������������ꍇ
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
	
	--���Z���ʂ����W�X�^�Ɋi�[
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
	
	

	
	--�X�e�b�v�Ԋu�J�E���g
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			step_cycle_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--FW���烂�[�^����J�n���o �J�E���^�N���A
			if( start_pulse_ff = '0' )then 
				step_cycle_cnt <= (others => '0');
			--1�X�e�b�v�I���ŃJ�E���g�N���A
			elsif( step_cycle_cnt = step_cycle_ff )then 
				step_cycle_cnt <= (others => '0');
			else
				step_cycle_cnt <= step_cycle_cnt + '1';
			end if;
		end if;
	end process;
	

	--�X�e�b�v���J�E���g
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_step_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--FW���烂�[�^����J�n���o �J�E���^�N���A
			if( start_pulse_ff = '0' )then 
				r_step_cnt <= "000000000000001";
			--1�X�e�b�v�I��
			elsif( step_cycle_cnt = step_cycle_ff )then 
				if( r_step_cnt = total_step_ff )then
					r_step_cnt <= "000000000000001";
				else
					r_step_cnt <= r_step_cnt + '1';
				end if;
			end if;
		end if;
	end process;


	--�����J�n�X�e�b�v : ���ړ��X�e�b�v�� - �����X�e�b�v��
--	sig_decel_duration <= '0' when ( r_step_cnt < total_step_ff- Deceleration_step_ff ) else '1';
	sig_decel_duration <= '1' when ((total_step_ff- Deceleration_step_ff ) <= r_step_cnt) else '0';
	

	motor_ctrl_cnt_en <= '1' when ((step_cycle_cnt = step_cycle_ff) and (r_step_cnt /= total_step_ff ) and (start_pulse_det(0) = '1') ) else '0';

	--�X�e�b�s���O���[�^����J�E���^
	--A��,B��,A-���AB-���̗㎥�p�^�[�������肷��J�E���^�B
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_motor_ctrl_cnt <= (others => '0');
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--( (1�X�e�b�v�I�����A���ړ��X�e�b�v�ɒB���Ă��Ȃ��Ƃ�)�܂��́AFW����X�^�[�g���󂯂��Ƃ� )
			if( ( motor_ctrl_cnt_en = '1' ) or (start_pulse_det = "01" ) )then
				--CCW�����̂Ƃ��A�f�B�N�������g
				if( STEP_CW_ff = '1' )then
					r_motor_ctrl_cnt <= r_motor_ctrl_cnt - '1';
				--CW�����̂Ƃ��A�C���N�������g
				else 
					r_motor_ctrl_cnt <= r_motor_ctrl_cnt + '1';	
				end if;
			end if;
		end if;
	end process;




	--����p���X����
	--	U_Mort_Ctrl_phase :
	process( Reset, FPGAclk	)begin
		if(  Reset = '0' )then
			r_motor_phase <= "1000";
		elsif(  FPGAclk'event and FPGAclk = '1' )then
			--2-2���㎥����
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
			--1-2���㎥����
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

