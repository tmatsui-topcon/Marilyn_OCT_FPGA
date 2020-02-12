## Generated SDC file "maestroII_OCT.sdc"

## Copyright (C) 2016  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

## DATE    "Tue Aug 08 18:14:02 2017"

##
## DEVICE  "10M25DCF256C8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {fpga_clock} -period 50.000 -waveform { 0.000 25.000 } [get_ports {FPGA_CLOCK}]
create_clock -name {nRD_n2} -period 50.000 -waveform { 0.000 25.000 } [get_ports {nRD_n2}]
create_clock -name {nWRn3} -period 50.000 -waveform { 0.000 25.000 } [get_ports {nWRn3}]
create_clock -name {GAL_CON:U_GAL_CON|sig_D_inc_25_latch_clk} -period 50.000 -waveform { 0.000 25.000 } [get_registers {GAL_CON:U_GAL_CON|sig_D_inc_25_latch_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name CSTM_MOVE_END_out -source [get_ports {FPGA_CLOCK}] [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|CSTM_MOVE_END_out}]
create_generated_clock -name cstm_wr_en -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GPIO_cstm:U_GPIO_cstm|cstm_wr_en}]
create_generated_clock -name cstm_wr_adr_10 -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GPIO_cstm:U_GPIO_cstm|cstm_wr_adr[10]}]
create_generated_clock -name sig_Trig_en -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|sig_TRIG_EN}]
create_generated_clock -name sig_RetryFlag2_EN -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|sig_RetryFlag2_EN}]
create_generated_clock -name sig_RetryFlag1_EN -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|sig_RetryFlag1_EN}]
create_generated_clock -name sig_Raster_Scan_CNT_UP_clk -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|sig_Raster_Scan_CNT_UP_clk}]
create_generated_clock -name sig_VH_Gen_EN -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|comp_VHsync_gen:U_comp_VHsync_gen|sig_VH_Gen_EN}]
create_generated_clock -name sig_Trig -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|comp_VHsync_gen:U_comp_VHsync_gen|sig_TRIG}]
create_generated_clock -name Gal_Clk -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|Gal_clk}]
create_generated_clock -name END_MOVE_CSTM -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|CURRENT_STATE.END_MOVE_CSTM}]
create_generated_clock -name INITIAL_STATE -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|CURRENT_STATE.INITIAL}]
create_generated_clock -name sig_Raster_Y_inc_clk -source FPGA_CLOCK [get_registers {OCT_TOP:U_OCT_TOP|GAL_CON:U_GAL_CON|sig_Raster_Y_inc_clk}]


#create_generated_clock -name {CSTM_MOVE_END_out} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|CSTM_MOVE_END_out}] 
#create_generated_clock -name {cstm_wr_en} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GPIO_cstm:U_GPIO_cstm|cstm_wr_en}] 
#create_generated_clock -name {cstm_wr_adr_10} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GPIO_cstm:U_GPIO_cstm|cstm_wr_adr[10]}] 
#create_generated_clock -name {sig_Trig_en} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|sig_TRIG_EN}] 
#create_generated_clock -name {sig_RetryFlag2_EN} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|sig_RetryFlag2_EN}] 
#create_generated_clock -name {sig_RetryFlag1_EN} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|sig_RetryFlag1_EN}] 
#create_generated_clock -name {sig_Raster_Scan_CNT_UP_clk} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|sig_Raster_Scan_CNT_UP_clk}] 
#create_generated_clock -name {sig_VH_Gen_EN} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|comp_VHsync_gen:U_comp_VHsync_gen|sig_VH_Gen_EN}] 
#create_generated_clock -name {sig_Trig} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|comp_VHsync_gen:U_comp_VHsync_gen|sig_TRIG}] 
#create_generated_clock -name {sig_Hsync} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|comp_VHsync_gen:U_comp_VHsync_gen|sig_Hsync}] ‚¢‚ç‚È‚¢
#create_generated_clock -name {Gal_Clk} -source [get_ports {FPGA_CLOCK}] -divide_by 4 -master_clock {fpga_clock} [get_registers { GAL_CON:U_GAL_CON|Gal_clk }] 
#create_generated_clock -name {END_MOVE_CSTM} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|CURRENT_STATE.END_MOVE_CSTM}] 
#create_generated_clock -name {INITIAL_STATE} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|CURRENT_STATE.INITIAL}] 
#create_generated_clock -name {sig_Raster_Y_inc_clk} -source [get_ports {FPGA_CLOCK}] -master_clock {fpga_clock} [get_registers {GAL_CON:U_GAL_CON|sig_Raster_Y_inc_clk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {fpga_clock}]  2.000 [get_ports {A[0]}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}]  2.000 [get_ports {A[1]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_registers {GPIO:U_GPIO|reg_GAL_CNT_RESET}] 


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

