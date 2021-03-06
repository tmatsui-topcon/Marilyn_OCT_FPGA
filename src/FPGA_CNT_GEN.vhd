-- ***************************************************************************************
--		******  Copyright (c) 2007 by TOPCON Corp.  All rights reserved.  ******		--
-- ***************************************************************************************
-- File name			:FPGA_CNT_GEN.vhd : VHDL File
-- Detail of Function	:�Ŏ����_�Ŏ��g���I��p���W�b�N��H
-- Date					:070829
-- Created by			:Y.NISHIO
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Change history >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- [2007/08/29]
--  �E�V�K�쐬
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
entity FPGA_CNT_GEN is
	port(
		CLK				: in std_logic;							-- 20MHz
		n_RESET			: in std_logic;							-- Low Active
		FPGA_CNT		: out std_logic_vector(15 downto 0)		--16bit
	);
end FPGA_CNT_GEN;

--**************************************************************************************--
--********************	Architecture Body					****************************--
--**************************************************************************************--
architecture RTL of FPGA_CNT_GEN is

--**************************************************************************************--
--********************	Signal definition part				****************************--
--**************************************************************************************--
	signal	cnt_FPGA	: std_logic_vector(15 downto 0);

--**************************************************************************************--
begin

--*************** FPGA CNT GEN		****************************************************--
	U_cnt_FPGA :
	process(
		n_RESET,
		CLK
	) begin
		if(
			n_RESET = '0'
		) then
			cnt_FPGA	<= (others=>'0');
		elsif(
			CLK'event and CLK = '1'
		) then
			if(
				cnt_FPGA = "1111111111111111"
			) then
				cnt_FPGA	<= (others=>'0');
			else
				cnt_FPGA	<= cnt_FPGA + '1';
			end if;
		end if;
	end process;

	FPGA_CNT	<= cnt_FPGA;

------------------------------------------------------------------------------------------
end RTL;
