
//-------------------------------------
// OCT���Ń��[�^�f�[�^�擾
//------------------------------------
	wire 		t_Motro_on;
	wire		t_Motor_AP;
	wire		t_Motor_BP;
	wire		t_Motor_AN;
	wire		t_Motor_BN;


	initial begin
		$signal_agent ( "OCT_TOP_MARILYN.OCTF_ON_OFF", "t_Motro_on", 1 );
		$signal_agent ( "OCT_TOP_MARILYN.OCTF_AP"    , "t_Motor_AP", 1 );
		$signal_agent ( "OCT_TOP_MARILYN.OCTF_BP"    , "t_Motor_BP", 1 );
		$signal_agent ( "OCT_TOP_MARILYN.OCTF_AN"    , "t_Motor_AN", 1 );
		$signal_agent ( "OCT_TOP_MARILYN.OCTF_BN"    , "t_Motor_BN", 1 );
	end



//--------------------------------------
// OCT���Ń��[�^����p���X�Ԋu����
//--------------------------------------
	reg [15:0] t_step_cycle_cnt = 16'd0;
	reg [14:0] t_step_cnt = 15'd0;
	reg [3:0]  t_mot_edge[1:0];
	reg [1:0]  t_mot_on_fall_edge;

	initial begin
		t_mot_edge[0] 		<= 4'd0;
		t_mot_edge[1] 		<= 4'd0;
		t_mot_on_fall_edge  <= 2'd0;
	end

	always @(posedge FPGA_CLOCK )begin
		if(t_Motro_on == 1'b0)begin
			t_mot_edge[0] <= {t_Motor_AP ,t_Motor_BP,t_Motor_AN,t_Motor_BN};
			t_mot_edge[1] <= {t_Motor_AP ,t_Motor_BP,t_Motor_AN,t_Motor_BN};
		end 
		else if(t_Motro_on == 1'b1)begin
			t_mot_edge[0] <= {t_Motor_AP ,t_Motor_BP,t_Motor_AN,t_Motor_BN};
			t_mot_edge[1] <= t_mot_edge[0];
		end
	end

	always @(posedge FPGA_CLOCK)begin
		t_mot_on_fall_edge <= {t_mot_on_fall_edge[0] , t_Motro_on};
	end

	
	//�p���X�Ԋu�J�E���g
	always @(posedge  FPGA_CLOCK )begin
		if(t_mot_on_fall_edge==2'b10)begin
			t_step_cycle_cnt <= 16'd0;
		end 
		else if(t_mot_edge[0] != t_mot_edge[1] )begin
			t_step_cycle_cnt <= 16'd0;
		end
		else begin
			t_step_cycle_cnt <= t_step_cycle_cnt + 1'b1;
		end
	end
	
	//�X�e�b�v���J�E���g
	always @(posedge  FPGA_CLOCK)begin
		if(t_mot_edge[0] != t_mot_edge[1])begin
			t_step_cnt <= t_step_cnt + 1'b1;
		end
		else if(t_mot_on_fall_edge==2'b10)begin
			t_step_cnt <= t_step_cnt + 1'b1;
		end
	end


//-----------------------------------------
// ���肵���p���X�Ԋu��txt�t�@�C���ŏo��
//-----------------------------------------
	always @(posedge  FPGA_CLOCK)begin
		if(t_step_cnt > 0)begin
			if(t_mot_edge[0] != t_mot_edge[1])begin
				$fdisplay(mcd, "%d , %d", t_step_cnt, t_step_cycle_cnt);//
			end
			else if(t_mot_on_fall_edge==2'b10)begin
				$fdisplay(mcd, "%d , %d", t_step_cnt, t_step_cycle_cnt);//
			end
		end
	end

	
	
	