###テストケースリストに記載してあるテストケースを順番に実行
proc sim_run {tst_name} { 
  
  ###シミュレーション初期化を行い、シミュレーション波形の保存先を指定
  asim +accb +access +r +w_nets+p+/$tst_name -dataset ./out/$tst_name -ieee_nowarn  $tst_name
  
  ###実行ログ出力
  transcript file ./out/$tst_name/sim.log   

  ###全ての信号をキャプチャ
  log -rec /* 
  
  ###シミュレーション実行
  run -all
  endsim
  
}

###テストケースリスト
set tst_list [list ]
lappend tst_list step_motor_1_2phase
lappend tst_list step_motor_2_2phase
lappend tst_list Step_mot_sankaku_test
lappend tst_list Step_mot_daikei_test ;#台形駆動はシミュレーション時間が2時間かかるので注意
lappend tst_list sim_live_cap_live_test
lappend tst_list enc_cnt_AB_test
lappend tst_list enc_cnt_BA_test
lappend tst_list  enc_cnt_AB_ng_test
lappend tst_list LCMOS_MisTrigger_ok
lappend tst_list LCMOS_MisTrigger_ng_ninus1
lappend tst_list LCMOS_MisTrigger_ng_pluse1

 

###デザインライブラリ作成
alib work

###ローカルライブラリ削除
adel -all


###VHDLファイルリストをIEEE 2008でコンパイル
acom -dbg -quiet -2008  -f filelist_vhdl.txt

###Verilogファイルリストをコンパイル
alog -dbg -quiet -f filelist_vlog.txt

###Verilogテストケースをコンパイル
alog -dbg -quiet -f filelist_testbench.txt


###テストケース切替
foreach i $tst_list {
  sim_run $i 
}


###テスト終了後、コンソール画面を閉じる
quit -force 