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
--
--
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
entity SEND_KEISEN is
	port(
		FPGAclk			:	in	std_logic;
		Reset			:	in	std_logic;
		SEND_DATA_EN	:	in 	std_logic;
		SEND_DATA		:	in	std_logic_vector( 15 downto 0 );

		RECIEVE_DATA_EN	:	out std_logic;
		RECIEVE_DATA	:	out std_logic_vector( 15 downto 0);
		
		RXD				:	in	std_logic;
		TXD				:	out	std_logic
		
	);
end SEND_KEISEN;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture RTL of SEND_KEISEN is


--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal reg_rxd_buf			:	std_logic_vector( 3 downto 0 );
	signal filtered_rxd			:	std_logic;
	signal filtered_rxd_d		:	std_logic;
	signal rxd_en				:	std_logic;
	signal sft_reg				:	std_logic_vector( 17 downto 0 );
	signal sft_reg_send			:	std_logic_vector( 17 downto 0 );
	signal rxd_bit_cnt 			:	std_logic_vector( 4 downto 0 );
	signal rxd_cnt 				:	std_logic_vector( 11 downto 0 );
	signal txd_en 				:	std_logic;
	signal txd_cnt 				:	std_logic_vector( 11 downto 0 );
	signal txd_bit_cnt			:	std_logic_vector( 4 downto 0);
	signal bps_count			:	std_logic_vector( 11 downto 0 );
	signal data_get				:	std_logic;
	signal SEND_DATA_EN_d		:	std_logic;
--**************************************************************************************--
begin

	bps_count <= X"0C8";

	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_rxd_buf <= (others => '1');
		elsif( FPGAclk'event and FPGAclk='1') then
			reg_rxd_buf(0) <= RXD;
			reg_rxd_buf( 3 downto 1 ) <= reg_rxd_buf( 2 downto 0 );
			if( reg_rxd_buf(3 downto 0) = "0000") then
				filtered_rxd <= '0';
			elsif( reg_rxd_buf(3 downto 0) = "1111") then
				filtered_rxd <= '1';
			end if;
		end if;
	end process;
	
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			filtered_rxd_d <= '1';
			rxd_en <= '0';
			rxd_bit_cnt <= ( others => '0' );
			rxd_cnt <= ( others => '0' );
			RECIEVE_DATA_EN	<= '0';
			RECIEVE_DATA	<= ( others => '0' );
			data_get <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			filtered_rxd_d <= filtered_rxd;
			if( rxd_en = '0' ) then
				if( filtered_rxd_d = '1' and filtered_rxd = '0' ) then
					rxd_en <= '1';
				end if;
				rxd_cnt <= '0' & bps_count(11 downto 1);
				data_get <= '0';
			else
				rxd_cnt <= rxd_cnt + X"001";
				if( rxd_cnt = bps_count ) then
					rxd_cnt <= ( others => '0' );
					if( rxd_bit_cnt = B"1_0000" ) then
						rxd_bit_cnt <= ( others => '0' );
						rxd_en <= '0';
						data_get <= '1';
					else
						rxd_bit_cnt <= rxd_bit_cnt + B"0_0001";
						data_get <= '0';
					end if;
					sft_reg(0) <= filtered_rxd ;
					sft_reg(15 downto 1) <= sft_reg(14 downto 0) ;
				else
					data_get <= '0';
				end if;
			end if;

			--if( rxd_en = '1' and rxd_bit_cnt = B"1_0000" )then
			if( data_get = '1' )then
				RECIEVE_DATA_EN	<= '1';
				RECIEVE_DATA	<= sft_reg(15 downto 0);
			else
				RECIEVE_DATA_EN	<= '0';
				RECIEVE_DATA	<= ( others => '0' );
			end if;
		end if;
	end process;

	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			TXD	<= '1';
			sft_reg_send( 17 downto 0 ) <= ( others => '1' );
			txd_en <= '0';
			txd_cnt <= ( others => '0' );
			txd_bit_cnt <= ( others => '0' );
		elsif( FPGAclk'event and FPGAclk='1') then
			SEND_DATA_EN_d <= SEND_DATA_EN;
			if( SEND_DATA_EN = '1' and SEND_DATA_EN_d = '0' )then
				sft_reg_send( 16 downto 1 ) <= SEND_DATA(15 downto 0);
				sft_reg_send( 17          ) <= '0';
				sft_reg_send(  0          ) <= '1';
				txd_en <= '1';
				txd_cnt <= ( others => '0' );
				TXD	<= '1';
			elsif( txd_en = '1' )then
				txd_cnt <= txd_cnt + X"001";
				if( txd_cnt = bps_count ) then
					txd_cnt <= ( others => '0' );
					if( txd_bit_cnt = B"1_0000" ) then
						txd_bit_cnt <= ( others => '0' );
						txd_en <= '0';
					else
						txd_bit_cnt <= txd_bit_cnt + B"0_0001";
						sft_reg_send(17 downto 1) <= sft_reg_send(16 downto 0) ;
					end if;
				end if;
				TXD	<= sft_reg_send(17);
			else
				TXD	<= '1';
				sft_reg_send( 17 downto 0 ) <= ( others => '1' );
				txd_en <= '0';
				txd_cnt <= ( others => '0' );
				txd_bit_cnt <= ( others => '0' );
			end if;
		end if;
	end process;

-----------------------------------------------------------------------------------------
end RTL;
