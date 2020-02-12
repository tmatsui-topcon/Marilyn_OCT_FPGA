`define TB_NAME step_motor_1_2phase

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"


initial begin
  wait(FPGA_RESET);
  #1us;

  reg_write( 'h06D, 'd400   ); //OCTF_Init_speed  初速=400[pps]
  reg_write( 'h06E, 'd400 );  //OCTF_Max_speed 最高速 = 400[pps]
  reg_write( 'h070, 'h0000  ); //[15]OCTF_CW, [14:0] OCTF_Deceleration_step 加速/減速ステップ数 = 0[spte]
  reg_write( 'h071, 'd0     ); //OCTF_Increase 1ステップあたりの加減速 = 0[pps]
  reg_write( 'h06F, 'h000A  ); //[15]OCTF_Motor_start=OFF , [14:0]OCTF_Total_step = 10[step]

  #500us
  reg_write( 'h06F, 'h800A ); //[15]OCTF_Motor_start = ON , [14:0]OCTF_Total_step = 10[step]

  #40ms
  $finish;

end

endmodule