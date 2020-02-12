`define TB_NAME sim_live_cap_live_test

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"
`include "tb_comp_exp_value.inc"

  parameter P_CSTM_RESO = 512; //キャプチャスキャン中の解像度設定
  reg [11:0] t_mem_galv_x [P_CSTM_RESO - 1 : 0]; //Galv_X期待値保存用メモリ
  reg [11:0] t_mem_galv_y [P_CSTM_RESO - 1 : 0]; //Galv_Y期待値保存用メモリ

  logic [15:0] rdata;

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
  #1us;


  reg_write( 'h01A, 'h0000  ); //GAL_CNT_RESET=0


//  const_ram_write();
  
  
  
  reg_read ( 'h000, rdata   );
  
  reg_write( 'h018, 'hA002  ); //SLD_ON_OFF=1, Pulse_ON_OFF=1, Pulse_Width=12(20d)

  reg_write( 'h01B, 'h1032  ); //MODE_SEL=1(B-SCAN), FREQ_SEL=31(49)

  reg_write( 'h02F, P_CSTM_RESO   ); //Live_Resol_CSTM
  reg_write( 'h030, P_CSTM_RESO    ); //Resol_CSTM

  reg_write( 'h031, {8'hAF, 8'hAF}  ); //GalvX_Gain_Data_B, GalvX_Gain_Data
  reg_write( 'h032, {8'hAF, 8'hAF}  ); //GalvY_Gain_Data_B, GalvY_Gain_Data

  reg_write( 'h067, 'h0001  );   
  reg_write( 'h068, 'h14A3  ); //VH_sync_period 
  
  
  reg_write( 'h039, 'h0001  ); //CSTM_FLAG
  reg_write( 'h03A, 'h0000  );
  reg_write( 'h03B, 'h0001   );
  reg_write( 'h039, 'h0002  ); //SCAN_NUM
  reg_write( 'h03A, 'h0000  );
  reg_write( 'h03B, 'd0     );
  reg_write( 'h039, 'h0005  ); //LIVE_NUM
  reg_write( 'h03A, 'h0000  );
  reg_write( 'h03B, 'h0     );




  //Live
  reg_write( 'h039, 'h0006    ); //L_Start_X
  reg_write( 'h03A, 'd0       );
  reg_write( 'h03B, 'h0       );

  reg_write( 'h039, 'h0007    ); //L_Start_Y
  reg_write( 'h03A, 'd0  		);
  reg_write( 'h03B, 'h0       );

  reg_write( 'h039, 'h0008    ); //L_End_X
  reg_write( 'h03A, 'd0  		);
  reg_write( 'h03B, 'h0      );

  reg_write( 'h039, 'h0009    );//L_End_Y
  reg_write( 'h03A, 'd0 		);
  reg_write( 'h03B, 'h0       );


  
  reg_write( 'h039, 'h000D  ); //Capture Start X
  reg_write( 'h03A, 'd0      );
  reg_write( 'h03B, 'hFFF    );

  reg_write( 'h039, 'h000E  ); //Capture Start Y
  reg_write( 'h03A, 'd0     );
  reg_write( 'h03B, 'h000   );

  reg_write( 'h039, 'h000F  ); //Capture End X
  reg_write( 'h03A, 'd0     );
  reg_write( 'h03B, 'h000 );

  reg_write( 'h039, 'h0010  ); //Capture End Y
  reg_write( 'h03A, 'd0     );
  reg_write( 'h03B, 'h100 );

  reg_write( 'h039, 'h0000  ); //RAM write/read confilict
 
  #1ms
  reg_write( 'h01A, 'h6000  ); //Galv_run=1, CAP_START=1

  #1200us
  reg_write( 'h01A, 'h4000  ); //Galv_run=1, CAP_START=0

 #13900us
// #13900us
  comp_result_disp();

  $finish;

end

endmodule