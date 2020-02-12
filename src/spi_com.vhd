-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:spi_com.vhd : VHDL File
-- Detail of Function	:FPGAコンフィグ用のSPIフラッシュコントロール
-- Date					:121018
-- Created by			:Nakano
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
entity SPI_COM is
	port(
		FPGAclk		:	in	std_logic;
		nReset		:	in	std_logic;
		ROM_ADR		:	in	std_logic_vector( 23 downto 0 );
		ROM_DATA	:	in	std_logic_vector( 7 downto 0 );
		ROM_ERASE	:	in	std_logic;
		ROM_WRITE	:	in	std_logic;
		ROM_READ 	:	in	std_logic;
		SPI_DIN		:	in	std_logic;
		BUSY   		:	out	std_logic;
		READ_DATA	:	out std_logic_vector( 7 downto 0);
		SPI_CSOB	:	out	std_logic;
		SPI_MOSI	:	out	std_logic;
		SPI_CCLK	:	out	std_logic
	);
end SPI_COM;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture RTL of SPI_COM is


--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal		clk_cnt     	: std_logic_vector(1 downto 0 )	;
	signal		sft_reg     	: std_logic_vector(39 downto 0 );
	signal		sft_reg_stat	: std_logic_vector(7 downto 0 ) ;
	signal		sft_reg_read	: std_logic_vector(7 downto 0 ) ;
	signal		clk_en 			: std_logic						;
	signal		reg_spi_clk 	: std_logic						;
	signal		reg_s			: std_logic						;
	signal		reg_busy		: std_logic						;
	signal		send_cnt		: std_logic_vector(7 downto 0)	;
	signal		reg_rom_write 	: std_logic						;
	signal		reg_rom_erase 	: std_logic						;
	signal		reg_dout		: std_logic						;
	signal		end_cnt			: std_logic_vector(1 downto 0)	;
	signal		end_s_read_flg	: std_logic;
	signal		end_s_stat_flg	: std_logic;

	TYPE STATE_TYPE is (
							IDLE			,
							START_WREN_S	,
							SEND_WREN_CMD	,
							END_WREN_S		,
							START_BERS_S	,
							SEND_BERS_CMD	,
							END_BERS_S		,
							START_RDSR_S	,
							SEND_RDSR_CMD	,
							END_RDSR_S		,
							START_RD_S		,
							SEND_RD_CMD		,
							END_RD_S		,
							START_WR_S		,
							SEND_WR_CMD		,
							END_WR_S		
						);
	signal SPI_STATE : STATE_TYPE;
--**************************************************************************************--
begin

	BUSY   		 <=	reg_busy;
	SPI_CSOB	 <=	reg_s;
	SPI_MOSI	 <=	reg_dout;
	SPI_CCLK	 <= reg_spi_clk;
	READ_DATA	 <= sft_reg_read;

	process( nReset, FPGAclk) 
	begin
		if( nReset = '0') then
			clk_cnt     (1 downto 0 )	<= (others => '0');
			sft_reg     (39 downto 0 )	<= (others => '0');
			sft_reg_stat(7 downto 0 ) 	<= (others => '0');
			sft_reg_read(7 downto 0) 	<= (others => '0');
			clk_en 						<= '0';
			reg_spi_clk 				<= '1';
			reg_s						<= '1';
			reg_busy					<= '0';
			send_cnt	(7 downto 0)	<= (others => '0');
			reg_dout					<= '0';
			end_cnt		(1 downto 0)	<= (others => '0');
			end_s_read_flg				<= '0';
			end_s_stat_flg				<= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( clk_en = '1' )then
				clk_cnt <= clk_cnt + "01";
				if(clk_cnt = "01")then
					reg_spi_clk <= '0';
				elsif(clk_cnt = "11")then
					reg_spi_clk <= '1';
				end if;
			else
				clk_cnt <= "00";
				reg_spi_clk <= '1';
			end if;

			if( SPI_STATE = IDLE )then
				reg_busy <= '0';
			else
				reg_busy <= '1';
			end if;

			if( SPI_STATE = SEND_RD_CMD )then
				end_s_read_flg <= '0';
				if( send_cnt > X"1f" )then
					if( clk_cnt = "00") then
						sft_reg_read(0) <= SPI_DIN;
						sft_reg_read(7 downto 1) <= sft_reg_read(6 downto 0);
					end if;
				end if;
			elsif( SPI_STATE = END_RD_S )then
				if( clk_cnt = "00"  and end_s_read_flg = '0') then
					end_s_read_flg <= '1';
					sft_reg_read(0) <= SPI_DIN;
					sft_reg_read(7 downto 1) <= sft_reg_read(6 downto 0);
				end if;
			end if;

			reg_dout <= sft_reg(39);
			if( SPI_STATE = START_WREN_S )then
				sft_reg(39 downto 32) <= X"06";			-- Write Enable Command
			elsif(	SPI_STATE = START_BERS_S)then
				sft_reg(39 downto 32) <= X"C7";			-- Bulk Erase Command
			elsif(	SPI_STATE = START_RDSR_S)then
				sft_reg(39 downto 32) <= X"05";			-- status read Command
			elsif(	SPI_STATE = START_WR_S)then
				sft_reg(39 downto 32) <= X"02";			-- page program Command
				sft_reg(31 downto 8 ) <= ROM_ADR;
				sft_reg( 7 downto 0 ) <= ROM_DATA;
			elsif(	SPI_STATE = START_RD_S)then
				sft_reg(39 downto 32) <= X"03";			-- byte read Command
				sft_reg(31 downto 8 ) <= ROM_ADR;
				sft_reg( 7 downto 0 ) <= X"00";
			elsif( SPI_STATE = SEND_RD_CMD )then
				if( clk_cnt = "01") then
					sft_reg(39 downto 1) <= sft_reg(38 downto 0);
				end if;
			elsif( SPI_STATE = SEND_WREN_CMD or
			    SPI_STATE = SEND_BERS_CMD or
				SPI_STATE = SEND_WR_CMD     )then
				if( clk_cnt = "01") then
					sft_reg(39 downto 1) <= sft_reg(38 downto 0);
				end if;
			elsif( SPI_STATE = SEND_RDSR_CMD )then
				end_s_stat_flg <= '0';
				if( clk_cnt = "01") then
					sft_reg(39 downto 1) <= sft_reg(38 downto 0);
				end if;
				if( send_cnt > X"07" )then
					if( clk_cnt = "00") then
						sft_reg_stat(0) <= SPI_DIN;
						sft_reg_stat(7 downto 1) <= sft_reg_stat(6 downto 0);
					end if;
				end if;
			elsif( SPI_STATE = END_RDSR_S )then
				if( clk_cnt = "00" and end_s_stat_flg = '0') then
					end_s_stat_flg <= '1';
					sft_reg_stat(0) <= SPI_DIN;
					sft_reg_stat(7 downto 1) <= sft_reg_stat(6 downto 0);
				end if;
			end if;

			if( SPI_STATE = END_WREN_S or
			    SPI_STATE = END_BERS_S or
				SPI_STATE = END_RDSR_S or
				SPI_STATE = END_WR_S   or
				SPI_STATE = END_RD_S)then
				if( end_cnt = "11" ) then
					reg_s <= '1';
				end if;
				clk_en <= '0';
				--send_cnt <= (others=>'0');
				end_cnt <= end_cnt + "01";
			elsif( SPI_STATE = SEND_RDSR_CMD or
				   SPI_STATE = SEND_WREN_CMD or
			       SPI_STATE = SEND_BERS_CMD or
				   SPI_STATE = SEND_RD_CMD   or
				   SPI_STATE = SEND_WR_CMD     )then
				end_cnt <= (others => '0');
				if( clk_cnt = "00") then
					send_cnt <= send_cnt + X"01";
				end if;
			elsif( SPI_STATE = START_RDSR_S or
				   SPI_STATE = START_WREN_S or
			       SPI_STATE = START_BERS_S or
				   SPI_STATE = START_RD_S   or
				   SPI_STATE = START_WR_S     )then
				end_cnt <= (others => '0');
				sft_reg_stat <= (others => '0');
				send_cnt <= (others=>'0');
				clk_en <= '1';
			--	if( clk_cnt = "11" ) then
				reg_s <= '0';
		--		end if;
			end if;
		end if;
	end process;
	
	process( nReset, FPGAclk) 
	begin
		if( nReset = '0') then
			reg_rom_write <= '0';
			reg_rom_erase <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SPI_STATE = IDLE )then
				if(ROM_WRITE = '1')then
					reg_rom_write <= '1';
				end if;
				if(ROM_ERASE = '1')then
					reg_rom_erase <= '1';
				end if;
			elsif( SPI_STATE = START_WR_S or
				   SPI_STATE = START_BERS_S)then
				reg_rom_write <= '0';
				reg_rom_erase <= '0';
			end if;
		end if;
	end process;
		
	process( nReset, FPGAclk) 
	begin
		if( nReset = '0') then
			SPI_STATE <= IDLE;
		elsif( FPGAclk'event and FPGAclk='1') then
			case SPI_STATE is
				when IDLE	=>
					if( ROM_WRITE = '1' or ROM_ERASE = '1') then
						SPI_STATE <= START_WREN_S;
					elsif( ROM_READ = '1' )then
						SPI_STATE <= START_RD_S;
					end if;
				when START_WREN_S	=>
					if( clk_cnt = "11" )then
						SPI_STATE <= SEND_WREN_CMD;
					end if;
				when SEND_WREN_CMD	=>
					if( clk_cnt = "11" and send_cnt = X"07")then
						SPI_STATE <= END_WREN_S;
					end if;
				when END_WREN_S	=>
					if( end_cnt = "11" )then
						if( reg_rom_write = '1') then
							SPI_STATE <= START_WR_S;
						elsif( reg_rom_erase = '1') then
							SPI_STATE <= START_BERS_S;
						else
							SPI_STATE <= IDLE;
						end if;
					end if;
				when START_RD_S =>
					if( clk_cnt = "11" )then
						SPI_STATE <= SEND_RD_CMD;
					end if;
				when SEND_RD_CMD	=>
					if( clk_cnt = "11" and send_cnt = X"27")then
						SPI_STATE <= END_RD_S;
					end if;
				when END_RD_S	=>
					if( end_cnt = "11" )then
						SPI_STATE <= IDLE;
					end if;
				when START_WR_S	=>
					if( clk_cnt = "11" )then
						SPI_STATE <= SEND_WR_CMD;
					end if;
				when SEND_WR_CMD	=>
					if( clk_cnt = "11" and send_cnt = X"27")then
						SPI_STATE <= END_WR_S;
					end if;
				when END_WR_S	=>
					if( end_cnt = "11" )then
						SPI_STATE <= START_RDSR_S;
					end if;
				when START_BERS_S	=>
					if( clk_cnt = "11" )then
						SPI_STATE <= SEND_BERS_CMD;
					end if;
				when SEND_BERS_CMD	=>
					if( clk_cnt = "11" and send_cnt = X"07")then
						SPI_STATE <= END_BERS_S;
					end if;
				when END_BERS_S	=>
					if( end_cnt = "11" )then
						SPI_STATE <= START_RDSR_S;
					end if;
				when START_RDSR_S	=>
					if( clk_cnt = "11" )then
						SPI_STATE <= SEND_RDSR_CMD;
					end if;
				when SEND_RDSR_CMD	=>
					if( clk_cnt = "11" and send_cnt = X"0f")then
						SPI_STATE <= END_RDSR_S;
					end if;
				when END_RDSR_S	=>
					if( end_cnt = "11" ) then
						if(sft_reg_stat(0) = '0')then
							SPI_STATE <= IDLE;
						else
							SPI_STATE <= START_RDSR_S;
						end if;
					end if;
			end case;
		end if;
	end process;
--*************** ハードウェアバージョン出力 ******************************************--
-----------------------------------------------------------------------------------------
end RTL;
