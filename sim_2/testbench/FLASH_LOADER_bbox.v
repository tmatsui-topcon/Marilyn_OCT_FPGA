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

assign RegFileRdData = 16'h1234;


endmodule
