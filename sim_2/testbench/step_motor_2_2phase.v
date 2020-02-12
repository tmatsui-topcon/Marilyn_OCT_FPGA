`define TB_NAME step_motor_2_2phase

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"


initial begin
  wait(FPGA_RESET);
  #1us;

  reg_write( 'h07D, 'd400   ); //P_SW_Init_speed  èâë¨=400[pps]
  reg_write( 'h07E, 'h0000  ); //[15]P_SW_CW
  reg_write( 'h07C, 'h0005  ); //[15]P_SW_Motor_start=OFF , [14:0]OCTF_Total_step = 10[step]

  #500us
  reg_write( 'h07C, 'h8005 ); //[15]OCTF_Motor_start = ON , [14:0]OCTF_Total_step = 10[step]

  #40ms
  $finish;

end

endmodule