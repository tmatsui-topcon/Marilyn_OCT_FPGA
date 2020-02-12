-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:SLD_EN_TRG.vhd : VHDL File			-- <<<<<< Check Version
-- Ver					:001									-- <<<<<< Check Version
-- Date					:20090925
-- Created by			:nakano
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--sld_gen_enに同期してパルス生成
--            ________                        ___
-- sld_gen_en         |______________________|                    
--       _________________________   ____________
-- Pulse                          |_|              
--                    |<-100usec->| |
--                              ->|-|<- 1usec
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
ENTITY SLD_EN_TRG IS
	PORT
	(
		FPGAclk 		: 	IN 	STD_LOGIC;						--20MHz
		Reset 			: 	IN 	STD_LOGIC;
		SLD_Gen_EN		:	IN	STD_LOGIC;
		Pulse_out		:	OUT	STD_LOGIC
		
		);
END  SLD_EN_TRG;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
ARCHITECTURE RTL OF SLD_EN_TRG IS

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal reg_SLD_Gen_EN			:	std_logic;
	signal reg_Pulse_out			:	std_logic;
	signal reg_counter1  			:	std_logic_vector(11 downto 0);

--**************************************************************************************--
--********************	State Machine Definition Part		   *************************--
--**************************************************************************************--
	TYPE STATE_TYPE is(
						INIT,
						WAIT_POS_EDGE,
						WAIT_NEG_EDGE,
						COUNTUP_100USEC,
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
			reg_SLD_Gen_EN		<= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			reg_SLD_Gen_EN		<= SLD_Gen_En;
		end if;
	end process;

	U_COUNTUP :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_counter1 <= (others =>'0');
			reg_Pulse_out <= '1';
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when INIT			=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '1';
				when WAIT_POS_EDGE		=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '1';
				when WAIT_NEG_EDGE		=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '1';
				when COUNTUP_100USEC	=> 
					reg_counter1 <= reg_counter1 + X"001";
					reg_Pulse_out <= '1';
				when COUNT_RESET	=> 
					reg_counter1 <= (others =>'0');
					reg_Pulse_out <= '1';
				when COUNTUP_1USEC	=> 
					reg_counter1 <= reg_counter1 + X"001";
					reg_Pulse_out <= '0';
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
					CURRENT_STATE <= WAIT_POS_EDGE;
				when WAIT_POS_EDGE	=>
					if(reg_SLD_Gen_EN = '1')then
						CURRENT_STATE <= WAIT_NEG_EDGE;
					end if;
				when WAIT_NEG_EDGE	=>
					if(reg_SLD_Gen_EN = '0') then
						CURRENT_STATE <= COUNTUP_100USEC;
					end if;
				when COUNTUP_100USEC =>
					if(reg_counter1 = X"7CB") then --(2000-5)カウント タイミング調整で5引く
						CURRENT_STATE <= COUNT_RESET;
					end if;
				when COUNT_RESET	=>
					CURRENT_STATE <= COUNTUP_1USEC;
				when COUNTUP_1USEC	=>
					if(reg_counter1 = X"013") then --20カウント 
						CURRENT_STATE <= WAIT_POS_EDGE;
					end if;
			end case;
		end if;
	end process;


					
-----------------------------------------------------------------------------------------
END RTL;
