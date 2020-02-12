onerror { resume }
set curr_transcript [transcript]
transcript off

add wave /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/FPGAclk
add wave /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/ENC_CNT_RST
add wave /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/ENC_CNT_EN
add wave /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/ENC_A
add wave /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/ENC_B
add wave -unsigned /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/OUT_ENC_CNT_AB
add wave -unsigned /enc_cnt_AB_ng_test/OCT_TOP_MARILYN/U_OCT_TOP/U_encoder_cnt/OUT_ENC_CNT_BA
wv.cursors.add -time 19400ns -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 0fs -to 262144ns
wv.time.unit.auto.set
transcript $curr_transcript
