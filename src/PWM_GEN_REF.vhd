-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:SLD_SMPL_TRG.vhd : VHDL File			-- <<<<<< Check Version
-- Ver					:001									-- <<<<<< Check Version
-- Date					:20090708
-- Created by			:nakano
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--VsyncÇ…ìØä˙ÇµÇƒÉpÉãÉXê∂ê¨
--
--                _____
-- Vsync ________|     |____________________
--                            _
-- Pulse ____________________| |____________
--               |<--50usec->| |
--                         ->|-|<- 1usec
--
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
ENTITY PWM_GEN_REF IS
	PORT
	(
		FPGAclk 		: 	IN 	STD_LOGIC;						--20MHz
		nReset 			: 	IN 	STD_LOGIC;
		PWM				:	IN	STD_LOGIC_VECTOR(6 downto 0);
		Pulse			:	IN	STD_LOGIC_VECTOR(15 downto 0);
		ONOFF			:	IN	STD_LOGIC;
		DIR				:	IN	STD_LOGIC;
--		MODE			:	IN	STD_LOGIC;						-- 0:PWM 1:Capture Zlock
		Pulse_A			:	OUT	STD_LOGIC;
		Pulse_B			:	OUT	STD_LOGIC
		
		);
END  PWM_GEN_REF;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
ARCHITECTURE RTL OF PWM_GEN_REF IS

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal reg_counter1  			:	std_logic_vector(11 downto 0);
	signal reg_counter2  			:	std_logic_vector(15 downto 0);
	signal reg_PWM 					:	std_logic_vector( 6 downto 0);
	signal reg_Pulse				:	std_logic_vector(15 downto 0);
	signal reg_Pulse_A 				:	std_logic;
	signal reg_Pulse_B 				:	std_logic;
	signal sig_PWM_end 				:	std_logic;
	signal sig_Pulse_end 			:	std_logic;
	signal sig_on_flg				:	std_logic;

--**************************************************************************************--
--********************	State Machine Definition Part		   *************************--
--**************************************************************************************--
	TYPE STATE_TYPE is(
						IDLE,
						COUNT_PWM,
						COUNT_PULSE,
						CONT
					);
	
	signal CURRENT_STATE	:	STATE_TYPE;

-----------------------------------------------------------------------------------------
begin

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
	Pulse_A <= reg_Pulse_A;
	Pulse_B <= reg_Pulse_B;

	U_COUNTUP :
	process( nReset, FPGAclk) 
	begin
		if( nReset = '0') then
			reg_counter1 <= (others =>'0');
			reg_counter2 <= (others =>'0');
			reg_PWM 	 <= (others =>'0');
			reg_Pulse 	 <= (others =>'0');
			reg_Pulse_A <= '0';
			reg_Pulse_B <= '0';
			sig_PWM_end <= '0';
			sig_on_flg  <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when IDLE		=> 
					reg_counter1 <= (others =>'0');
					reg_counter2 <= (others =>'0');
					reg_PWM <= PWM;
					reg_Pulse <= PULSE;
					reg_Pulse_A <= '0';
					reg_Pulse_B <= '0';
					sig_PWM_end <= '0';
					sig_on_flg  <= '0';
				when COUNT_PWM		=> 
					if(reg_counter1 = X"7CF")then
						reg_counter1 <= (others => '0');
						reg_counter2 <= reg_counter2 + X"01";
					else
						reg_counter1 <= reg_counter1 + X"001";
					end if;

					if( reg_counter2(6 downto 0) = reg_PWM(6 downto 0) ) then
						sig_PWM_end <= '1';
					else
						sig_PWM_end <= '0';
					end if;


					if( DIR = '1' )then
						reg_Pulse_A <= '1';
						reg_Pulse_B <= '0';
					else 
						reg_Pulse_A <= '0';
						reg_Pulse_B <= '1';
					end if;
				when COUNT_PULSE		=> 
					if(reg_counter1 = X"0C7")then
						reg_counter1 <= (others => '0');
						reg_counter2 <= reg_counter2 + X"01";
					else
						reg_counter1 <= reg_counter1 + X"001";
					end if;

					if( reg_counter2(15 downto 0) = reg_Pulse(15 downto 0) ) then
						sig_Pulse_end <= '1';
					else
						sig_Pulse_end <= '0';
					end if;


					if( DIR = '1' )then
						reg_Pulse_A <= '1';
						reg_Pulse_B <= '0';
					else 
						reg_Pulse_A <= '0';
						reg_Pulse_B <= '1';
					end if;
				when CONT		=> 
					if( ONOFF = '1')then
						if( DIR = '1' )then
							reg_Pulse_A <= '1';
							reg_Pulse_B <= '0';
						else 
							reg_Pulse_A <= '0';
							reg_Pulse_B <= '1';
						end if;
						sig_on_flg <= '1';
					else
						reg_Pulse_A <= '0';
						reg_Pulse_B <= '0';
					end if;
				when others => null;
			end case;
		end if;
	end process;

	U_STATE_MACHINE:
	process( nReset, FPGAclk) 
	begin
		if( nReset = '0') then
			CURRENT_STATE <= IDLE;
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when IDLE	=>
					if(PWM = B"111_1111")then
						CURRENT_STATE <= CONT;
					elsif (PWM /= B"000_0000") then
						CURRENT_STATE <= COUNT_PWM;
					elsif (Pulse(6 downto 0) /= B"000_0000") then
						CURRENT_STATE <= COUNT_PULSE;
					end if;
				when COUNT_PWM =>
					if(sig_PWM_end = '1') then
						CURRENT_STATE <= IDLE;
					end if;
				when COUNT_PULSE =>
					if(sig_Pulse_end = '1') then
						CURRENT_STATE <= IDLE;
					end if;
				when CONT =>
					if( ONOFF = '0' and sig_on_flg = '1')then
						CURRENT_STATE <= IDLE;
					end if;
				when others => null;
			end case;
		end if;
	end process;


					
-----------------------------------------------------------------------------------------
END RTL;
