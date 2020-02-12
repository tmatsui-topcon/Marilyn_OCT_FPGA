`define TB_NAME LCMOS_MisTrigger_ng_ninus1

module `TB_NAME();


`include "tb_instance.inc"
`include "tb_task.inc"

  parameter P_CSTM_RESO = 512; //キャプチャスキャン中の解像度設定

  logic [15:0] rdata;


//------------------------------------------------------------
// LCMOS_MisTrig信号生成
//------------------------------------------------------------
  reg t_LCMOS_MisTrig_gen;
  reg t_LCMOS_MisTrig_en;

  initial begin
    t_LCMOS_MisTrig_gen = 0;
    #3.2ms;
      forever begin
      t_LCMOS_MisTrig_gen = 1;
      #5us;
      t_LCMOS_MisTrig_gen = 0;
      #45us;
      end
  end

//------------------------------------------------------------
// LCMOS_MisTrig信号 512パルス生成
//------------------------------------------------------------
  initial begin
  	t_LCMOS_MisTrig_en = 1;
  	#3.2ms;
  	#25.61ms;
  	t_LCMOS_MisTrig_en = 0;
  end

  assign t_LCMOS_MisTrig = t_LCMOS_MisTrig_gen & t_LCMOS_MisTrig_en;


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

  reg_write( 'h01B, 'h1014  ); //MODE_SEL=1(B-SCAN), FREQ_SEL=14(20kHz)

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

 #31.65ms

  $finish;

end

endmodule