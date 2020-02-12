onerror { resume }
set curr_transcript [transcript]
transcript off

add wave /LCMOS_MisTrigger_ng_pluse1/OCT_TOP_MARILYN/LCMOS_MisTrigger
add wave -unsigned /LCMOS_MisTrigger_ng_pluse1/OCT_TOP_MARILYN/U_OCT_TOP/U_err_det/LCMOS_MisTrigger_cnt
add wave /LCMOS_MisTrigger_ng_pluse1/OCT_TOP_MARILYN/LCMOS_Hsync
add wave -unsigned /LCMOS_MisTrigger_ng_pluse1/OCT_TOP_MARILYN/U_OCT_TOP/U_err_det/hsync_cnt
add wave /LCMOS_MisTrigger_ng_pluse1/OCT_TOP_MARILYN/U_OCT_TOP/nIRQ4_FPGA
wv.cursors.add -time 31936325ns -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 0fs -to 67108864ns
wv.time.unit.auto.set
transcript $curr_transcript
