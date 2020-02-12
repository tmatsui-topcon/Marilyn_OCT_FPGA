

set DESIGN_NAME      "OCT_TOP_MARILYN"
set DESIGN_TOP       "OCT_TOP_MARILYN"
set PROJ_NAME        ${DESIGN_NAME}_proj
set SRC_VERI_FILE    "./filelist_verilog.txt"
set SRC_VHDL_FILE    "./filelist_vhdl.txt"
set RULE_SET_FILE    "./rule_set.txt"
set SDC_FILE         "./sample.sdc"
set FALSE_PATH_FILE  "./false_path.txt"
set WAIVER_FILE      "./waiver.txt"
#set OUT_DIR          "../log/${DESIGN_NAME}"
set OUT_DIR          "./log"



###実行ログ出力
transcript file ${OUT_DIR}/console.log


###ワークスペースが存在するかチェック
###存在する場合はオープン
###存在しない場合は作成
if [file exists ${DESIGN_NAME}.alintws] {
  # Open workspace 
  workspace.open ${DESIGN_NAME}.alintws
} else {
  # Create workspace and project 
  workspace.create ${DESIGN_NAME}
  workspace.project.create ${PROJ_NAME}
}
workspace.clean -force


###Set Policy
#project.policy.clear
#project.policy.add -project $PROJ_NAME -ruleset ALDEC_CDC
#project.policy.add -project $PROJ_NAME -ruleset STARC_VLOG
#project.policy.add -project $PROJ_NAME -ruleset STARC_VHDL
#project.policy.add -project $PROJ_NAME -ruleset STARC_NETLIST
source $RULE_SET_FILE


###waiver
project.waiver.clear -project $PROJ_NAME
#project.waiver.add -f $WAIVER_FILE


###Add design file
workspace.file.add -destination $PROJ_NAME -f $SRC_VERI_FILE
workspace.file.add -destination $PROJ_NAME -f $SRC_VHDL_FILE
project.pref.toplevels -top $DESIGN_TOP

###project.descriptionstyle.add
project.descriptionstyle.add -unit stepmotor_ctrl -style rtl
project.descriptionstyle.add -unit OCT_TOP_MARILYN -style rtl



###Add SDC/ADC file
workspace.file.add -destination $PROJ_NAME $SDC_FILE


###Generate Black Box 
project.pref.generateblackbox yes



###Verilog/VHDL Standard
project.pref.vhdlstandard -project $PROJ_NAME -format vhdl93
#project.pref.vhdlstandard -project $PROJ_NAME -format vhdl2002
project.pref.vlogstandard -project $PROJ_NAME -format v2k
#project.pref.vlogstandard -project $PROJ_NAME -format sv2009


###Vendor Library
project.pref.vloglibs -project $PROJ_NAME -lib unisims_ver -lib secureip      -lib xpm
project.pref.vloglibs -project $PROJ_NAME -lib altera_ver  -lib altera_mf_ver -lib lpm_ver -lib altera_lnsim_ver


###Start Linting
project.run


###cdc false path file
#set_cdc_false_path -project $PROJ_NAME -f $FALSE_PATH_FILE


### SDC Generate
project.generate.constraints -sdc -file ${DESIGN_NAME}.sdc



####Reports
project.report.violations -format csv           -report ${OUT_DIR}/report_vio_${DESIGN_NAME}.summary.txt -summary rule
#project.report.violations -format csv           -report ${OUT_DIR}/report_vio_${DESIGN_NAME}.summary.txt -summary rule+source
project.report.violations -format csv           -report ${OUT_DIR}/report_vio_${DESIGN_NAME}.csv 
#project.report.violations -format html          -report ${OUT_DIR}/report_vio_${DESIGN_NAME}.html
#project.report.violations -format full_tex t    -report ${OUT_DIR}/report_vio_${DESIGN_NAME}_full.txt
#project.report.violations -format simple_text   -report ${OUT_DIR}/report_vio_${DESIGN_NAME}_simple.txt
project.report.cdc.csv                          -report ${OUT_DIR}/report_cdc_${DESIGN_NAME}.csv
#project.report.cdc.txt                          -report ${OUT_DIR}/report_cdc_${DESIGN_NAME}.txt
project.report.rdc.txt                          -report ${OUT_DIR}/report_rdc_${DESIGN_NAME}.txt
#project.report.synthesis                        -report ${OUT_DIR}/report_syn_${DESIGN_NAME}.txt
#project.report.fsm                              -report ${OUT_DIR}/report_fsm_${DESIGN_NAME}.txt


echo "FINISH!!!"
#quit


