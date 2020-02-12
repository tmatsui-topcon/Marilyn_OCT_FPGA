###�e�X�g�P�[�X���X�g�ɋL�ڂ��Ă���e�X�g�P�[�X�����ԂɎ��s
proc sim_run {tst_name} { 
  
  ###�V�~�����[�V�������������s���A�V�~�����[�V�����g�`�̕ۑ�����w��
  asim +accb +access +r +w_nets+p+/$tst_name -dataset ./out/$tst_name -ieee_nowarn  $tst_name
  
  ###���s���O�o��
  transcript file ./out/$tst_name/sim.log   

  ###�S�Ă̐M�����L���v�`��
  log -rec /* 
  
  ###�V�~�����[�V�������s
  run -all
  endsim
  
}

###�e�X�g�P�[�X���X�g
set tst_list [list ]
lappend tst_list step_motor_1_2phase
lappend tst_list step_motor_2_2phase
lappend tst_list Step_mot_sankaku_test
lappend tst_list Step_mot_daikei_test ;#��`�쓮�̓V�~�����[�V�������Ԃ�2���Ԃ�����̂Œ���
lappend tst_list sim_live_cap_live_test
lappend tst_list enc_cnt_AB_test
lappend tst_list enc_cnt_BA_test
lappend tst_list  enc_cnt_AB_ng_test
lappend tst_list LCMOS_MisTrigger_ok
lappend tst_list LCMOS_MisTrigger_ng_ninus1
lappend tst_list LCMOS_MisTrigger_ng_pluse1

 

###�f�U�C�����C�u�����쐬
alib work

###���[�J�����C�u�����폜
adel -all


###VHDL�t�@�C�����X�g��IEEE 2008�ŃR���p�C��
acom -dbg -quiet -2008  -f filelist_vhdl.txt

###Verilog�t�@�C�����X�g���R���p�C��
alog -dbg -quiet -f filelist_vlog.txt

###Verilog�e�X�g�P�[�X���R���p�C��
alog -dbg -quiet -f filelist_testbench.txt


###�e�X�g�P�[�X�ؑ�
foreach i $tst_list {
  sim_run $i 
}


###�e�X�g�I����A�R���\�[����ʂ����
quit -force 