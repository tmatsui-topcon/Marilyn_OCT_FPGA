onerror { resume }
set curr_transcript [transcript]
transcript off

add wave /step_motor_1_2phase/OCT_TOP_MARILYN/OCTF_ON_OFF
add wave /step_motor_1_2phase/OCT_TOP_MARILYN/OCTF_AP
add wave /step_motor_1_2phase/OCT_TOP_MARILYN/OCTF_BP
add wave /step_motor_1_2phase/OCT_TOP_MARILYN/OCTF_AN
add wave /step_motor_1_2phase/OCT_TOP_MARILYN/OCTF_BN
add wave -unsigned /step_motor_1_2phase/OCT_TOP_MARILYN/U_OCT_TOP/U_OCT_stp/r_step_cnt
add wave /step_motor_1_2phase/OCT_TOP_MARILYN/U_OCT_TOP/nIRQ1_FPGA
wv.cursors.add -time 9400us -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 0fs -to 40525742ns
wv.time.unit.auto.set
transcript $curr_transcript
