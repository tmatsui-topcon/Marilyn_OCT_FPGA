## Generated SDC file "marilyn_OCT.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Mon Dec 16 19:37:28 2019"

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


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {A[*]}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {D[*]}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {DIP_SW[*]}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {ENC_A}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {ENC_B}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {LCMOS_MisTrigger}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {nCS1n}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {nRD_n2}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {nWRn3}]
set_input_delay -add_delay  -clock [get_clocks {fpga_clock}] 20 [get_ports {FPGA_RESET}]



#**************************************************************
# Set Output Delay
#**************************************************************
#20nsで設定する
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ1_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ2_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ3_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ4_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ5_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ6_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nIRQ7_FPGA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nGalvX_SYNC}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nGalvY_SYNC}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_SCLK}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_SDIN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nGalvX_GAIN_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_GAIN_SDI}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_GAIN_CLK}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nGalvX_OS_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nGalvY_OS_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_OS_DIN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {Galv_OS_SCLK}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {LCMOS_Hsync}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {SLD_REF_SCLK}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {SLD_REF_DIN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nSLD_REF_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nSLD_LIMIT_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {PER_REF_SCLK}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {PER_REF_DIN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {nPER_RES_CS}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {SLD_PULSE}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D_LINE_AP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D_LINE_BP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D_LINE_AN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D_LINE_BN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D_LINE_ON_OFF}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {POLA_AP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {POLA_BP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {POLA_AN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {POLA_BN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {POLA_ON_OFF}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {OCTF_AP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {OCTF_BP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {OCTF_AN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {OCTF_BN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {OCTF_ON_OFF}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {P_SW_AP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {P_SW_BP}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {P_SW_AN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {P_SW_BN}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {P_SW_ON_OFF}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {MOT_PWMSW}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {MOT_ENABLE}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {MOT_DIR}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {MOT_PHA}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {CP8}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {CP9}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {CP10}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {CP11}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {CP12}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {D[*]}]
set_output_delay -add_delay  -clock [get_clocks {fpga_clock}]  20 [get_ports {RDnWR}]



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



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

