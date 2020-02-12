`define TB_NAME enc_cnt_AB_test

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"

//------------------------------------------------------------
// t_ENC_A
//------------------------------------------------------------
  initial begin
    t_ENC_A = 0;
  //  #0.5us;      
    forever begin
       #(2us/2) t_ENC_A = ~t_ENC_A;
    end
  end

//------------------------------------------------------------
// t_ENC_B
//------------------------------------------------------------
  initial begin
    t_ENC_B = 0;
    #0.5us;    
    forever begin
       #(2us/2) t_ENC_B = ~t_ENC_B;
    end
  end




initial begin
  wait(FPGA_RESET);
  #1us
  reg_write( 'h067, 'h2000   );
  
  #20us
  reg_write( 'h067, 'h6000   );
  
  #1us
  reg_write( 'h067, 'h2000   );
  
  #60us
  reg_write( 'h067, 'h0000   );
  
  #100us
  $finish;

end

endmodule