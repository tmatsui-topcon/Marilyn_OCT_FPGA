`define TB_NAME enc_cnt_AB_ng_test

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"

//------------------------------------------------------------
// t_ENC_A
//------------------------------------------------------------
  initial begin
    t_ENC_A = 0;
    wait(FPGA_RESET);
    #10us
    //ENC_Aパルス幅=0.7us
    //ENC_AとENC_Bの位相差=0.35us
    t_ENC_A = 0;
     #(0.7us) 
     t_ENC_A = ~t_ENC_A;
     #(0.7us)
     t_ENC_A = ~t_ENC_A;
     #(0.7us)
     t_ENC_A = ~t_ENC_A;
     #(0.7us)
     t_ENC_A = ~t_ENC_A;
     #(0.7us)
     t_ENC_A = ~t_ENC_A;
     #(0.7us)
     t_ENC_A = 0;
     #0.35us;
     
     #10us
     
     //ENC_Aパルス幅=0.6us
     //ENC_AとENC_Bの位相差=0.3us
     #(0.6us)
     t_ENC_A = ~t_ENC_A;
     #(0.6us)
     t_ENC_A = ~t_ENC_A;
     #(0.6us)
     t_ENC_A = ~t_ENC_A;
     #(0.6us)
     t_ENC_A = ~t_ENC_A;
     #(0.6us)
     t_ENC_A = ~t_ENC_A;
     #(0.6us)
     t_ENC_A = 0;
     #0.3us;
     
     #10us
     
     //ENC_Aパルス幅=0.5us
     //ENC_AとENC_Bの位相差=0.25us
      #(0.5us)
      t_ENC_A = ~t_ENC_A;
      #(0.5us)
      t_ENC_A = ~t_ENC_A;
      #(0.5us)
      t_ENC_A = ~t_ENC_A;
      #(0.5us)
      t_ENC_A = ~t_ENC_A;
      #(0.5us)
      t_ENC_A = ~t_ENC_A;
      #(0.5us)
      t_ENC_A = 0;
     
  end

//------------------------------------------------------------
// t_ENC_B
//------------------------------------------------------------
  initial begin
  t_ENC_B = 0;
  wait(FPGA_RESET);
  #10us
    t_ENC_B = 0;
    
    //ENC_Bパルス幅=0.7us
    //ENC_AとENC_Bの位相差=0.35us
    #0.35us;    
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     #(0.7us) 
     t_ENC_B = ~t_ENC_B;
     
     t_ENC_B = 0;
     #10us
     
     //ENC_Bのパルス幅=0.6us
     //ENC_AとENC_Bの位相差=0.3us
     #0.3us;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     #(0.6us) 
     t_ENC_B = ~t_ENC_B;
     
     t_ENC_B = 0;
     #10us
     
     //ENC_Bのパルス幅=0.5us
     //ENC_AとENC_Bの位相差=0.25us
     #0.25us;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
     #(0.5us) 
     t_ENC_B = ~t_ENC_B;
  end




initial begin
  wait(FPGA_RESET);
  #1us
  reg_write( 'h067, 'h2000   );
  #15us
  reg_write( 'h067, 'h6000   );
  reg_write( 'h067, 'h2000   );
  
  #10us
  reg_write( 'h067, 'h6000   );
  reg_write( 'h067, 'h2000   );
  
  #100us
  $finish;

end

endmodule