onerror { resume }
set curr_transcript [transcript]
transcript off

add wave /LCMOS_MisTrigger_ok/OCT_TOP_MARILYN/LCMOS_MisTrigger
add wave -unsigned /LCMOS_MisTrigger_ok/OCT_TOP_MARILYN/U_OCT_TOP/U_err_det/LCMOS_MisTrigger_cnt
add wave /LCMOS_MisTrigger_ok/OCT_TOP_MARILYN/LCMOS_Hsync
add wave -unsigned /LCMOS_MisTrigger_ok/OCT_TOP_MARILYN/U_OCT_TOP/U_err_det/hsync_cnt
add wave /LCMOS_MisTrigger_ok/OCT_TOP_MARILYN/U_OCT_TOP/nIRQ4_FPGA
wv.cursors.add -time 31650us -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 419589993ps -to 33974022ns
wv.time.unit.auto.set
transcript $curr_transcript
