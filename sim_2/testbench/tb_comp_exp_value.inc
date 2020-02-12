//------------------------------------------------------------
// Galv期待値比較
//------------------------------------------------------------

   wire [11:0]		t_X_GALV;
   wire [11:0]		t_Y_GALV;
   wire [11:0]		t_Start_X;
   wire [11:0]		t_Start_Y;
   wire [11:0]		t_End_X;
   wire [11:0]		t_End_Y;	
   wire				t_cstm_CapScanNow_Flag;
   wire				t_Gal_clk;
   integer          t_Gal_clk_cnt=0;
   reg				t_miss_galv_x=1'b0;
   reg				t_miss_galv_y=1'b0;
   wire				t_OUT_VH_SYNC;
   wire				t_OUT_HSYNC;
   wire				t_OUT_SLD_PULSE;

   integer			t_cnt_OUT_VH_SYNC=0;
   integer			t_cnt_OUT_HSYNC=0;
   integer			t_cnt_OUT_SLD_PULSE=0;


   initial begin
      $signal_agent ( "OCT_TOP_MARILYN.U_OCT_TOP.U_GAL_CON.X_galv","t_X_GALV", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.U_OCT_TOP.U_GAL_CON.Y_galv", "t_Y_GALV", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.U_OCT_TOP.U_GAL_CON.Gal_clk","t_Gal_clk", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.LCMOS_Hsync", "t_OUT_VH_SYNC", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.U_OCT_TOP.U_comp_sync_gen.OUT_HSYNC", "t_OUT_HSYNC", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.SLD_PULSE", "t_OUT_SLD_PULSE", 1 );
      $signal_agent ( "OCT_TOP_MARILYN.U_OCT_TOP.U_CustomScan.cstm_CapScanNow_Flag", "t_cstm_CapScanNow_Flag", 1 );
   end




  //GAL_CONモジュール Galv出力データ期待値比較
   always@(negedge t_Gal_clk)begin
      if(t_cstm_CapScanNow_Flag == 1'b1 )begin
         if(t_Gal_clk_cnt < P_CSTM_RESO)begin //t_Gal_clk_cnt < P_CSTM_RESO : 解像度以上は期待値読み出しアドレスをホールドする。
            t_Gal_clk_cnt <= t_Gal_clk_cnt + 1'b1;
         end

         if(t_X_GALV != t_mem_galv_x[t_Gal_clk_cnt])begin
            $display("galv_x err!! galv_x(%d) != expect_galv_x(%d)",t_X_GALV, t_mem_galv_x[t_Gal_clk_cnt]);
            t_miss_galv_x <= 1'b1;
         end
         
         if(t_Y_GALV != t_mem_galv_y[t_Gal_clk_cnt])begin
            $display("galv_y err!! galv_y(%d) != expect_galv_y(%d)",t_Y_GALV, t_mem_galv_y[t_Gal_clk_cnt]);
            t_miss_galv_y <= 1'b1;
         end
      
      end
   end

   //ラインセンサ外部同期信号出力パルス数確認
   always@(posedge t_OUT_VH_SYNC )begin
      if(t_cstm_CapScanNow_Flag == 1'b1 )begin
         t_cnt_OUT_VH_SYNC <= t_cnt_OUT_VH_SYNC + 1;
      end
   end
   
   always@(posedge t_OUT_HSYNC )begin
      if(t_cstm_CapScanNow_Flag == 1'b1 )begin
         t_cnt_OUT_HSYNC <= t_cnt_OUT_HSYNC + 1;
      end
   end
   
   //SLDパルス数確認
   always@(posedge t_OUT_SLD_PULSE )begin
      if(t_cstm_CapScanNow_Flag == 1'b1 )begin
         t_cnt_OUT_SLD_PULSE <= t_cnt_OUT_SLD_PULSE + 1;
      end
   end
      
//------------------------------------------------------------
// 期待値ファイル読み出し
//------------------------------------------------------------
   initial begin
      for (int i=0; i< P_CSTM_RESO; i++) begin
        t_mem_galv_x[i]=13'd0;
        t_mem_galv_y[i]=13'd0;
      end
      
      //Galv期待値読み出し
       fd=$fopen("./exp/galv_data.txt","r");
      
      
      if (fd==0) begin
         $display("galv_data.txt open errer.");
      end
      else begin
         for (int i=0; i< P_CSTM_RESO; i++) begin
             ret = $fscanf(fd, "%d,%d\n" , t_mem_galv_x[i],t_mem_galv_y[i]);
         end
      end
      $fclose(fd);
      
   end
   
//------------------------------------------------------------
// 期待値比較結果表示
//------------------------------------------------------------

   task comp_result_disp;
      if(t_miss_galv_x==1)begin
      	$display("galv_x errer.");
      end 
      else begin
      	$display("galv_x check OK.");
      end
      
      if(t_miss_galv_y==1)begin
      	$display("galv_y errer.");
      end
      else begin
      	$display("galv_y check OK.");
      end
      
      if(t_cnt_OUT_HSYNC != P_CSTM_RESO+2 || t_cnt_OUT_VH_SYNC != P_CSTM_RESO+3)begin
        $display("VHsync pulse_cnt errer.");
      end
      else begin
        $display("VHsync pulse_cnt OK");
      end
      
      if(t_cnt_OUT_SLD_PULSE != P_CSTM_RESO+2)begin
        $display("SLD pulse_cnt errer.");
      end
      else begin
        $display("SLD pulse_cnt OK");
      end
   endtask

