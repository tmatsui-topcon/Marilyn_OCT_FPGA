2020/1/29 ����

�V�~�����[�V�����̎��s���@���������B

�����̓t�@�C���ꗗ
do_file/*                             :�V�~�����[�V�����g�`�\��do�t�@�C��
data/*                                :FPGA������RAM�̏����l�t�@�C��
exp/*                                 :���Ғl�t�@�C�����i�[����t�H���_
testbench/*                           :�e�X�g�x���`�ƃe�X�g�P�[�X���i�[����t�H���_
filelist_vlog.txt                     :Verilog�t�@�C�����X�g
filelist_vhdl.txt                     :VHDL�\�[�X�t�@�C�����X�g
filelist_testbench.txt                :�e�X�g�x���`�t�@�C�����X�g(Verilog)
Readme.txt                            :�{�t�@�C��
run.tcl                               :�V�~�����[�V�������stcl


���o�̓t�@�C��
out/<�e�X�g�P�[�X��>/dataset.asdb     :�V�~�����[�V�����g�`
out/<�e�X�g�P�[�X��>/sim.log          :�V�~�����[�V�������O
out/<�e�X�g�P�[�X��>_octf_motor.txt   :OCT���Ń��[�^�EDump�t�@�C��
out/<�e�X�g�P�[�X��>_octf_motor.txt   :OCT���Ń��[�^�EDump�t�@�C��


�����s�菇
1. Riviera-PRO 2018.10 64-bit Console�N��
2. cd <�l�t�H���_�̃p�X>/Marilyn_OCT_FPGA_v***/sim_2
3. do run.tcl


���V�~�����[�V�������s����e�X�g�P�[�X�̑I����@
run.tcl���C������B
  step_motor_2_2phase���V�~�����[�V�������s���Ȃ��ꍇ�́A
  �擪��"#"�����ăR�����g�A�E�g����B
  #lappend tst_list step_motor_2_2phase


�����ʊm�F���@
1.out/<�e�X�g�P�[�X��>/sim.log����������Ă��邱�Ƃ��m�F����B
	���Ғl��r���L�q���Ă���e�X�g�x���`�ɂ��ẮA���ʂ̃R�����g���\������̂Ŋm�F����B

2.Riviera-PRO 2018.10 64-bit(GUI)���J���B
	�@File menue -> open -> File ->dataset.asdb(�V�~�����[�V�����g�`)���J���B
	�Atool menue -> Excecute Macro -> sim2/do_file/<�e�X�g�x���`��>.do�t�@�C����I������ƁA�e�X�g�ɕK�v�Ȕg�`���\������      ��B
	
	do�t�@�C���ɕۑ����Ă���g�`�ȊO��ǉ�����ꍇ�́A���LRivera-PRO�g���[�j���O���� p.23���Q�Ƃ��Ēǉ�����B
	\\topsv07\user\�g�v�R��\�y���J�{�z\�q�d�J�r\�kE�J���l\�t�@�[���E�F�A\FC_Tool\Aldec\tool_training
	Riviera-PRO_Basic_Training_20180807.pdf
	
	

�ȏ�

