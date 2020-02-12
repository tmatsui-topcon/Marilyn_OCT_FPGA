/******************************************************************************
Module:     MAX10_FLASH_INTERFACE
Date:       02 MAR 2015
Settings:   Tabstop = 2

Purpose:
Handle control of the flash to erase and write a new configuration into the
application image.

******************************************************************************/

module MAX10_FLASH_INTERFACE
  (
    Clock,
    Reset,
    
    FlashMemWrAddress,
    FlashMemWrData,
    FlashMemWrEn,
    
    FlashOpAddr,
    FlashOpLen,
    FlashOpUnlock,
    FlashOpWr,
    FlashOpEr,
    
    FlashCmdAck,
    FlashBusy,
    FlashError
    
  );

  input           Clock;                    //FPGA Primary Synchronous Clock
  input           Reset;                    //Synchronous Reset
  input   [ 6: 0] FlashMemWrAddress;        //Write Address for writing to storage RAM for flash writes
  input   [15: 0] FlashMemWrData;           //Write Data for writing to storage RAM for flash writes
  input           FlashMemWrEn;             //Write Enable for marking Address and Data as valid to write
  
  input   [17: 0] FlashOpAddr;              //Address for flash write operation
  input   [ 5: 0] FlashOpLen;               //Number of 32-bit words to do in write operation
  input           FlashOpUnlock;            //The flash unlock word is written
  input           FlashOpWr;                //Starts a flash write if unlocked and ready
  input           FlashOpEr;                //Starts a flash erase if unlocked and ready

  output          FlashCmdAck;              //Acknowledges flash command to clear lock and command bits
  output          FlashBusy;                //Flash operation is currently under way
  output          FlashError;               //An error has occurred with the flash command
  
  //Internal Wires
  wire    [31: 0] CntlRdData;               //Control interface read data
  wire    [31: 0] DataRdData;               //Data interface read data
  wire            DataWaitReq;              //Data interface wait request
  wire            DataRdValid;              //Data interface read data valid
  wire            FlashRamWe;               //Write enable for flash holding RAM
  wire    [31: 0] RamRdVal;                 //Value read back from the holding RAM
  reg             CntlAddr;                 //Control interface address
  reg             CntlRd;                   //Control interface read enable
  reg     [31: 0] CntlWrData;               //Control interface write data
  reg             CntlWr;                   //Control interface write enable
  reg     [17: 0] DataAddr;                 //Data interface address
  reg             DataRd;                   //Data interface read enable
  reg     [31: 0] DataWrData;               //Data interface write data
  reg             DataWr;                   //Data interface write enable
  reg     [ 6: 0] DataBurstCnt;             //Data interface burst count for bus read
  reg             DelayCntLd;               //Load delay counter with starting value
  reg             StoreControlVals;         //Store values from command module
  reg             NextFlashCmdAck;          //Computed next value
  reg             FlashBusyClr;             //Clear the busy status
  reg             FlashErrorSet;            //Set to indicate an error happened
  reg             WritePrep;                //Prepare for a write operation
  reg             WriteDone;                //Write of a word is complete
  
  //Internal Registers
  reg             FlashCmdAck;              //Register output
  reg             FlashBusy;                //Register output
  reg             FlashError;               //Register output
  reg             ResetN;                   //Inverted reset for flash module
  reg     [31: 0] DelayCnt;                 //Delay counter
  reg     [15: 0] FlashMsw;                 //MSW for writing 32-bit words into flash
  reg     [ 5: 0] RamRdAddr;                //Address for reading into holding RAM
  reg     [17: 0] FlashWrAddr;              //Address to actually write to the flash module
  reg             ControlIdle;              //Control module is indicating idle
  reg             ControlWrOk;              //Control module is indicating write was successful
  reg             ControlErOk;              //Control module is indicating erase was successful
  reg     [ 5: 0] WriteCnt;                 //Counter for tracking writes to flash
  reg     [17: 0] DataAddrReg;              //Registered data interface address
  reg             DataRdReg;                //Registered data interface read enable
  reg     [31: 0] DataWrDataReg;            //Registered data interface write data
  reg             DataWrReg;                //Registered data interface write enable
  reg     [ 6: 0] DataBurstCntReg;          //Registered data interface burst count for bus read
  reg             CntlAddrReg;              //Registered control interface address
  reg             CntlRdReg;                //Registered control interface read enable
  reg     [31: 0] CntlWrDataReg;            //Registered control interface write data
  reg             CntlWrReg;                //Registered control interface write enable
  
  //Store the previous word as MSW so that when we get the LSW we can write the 32-bit word
  always @(posedge Clock)
  begin
    if(Reset)
      FlashMsw <= 16'b0;
    else if(FlashMemWrEn)
      FlashMsw <= FlashMemWrData;
    else
      FlashMsw <= FlashMsw;
  end
  
  //We only write on every second 16-bit word since we are storing 32-bit words
  assign FlashRamWe = (FlashMemWrEn & FlashMemWrAddress[0]);
  
  //Dual port RAM for holding data we want to write - do a 32-bit write every other value
  MAX10_FLASH_INTERFACE_RAM FlashInterfaceRam
    (
      .clock                        (Clock                        ),
      .wraddress                    (FlashMemWrAddress[6:1]       ),
      .data                         ({FlashMsw, FlashMemWrData}   ),
      //.data                         ({FlashMemWrData, FlashMsw}   ),
      .wren                         (FlashRamWe                   ),
      .rdaddress                    (RamRdAddr                    ),
      .q                            (RamRdVal                     )
    );
  
  //Register to index into the holding RAM for reading it out
  always @(posedge Clock)
  begin
    if(Reset)
      RamRdAddr <= 6'b0;
    else if(WritePrep)
      RamRdAddr <= 6'b0;
    else if(WriteDone)
      RamRdAddr <= RamRdAddr + 6'd1;
    else
      RamRdAddr <= RamRdAddr;
  end
  
  //Register to control real address to write to flash
  always @(posedge Clock)
  begin
    if(Reset)
      FlashWrAddr <= 18'b0;
    else if(WritePrep)
      FlashWrAddr <= FlashOpAddr;
    else if(WriteDone)
      FlashWrAddr <= FlashWrAddr + 18'd1;
    else
      FlashWrAddr <= FlashWrAddr;
  end
  
  //Count down the number of words to be written
  always @(posedge Clock)
  begin
    if(Reset)
      WriteCnt <= 6'b0;
    else if(WritePrep)
      WriteCnt <= FlashOpLen;
    else if(WriteDone & (WriteCnt != 6'b0))
      WriteCnt <= WriteCnt - 6'd1;
    else
      WriteCnt <= WriteCnt;
  end
  
  //Store value from the control module when it is read
  always @(posedge Clock)
  begin
    if(Reset)
      begin
        ControlIdle <= 1'b0;
        ControlWrOk <= 1'b0;
        ControlErOk <= 1'b0;
      end
    else if(StoreControlVals)
      begin
        ControlIdle <= (CntlRdData[1:0] == 2'b0);
        ControlWrOk <= CntlRdData[3];
        ControlErOk <= CntlRdData[4];
      end
    else
      begin
        ControlIdle <= ControlIdle;
        ControlWrOk <= ControlWrOk;
        ControlErOk <= ControlErOk;
      end    
  end
  
  //Delay counter
  always @(posedge Clock)
  begin
    if(Reset)
      DelayCnt <= 32'b0;
    else if(DelayCntLd)
      DelayCnt <= 32'd100000000;
    else if(DelayCnt != 32'b0)
      DelayCnt <= DelayCnt - 32'd1;
    else
      DelayCnt <= DelayCnt;
  end
  
  //State machine to control flash interface
  parameter [5:0]
    YFI_READ_SET          =  0,
    YFI_READ_LAT          =  1,
    YFI_READ_STR          =  2,
    YFI_READ_VAL          =  3,
    
    YFI_E_PREP            =  4,
    YFI_E1_CLR_SWP_CFM    =  5,
    YFI_E1_SET_SEL_CFM    =  6,
    YFI_E1_WAIT_BUSY_SET  =  7,
    YFI_E1_WAIT_BUSY_LAT  =  8,
    YFI_E1_WAIT_BUSY_STR  =  9,
    YFI_E1_WAIT_BUSY      = 10,
    YFI_E1_WAIT_IDLE      = 11,
    YFI_E1_CHK_ERROR      = 12,
    YFI_E1_SET_SWP_CFM    = 13,
    YFI_E2_CLR_SWP_CFM    = 14,
    YFI_E2_SET_SEL_CFM    = 15,
    YFI_E2_WAIT_BUSY_SET  = 16,
    YFI_E2_WAIT_BUSY_LAT  = 17,
    YFI_E2_WAIT_BUSY_STR  = 18,
    YFI_E2_WAIT_BUSY      = 19,
    YFI_E2_WAIT_IDLE      = 20,
    YFI_E2_CHK_ERROR      = 21,
    YFI_E2_SET_SWP_CFM    = 22,
    
    YFI_W_PREP            = 23,
    YFI_W_CLR_SWP         = 24,
    YFI_W_LOAD_WORD       = 25,
    YFI_W_WRITE_WORD      = 26,
    YFI_W_WAIT_WAIT_REQ_H = 27,
    YFI_W_WAIT_WAIT_REQ_L = 28,
    YFI_W_WAIT_IDLE_PREP  = 29,
    YFI_W_WAIT_IDLE_STR   = 30,
    YFI_W_WAIT_IDLE       = 31,
    YFI_W_CHK_ERROR       = 32,
    YFI_W_SET_SWP         = 33;
    
  reg [5:0] CurrentState, NextState;
  
  always @(posedge Clock)
  begin
    if(Reset)
      CurrentState <= YFI_READ_SET;
    else
      CurrentState <= NextState;
  end
  
  //Next state logic
  always @(CurrentState or ControlIdle or FlashOpUnlock or FlashOpWr or FlashOpEr or WriteCnt or DataWaitReq)
  begin
    case(CurrentState)
    
      /////////////////////////////////////////////////////////////////////////////
      // Basic loop to monitor status
      /////////////////////////////////////////////////////////////////////////////

      YFI_READ_SET :
        //Just go read so we can check status
        NextState <= YFI_READ_LAT;
        
      YFI_READ_LAT :
        //Just go read so we can check status
        NextState <= YFI_READ_STR;
        
      YFI_READ_STR :
        //Just go read so we can check status
        NextState <= YFI_READ_VAL;
        
      YFI_READ_VAL :
        begin
          if(ControlIdle & FlashOpWr & FlashOpUnlock)
            //We are OK to start a write
            NextState <= YFI_W_PREP;
          else if(ControlIdle & FlashOpEr & FlashOpUnlock)
            //We are OK to start a erase
            NextState <= YFI_E_PREP;
          else
            NextState <= YFI_READ_VAL;
        end
      
      /////////////////////////////////////////////////////////////////////////////
      // Erase states
      /////////////////////////////////////////////////////////////////////////////
        
      YFI_E_PREP :
        //Setup erase registers and start
        NextState <= YFI_E1_CLR_SWP_CFM;
        
      YFI_E1_CLR_SWP_CFM :
        //Clear the write protect bit and move on
        NextState <= YFI_E1_SET_SEL_CFM;
        
      YFI_E1_SET_SEL_CFM :
        //Set the sector erase bit and move on
        NextState <= YFI_E1_WAIT_BUSY_SET;
        
      YFI_E1_WAIT_BUSY_SET :
        //Send a read to status register
        NextState <= YFI_E1_WAIT_BUSY_LAT;
        
      YFI_E1_WAIT_BUSY_LAT :
        //Send a read to status register, data output on this clock
        NextState <= YFI_E1_WAIT_BUSY_STR;
        
      YFI_E1_WAIT_BUSY_STR :
        //Send a read to status register, can latch read data on this clock
        NextState <= YFI_E1_WAIT_BUSY;
        
      YFI_E1_WAIT_BUSY :
        begin
          if(!ControlIdle)
            //Erase is under way, go wait for it to finish
            NextState <= YFI_E1_WAIT_IDLE;
          else
            NextState <= YFI_E1_WAIT_BUSY;
        end
      
      YFI_E1_WAIT_IDLE :
        begin
          if(ControlIdle)
            //Erase is done go get status
            NextState <= YFI_E1_CHK_ERROR;
          else
            NextState <= YFI_E1_WAIT_IDLE;
        end
      
      YFI_E1_CHK_ERROR :
        //Store the state of the success bit
        NextState <= YFI_E1_SET_SWP_CFM;
        
      YFI_E1_SET_SWP_CFM :
        //Enable the write protect bit
        NextState <= YFI_E2_CLR_SWP_CFM;
        
      YFI_E2_CLR_SWP_CFM :
        //Clear the write protect bit and move on
        NextState <= YFI_E2_SET_SEL_CFM;
        
      YFI_E2_SET_SEL_CFM :
        //Set the sector erase bit and move on
        NextState <= YFI_E2_WAIT_BUSY_SET;
        
      YFI_E2_WAIT_BUSY_SET :
        //Send a read to status register
        NextState <= YFI_E2_WAIT_BUSY_LAT;
        
      YFI_E2_WAIT_BUSY_LAT :
        //Send a read to status register, data output on this clock
        NextState <= YFI_E2_WAIT_BUSY_STR;
        
      YFI_E2_WAIT_BUSY_STR :
        //Send a read to status register, can latch read data on this clock
        NextState <= YFI_E2_WAIT_BUSY;
        
      YFI_E2_WAIT_BUSY :
        begin
          if(!ControlIdle)
            //Erase is under way, go wait for it to finish
            NextState <= YFI_E2_WAIT_IDLE;
          else
            NextState <= YFI_E2_WAIT_BUSY;
        end
      
      YFI_E2_WAIT_IDLE :
        begin
          if(ControlIdle)
            //Erase is done go get status
            NextState <= YFI_E2_CHK_ERROR;
          else
            NextState <= YFI_E2_WAIT_IDLE;
        end
      
      YFI_E2_CHK_ERROR :
        //Store the state of the success bit
        NextState <= YFI_E2_SET_SWP_CFM;
        
      YFI_E2_SET_SWP_CFM :
        //Enable the write protect bit
        NextState <= YFI_READ_SET;
        
      /////////////////////////////////////////////////////////////////////////////
      // Write states
      /////////////////////////////////////////////////////////////////////////////
        
      YFI_W_PREP :
        //Setup write registers and start
        NextState <= YFI_W_CLR_SWP;
        
      YFI_W_CLR_SWP :
        //Clear the write protect bits and move on
        NextState <= YFI_W_LOAD_WORD;
        
      YFI_W_LOAD_WORD :
        //Let the RAM get valid data out
        NextState <= YFI_W_WRITE_WORD;
        
      YFI_W_WRITE_WORD :
        //Commit the word to a write
        NextState <= YFI_W_WAIT_WAIT_REQ_H;
        
      YFI_W_WAIT_WAIT_REQ_H :
        begin
          if(DataWaitReq)
            //Wait until we see that the module has started the write
            NextState <= YFI_W_WAIT_WAIT_REQ_L;
          else
            NextState <= YFI_W_WAIT_WAIT_REQ_H;
        end
      
      YFI_W_WAIT_WAIT_REQ_L :
        begin
          if(!DataWaitReq)
            //Wait until we see that the module has finished the write
            NextState <= YFI_W_WAIT_IDLE_PREP;
          else
            NextState <= YFI_W_WAIT_WAIT_REQ_L;
        end
      
      YFI_W_WAIT_IDLE_PREP :
        //Send a read to status register
        NextState <= YFI_W_WAIT_IDLE_STR;
        
      YFI_W_WAIT_IDLE_STR :
        //Store the result to get real data for next clock's usage of it
        NextState <= YFI_W_WAIT_IDLE;
        
      YFI_W_WAIT_IDLE :
        begin
          if(ControlIdle)
            //Write is done go get status
            NextState <= YFI_W_CHK_ERROR;
          else
            NextState <= YFI_W_WAIT_IDLE;
        end
      
      YFI_W_CHK_ERROR :
        begin
          if(WriteCnt > 6'd1)
            //More words to write
            NextState <= YFI_W_LOAD_WORD;
          else
            NextState <= YFI_W_SET_SWP;
        end
      
      YFI_W_SET_SWP :
        //Enable the write protect bits
        NextState <= YFI_READ_SET;
        
      default
        begin
          NextState <= YFI_READ_SET;
        end
    endcase
  end
  
  //Decode state for control signals
  always @(CurrentState or ControlErOk or FlashWrAddr or RamRdVal or ControlWrOk)
  begin
    //Default to not asserted
    CntlAddr          <= 1'b0;
    CntlRd            <= 1'b0;
    CntlWrData        <= 32'b0;
    CntlWr            <= 1'b0;
    DataAddr          <= 18'b0;
    DataRd            <= 1'b0;
    DataWrData        <= 32'b0;
    DataWr            <= 1'b0;
    DataBurstCnt      <= 7'b0;
    DelayCntLd        <= 1'b0;
    StoreControlVals  <= 1'b0;
    NextFlashCmdAck   <= 1'b0;
    FlashBusyClr      <= 1'b0;
    FlashErrorSet     <= 1'b0;
    WritePrep         <= 1'b0;
    WriteDone         <= 1'b0;
    
    case (CurrentState)

      /////////////////////////////////////////////////////////////////////////////
      // Basic loop to monitor status
      /////////////////////////////////////////////////////////////////////////////

      YFI_READ_SET :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_READ_LAT :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_READ_STR :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_READ_VAL :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
          FlashBusyClr          <= 1'b1;                      //Set flash as not busy and ready for an op
        end
        
      /////////////////////////////////////////////////////////////////////////////
      // Erase states
      /////////////////////////////////////////////////////////////////////////////
        
      YFI_E_PREP :
        begin
          NextFlashCmdAck       <= 1'b1;                      //Clear the lock and command registers
        end

      YFI_E1_CLR_SWP_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFBFFFFFF;              //Clear write protection for CFM1
        end

      YFI_E1_SET_SEL_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFBCFFFFF;              //Clear write protection for CFM1 and set CFM1 sector erase
        end

      YFI_E1_WAIT_BUSY_SET :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_E1_WAIT_BUSY_LAT :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_E1_WAIT_BUSY_STR :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E1_WAIT_BUSY :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E1_WAIT_IDLE :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E1_CHK_ERROR :
        begin
          FlashErrorSet         <= !ControlErOk;              //Store the state of the bit
        end
        
      YFI_E1_SET_SWP_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFFFFFFFF;              //Reset write protection
        end

      YFI_E2_CLR_SWP_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFDFFFFFF;              //Clear write protection for CFM2
        end

      YFI_E2_SET_SEL_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFDBFFFFF;              //Clear write protection for CFM2 and set CFM2 sector erase
        end

      YFI_E2_WAIT_BUSY_SET :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_E2_WAIT_BUSY_LAT :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end
        
      YFI_E2_WAIT_BUSY_STR :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E2_WAIT_BUSY :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E2_WAIT_IDLE :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_E2_CHK_ERROR :
        begin
          FlashErrorSet         <= !ControlErOk;              //Store the state of the bit
        end
        
      YFI_E2_SET_SWP_CFM :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFFFFFFFF;              //Reset write protection
        end

      /////////////////////////////////////////////////////////////////////////////
      // Write states
      /////////////////////////////////////////////////////////////////////////////
        
      YFI_W_PREP :
        begin
          NextFlashCmdAck       <= 1'b1;                      //Clear the lock and command registers
          WritePrep             <= 1'b1;                      //Prepare write registers
        end

      YFI_W_CLR_SWP :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hF9FFFFFF;              //Clear write protection for CFM1 and CFM2
        end

      YFI_W_LOAD_WORD :
        begin
          DataAddr              <= FlashWrAddr;               //Get address set up early
          DataWrData            <= RamRdVal;                  //Get data set up early
          DataBurstCnt          <= 7'b1;                      //Burst write is only for 1 item
        end

      YFI_W_WRITE_WORD :
        begin
          DataAddr              <= FlashWrAddr;               //Get address set up early
          DataWrData            <= RamRdVal;                  //Get data set up early
          DataBurstCnt          <= 7'b1;                      //Burst write is only for 1 item
          DataWr                <= 1'b1;                      //Commit write
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
        end

      YFI_W_WAIT_WAIT_REQ_H :
        begin
          DataAddr              <= FlashWrAddr;               //Get address set up early
          DataWrData            <= RamRdVal;                  //Get data set up early
          DataBurstCnt          <= 7'b1;                      //Burst write is only for 1 item
          DataWr                <= 1'b1;                      //Commit write
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_W_WAIT_WAIT_REQ_L :
        begin
          DataAddr              <= FlashWrAddr;               //Get address set up early
          DataWrData            <= RamRdVal;                  //Get data set up early
          DataBurstCnt          <= 7'b1;                      //Burst write is only for 1 item
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_W_WAIT_IDLE_PREP :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_W_WAIT_IDLE_STR :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_W_WAIT_IDLE :
        begin
          CntlAddr              <= 1'b0;                      //Read status register
          CntlRd                <= 1'b1;                      //Do the read
          StoreControlVals      <= 1'b1;                      //Data is now valid from previous read
        end
        
      YFI_W_CHK_ERROR :
        begin
          FlashErrorSet         <= !ControlWrOk;              //Store the state of the bit
          WriteDone             <= 1'b1;                      //Increment counters and addresses
        end
        
      YFI_W_SET_SWP :
        begin
          CntlWr                <= 1'b1;                      //Set to a write command
          CntlAddr              <= 1'b1;                      //Write control register
          CntlWrData            <= 32'hFFFFFFFF;              //Reset write protection
        end

    endcase
  end
  
  //Invert reset for the flash module
  always @(posedge Clock)
  begin
    ResetN <= !Reset;
  end
    
  //Register the inputs to the module to investigate timing issues
  always @(posedge Clock)
  begin
    if(Reset)
      begin
        CntlAddrReg     <= 1'b0;
        CntlRdReg       <= 1'b0;
        CntlWrDataReg   <= 32'b0;
        CntlWrReg       <= 1'b0;
        DataAddrReg     <= 18'b0;
        DataWrDataReg   <= 32'b0;
        DataBurstCntReg <= 7'b0;
        DataWrReg       <= 1'b0;
        DataRdReg       <= 1'b0;
      end
    else
      begin
        CntlAddrReg     <= CntlAddr;
        CntlRdReg       <= CntlRd;
        CntlWrDataReg   <= CntlWrData;
        CntlWrReg       <= CntlWr;
        DataAddrReg     <= DataAddr;
        DataWrDataReg   <= DataWrData;
        DataBurstCntReg <= DataBurstCnt;
        DataWrReg       <= DataWr;
        DataRdReg       <= DataRd;
      end
  end

  //Instantiate module to control Flash
  config_ram FlashModule
    (
      .clock                        (Clock                        ),
      .reset_n                      (ResetN                       ),
      .avmm_csr_addr                (CntlAddrReg                  ),
      .avmm_csr_read                (CntlRdReg                    ),
      .avmm_csr_writedata           (CntlWrDataReg                ),
      .avmm_csr_write               (CntlWrReg                    ),
      .avmm_csr_readdata            (CntlRdData                   ),
      .avmm_data_addr               (DataAddrReg                  ),
      .avmm_data_read               (DataRdReg                    ),
      .avmm_data_writedata          (DataWrDataReg                ),
      .avmm_data_write              (DataWrReg                    ),
      .avmm_data_readdata           (DataRdData                   ),
      .avmm_data_waitrequest        (DataWaitReq                  ),
      .avmm_data_readdatavalid      (DataRdValid                  ),
      .avmm_data_burstcount         (DataBurstCntReg              )
    );
  
  //Register decoded outputs
  always @(posedge Clock)
  begin
    if(Reset)
      begin
        FlashCmdAck <= 1'b0;
      end
    else
      begin
        FlashCmdAck <= NextFlashCmdAck;
      end
  end
  
  //Register output for busy state
  always @(posedge Clock)
  begin
    if(Reset)
      FlashBusy <= 1'b0;
    else if(NextFlashCmdAck)
      FlashBusy <= 1'b1;
    else if(FlashBusyClr)
      FlashBusy <= 1'b0;
    else
      FlashBusy <= FlashBusy;
  end
  
  //Register output for error indicator
  always @(posedge Clock)
  begin
    if(Reset)
      FlashError <= 1'b0;
    else if(NextFlashCmdAck)
      FlashError <= 1'b0;
    else if(FlashErrorSet)
      FlashError <= 1'b1;
    else
      FlashError <= FlashError;
  end
      
endmodule
