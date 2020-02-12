`define TB_NAME Step_mot_daikei_test

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"
`include "tb_comp_step_value.inc"

  integer mcd=1;

  initial begin
    mcd = $fopen("./out/Step_mot_daikei_test_octf_motor.txt");
  end



initial begin
  wait(FPGA_RESET);
  #1us;

  reg_write( 'h06D, 'd310   ); //OCTF_Init_speed  初速=310[pps]
  reg_write( 'h06E, 'd10000 ); //OCTF_Max_speed 最高速 = 10000[pps]
  reg_write( 'h070, 'h12ED  ); //[15]OCTF_CW, [14:0] OCTF_Deceleration_step 加速/減速ステップ数 = 4845[spte]
  reg_write( 'h071, 'd2     ); //OCTF_Increase 1ステップあたりの加減速 = 2[pps]
  reg_write( 'h06F, 'h7FFF  ); //[15]OCTF_Motor_start=OFF , [14:0]OCTF_Total_step = 32767[step]

  #0.5us
  reg_write( 'h06F, 'hFFFF ); //[15]OCTF_Motor_start = ON , [14:0]OCTF_Total_step = 32767[step]

  #5.79s
  $finish;

end

endmodule