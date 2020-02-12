`define TB_NAME Step_mot_sankaku_test

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"
`include "tb_comp_step_value.inc"


  integer mcd=1;

  initial begin
    mcd = $fopen("./out/Step_mot_sankaku_test_octf_motor.txt");
  end


initial begin
  wait(FPGA_RESET);
  #1us;

  reg_write( 'h06D, 'd400   ); //OCTF_Init_speed  初速=400[pps]
  reg_write( 'h06E, 'd1000 ); //OCTF_Max_speed 最高速 = 1000[pps]
  reg_write( 'h070, 'h801A  ); //[15]OCTF_CW, [14:0] OCTF_Deceleration_step 加速/減速ステップ数 = 26[spte]
  reg_write( 'h071, 'd15     ); //OCTF_Increase 1ステップあたりの加減速 = 15[pps]
  reg_write( 'h06F, 'h0035  ); //[15]OCTF_Motor_start=OFF , [14:0]OCTF_Total_step = 53[step]

  #0.5us
  reg_write( 'h06F, 'h8035 ); //[15]OCTF_Motor_start = ON , [14:0]OCTF_Total_step = 32767[step]

  #97.10ms
  $finish;

end

endmodule