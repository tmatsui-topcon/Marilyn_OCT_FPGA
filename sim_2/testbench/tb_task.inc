
//------------------------------------------------------------
// Clock
//------------------------------------------------------------
initial begin
  FPGA_CLOCK = 0;
  forever begin
     #(50ns/2) FPGA_CLOCK = ~FPGA_CLOCK;
  end
end



//------------------------------------------------------------
// Reset
//------------------------------------------------------------
initial begin
  FPGA_RESET = 0;
  #10us;
  FPGA_RESET = 1;
end


////------------------------------------------------------------
//// ENC_A
////------------------------------------------------------------
//initial begin
//  ENC_A = 0;
//  #0.5us;      
//  forever begin
//     #(2us/2) ENC_A = ~ENC_A;
//  end
//end
//
////------------------------------------------------------------
//// ENC_B
////------------------------------------------------------------
//initial begin
//  ENC_B = 0;
////  #0.5us;    
//  forever begin
//     #(2us/2) ENC_B = ~ENC_B;
//  end
//end


//------------------------------------------------------------
// Register Write
//------------------------------------------------------------
task reg_write;
  input  [10:0] adr;
  input  [15:0] data;
//  begin
    #1ns;   nCS1n='d1;  nWRn3='d1;  nRD_n2='d1;  A='d0;  D_IN_EN='d0;
    #1ns;                                        A=adr;
    #5ns;   nCS1n='d0;  nWRn3='d0;                       D_IN_EN='d1; D_IN=data;
    #1.8us;             nWRn3='d1;
    #450ns;   nCS1n='d1;                           A='d0;  D_IN_EN='d0;
    #200ns;
//  end
endtask

task reg_read;
  input  [10:0] adr;
  output [15:0] data;
//  begin
    #1ns;   nCS1n='d1;  nWRn3='d1;  nRD_n2='d1;  A='d0;  D_IN_EN='d0;
    #1ns;                                        A=adr;
    #5ns;   nCS1n='d0;              nRD_n2='d0;
    #1.8us;                         nRD_n2='d1;          data=D;
    #450ns;   nCS1n='d1;                           A='d0;
    #200ns;
//  end
endtask


//------------------------------------------------------------
// Const RAM write (GAIN, COS, SIN)
//------------------------------------------------------------
integer fd  = 0;
integer ret = 0;

task const_ram_write;
  logic [15:0] data;

  //GAIN
  fd=$fopen("./data/const_gain.h","r");
 
  if (fd==0) begin
     $display("const_gain.h open errer.");
  end
  else begin
     for (int i=0; i<256; i++) begin
         ret = $fscanf(fd, "%h\n", data);
         reg_write('h0056, 'h0000+i);
         reg_write('h0057, data);
     end
  end
  $fclose(fd);
  
  //COS
  fd=$fopen("./data/const_cos.h","r");

  if (fd==0) begin
     $display("const_cos.h open errer.");
  end
  else begin
     for (int i=0; i<2048; i++) begin
         ret = $fscanf(fd, "%h\n", data);
         reg_write('h0056, 'h1000+i);
         reg_write('h0057, data);
     end
  end

  //SIN
  fd=$fopen("./data/const_sin.h","r");

  if (fd==0) begin
     $display("const_cos.h open errer.");
  end
  else begin
     for (int i=0; i<2048; i++) begin
         ret = $fscanf(fd, "%h\n", data);
         reg_write('h0056, 'h2000+i);
         reg_write('h0057, data);
     end
  end
  
endtask


