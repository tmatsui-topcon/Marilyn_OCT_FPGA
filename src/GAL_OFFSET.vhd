-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:GAL_OFFSET.vhd : VHDL File			-- <<<<<< Check Version
-- Ver					:001									-- <<<<<< Check Version
-- Date					:20090708
-- Created by			:nakano
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--ガルバノオフセットをパラレル→シリアル変換して対象デバイスに送信
--CS,SCLK生成
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
ENTITY GAL_OFFSET IS
	PORT
	(
		FPGAclk 			: 	IN 	STD_LOGIC;						--20MHz
		Reset 				: 	IN 	STD_LOGIC;
		GalvX_Offset_Data	:	IN	STD_LOGIC_VECTOR(9 downto 0);
		GalvY_Offset_Data	:	IN	STD_LOGIC_VECTOR(9 downto 0);
		GalvX_Offset_Data_B	:	IN	STD_LOGIC_VECTOR(9 downto 0);
		GalvY_Offset_Data_B	:	IN	STD_LOGIC_VECTOR(9 downto 0);
		VSync_End			:	IN	STD_LOGIC;
		Galv_Run			:	IN	STD_LOGIC;
		SEL					:	IN	STD_LOGIC;
		Galv_Offset_SDI 	:	OUT	STD_LOGIC;
		Galv_Offset_CLK		:	OUT	STD_LOGIC;
		nGalvX_Offset_CS	:	OUT	STD_LOGIC;
		nGalvY_Offset_CS	:	OUT	STD_LOGIC
		);
END  GAL_OFFSET;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
ARCHITECTURE RTL OF GAL_OFFSET IS

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal reg_Galv_Offset_CLK		:	std_logic;
	signal reg_Galv_Offset_SDI 		: 	std_logic;
	signal reg_clk_cnt				:	std_logic_vector(2 downto 0);
	signal reg_nGalvX_Offset_CS		:	std_logic;
	signal reg_nGalvY_Offset_CS		:	std_logic;
	signal reg_GalvX_Offset_Data	:	std_logic_vector(9 downto 0);
	signal reg_GalvY_Offset_Data	:	std_logic_vector(9 downto 0);
	signal reg_Offset_Sft_X			:	std_logic_vector(15 downto 0);
	signal reg_Offset_Sft_Y			:	std_logic_vector(15 downto 0);
	signal reg_Offset_org_X			:	std_logic_vector(9 downto 0);
	signal reg_Offset_org_Y			:	std_logic_vector(9 downto 0);
	signal send_cnt_x				:	std_logic_vector(3 downto 0);
	signal send_cnt_y				:	std_logic_vector(3 downto 0);
	signal cs_wait   				:	std_logic_vector(3 downto 0);
	signal reg_cs_x_en				:	std_logic;
	signal reg_cs_y_en				:	std_logic;
	signal reg_Galv_Run				:	std_logic;
	signal reg_VSync_End			:	std_logic;
	signal reg_VSync_End_1d			:	std_logic;
	signal reg_Vsync_End_Edge		:	std_logic;
	signal reg_SEL					:	std_logic;
	signal reg_SEL_edge				:	std_logic;
	signal reg_SEL_edge_d			:	std_logic;
	signal reg_SEL_edge_2d			:	std_logic;
	signal reg_SEL_nedge			:	std_logic;
	signal reg_SEL_nedge_d			:	std_logic;
	signal reg_SEL_nedge_2d			:	std_logic;

--**************************************************************************************--
--********************	State Machine Definition Part		   *************************--
--**************************************************************************************--
	TYPE STATE_TYPE is(
						INIT,
						WAIT_VSYNC_END,
						CS_ASSERT_X,
						GAIN_OUT_X,
						CS_NEGATE_X,
						CS_ASSERT_Y,
						GAIN_OUT_Y,
						CS_NEGATE_Y,
						CHECK
					);
	
	signal CURRENT_STATE	:	STATE_TYPE;

-----------------------------------------------------------------------------------------
begin

-----------------------------------------------------------------------------------------
	Galv_Offset_SDI   <= reg_Galv_Offset_SDI;
	nGalvX_Offset_CS  <= reg_nGalvX_Offset_CS;
	nGalvY_Offset_CS  <= reg_nGalvY_Offset_CS;
	Galv_Offset_CLK   <= reg_Galv_Offset_CLK;

-----------------------------------------------------------------------------------------
	U_TMP :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_GalvX_Offset_Data <= (others=>'0');
			reg_GalvY_Offset_Data <= (others=>'0');
			reg_VSync_End		  <= '0';
			reg_VSync_End_1d	  <= '0';
			reg_Galv_Run		  <= '0';
			reg_Vsync_End_Edge	  <= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			if( SEL = '0') then
				reg_GalvX_Offset_Data <= GalvX_Offset_Data;
			else 
				reg_GalvX_Offset_Data <= GalvX_Offset_Data_B;
			end if;
			if( SEL = '0') then
				reg_GalvY_Offset_Data <= GalvY_Offset_Data;
			else 
				reg_GalvY_Offset_Data <= GalvY_Offset_Data_B;
			end if;
			reg_VSync_End		<= VSync_End;
			reg_VSync_End_1d	<= reg_VSync_End;
			reg_VSync_End_Edge	<= reg_VSync_End and not(reg_Vsync_End_1d);
			reg_Galv_Run		<= Galv_Run;
			reg_SEL				<= SEL;
			reg_SEL_edge		<= SEL and not(reg_SEL);
			reg_SEL_edge_d		<= reg_SEL_edge;
			reg_SEL_edge_2d		<= reg_SEL_edge_d;
			reg_SEL_nedge		<= not(SEL) and reg_SEL;
			reg_SEL_nedge_d		<= reg_SEL_nedge;
			reg_SEL_nedge_2d	<= reg_SEL_nedge_d;
		end if;
	end process;

	U_GAIN_OUT :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_Galv_Offset_SDI   <= '0';
			reg_nGalvX_Offset_CS  <= '1';
			reg_nGalvY_Offset_CS  <= '1';
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when CS_ASSERT_X	=>
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_X(15);
					if(reg_cs_x_en = '1') then
						reg_nGalvX_Offset_CS  <= '0';
					else
						reg_nGalvX_Offset_CS  <= '1';
					end if;
					reg_nGalvY_Offset_CS  <= '1';
				when GAIN_OUT_X	=>	
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_X(15);
					if(reg_cs_x_en = '1') then
						reg_nGalvX_Offset_CS  <= '0';
					else
						reg_nGalvX_Offset_CS  <= '1';
					end if;
					reg_nGalvY_Offset_CS  <= '1';
				when CS_NEGATE_X	=>
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_X(15);
					if(reg_cs_x_en = '1') then
						reg_nGalvX_Offset_CS  <= '0';
					else
						reg_nGalvX_Offset_CS  <= '1';
					end if;
					reg_nGalvY_Offset_CS  <= '1';
				when CS_ASSERT_Y	=>
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_Y(15);
					reg_nGalvX_Offset_CS  <= '1';
					if(reg_cs_y_en = '1') then
						reg_nGalvY_Offset_CS  <= '0';
					else
						reg_nGalvY_Offset_CS  <= '1';
					end if;
				when GAIN_OUT_Y	=>	
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_Y(15);
					reg_nGalvX_Offset_CS  <= '1';
					if(reg_cs_y_en = '1') then
						reg_nGalvY_Offset_CS  <= '0';
					else
						reg_nGalvY_Offset_CS  <= '1';
					end if;
				when CS_NEGATE_Y	=>
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_Y(15);
					reg_nGalvX_Offset_CS  <= '1';
					if(reg_cs_y_en = '1') then
						reg_nGalvY_Offset_CS  <= '0';
					else
						reg_nGalvY_Offset_CS  <= '1';
					end if;
				when others =>
					reg_Galv_Offset_SDI   <= reg_Offset_Sft_X(15);
					reg_nGalvX_Offset_CS  <= '1';
					reg_nGalvY_Offset_CS  <= '1';
			end case;
		end if;
	end process;

	U_COUNT_CLK :
	process( Reset, FPGAclk) 
	begin
		if( Reset = '1') then
			reg_clk_cnt <= (others=>'0');
			reg_Galv_Offset_CLK	<= '0';
		elsif( FPGAclk'event and FPGAclk='1') then
			reg_Galv_Offset_CLK	<= reg_clk_cnt(2);
			case CURRENT_STATE is
				when GAIN_OUT_X	=>	
					reg_clk_cnt <= reg_clk_cnt + "001";
				when GAIN_OUT_Y	=>	
					reg_clk_cnt <= reg_clk_cnt + "001";
				when others	=> reg_clk_cnt <= "000";
			end case;
		end if;
	end process;

	U_SHIFT_REG:
	process( reset, fpgaclk) 
	begin
		if( Reset = '1') then
			reg_Offset_Sft_X      <= (others=>'0');
			reg_Offset_Sft_Y      <= (others=>'0');
			send_cnt_x            <= (others=>'0');
			send_cnt_y            <= (others=>'0');
			reg_Offset_org_X      <= (others=>'0');
			reg_Offset_org_Y      <= (others=>'0');
			cs_wait				  <= (others=>'0');
			reg_cs_x_en			  <= '1';
			reg_cs_y_en			  <= '1';
		elsif( FPGAclk'event and FPGAclk='1') then
			case CURRENT_STATE is
				when INIT			=>
					reg_Offset_Sft_X <= "000" & B"01_1111_1111" & "000";
					reg_Offset_Sft_Y <= "000" & B"01_1111_1111" & "000";
					send_cnt_y     <= (others=>'1');
				when CS_ASSERT_X	=>
					cs_wait <= cs_wait + "0001";
				when GAIN_OUT_X		=>	
					cs_wait <= (others=>'0');
					if( reg_clk_cnt = "111" ) then
						reg_Offset_Sft_X(15 downto 0) <= reg_Offset_Sft_X(14 downto 0) & '0';
						send_cnt_x                 <= send_cnt_x+ "0001";
						send_cnt_y                 <= (others=>'0');
					end if;
				when CS_NEGATE_X	=>
					if(cs_wait = X"4")then
						cs_wait <= (others=>'0');
					else
						cs_wait <= cs_wait + "0001";
					end if;
					reg_cs_x_en <= '0';
				when CS_ASSERT_Y	=>
					cs_wait <= cs_wait + "0001";
				when GAIN_OUT_Y		=>	
					cs_wait <= (others=>'0');
					if( reg_clk_cnt = "111" ) then
						reg_Offset_Sft_Y(15 downto 0) <= reg_Offset_Sft_Y(14 downto 0) & '0';
						send_cnt_x     			   <= (others=>'0');
						send_cnt_y     			   <= send_cnt_y + "0001";
					end if;
				when CS_NEGATE_Y	=>
					cs_wait  		 <= cs_wait + "0001";
					reg_cs_y_en      <= '0';
				when CHECK			=>
					cs_wait <= (others=>'0');
					if(reg_Offset_org_X /= reg_GalvX_Offset_Data ) then
						reg_Offset_org_X <= reg_GalvX_Offset_Data;
						reg_Offset_Sft_X <= "000" & reg_GalvX_Offset_Data & "000";
						reg_cs_x_en      <= '1';
					end if;
					if( reg_Offset_org_Y /= reg_GalvY_Offset_Data)then
						reg_Offset_org_Y <= reg_GalvY_Offset_Data;
						reg_Offset_Sft_Y <= "000" & reg_GalvY_Offset_Data & "000";
						reg_cs_y_en      <= '1';
					end if;
				when WAIT_VSYNC_END	=>
					cs_wait <= (others=>'0');
					if(reg_Offset_org_X /= reg_GalvX_Offset_Data ) then
						reg_Offset_org_X <= reg_GalvX_Offset_Data;
						reg_Offset_Sft_X <= "000" & reg_GalvX_Offset_Data & "000";
						reg_cs_x_en      <= '1';
					end if;
					if( reg_Offset_org_Y /= reg_GalvY_Offset_Data)then
						reg_Offset_org_Y <= reg_GalvY_Offset_Data;
						reg_Offset_Sft_Y <= "000" & reg_GalvY_Offset_Data & "000";
						reg_cs_y_en      <= '1';
					end if;
				when others =>
					cs_wait <= (others=>'0');
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
					if(send_cnt_y = "1111") then
						CURRENT_STATE <= WAIT_VSYNC_END;
					end if;
				when WAIT_VSYNC_END	=>
					if( reg_VSync_End_Edge = '1' or reg_Galv_Run = '0'or reg_SEL_edge_2d = '1' or reg_SEL_nedge_2d = '1') then
						CURRENT_STATE <= CS_ASSERT_X;
					end if;
				when CS_ASSERT_X	=>
					if(cs_wait = X"4")then
						CURRENT_STATE <= GAIN_OUT_X;
					end if;
				when GAIN_OUT_X		=>
					if(send_cnt_x = B"1111" and reg_clk_cnt = "111") then
						CURRENT_STATE <= CS_NEGATE_X;
					end if;
				when CS_NEGATE_X	=>
					if(cs_wait = X"4")then
						CURRENT_STATE <= CS_ASSERT_Y;
					end if;
				when CS_ASSERT_Y	=>
					if(cs_wait = X"4")then
						CURRENT_STATE <= GAIN_OUT_Y;
					end if;
				when GAIN_OUT_Y		=>
					if(send_cnt_y = B"1111" and reg_clk_cnt = "111") then
						CURRENT_STATE <= CS_NEGATE_Y;
					end if;
				when CS_NEGATE_Y	=>
					if(cs_wait = X"4")then
						CURRENT_STATE <= CHECK;
					end if;
				when CHECK		=>
					if(reg_Offset_org_X /= reg_GalvX_Offset_Data or reg_Offset_org_Y /= reg_GalvY_Offset_Data) then
						CURRENT_STATE <= WAIT_VSYNC_END;
					end if;
				when others => null;
			end case;
		end if;
	end process;


					
-----------------------------------------------------------------------------------------
END RTL;
