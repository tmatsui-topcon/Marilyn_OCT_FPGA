onerror { resume }
set curr_transcript [transcript]
transcript off

add wave -logic /enc_cnt_BA_test/OCT_TOP_MARILYN/U_OCT_TOP/U_GPIO/ENC_CNT_RST
add wave -logic /enc_cnt_BA_test/OCT_TOP_MARILYN/U_OCT_TOP/U_GPIO/ENC_CNT_EN
add wave /enc_cnt_BA_test/OCT_TOP_MARILYN/ENC_A
add wave /enc_cnt_BA_test/OCT_TOP_MARILYN/ENC_B
add wave -unsigned -literal /enc_cnt_BA_test/OCT_TOP_MARILYN/U_OCT_TOP/U_GPIO/ENC_CNT_AB
add wave -unsigned /enc_cnt_BA_test/OCT_TOP_MARILYN/U_OCT_TOP/U_GPIO/ENC_CNT_BA
wv.cursors.add -time 122us -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 0fs -to 524288ns
wv.time.unit.auto.set
transcript $curr_transcript
