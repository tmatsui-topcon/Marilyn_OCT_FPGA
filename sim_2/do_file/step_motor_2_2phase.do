onerror { resume }
set curr_transcript [transcript]
transcript off

add wave -logic /step_motor_2_2phase/OCT_TOP_MARILYN/P_SW_ON_OFF
add wave -height 17 /step_motor_2_2phase/OCT_TOP_MARILYN/P_SW_AP
add wave /step_motor_2_2phase/OCT_TOP_MARILYN/P_SW_BP
add wave /step_motor_2_2phase/OCT_TOP_MARILYN/P_SW_AN
add wave /step_motor_2_2phase/OCT_TOP_MARILYN/P_SW_BN
add wave -unsigned /step_motor_2_2phase/OCT_TOP_MARILYN/U_OCT_TOP/U_P_SW_stp/r_step_cnt
add wave /step_motor_2_2phase/OCT_TOP_MARILYN/U_OCT_TOP/nIRQ1_FPGA
wv.cursors.add -time 4ms -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 0fs -to 30024828ns
wv.time.unit.auto.set
transcript $curr_transcript
