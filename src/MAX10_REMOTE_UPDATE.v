/******************************************************************************
Module:     MAX10_REMOTE_UPDATE
Date:       27 OCT 2015
Settings:   Tabstop = 2

Purpose:
Check the loaded configuration, and if it isn't the application image switch to
it.  Also kicks the watchdog to keep things alive.

******************************************************************************/

module MAX10_REMOTE_UPDATE
  (
    Clock,
    RuReset,
    ReloadApplication,
    ApplicationError
  );

  input           Clock;                    //FPGA Primary Synchronous Clock
  input           RuReset;                  //Reset for Remote Update logic
  input           ReloadApplication;        //Start a reload of the application image
  
  output          ApplicationError;         //An error was detected on application image load
  
  //Internal Wires
  wire            RuDout;                   //Serial output data bit from module
  reg     [13: 0] RuDinVal;                 //Value to store on a load
  reg             RuDinLd;                  //Load a new value
  reg             RuDinSft;                 //Shift the value one bit
  reg             RuDoutStr;                //Store data from module
  reg     [ 5: 0] BitCntVal;                //Value to store on a load
  reg             BitCntLd;                 //Load a new value
  reg             BitCntDec;                //Decrement bit counter
  reg             Config1Str;               //Store the configuration bits
  reg             Config2Str;               //Store the configuration bits
  reg             Config3Str;               //Store the configuration bits
  reg             RuShiftNLd;               //ShiftNLd input to module
  reg             RuCaptNUpdt;              //CaptNUpdt input to module
  reg             RuConfig;                 //Config input to module
  reg             DelayLd;                  //Load delay register with 10s delay
  
  //Internal Registers
  reg     [ 4: 0] WatchdogKick;             //Register to kick the watchdog timer
  reg     [13: 0] RuDin;                    //Shift register for data input to module
  reg     [33: 0] RuDoutReg;                //Shift register for data output from module
  reg     [ 7: 0] Config1;                  //Configuration from the ambiguous Application 1
  reg     [ 7: 0] Config2;                  //Configuration from the ambiguous Application 2
  reg     [ 3: 0] ConfigCurrent;            //Configuration from the current state
  reg     [ 5: 0] BitCnt;                   //Bit counter for handling shift operations
  reg     [31: 0] DelayCnt;                 //Delay counter
  reg             ApplicationError;         //Register output
  
  //Delay counter for watching this happen
  always @(posedge Clock)
  begin
    if(RuReset)
      DelayCnt <= 32'd10;
    else if(DelayLd)
      DelayCnt <= 32'd10;
    else if(DelayCnt != 32'b0)
      DelayCnt <= DelayCnt - 32'd1;
    else
      DelayCnt <= DelayCnt;
  end
  
  //Shift register for write data
  always @(posedge Clock)
  begin
    if(RuReset)
      RuDin <= 14'b0;
    else if(RuDinLd)
      RuDin <= RuDinVal;
    else if(RuDinSft)
      RuDin <= {1'b0, RuDin[13:1]};
    else
      RuDin <= RuDin;
  end
  
  //Shift register for read data
  always @(posedge Clock)
  begin
    if(RuReset)
      RuDoutReg <= 34'b0;
    else if(RuDoutStr)
      RuDoutReg <= {RuDout, RuDoutReg[33:1]};
    else
      RuDoutReg <= RuDoutReg;
  end
  
  //Register to store register data
  always @(posedge Clock)
  begin
    if(RuReset)
      Config1 <= 8'b0;
    else if(Config1Str)
      Config1 <= {RuDoutReg[31:28], RuDoutReg[25:22]};
    else
      Config1 <= Config1;
  end
  
  //Register to store register data
  always @(posedge Clock)
  begin
    if(RuReset)
      Config2 <= 8'b0;
    else if(Config2Str)
      Config2 <= {RuDoutReg[31:28], RuDoutReg[25:22]};
    else
      Config2 <= Config2;
  end
  
  //Register to store register data
  always @(posedge Clock)
  begin
    if(RuReset)
      ConfigCurrent <= 4'b0;
    else if(Config3Str)
      ConfigCurrent <= RuDoutReg[33:30];
    else
      ConfigCurrent <= ConfigCurrent;
  end
  
  //Bit counter for tracking writes and reads
  always @(posedge Clock)
  begin
    if(RuReset)
      BitCnt <= 6'b0;
    else if(BitCntLd)
      BitCnt <= BitCntVal;
    else if(BitCntDec & (BitCnt != 6'b0))
      BitCnt <= BitCnt - 6'd1;
    else
      BitCnt <= BitCnt;
  end
  
  //State Machine to read and write module as needed
  parameter [4:0]
    FRU_RESET             =  0,
    
    FRU_RD_AP_1_PREP      =  1,
    FRU_RD_AP_1_WR_1      =  2,
    FRU_RD_AP_1_WR_2      =  3,
    FRU_RD_AP_1_CAPTURE   =  4,
    FRU_RD_AP_1_READ      =  5,
    FRU_RD_AP_1_STR       =  6,

    FRU_RD_AP_2_PREP      =  7,
    FRU_RD_AP_2_WR_1      =  8,
    FRU_RD_AP_2_WR_2      =  9,
    FRU_RD_AP_2_CAPTURE   = 10,
    FRU_RD_AP_2_READ      = 11,
    FRU_RD_AP_2_STR       = 12,
    
    FRU_RD_AP_3_PREP      = 13,
    FRU_RD_AP_3_WR_1      = 14,
    FRU_RD_AP_3_WR_2      = 15,
    FRU_RD_AP_3_CAPTURE   = 16,
    FRU_RD_AP_3_READ      = 17,
    FRU_RD_AP_3_STR       = 18,
    
    FRU_CHK_CONFIG        = 19,
    
    FRU_WR_1_PREP         = 20,
    FRU_WR_1_WRITE        = 21,
    FRU_WR_1_UPDATE       = 22,
    
    FRU_WR_2_PREP         = 23,
    FRU_WR_2_WRITE        = 24,
    FRU_WR_2_UPDATE       = 25,
    
    FRU_DELAY             = 26,
    
    FRU_RECONFIG          = 27,
    
    FRU_IDLE              = 28;

    
  reg [4:0] CurrentState, NextState;
  
  always @(posedge Clock)
  begin
    if(RuReset)
      CurrentState <= FRU_RESET;
    else
      CurrentState <= NextState;
  end
  
  //Next state logic
  always @(CurrentState or DelayCnt or BitCnt or ConfigCurrent or ReloadApplication)
  begin
    case(CurrentState)
    
      FRU_RESET :
        begin
          //Stay here until delay counter is up
          if(DelayCnt == 32'b0)
            NextState <= FRU_RD_AP_1_PREP;
          else
            NextState <= FRU_RESET;
        end
        
      /////////////////////////////////////////////////////////////////////////////
      // Read Application 1 register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_1_PREP :
        //Store serial input bits and move on
        NextState <= FRU_RD_AP_1_WR_1;
        
      FRU_RD_AP_1_WR_1 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_1_WR_2;
        
      FRU_RD_AP_1_WR_2 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_1_CAPTURE;
        
      FRU_RD_AP_1_CAPTURE :
        //Capture the value we want to read and move on
        NextState <= FRU_RD_AP_1_READ;
        
      FRU_RD_AP_1_READ :
        begin
          if(BitCnt <= 32'd1)
            //Final bit, move on
            NextState <= FRU_RD_AP_1_STR;
          else
            NextState <= FRU_RD_AP_1_READ;
        end
      
      FRU_RD_AP_1_STR :
        //Store value and move on
        NextState <= FRU_RD_AP_2_PREP;
      
      /////////////////////////////////////////////////////////////////////////////
      // Read Application 2 register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_2_PREP :
        //Store serial input bits and move on
        NextState <= FRU_RD_AP_2_WR_1;
        
      FRU_RD_AP_2_WR_1 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_2_WR_2;
        
      FRU_RD_AP_2_WR_2 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_2_CAPTURE;
        
      FRU_RD_AP_2_CAPTURE :
        //Capture the value we want to read and move on
        NextState <= FRU_RD_AP_2_READ;
        
      FRU_RD_AP_2_READ :
        begin
          if(BitCnt <= 32'd1)
            //Final bit, move on
            NextState <= FRU_RD_AP_2_STR;
          else
            NextState <= FRU_RD_AP_2_READ;
        end
      
      FRU_RD_AP_2_STR :
        //Store value and move on
        NextState <= FRU_RD_AP_3_PREP;
      
      /////////////////////////////////////////////////////////////////////////////
      // Read Current Status Register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_3_PREP :
        //Store serial input bits and move on
        NextState <= FRU_RD_AP_3_WR_1;
        
      FRU_RD_AP_3_WR_1 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_3_WR_2;
        
      FRU_RD_AP_3_WR_2 :
        //Write in one bit for setting capture address and move on
        NextState <= FRU_RD_AP_3_CAPTURE;
        
      FRU_RD_AP_3_CAPTURE :
        //Capture the value we want to read and move on
        NextState <= FRU_RD_AP_3_READ;
        
      FRU_RD_AP_3_READ :
        begin
          if(BitCnt <= 32'd1)
            //Final bit, move on
            NextState <= FRU_RD_AP_3_STR;
          else
            NextState <= FRU_RD_AP_3_READ;
        end
      
      FRU_RD_AP_3_STR :
        //Store value and move on
        NextState <= FRU_CHK_CONFIG;
      
      /////////////////////////////////////////////////////////////////////////////
      // Check configuration and decide what to do
      /////////////////////////////////////////////////////////////////////////////
      
      FRU_CHK_CONFIG :
        begin
          if(ConfigCurrent == 4'h2)
            //A normal load to image 0 was done, go for image 1
            NextState <= FRU_WR_1_PREP;
          else
            //Some other reason, don't automatically do anything
            NextState <= FRU_IDLE;
        end
        
      /////////////////////////////////////////////////////////////////////////////
      // Write reconfig register to allow overwrites and then to overwrite
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_WR_1_PREP :
        //Get data ready and move on
        NextState <= FRU_WR_1_WRITE;
        
      FRU_WR_1_WRITE :
        begin
          if(BitCnt <= 32'd1)
            //Final bit, move on
            NextState <= FRU_WR_1_UPDATE;
          else
            NextState <= FRU_WR_1_WRITE;
        end
      
      FRU_WR_1_UPDATE :
        //Latch data into config register and move on
        NextState <= FRU_WR_2_PREP;
      
      FRU_WR_2_PREP :
        //Get data ready and move on
        NextState <= FRU_WR_2_WRITE;
        
      FRU_WR_2_WRITE :
        begin
          if(BitCnt <= 32'd1)
            //Final bit, move on
            NextState <= FRU_WR_2_UPDATE;
          else
            NextState <= FRU_WR_2_WRITE;
        end
      
      FRU_WR_2_UPDATE :
        //Latch data into config register and move on
        NextState <= FRU_DELAY;
      
      FRU_DELAY :
        begin
          //Stay here until delay counter is up
          if(DelayCnt == 32'b0)
            NextState <= FRU_RECONFIG;
          else
            NextState <= FRU_DELAY;
        end
        
      FRU_RECONFIG :
        //Once in reconfig we stay until reset
        NextState <= FRU_RECONFIG;
      
      /////////////////////////////////////////////////////////////////////////////
      // Completed, stay in idle
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_IDLE :
        begin
          //Stay here unless we want to trigger a reload
          if(ReloadApplication)
            NextState <= FRU_WR_1_PREP;
          else
            NextState <= FRU_IDLE;
        end
      
      default
        begin
          NextState <= FRU_RESET;
        end
    endcase
  end
  
  //Decode state for control signals
  always @(CurrentState)
  begin
    //Default to not asserted
    RuDinVal    <= 14'b0;
    RuDinLd     <= 1'b0;
    RuDinSft    <= 1'b0;
    RuDoutStr   <= 1'b0;
    BitCntVal   <= 6'b0;
    BitCntLd    <= 1'b0;
    BitCntDec   <= 1'b0;
    Config1Str  <= 1'b0;
    Config2Str  <= 1'b0;
    Config3Str  <= 1'b0;
    RuShiftNLd  <= 1'b0;
    RuCaptNUpdt <= 1'b1;
    RuConfig    <= 1'b0;
    DelayLd     <= 1'b0;
    
    case (CurrentState)
      FRU_RESET :
        begin
          //Defaults are ok
        end
        
      /////////////////////////////////////////////////////////////////////////////
      // Read Application 1 register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_1_PREP :
        begin
          RuDinVal              <= 14'h0001;                  //Need to shift in two bits as 2'b01
          RuDinLd               <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_1_WR_1 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_1_WR_2 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_1_CAPTURE :
        begin
          BitCntVal             <= 6'd34;                     //We will read out 34 bits
          BitCntLd              <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_1_READ :
        begin
          BitCntDec             <= 1'b1;                      //Count this bit as done
          RuDoutStr             <= 1'b1;                      //Store the incoming bit
          RuShiftNLd            <= 1'b1;                      //Shift bits out
        end

      FRU_RD_AP_1_STR :
        begin
          Config1Str            <= 1'b1;                      //Store relevant bits
        end

      /////////////////////////////////////////////////////////////////////////////
      // Read Application 2 register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_2_PREP :
        begin
          RuDinVal              <= 14'h0002;                  //Need to shift in two bits as 2'b10
          RuDinLd               <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_2_WR_1 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_2_WR_2 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_2_CAPTURE :
        begin
          BitCntVal             <= 6'd34;                     //We will read out 34 bits
          BitCntLd              <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_2_READ :
        begin
          BitCntDec             <= 1'b1;                      //Count this bit as done
          RuDoutStr             <= 1'b1;                      //Store the incoming bit
          RuShiftNLd            <= 1'b1;                      //Shift bits out
        end

      FRU_RD_AP_2_STR :
        begin
          Config2Str            <= 1'b1;                      //Store relevant bits
        end

      /////////////////////////////////////////////////////////////////////////////
      // Read Current Status register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_RD_AP_3_PREP :
        begin
          RuDinVal              <= 14'h0000;                  //Need to shift in two bits as 2'b00
          RuDinLd               <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_3_WR_1 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_3_WR_2 :
        begin
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits in
        end

      FRU_RD_AP_3_CAPTURE :
        begin
          BitCntVal             <= 6'd34;                     //We will read out 34 bits
          BitCntLd              <= 1'b1;                      //Store the value
        end

      FRU_RD_AP_3_READ :
        begin
          BitCntDec             <= 1'b1;                      //Count this bit as done
          RuDoutStr             <= 1'b1;                      //Store the incoming bit
          RuShiftNLd            <= 1'b1;                      //Shift bits out
        end

      FRU_RD_AP_3_STR :
        begin
          Config3Str            <= 1'b1;                      //Store relevant bits
        end

      /////////////////////////////////////////////////////////////////////////////
      // Check configuration and decide what to do
      /////////////////////////////////////////////////////////////////////////////
      
      FRU_CHK_CONFIG :
        begin
          //Defaults ok
        end

      /////////////////////////////////////////////////////////////////////////////
      // Write reconfig register
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_WR_1_PREP :
        begin
          RuDinVal              <= 14'h1000;                  //Set to enable bit overwrites
          RuDinLd               <= 1'b1;                      //Store the value
          BitCntVal             <= 6'd41;                     //We will write in all 41 bits
          BitCntLd              <= 1'b1;                      //Store the value
        end

      FRU_WR_1_WRITE :
        begin
          BitCntDec             <= 1'b1;                      //Count this bit as done
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits out
          RuCaptNUpdt           <= 1'b0;                      //Update config from input
        end

      FRU_WR_1_UPDATE :
        begin
          RuCaptNUpdt           <= 1'b0;                      //Update config from input
          DelayLd               <= 1'b1;                      //Load delay register
        end

      FRU_WR_2_PREP :
        begin
          RuDinVal              <= 14'h3000;                  //Set to enable bit overwrites and to do image 1
          RuDinLd               <= 1'b1;                      //Store the value
          BitCntVal             <= 6'd41;                     //We will write in all 41 bits
          BitCntLd              <= 1'b1;                      //Store the value
        end

      FRU_WR_2_WRITE :
        begin
          BitCntDec             <= 1'b1;                      //Count this bit as done
          RuDinSft              <= 1'b1;                      //Shift bits in
          RuShiftNLd            <= 1'b1;                      //Shift bits out
          RuCaptNUpdt           <= 1'b0;                      //Update config from input
        end

      FRU_WR_2_UPDATE :
        begin
          RuCaptNUpdt           <= 1'b0;                      //Update config from input
          DelayLd               <= 1'b1;                      //Load delay register
        end

      FRU_DELAY :
        begin
          //Defaults ok
        end

      FRU_RECONFIG :
        begin
          RuConfig              <= 1'b1;                      //Start a reconfig
        end

      /////////////////////////////////////////////////////////////////////////////
      // Completed, stay in idle
      /////////////////////////////////////////////////////////////////////////////
        
      FRU_IDLE :
        begin
          //Defaults ok
        end
      
    endcase
  end
  
  //Kick the watchdog continually once out of reset
  always @(posedge Clock)
  begin
    if(RuReset)
      WatchdogKick <= 5'b0;
    else
      WatchdogKick <= WatchdogKick + 5'd1;
  end
  
  //Instantiate module for Remote Update control
  fiftyfivenm_rublock RuBlock
    (
      .clk                          (Clock                        ),
      .shiftnld                     (RuShiftNLd                   ),
      .captnupdt                    (RuCaptNUpdt                  ),
      .regin                        (RuDin[0]                     ),
      .rsttimer                     (WatchdogKick[4]              ),
      .rconfig                      (RuConfig                     ),
      .regout                       (RuDout                       )
    );

  //Application error is set if we did not just load the main image
  always @(posedge Clock)
  begin
    if(RuReset)
      ApplicationError <= 1'b0;
    else if((ConfigCurrent != 4'h3) & (ConfigCurrent != 4'h4))
      ApplicationError <= 1'b1;
    else
      ApplicationError <= 1'b0;
  end
  
endmodule
