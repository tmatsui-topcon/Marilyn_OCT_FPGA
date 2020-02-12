/******************************************************************************
Module:     REG_FILE
Date:       03 APR 2015
Settings:   Tabstop = 2

Purpose:
Create a register file for module control and status.

******************************************************************************/

`define ADDR_HwFwRevision0            0   //8'h00
`define ADDR_SystemReset              1   //8'h01

`define ADDR_FlashOpAddr            124   //8'h7C
`define ADDR_FlashOpLen             125   //8'h7D
`define ADDR_FlashOpUnlock          126   //8'h7E
`define ADDR_FlashOpCmd             127   //8'h7F

`define ADDR_HwFwRevision           128   //8'h80
`define ADDR_PrimaryErrSts          129   //8'h81

`define MAX_ADDR                    129   //Max address from list above

module REG_FILE
  (
    Clock,
    Reset,
    RegFileWrAddress,
    RegFileWrData,
    RegFileWrEn,
    RegFileRdAddress,
    RegFileRdData,
    
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
    FlashError,
    
    ApplicationError,
    I2cError,
    WatchdogTimeout,
    
    SoftReset,
    ReloadApplication
  );
  
  input           Clock;                    //FPGA Primary Synchronous Clock
  input           Reset;                    //Synchronous Reset
  input   [15: 0] RegFileWrAddress;         //Write Address for writing to registers
  input   [17: 0] RegFileWrData;            //Write Data for writing to registers
  input           RegFileWrEn;              //Write Enable for marking Address and Data as valid to write
  input   [15: 0] RegFileRdAddress;         //Read Address for reading from registers
  output  [15: 0] RegFileRdData;            //Read Data for reading from registers
  
  output  [ 6: 0] FlashMemWrAddress;        //Write Address for writing to storage RAM for flash writes
  output  [15: 0] FlashMemWrData;           //Write Data for writing to storage RAM for flash writes
  output          FlashMemWrEn;             //Write Enable for marking Address and Data as valid to write
  output  [17: 0] FlashOpAddr;              //Address for flash write operation
  output  [ 5: 0] FlashOpLen;               //Number of 32-bit words to do in write operation
  output          FlashOpUnlock;            //The flash unlock word is written
  output          FlashOpWr;                //Starts a flash write if unlocked and ready
  output          FlashOpEr;                //Starts a flash erase if unlocked and ready
  input           FlashCmdAck;              //Acknowledges flash command to clear lock and command bits
  input           FlashBusy;                //Flash operation is currently under way
  input           FlashError;               //An error has occurred with the flash command

  input           ApplicationError;         //Indicates an error occurred loading application image
  input           I2cError;                 //Error with communication
  input           WatchdogTimeout;          //Communication has failed, reset controls to default state
  
  output          SoftReset;                //Initiate a Soft Reset
  output          ReloadApplication;        //Initiate a Full reload of FPGA Application image
  
  //Internal Wires
  wire    [ 7: 0] Address;                  //Avalon Slave Address, renamed for simplicity
  wire            WriteEn;                  //Avalon Slave Write Enable, renamed for simplicity
  wire    [17: 0] WriteData;                //Avalon Slave Write Data, renamed for simplicity
  wire            NextReloadFPGA;           //Next value for ReloadFPGA
  wire            StartSoftReset;           //Starts a pulsed soft reset
  wire            StickyI2cError;           //Sticky warning for status
  
  //Internal Registers
  reg             SoftReset;                //Register output
  reg             ReloadApplication;        //Register output
  reg     [ 3: 0] SoftResetCount;           //Counter for setting width of reset pulse for soft reset
  reg     [17: 0] RegFile [`MAX_ADDR:0];    //Registers - 16 bit x MAX_ADDR
  reg     [23: 0] ResetDelayReg;            //Delay register to wait 1.0s before reloading
  reg     [24: 0] StatusClrCnt;             //Startup timer to ignore certain errors and warnings
  
  //Use simple names for clarity in module - this module only uses the lower 8 bits
  assign Address    = RegFileWrAddress[7:0];
  assign WriteEn    = (RegFileWrEn & (RegFileWrAddress[15:8] == 8'b0));
  assign WriteData  = RegFileWrData;
  
  //Data instead goes to flash if address is correct
  assign FlashMemWrAddress = RegFileWrAddress[6:0];
  assign FlashMemWrData[15] = RegFileWrData[ 0];
  assign FlashMemWrData[14] = RegFileWrData[ 1];
  assign FlashMemWrData[13] = RegFileWrData[ 2];
  assign FlashMemWrData[12] = RegFileWrData[ 3];
  assign FlashMemWrData[11] = RegFileWrData[ 4];
  assign FlashMemWrData[10] = RegFileWrData[ 5];
  assign FlashMemWrData[ 9] = RegFileWrData[ 6];
  assign FlashMemWrData[ 8] = RegFileWrData[ 7];
  assign FlashMemWrData[ 7] = RegFileWrData[ 8];
  assign FlashMemWrData[ 6] = RegFileWrData[ 9];
  assign FlashMemWrData[ 5] = RegFileWrData[10];
  assign FlashMemWrData[ 4] = RegFileWrData[11];
  assign FlashMemWrData[ 3] = RegFileWrData[12];
  assign FlashMemWrData[ 2] = RegFileWrData[13];
  assign FlashMemWrData[ 1] = RegFileWrData[14];
  assign FlashMemWrData[ 0] = RegFileWrData[15];
  assign FlashMemWrEn = (RegFileWrEn & (RegFileWrAddress[15:8] == 8'h01));
  
  //Counter to delay one second before reloading FPGA
  always @(posedge Clock)
  begin
    if(Reset)
      begin
        ResetDelayReg     <= 24'b0;
        ReloadApplication <= 1'b0;
      end
    else if(NextReloadFPGA & (ResetDelayReg == 24'b0))
      begin
        ResetDelayReg     <= ResetDelayReg + 24'd1;
        ReloadApplication <= 1'b0;
      end
    else if(ResetDelayReg >= 24'd10000000)
      begin
        ResetDelayReg     <= ResetDelayReg;
        ReloadApplication <= 1'b1;
      end
    else if(ResetDelayReg != 24'b0)
      begin
        ResetDelayReg     <= ResetDelayReg + 24'd1;
        ReloadApplication <= 1'b0;
      end
    else
      begin
        ResetDelayReg     <= 24'b0;
        ReloadApplication <= 1'b0;
      end
  end

  //Counter creating a reset pulse for soft reset (doesn't use Reset since it causes Reset)
  always @(posedge Clock)
  begin
    if(SoftResetCount != 4'b0)
      begin
        SoftResetCount  <= SoftResetCount - 4'd1;
        SoftReset       <= 1'b1;
      end
    else if(StartSoftReset)
      begin
        SoftResetCount  <= 4'd15;
        SoftReset       <= 1'b0;
      end
    else
      begin
        SoftResetCount  <= 4'b0;
        SoftReset       <= 1'b0;
      end
  end
  
  //Read logic for Register File matrix - null if unsupported address to prevent wrapping
  wire [17:0]	regfiletmp = RegFile[RegFileRdAddress[7:0]];
  //assign RegFileRdData = (RegFileRdAddress > `MAX_ADDR) ? 16'hFFFF : RegFile[RegFileRdAddress[7:0]];
  assign RegFileRdData = (RegFileRdAddress > `MAX_ADDR) ? 16'hFFFF : regfiletmp[15:0];
  
  /////////////////////////////////////////////////////////////////////////////
  // R/W Registers start here
  /////////////////////////////////////////////////////////////////////////////

  //Register for hardware and firmware revision - always at address 0
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_HwFwRevision0] <= 16'b0;
    else
      RegFile[`ADDR_HwFwRevision0] <= {4'b0, 12'h123};
  end
  
  //Register for resetting or reloading board
  assign StartSoftReset = RegFile[`ADDR_SystemReset] == 18'h1324;
  assign NextReloadFPGA = RegFile[`ADDR_SystemReset] == 18'hDEAD;
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_SystemReset] <= 18'b0;
    else if(WriteEn & (Address == 8'd`ADDR_SystemReset))
      RegFile[`ADDR_SystemReset] <= WriteData;
    else
      //Self clear, all signals are only needed for a single clock
      RegFile[`ADDR_SystemReset] <= 18'b0;
  end

  //Register for Flash address
  assign FlashOpAddr = RegFile[`ADDR_FlashOpAddr];
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_FlashOpAddr] <= 18'b0;
    else if(WriteEn & (Address == 8'd`ADDR_FlashOpAddr))
      RegFile[`ADDR_FlashOpAddr] <= WriteData;
    else
      RegFile[`ADDR_FlashOpAddr] <= RegFile[`ADDR_FlashOpAddr];
  end

  //Register for Flash length
  assign FlashOpLen = RegFile[`ADDR_FlashOpLen][5:0];
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_FlashOpLen] <= 18'b0;
    else if(WriteEn & (Address == 8'd`ADDR_FlashOpLen))
      RegFile[`ADDR_FlashOpLen] <= {12'b0, WriteData[5:0]};
    else
      RegFile[`ADDR_FlashOpLen] <= RegFile[`ADDR_FlashOpLen];
  end

  //Register for Flash unlock
  assign FlashOpUnlock = (RegFile[`ADDR_FlashOpUnlock] == 18'hDAF0);
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_FlashOpUnlock] <= 18'b0;
    else if(FlashCmdAck)
      //Clear when a command is started
      RegFile[`ADDR_FlashOpUnlock] <= 18'b0;
    else if(WriteEn & (Address == 8'd`ADDR_FlashOpUnlock))
      RegFile[`ADDR_FlashOpUnlock] <= WriteData;
    else
      RegFile[`ADDR_FlashOpUnlock] <= RegFile[`ADDR_FlashOpUnlock];
  end

  //Register for Flash command
  assign FlashOpWr = RegFile[`ADDR_FlashOpCmd][0];
  assign FlashOpEr = RegFile[`ADDR_FlashOpCmd][1];
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_FlashOpCmd] <= 18'b0;
    else if(FlashCmdAck)
      //Clear when a command is started
      RegFile[`ADDR_FlashOpCmd] <= 18'b0;
    else if(WriteEn & (Address == 8'd`ADDR_FlashOpCmd))
      RegFile[`ADDR_FlashOpCmd] <= WriteData;
    else
      RegFile[`ADDR_FlashOpCmd] <= RegFile[`ADDR_FlashOpCmd];
  end

  /////////////////////////////////////////////////////////////////////////////
  // Read Only Registers start here
  /////////////////////////////////////////////////////////////////////////////
  
  //Register for hardware and firmware revision
  always @(posedge Clock)
  begin
    if(Reset)
      RegFile[`ADDR_HwFwRevision] <= 18'b0;
    else
      RegFile[`ADDR_HwFwRevision] <= {6'b0, 12'h123};
  end
  
  //Register for Status
  always @(posedge Clock)
  begin
    if(Reset)
      begin
        RegFile[`ADDR_PrimaryErrSts][17:0] <= 18'b0;
      end
    else
      begin
        RegFile[`ADDR_PrimaryErrSts][    0] <= ApplicationError;
        RegFile[`ADDR_PrimaryErrSts][    1] <= I2cError;
        RegFile[`ADDR_PrimaryErrSts][    2] <= FlashError;
        RegFile[`ADDR_PrimaryErrSts][    3] <= FlashBusy;
        RegFile[`ADDR_PrimaryErrSts][17: 4] <= 14'b0;
      end
  end

endmodule
