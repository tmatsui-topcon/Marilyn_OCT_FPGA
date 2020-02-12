-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:H_W_Rev.vhd : VHDL File
-- Detail of Function	:FPGAハードウェアレビジョン通知回路
-- Date					:070808
-- Created by			:Y.NISHIO
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- [2007/08/08 : H_W_Rev_001]
--  ・新規作成
-- [2007/10/12]
--  ・ハードウェアバージョンの設定値入力を16進に変更
-- [2018/03/16]
--  ・MaetstroのOCT基板FPGAver1.1.1.3で対応された内容を反映 T.Sato



--**************************************************************************************--
--********************	Library declaration part			****************************--
--**************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--**************************************************************************************--
--********************	Entity Declaration					****************************--
--**************************************************************************************--
entity GALV_DAC_PSC is
	port(
		FPGAclk		:	in	std_logic;
		Reset		:	in	std_logic;
		GALV_X		:	in	std_logic_vector( 11 downto 0 );
		GALV_Y		:	in	std_logic_vector( 11 downto 0 );
		nSYNC_X		:	out	std_logic;
		nSYNC_Y		:	out	std_logic;
		SCLK		:	out	std_logic;
		nCLR		:	out	std_logic;
		SDIN		:	out	std_logic

	);
end GALV_DAC_PSC;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture RTL of GALV_DAC_PSC is


--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal	reg_galv_clk_1d 	: std_logic;
	signal	reg_galv_clk_2d 	: std_logic;
	signal	reg_galv_x		 	: std_logic_vector( 11 downto 0 );
	signal	reg_galv_y		 	: std_logic_vector( 11 downto 0 );
	signal	reg_galv_x_d	 	: std_logic_vector( 11 downto 0 );
	signal	reg_galv_y_d	 	: std_logic_vector( 11 downto 0 );
	signal	sft_reg_x			: std_logic_vector( 16 downto 0 );
	signal	sft_reg_y			: std_logic_vector( 16 downto 0 );
	signal	reg_sync_n_x		: std_logic;
	signal	reg_sync_n_y		: std_logic;
	signal	reg_sclk 			: std_logic;
	signal 	reg_send_cnt		: std_logic_vector( 7 downto 0 ); 
	signal	send_x_end 			: std_logic;
	signal	send_y_end 			: std_logic;
	signal	reg_galv_get_d 		: std_logic;
	signal	reg_galv_get		: std_logic;

	TYPE STATE_TYPE is (
							IDLE			,
							SEND_GALV_X		,
							WAIT_1CLK		,
							SEND_GALV_Y		
						);
	signal GALV_PSC_STATE : STATE_TYPE;
--**************************************************************************************--
begin

	nSYNC_X 	<=	reg_sync_n_x;
	nSYNC_Y 	<=	reg_sync_n_y;
	SDIN		<=	sft_reg_x(16) when (GALV_PSC_STATE = SEND_GALV_X or 
			                            GALV_PSC_STATE = WAIT_1CLK      ) else sft_reg_y(16);
	SCLK		<=	reg_sclk;
	
	
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_sclk 		<= '1';
			reg_sync_n_x 	<= '1';
			reg_sync_n_y 	<= '1';
			reg_galv_x		<= (others => '0');
			reg_galv_y		<= (others => '0');
			reg_galv_x_d	<= (others => '0');
			reg_galv_y_d	<= (others => '0');
			nCLR			<= '0';
			sft_reg_x(16 downto 12) <= (others => '0');
			sft_reg_y(16 downto 12) <= (others => '0');
			sft_reg_x(11 downto 0 ) <= (others => '0');
			sft_reg_y(11 downto 0 ) <= (others => '0');
			reg_galv_get_d <= '0';
			reg_galv_get <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			nCLR			<= '1';

			if( GALV_PSC_STATE = IDLE )then
				reg_send_cnt <= (others => '0');
				send_x_end <= '0';
				send_y_end <= '0';
			elsif( GALV_PSC_STATE = SEND_GALV_X or GALV_PSC_STATE = SEND_GALV_Y )then
				if(reg_sclk = '0')then
					reg_send_cnt <= reg_send_cnt + X"01";
				end if;
				if( GALV_PSC_STATE = SEND_GALV_X )then
					if(reg_send_cnt = X"0f" and reg_sclk = '0')then
						send_x_end <= '1';
					end if;
					send_y_end <= '0';
				elsif( GALV_PSC_STATE = SEND_GALV_Y )then
					if(reg_send_cnt = X"1f" and reg_sclk = '0')then
						send_y_end <= '1';
					end if;
					send_x_end <= '0';
				end if;
			end if;
			if( GALV_PSC_STATE = IDLE )then
				reg_sclk 				<= '0';
				reg_sync_n_x 			<= '1';
				reg_sync_n_y 			<= '1';
				sft_reg_x(16 downto 12) <= (others => '0');
				sft_reg_y(16 downto 12) <= (others => '0');
				sft_reg_x(11 downto 0 ) <= GALV_X(11 downto 0);
				sft_reg_y(11 downto 0 ) <= GALV_Y(11 downto 0);
			elsif( GALV_PSC_STATE = SEND_GALV_X )then
				if(reg_sclk = '1')then
					reg_sclk <= '0';
				else
					sft_reg_x(16 downto 0) <= sft_reg_x(15 downto 0) & '0';
					reg_sclk <= '1';
				end if;
				reg_sync_n_x <= '0';
				reg_sync_n_y <= '1';
			elsif( GALV_PSC_STATE = WAIT_1CLK )then
				reg_sync_n_x <= '1';
				reg_sync_n_y <= '1';
				reg_sclk <= '0';
			elsif( GALV_PSC_STATE = SEND_GALV_Y )then
				if(reg_sclk = '1')then
					reg_sclk <= '0';
				else
					sft_reg_y(16 downto 0) <= sft_reg_y(15 downto 0) & '0';
					reg_sclk <= '1';
				end if;
				reg_sync_n_x <= '1';
				reg_sync_n_y <= '0';
			end if;

			if( GALV_PSC_STATE = IDLE )then
				reg_galv_get <= '0';
			else
				reg_galv_get <= '1';
			end if;
			reg_galv_get_d <= reg_galv_get;
			reg_galv_x_d	<= GALV_X;
			reg_galv_y_d	<= GALV_Y;

			if( reg_galv_get_d = '0' and reg_galv_get = '1' )then
				reg_galv_x		<= reg_galv_x_d;
				reg_galv_y		<= reg_galv_y_d;
				--reg_galv_x		<= GALV_X;
				--reg_galv_y		<= GALV_Y;
			end if;
		end if;
	end process;
	
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			GALV_PSC_STATE <= IDLE;
		elsif( FPGAclk'event and FPGAclk='1') then
			case GALV_PSC_STATE is
				when IDLE	=>
					if( GALV_X(11 downto 0) /= reg_galv_x(11 downto 0) ) then
						GALV_PSC_STATE <= SEND_GALV_X;
					elsif( GALV_Y(11 downto 0) /= reg_galv_y(11 downto 0) )then
						GALV_PSC_STATE <= SEND_GALV_X;
					end if;
				when SEND_GALV_X	=>
					if( send_x_end = '1' )then
						GALV_PSC_STATE <= WAIT_1CLK;
					end if;
				when WAIT_1CLK	=>
					GALV_PSC_STATE <= SEND_GALV_Y;
				when SEND_GALV_Y	=>
					if( send_y_end = '1' )then
						GALV_PSC_STATE <= IDLE;
					end if;
				when others => null;
			end case;
		end if;
	end process;
--*************** ハードウェアバージョン出力 ******************************************--
-----------------------------------------------------------------------------------------
end RTL;
