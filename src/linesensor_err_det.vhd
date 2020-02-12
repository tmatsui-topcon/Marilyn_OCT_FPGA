library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	ENTITY declaration part				****************************--
--**************************************************************************************--

entity linesensor_err_det is
	port
	(
		Reset				: in STD_LOGIC;
		FPGAclk         	: in STD_LOGIC;
		LCMOS_MisTrigger	: in STD_LOGIC;
		HSYNC_IN			: in STD_LOGIC;
		VSYNC_IN			: in STD_LOGIC;
		OUT_MisTrigger_det	: out STD_LOGIC

	);
end linesensor_err_det;

--**************************************************************************************--
--********************	ARCHITECTURE Body					****************************--
--**************************************************************************************--
architecture rtl of linesensor_err_det is
--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	constant c_LCMOS_MisTrigger_rise_edge 	: std_logic_vector(9 downto 0) := "0000011111" ;
	constant c_1us_err_t_cnt					: std_logic_vector(6 downto 0) := "0010100";
	signal	vsync_d				: std_logic;
	signal	hsync_d					: std_logic;
	signal	hsync_cnt				: std_logic_vector(12 downto 0);
	signal	LCMOS_MisTrigger_edge	: std_logic_vector(10 downto 0);
	signal	LCMOS_MisTrigger_cnt	: std_logic_vector(12 downto 0);
	signal	MisTrigger_det			: std_logic;
	signal	vsync_rise_edge			: std_logic;
	signal	hsync_rise_edge			: std_logic;
	signal	err_clear_cnt			: std_logic_vector(6 downto 0);
	signal	vsync_rise_dge_d		: std_logic;
	
--**************************************************************************************--
begin
	
	
	--Inter_Reset 1clk delay
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			vsync_d 	     <= '0';
			hsync_d			 <= '0';			
			vsync_rise_dge_d <= '0';
		elsif( FPGAclk'event and FPGAclk = '1' )then
			vsync_d 			<= VSYNC_IN;
			hsync_d				<= HSYNC_IN;
			vsync_rise_dge_d	<= vsync_rise_edge;
		end if;
	end process;
	
	vsync_rise_edge	<= ( not vsync_d and  VSYNC_IN);
	
	
	

	--LCMOS_MisTrigger �����オ��G�b�W
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			LCMOS_MisTrigger_edge <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			LCMOS_MisTrigger_edge <= LCMOS_MisTrigger_edge(9 downto 0) & LCMOS_MisTrigger;
		end if;
	end process;
	
	hsync_rise_edge		<= ( HSYNC_IN and not hsync_d);
	
	--LCMOS_MisTrigger �G�b�W���o�����Ƃ��A�J�E���g�C���N�������g
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			LCMOS_MisTrigger_cnt <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			if( vsync_rise_edge = '1' )then
				LCMOS_MisTrigger_cnt  <= ( others => '0');
			elsif( LCMOS_MisTrigger_edge(10 downto 1) = c_LCMOS_MisTrigger_rise_edge )then
				LCMOS_MisTrigger_cnt <= LCMOS_MisTrigger_cnt + '1';
			end if;
		end if;
	end process;
	
	
	--Hsync�����オ��G�b�W���o�����Ƃ��A�J�E���^�C���N�������g
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			hsync_cnt <= ( others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			if( vsync_rise_edge = '1' )then
				hsync_cnt <= ( others => '0');
			elsif( hsync_rise_edge = '1' )then
				hsync_cnt <= hsync_cnt + '1';
			end if;
		end if;
	end process;
	
	

	--Inter_Reset �����オ�茟�o,LCMOS_MisTrigger�J�E���g�AHsync�J�E���g��r����B
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			MisTrigger_det <= '1';
		elsif( FPGAclk'event and FPGAclk = '1' )then
			--�G���[�o�͌�A1us�o�߂ŃG���[���N���A����B
			if( err_clear_cnt =  c_1us_err_t_cnt )then
				MisTrigger_det <= '1';
			elsif( vsync_rise_edge = '1' )then
				--Hsync�J�E���g��GPO�J�E���g�قȂ�Ƃ��AIRQ4�փG���[���o�͂���B(Low Active)
				if( hsync_cnt /= LCMOS_MisTrigger_cnt )then
					MisTrigger_det <= '0';
				end if;
			end if;
		end if;
	end process;
	
	--�G���[���o��A1[us]�o�߂�IRQ4�G���[�o�͂��N���A����B
	process( Reset, FPGAclk )begin
		if( Reset = '1' )then
			err_clear_cnt <= (others => '0');
		elsif( FPGAclk'event and FPGAclk = '1' )then
			if( MisTrigger_det = '0' )then
				err_clear_cnt <= err_clear_cnt + '1';
			else
				err_clear_cnt <= (others => '0');
			end if;
		end if;
	end process;
	

	
	
	OUT_MisTrigger_det <= MisTrigger_det;


end rtl;
