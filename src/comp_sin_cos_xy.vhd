--**************************************************************************************--
--		******  Copyright (c) 2008 by TOPCON Corp.  All rights reserved.  ******		--
--**************************************************************************************--
-- File name			:comp_sin_cos_xy.vhd
-- Detail of Function	:generate X/Y data from SIN-COS table
-- Ver					:001									-- <<<<<< Check Version --
-- Date					:080630
-- Created by			:Y.Nishio
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- [2008/06/30 : 001]
--  ÅEêVãKçÏê¨
--**************************************************************************************--

LIBRARY ieee;
LIBRARY lpm;
LIBRARY altera_mf;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--  Entity Declaration

ENTITY COMP_SIN_COS_XY IS
	PORT
	(
		FPGAclk 			: IN STD_LOGIC;
		Reset 				: IN STD_LOGIC;
		gal_clk_fall_edge	: IN STD_LOGIC;
		RAM_CONST_DATA 	: IN STD_LOGIC_VECTOR(15 downto 0);
		RAM_CONST_ADR  	: IN STD_LOGIC_VECTOR(15 downto 0);
		COS_TABLE_EN	: IN STD_LOGIC;
		SIN_TABLE_EN	: IN STD_LOGIC;
		Rdaddress : IN STD_LOGIC_VECTOR(11 downto 0);	-- 0 -> 4095 (0Åã->360Åã)
		Circle_R : IN STD_LOGIC_VECTOR(11 downto 0);	-- îºåa
		Start_X : IN STD_LOGIC_VECTOR(11 downto 0);		-- ÉXÉ^Å[ÉgXç¿ïW(L_RÇ≈àŸÇ»ÇÈ)
		Start_Y : IN STD_LOGIC_VECTOR(11 downto 0);		-- ÉXÉ^Å[ÉgYç¿ïW(L_RÇ≈àŸÇ»ÇÈ)
--		ROMclk : IN STD_LOGIC;							-- SIN-COS table read clk
		ROM_EN : IN STD_LOGIC;							-- SIN-COS table read enable
--		L_R    : IN STD_LOGIC;							-- ç∂âEñ⁄îªï  '1'=R  '0'=L
		X_DATA : OUT STD_LOGIC_VECTOR(11 downto 0);		-- Xç¿ïWèoóÕ
		Y_DATA : OUT STD_LOGIC_VECTOR(11 downto 0)		-- Yç¿ïWèoóÕ
	);
END COMP_SIN_COS_XY;


ARCHITECTURE RTL OF COMP_SIN_COS_XY IS


	COMPONENT alt_ram_cos IS
	PORT
	(
		rdclock		: IN STD_LOGIC  ;
		rden		: IN STD_LOGIC	;
		wrclock		: IN STD_LOGIC;
		data		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
	END COMPONENT;


	COMPONENT alt_mult_12x12 IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
	END COMPONENT;
	
	signal sig_Rdaddress : std_logic_vector(10 downto 0);
	signal sig_ROM_CLK   : std_logic;
	signal sig_ROM_EN    : std_logic;
	signal sig_Add_Sub_Flag : std_logic_vector(1 downto 0);
	signal read_address_delay : std_logic_vector(1 downto 0);
	signal sig_Add_Sub_Flag_shift_2 : std_logic_vector(1 downto 0);
	signal sig_Cos_Data_lat : std_logic_vector(10 downto 0);
	signal sig_Sin_Data_lat : std_logic_vector(10 downto 0);
	signal sig_Circle_R : std_logic_vector(11 downto 0);
	signal sig_Cos_Mul_Data_24bit : std_logic_vector(23 downto 0);
	signal sig_Sin_Mul_Data_24bit : std_logic_vector(23 downto 0);
	signal sig_Cos_Mul_Data_12bit : std_logic_vector(11 downto 0);
	signal sig_Sin_Mul_Data_12bit : std_logic_vector(11 downto 0);
	signal sig_R_Scan_X : std_logic_vector(11 downto 0);
	signal sig_R_Scan_Y : std_logic_vector(11 downto 0);
	signal sig_Cos_ROM_Data : std_logic_vector(10 downto 0);
	signal sig_Sin_ROM_Data : std_logic_vector(10 downto 0);
	signal rom_rd_en		: std_logic;
	
	signal ext_Cos_ROM_Data : std_logic_vector(11 downto 0);
	signal ext_Sin_ROM_Data : std_logic_vector(11 downto 0);
	
begin
	
	
--	sig_ROM_CLK <= ROMclk;
	sig_ROM_EN <= ROM_EN;
	sig_Circle_R <= Circle_R;
	
	
	rom_rd_en <= ROM_EN and gal_clk_fall_edge;
-----------------------------------------------------------------------------------------
--component M4K RAM for Circle-Scan------------------------------------------------------
	sig_Rdaddress <= Rdaddress(10 downto 0);


	U_alt_rom_cos_4096 : alt_ram_cos port map(
		wrclock		=> FPGAclk,
		rden		=> rom_rd_en,
		rdclock		=> FPGAclk,
		data		=> RAM_CONST_DATA(10 downto 0) ,
		rdaddress	=> sig_Rdaddress,
		wraddress	=> RAM_CONST_ADR(10 downto 0),
		wren		=> COS_TABLE_EN	,
		q			=> sig_Cos_ROM_Data		--11bit
	);


	U_alt_rom_sin_4096 : alt_ram_cos port map(
		wrclock		=> FPGAclk,
		rdclock		=> FPGAclk,
		rden		=> rom_rd_en,
		data		=> RAM_CONST_DATA (10 downto 0),
		rdaddress	=> sig_Rdaddress,
		wraddress	=> RAM_CONST_ADR(10 downto 0),
		wren		=> SIN_TABLE_EN	,
		q			=> sig_Sin_ROM_Data		--11bit
	);





--Internal singal sig_Add_Sub_Flag----------------------------------------------------
--Internal singal sig_Cos_Data_12
--Internal singal sig_Sin_Data_12
--	process(Reset,sig_ROM_CLK) begin
--		if(Reset='1') then
--			sig_Add_Sub_Flag <= (others => '0');
--			sig_Cos_Data_12bit  <= (others => '0');
--			sig_Sin_Data_12bit  <= (others => '0');
--		elsif(sig_ROM_CLK'event and sig_ROM_CLK='1') then
--			sig_Add_Sub_Flag <= Rdaddress(11 downto 10);
--			sig_Cos_Data_12bit  <= '0' & sig_Cos_ROM_Data;	--12bitÇ…åÖÇ†ÇÌÇπ
--			sig_Sin_Data_12bit  <= '0' & sig_Sin_ROM_Data;	--12bitÇ…åÖÇ†ÇÌÇπ
--		end if;
--	end process;


	--GAL_CLKóßâ∫ÇËÇ≈ROMÉfÅ[É^ÉâÉbÉ`
	process( Reset, FPGAclk )begin
		if( Reset='1' ) then
			sig_Cos_Data_lat  <= (others => '0');
			sig_Sin_Data_lat  <= (others => '0');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( gal_clk_fall_edge = '1' )then
				sig_Cos_Data_lat  <= sig_Cos_ROM_Data;
				sig_Sin_Data_lat  <= sig_Sin_ROM_Data;
			end if;
		end if;
	end process;
	
	ext_Cos_ROM_Data <= '0' & sig_Cos_Data_lat;
	ext_Sin_ROM_Data <= '0' & sig_Sin_Data_lat;



--Internal signal sig_Add_Sub_Flag_shift
--ROM ÇÃèoóÕÇ™1clkíxÇÍÇÈÇÃÇ≈ÇªÇÍÇ…Ç†ÇÌÇπÇƒÉtÉâÉOÇÉVÉtÉg
	process(Reset,FPGAclk) begin
		if(Reset='1') then
			read_address_delay <= (others=>'0');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( gal_clk_fall_edge = '1' and ROM_EN = '1' )then
				read_address_delay <= Rdaddress(11 downto 10);
			end if;
		end if;
	end process;

--component 12x12 MULT-------------------------------------------------------------------
	U_alt_mult_12x12_Cos :alt_mult_12x12 port map(
		dataa		=> sig_Circle_R				,	--12bit
		datab		=> ext_Cos_ROM_Data		,	--12bit
		result		=> sig_Cos_Mul_Data_24bit		--24bit
	);
--component 12x12 MULT-------------------------------------------------------------------
	U_alt_mult_12x12_Sin :alt_mult_12x12 port map(
		dataa		=> sig_Circle_R				,	--12bit
		datab		=> ext_Sin_ROM_Data		,	--12bit
		result		=> sig_Sin_Mul_Data_24bit		--24bit
	);


--11bit sift-----------------------------------------------------------------------------
	sig_Cos_Mul_Data_12bit <= sig_Cos_Mul_Data_24bit(22 downto 11);
	sig_Sin_Mul_Data_12bit <= sig_Sin_Mul_Data_24bit(22 downto 11);

--Calculate X OUT DATA ------------------------------------------------------------------
--	U_R_Scan_X : process(Reset,FPGAclk) begin
--		if(Reset='1') then
--			sig_R_Scan_X <= (others=>'0');
--		elsif(FPGAclk'event and FPGAclk='1') then
--			if(ROM_EN = '1') then
----				if(L_R = '1') then	--R eye
----					if(sig_Add_Sub_Flag_shift_2 = "00" ) then	--0ÅãÅ`90Åã
----						sig_R_Scan_X <= Start_X + sig_Circle_R - sig_Cos_Mul_Data_12bit;
----					elsif(sig_Add_Sub_Flag_shift_2 = "01") then	--90ÅãÅ`180Åã
----						sig_R_Scan_X <= Start_X + sig_Circle_R + sig_Cos_Mul_Data_12bit;
----					elsif(sig_Add_Sub_Flag_shift_2 = "10") then	--180ÅãÅ`270Åã
----						sig_R_Scan_X <= Start_X + sig_Circle_R + sig_Cos_Mul_Data_12bit;
----					elsif(sig_Add_Sub_Flag_shift_2 = "11") then	--270ÅãÅ`360Åã
----						sig_R_Scan_X <= Start_X + sig_Circle_R - sig_Cos_Mul_Data_12bit;
----					end if;
----				else				--L eye
--					if(sig_Add_Sub_Flag_shift_2 = "00") then	--0ÅãÅ`90Åã
--						sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit;
--					elsif(sig_Add_Sub_Flag_shift_2 = "01") then	--90ÅãÅ`180Åã
--						sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit;
--					elsif(sig_Add_Sub_Flag_shift_2 = "10") then	--180ÅãÅ`270Åã
--						sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit;
--					elsif(sig_Add_Sub_Flag_shift_2 = "11") then	--270ÅãÅ`360Åã
--						sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit;
--					end if;
----				end if;
--			end if;
--		end if;
--	end process;


--Calculate X OUT DATA ------------------------------------------------------------------
--	process(Reset,FPGAclk) begin
--		if( Reset='1' ) then
--			sig_R_Scan_X <= (others=>'0');
--		elsif(FPGAclk'event and FPGAclk='1') then
--			if( gal_clk_fall_edge = '1' and ROM_EN = '1' )then
--				if(read_address_delay = "00") then	--0ÅãÅ`90Åã
--					sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit;
--				elsif(read_address_delay = "01") then	--90ÅãÅ`180Åã
--					sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit;
--				elsif(read_address_delay = "10") then	--180ÅãÅ`270Åã
--					sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit;
--				elsif(read_address_delay = "11") then	--270ÅãÅ`360Åã
--					sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit;
--				end if;
--			end if;
--		end if;
--	end process;

	process(Reset,FPGAclk) begin
		if( Reset='1' ) then
			sig_R_Scan_X <= (others=>'0');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( gal_clk_fall_edge = '1' and ROM_EN = '1' )then
				case read_address_delay is
					when "00"	=> sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit; --0ÅãÅ`90Åã
					when "01"	=> sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit; --90ÅãÅ`180Åã
					when "10"	=> sig_R_Scan_X <= Start_X - sig_Circle_R + sig_Cos_Mul_Data_12bit; --180ÅãÅ`270Åã
					when "11"	=> sig_R_Scan_X <= Start_X - sig_Circle_R - sig_Cos_Mul_Data_12bit; --270ÅãÅ`360Åã
					when others	=> sig_R_Scan_X <= (others=>'0');
				end case;
			end if;
		end if;
	end process;



--Calculate Y OUT DATA ------------------------------------------------------------------
--	U_R_Scan_Y : process(Reset,FPGAclk) begin
--		if(Reset='1') then
--			sig_R_Scan_Y <= (others=>'1');
--		elsif(FPGAclk'event and FPGAclk='1') then
--			if(ROM_EN = '1') then
--				if(sig_Add_Sub_Flag_shift_2 = "00" or sig_Add_Sub_Flag_shift_2 = "01") then	--0ÅãÅ`180Åã
--					sig_R_Scan_Y <= Start_Y + sig_Sin_Mul_Data_12bit;
--				elsif(sig_Add_Sub_Flag_shift_2 = "10" or sig_Add_Sub_Flag_shift_2 = "11") then	--180ÅãÅ`360Åã
--					sig_R_Scan_Y <= Start_Y - sig_Sin_Mul_Data_12bit;
--				end if;
--			end if;
--		end if;
--	end process;

--	U_R_Scan_Y : process(Reset,FPGAclk) begin
	process(Reset,FPGAclk) begin
		if( Reset='1' ) then
			sig_R_Scan_Y <= (others=>'1');
		elsif(FPGAclk'event and FPGAclk='1') then
			if( gal_clk_fall_edge = '1' and ROM_EN = '1'  )then
				if(read_address_delay = "00" or read_address_delay = "01") then	--0ÅãÅ`180Åã
					sig_R_Scan_Y <= Start_Y + sig_Sin_Mul_Data_12bit;
				elsif(read_address_delay = "10" or read_address_delay = "11") then	--180ÅãÅ`360Åã
					sig_R_Scan_Y <= Start_Y - sig_Sin_Mul_Data_12bit;
				end if;				
			end if;
		end if;
	end process;



X_DATA <= sig_R_Scan_X;
Y_DATA <= sig_R_Scan_Y;

end RTL;
