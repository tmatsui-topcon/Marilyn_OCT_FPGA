2020/1/29 松井

シミュレーションの実行方法を説明する。

■入力ファイル一覧
do_file/*                             :シミュレーション波形表示doファイル
data/*                                :FPGA内部のRAMの初期値ファイル
exp/*                                 :期待値ファイルを格納するフォルダ
testbench/*                           :テストベンチとテストケースを格納するフォルダ
filelist_vlog.txt                     :Verilogファイルリスト
filelist_vhdl.txt                     :VHDLソースファイルリスト
filelist_testbench.txt                :テストベンチファイルリスト(Verilog)
Readme.txt                            :本ファイル
run.tcl                               :シミュレーション実行tcl


■出力ファイル
out/<テストケース名>/dataset.asdb     :シミュレーション波形
out/<テストケース名>/sim.log          :シミュレーションログ
out/<テストケース名>_octf_motor.txt   :OCT合焦モータ・Dumpファイル
out/<テストケース名>_octf_motor.txt   :OCT合焦モータ・Dumpファイル


■実行手順
1. Riviera-PRO 2018.10 64-bit Console起動
2. cd <個人フォルダのパス>/Marilyn_OCT_FPGA_v***/sim_2
3. do run.tcl


■シミュレーション実行するテストケースの選択方法
run.tclを修正する。
  step_motor_2_2phaseをシミュレーション実行しない場合は、
  先頭に"#"をつけてコメントアウトする。
  #lappend tst_list step_motor_2_2phase


■結果確認方法
1.out/<テストケース名>/sim.logが生成されていることを確認する。
	期待値比較が記述してあるテストベンチについては、結果のコメントが表示されので確認する。

2.Riviera-PRO 2018.10 64-bit(GUI)を開く。
	①File menue -> open -> File ->dataset.asdb(シミュレーション波形)を開く。
	②tool menue -> Excecute Macro -> sim2/do_file/<テストベンチ名>.doファイルを選択すると、テストに必要な波形が表示され      る。
	
	doファイルに保存してある波形以外を追加する場合は、下記Rivera-PROトレーニング資料 p.23を参照して追加する。
	\\topsv07\user\トプコン\【製開本】\〈Ｅ開〉\〔E開成〕\ファームウェア\FC_Tool\Aldec\tool_training
	Riviera-PRO_Basic_Training_20180807.pdf
	
	

以上

