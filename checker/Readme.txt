
2019/05/17 山部

■ファイル一覧
ALINT-PRO_2018.07_MIX_20180517.xlsx   :ルール一覧
false_path.txt                        :設定ファイル（cdc_false_path）
filelist_verilog.txt                  :Verilogファイルリスト
filelist_vhdl.txt                     :VHDLソースファイルリスト
Readme.txt                            :本ファイル
rule_set.txt                          :設定ファイル（チェック実行ルール）
sample.sdc                            :設定ファイル（cdc）
sample.tcl                            :実行スクリプト本体
waiver.txt                            :設定ファイル（waiver）


■実行手順
1. ALINT-PRO 2018.07 SU1 64-bit Console起動
2. cd <個人フォルダのパス>\OCT_PCB_FPGA\checker
3. do sample.tcl


■レポート
1. log/console.log                 :実行ログ
2. log/report_cdc_???.csv          :クロック・ドメイン・クロッシング・レポート
3. log/report_rdc_???.txt          :リセット・ドメイン・クロッシング・レポート
4. log/report_vio_???.csv          :LINT,CDC違反箇所のレポート
5. log/report_vio_???.summary.txt  :LINT,CDC違反箇所のレポートのサマリ


■確認
1. log/console.log
   ブラックボックスを確認する
   意図しないブロックがブラックボックスにある場合はファイルリストを修正する

2. log/report_cdc_???.csv
   違反箇所を確認する
   問題ない場合、cdc_false_pathに指定する
   問題ある場合、ソードコードを修正する

3. log/report_rdc_???.txt
   意図しない非同期リセット信号がないか確認する

4. log/report_vio_???.csv
   違反箇所を確認する
   問題ない場合、waiverに指定する
   問題ある場合、ソースコードを修正する
   

5. log/report_vio_???.summary.txt
   違反数を確認する


■GUI
実行後に生成される以下のファイルをダブルクリックする
???_proj.alintproj



以上

