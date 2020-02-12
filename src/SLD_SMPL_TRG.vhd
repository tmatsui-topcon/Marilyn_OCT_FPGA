-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:SLD_SMPL_TRG.vhd : VHDL File			-- <<<<<< Check Version
-- Ver					:001									-- <<<<<< Check Version
-- Date					:20090708
-- Created by			:nakano
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Vsyncに同期してパルス生成
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
ENTITY SLD_SMPL_TRG IS
	PORT
	(
		FPGAclk 		: 	IN 	STD_LOGIC;						--20MHz
		Reset 			: 	IN 	STD_LOGIC;
		Vsync			:	IN	STD_LOGIC;
		Pulse_out		:	OUT	STD_LOGIC
		
		);
END  SLD_SMPL_TRG;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
ARCHITECTURE RTL OF SLD_SMPL_TRG IS

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal reg_Vsync				:	std_logic;
	signal reg_Pulse_out			:	std_logic;
	signal reg_counter1  			:	std_logic_vector(11 downto 0);

--**************************************************************************************--
--********************	State Machine Definition Part		   *************************--
--**************************************************************************************--
	TYPE STATE_TYPE is(
						INIT,
						WAIT_VSYNC,
						COUNTUP_50USEC,
						COUNT_RESET,
						COUNTUP_1USEC
					);
	
	signal CURRENT_STATE	:	STATE_TYPE;

-----------------------------------------------------------------------------------------
begin

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
	Pulse_out <= reg_Pulse_out;

	U_TMP :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_VSync		<= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			reg_VSync		<= VSync;
		end if;
	end process;

	U_COUNTUP :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_counter1 <= (others =>'0');
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when INIT			=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '0';
				when WAIT_VSYNC		=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '0';
				when COUNTUP_50USEC	=> 
					reg_counter1 <= reg_counter1 + X"001";
					reg_Pulse_out <= '0';
				when COUNT_RESET	=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '0';
				when COUNTUP_1USEC	=> 
					reg_counter1 <= reg_counter1 + X"001";
					reg_Pulse_out <= '1';
				when others => null;
			end case;
		end if;
	end process;

	U_STATE_MACHINE:
	process( reset, fpgaclk) 
	begin
		if( Reset = '1') then
			CURRENT_STATE <= INIT;
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when INIT			=>
					CURRENT_STATE <= WAIT_VSYNC;
				when WAIT_VSYNC	=>
					if(reg_VSync = '1') then
						CURRENT_STATE <= COUNTUP_50USEC;
					end if;
				when COUNTUP_50USEC =>
					if(reg_counter1 = X"3E4") then --1000カウント 
						CURRENT_STATE <= COUNT_RESET;
					end if;
				when COUNT_RESET	=>
					CURRENT_STATE <= COUNTUP_1USEC;
				when COUNTUP_1USEC	=>
					if(reg_counter1 = X"013") then --20カウント 
						CURRENT_STATE <= WAIT_VSYNC;
					end if;
				when others => null;
			end case;
		end if;
	end process;


					
-----------------------------------------------------------------------------------------
END RTL;
