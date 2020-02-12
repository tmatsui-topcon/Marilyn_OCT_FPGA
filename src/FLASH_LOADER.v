/******************************************************************************
Module:     FLASH_LOADER
Date:       27 OCT 2015

Purpose:
Top level file for Flash Loader

******************************************************************************/

module FLASH_LOADER
  (
    FpgaClk,
	RST,
    
    RegFileWrAddress             ,
    RegFileWrData                ,
    RegFileWrEn                  ,
    RegFileRdAddress             ,
    RegFileRdData                
  );

  input           FpgaClk;                  //Main Clock Input
  input			  RST;

  input		[15:0]	RegFileWrAddress             ;
  input		[17:0]	RegFileWrData                ;
  input				RegFileWrEn                  ;
  input		[15:0]	RegFileRdAddress             ;
  output	[15:0]	RegFileRdData                ;
  
  //Internal Wires
  wire            PllLocked;                //Indicates PLL lock is complete
  wire            SdaOut;                   //SDA Data Output value, when lo will enable open drain output
  wire            SoftReset;                //Request a soft reset
  wire            ReloadApplication;        //Force an FPGA reload of application image
  wire            ApplicationError;         //Indicates an error occurred loading application image
  wire    [ 6: 0] FlashMemWrAddress;        //Write Address for writing to storage RAM for flash writes
  wire    [15: 0] FlashMemWrData;           //Write Data for writing to storage RAM for flash writes
  wire            FlashMemWrEn;             //Write Enable for marking Address and Data as valid to write
  wire    [17: 0] FlashOpAddr;              //Address for flash write operation
  wire    [ 5: 0] FlashOpLen;               //Number of 32-bit words to do in write operation
  wire            FlashOpUnlock;            //The flash unlock word is written
  wire            FlashOpWr;                //Starts a flash write if unlocked and ready
  wire            FlashOpEr;                //Starts a flash erase if unlocked and ready
  wire            FlashCmdAck;              //Acknowledges flash command to clear lock and command bits
  wire            FlashBusy;                //Flash operation is currently under way
  wire            FlashError;               //An error has occurred with the flash command
  
  //Internal Registers
  reg				wr_en_d, wr_en_posedge;
  
  always @(posedge FpgaClk, posedge RST) begin
	  if(RST)begin
		  wr_en_d <= 1'b0;
		  wr_en_posedge <= 1'b0;
	  end else begin
		  wr_en_d <= RegFileWrEn;
		  if(wr_en_d == 1'b0 && RegFileWrEn == 1'b1)begin
			  wr_en_posedge <= 1'b1;
		  end else begin
			  wr_en_posedge <= 1'b0;
		  end
	  end
  end

  //Instantiate module to control configuration
  MAX10_REMOTE_UPDATE Max10RuControl
    (
      .Clock                        (FpgaClk                      ),
      .RuReset                      (RST                          ),
      .ReloadApplication            (ReloadApplication            ),
      .ApplicationError             (ApplicationError             )
    );

  //Instantiate module to control flash
  MAX10_FLASH_INTERFACE Max10FlashInterface
    (
      .Clock                        (FpgaClk                      ),
      .Reset                        (RST                          ),
      .FlashMemWrAddress            (FlashMemWrAddress            ),
      .FlashMemWrData               (FlashMemWrData               ),
      .FlashMemWrEn                 (FlashMemWrEn                 ),
      .FlashOpAddr                  (FlashOpAddr                  ),
      .FlashOpLen                   (FlashOpLen                   ),
      .FlashOpUnlock                (FlashOpUnlock                ),
      .FlashOpWr                    (FlashOpWr                    ),
      .FlashOpEr                    (FlashOpEr                    ),
      .FlashCmdAck                  (FlashCmdAck                  ),
      .FlashBusy                    (FlashBusy                    ),
      .FlashError                   (FlashError                   )
    );
    
  REG_FILE RegFile
    (
      .Clock                        (FpgaClk                      ),
      .Reset                        (RST                          ),
      .RegFileWrAddress             (RegFileWrAddress             ),
      .RegFileWrData                (RegFileWrData                ),
      //.RegFileWrEn                  (RegFileWrEn                  ),
      .RegFileWrEn                  (wr_en_posedge                  ),
      .RegFileRdAddress             (RegFileRdAddress             ),
      .RegFileRdData                (RegFileRdData                ),
      
      .FlashMemWrAddress            (FlashMemWrAddress            ),
      .FlashMemWrData               (FlashMemWrData               ),
      .FlashMemWrEn                 (FlashMemWrEn                 ),
      .FlashOpAddr                  (FlashOpAddr                  ),
      .FlashOpLen                   (FlashOpLen                   ),
      .FlashOpUnlock                (FlashOpUnlock                ),
      .FlashOpWr                    (FlashOpWr                    ),
      .FlashOpEr                    (FlashOpEr                    ),
      .FlashCmdAck                  (FlashCmdAck                  ),
      .FlashBusy                    (FlashBusy                    ),
      .FlashError                   (FlashError                   ),

      .ApplicationError             (ApplicationError             ),
      .I2cError                     (I2cError                     ),
      .WatchdogTimeout              (WatchdogTimeout              ),
      
      .SoftReset                    (SoftReset                    ),
      .ReloadApplication            (ReloadApplication            )
    );
    
endmodule
