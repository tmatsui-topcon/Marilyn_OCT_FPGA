

wire   [15:0]   D                 ;
reg    [15:0]   D_IN              = 'd0 ;
reg             D_IN_EN           = 'd0 ;
assign D = (D_IN_EN=='d1)? D_IN : 'hz;

reg   [10:0]   A                  = 'd0 ;
reg            nCS1n              = 'd1 ;
reg            nWRn3              = 'd1 ;
reg            nRD_n2             = 'd1 ;
wire           CIBT3_Hsync        ;
wire           CIBT3_Vsync        ;
wire           LineCCD_Trig       ;
wire           RETRY_FLAG1        ;
wire           RETRY_FLAG2        ;
wire           RDnWR              ;
reg            GPIO0_IN           ; //no use
wire           SLD_PULSE          ;
reg            FPGA_RESET         = 'd0 ;
reg            GPIO1_IN           = 'd0 ;
reg            GPIO2_IN           ;//no use
reg            GPIO3_IN           ;//no use
wire           nIRQ1_FPGA         ;
wire           nIRQ2_FPGA         ;
wire           nIRQ3_FPGA         ;
wire           nIRQ4_FPGA         ;
wire           nIRQ5_FPGA         ;
wire           nIRQ6_FPGA         ;
wire           nIRQ7_FPGA         ;
wire           nIRQ8_FPGA         ;
wire           nGalvX_OS_CS       ;
wire           nGalvY_OS_CS       ;
wire           Galv_OS_SCLK       ;
wire           Galv_OS_DIN        ;
wire           nGalvX_SYNC        ;
wire           nGalvY_SYNC        ;
wire           Galv_SDIN          ;
wire           Galv_SCLK          ;
wire           Galv_GAIN_SDI      ;
wire           Galv_GAIN_CLK      ;
wire           nGalvX_GAIN_CS     ;
reg            FPGA_CLOCK         = 'd0 ;
wire           REF_POLA_RESET     ;
wire           MOT_ENABLE         ;
wire           MOT_PHA            ;
wire           MOT_DIR            ;
wire           MOT_PWMSW          ;
wire           PER_N              ;
wire           PER_P              ;
wire           PER_REF_SCLK       ;
wire           PER_REF_DIN        ;
wire           nPER_RES_CS        ;
wire           POLA_IN1           ;
wire           POLA_IN2           ;
wire           REF_IN1            ;
wire           REF_IN2            ;
wire           OCTFOCUS_IN1       ;
wire           OCTFOCUS_IN2       ;
wire           SLD_REF_SCLK       ;
wire           SLD_REF_DIN        ;
wire           nSLD_REF_CS        ;
wire           nSLD_LIMIT_CS      ;
//reg            nFOCUS_FAULT       = 'd0 ;
wire			nFOCUS_FAULT		;
//reg            nREF_POLA_FAULT    = 'd0 ;
wire            nREF_POLA_FAULT     ;

wire           nDRV8841_SLEEP     ;
wire           LineCCD_ONOFF      ;
wire           SLD_ACTIVE_PERIOD  ;
reg  [3:0]     DIP_SW             = 'd0 ;
wire           KEISEN_TXD         ;
reg            PD_MONITOR         ;//no use
wire           FOCUS_SLEEP        ;
wire           CP9                ;

reg				t_ENC_A			  ;
reg				t_ENC_B			  ;

wire			w_hsync_out		  ;

wire 			t_LCMOS_MisTrig   ;




OCT_TOP_MARILYN OCT_TOP_MARILYN (    
     .    D              (  D                       )
   , .A                  (  A                       )
   , .nCS1n              (  nCS1n                   )
   , .nWRn3              (  nWRn3                   )
   , .nRD_n2             (  nRD_n2                  )
   , .LCMOS_Hsync        (  w_hsync_out             )
   , .RDnWR              (  RDnWR                   )
   , .SLD_PULSE          (  SLD_PULSE               )
   , .FPGA_RESET         (  FPGA_RESET              )
   , .nIRQ1_FPGA         (  nIRQ1_FPGA              )
   , .nIRQ2_FPGA         (  nIRQ2_FPGA              )
   , .nIRQ3_FPGA         (  nIRQ3_FPGA              )
   , .nIRQ4_FPGA         (  nIRQ4_FPGA              )
   , .nIRQ5_FPGA         (  nIRQ5_FPGA              )
   , .nIRQ6_FPGA         (  nIRQ6_FPGA              )
   , .nGalvX_OS_CS       (  nGalvX_OS_CS            )
   , .nGalvY_OS_CS       (  nGalvY_OS_CS            )
   , .Galv_OS_SCLK       (  Galv_OS_SCLK            )
   , .Galv_OS_DIN        (  Galv_OS_DIN             )
   , .nGalvX_SYNC        (  nGalvX_SYNC             )
   , .nGalvY_SYNC        (  nGalvY_SYNC             )
   , .Galv_SDIN          (  Galv_SDIN               )
   , .Galv_SCLK          (  Galv_SCLK               )
   , .Galv_GAIN_SDI      (  Galv_GAIN_SDI           )
   , .Galv_GAIN_CLK      (  Galv_GAIN_CLK           )
   , .nGalvX_GAIN_CS     (  nGalvX_GAIN_CS          )
   , .FPGA_CLOCK         (  FPGA_CLOCK              )
   , .MOT_ENABLE         (  MOT_ENABLE              )
   , .MOT_PHA            (  MOT_PHA                 )
   , .MOT_DIR            (  MOT_DIR                 )
   , .MOT_PWMSW          (  MOT_PWMSW               )
   , .PER_REF_SCLK       (  PER_REF_SCLK            )
   , .PER_REF_DIN        (  PER_REF_DIN             )
   , .nPER_RES_CS        (  nPER_RES_CS             )
   , .SLD_REF_SCLK       (  SLD_REF_SCLK            )
   , .SLD_REF_DIN        (  SLD_REF_DIN             )
   , .nSLD_REF_CS        (  nSLD_REF_CS             )
   , .nSLD_LIMIT_CS      (  nSLD_LIMIT_CS           )
   , .DIP_SW             (  DIP_SW                  )
   , .ENC_A				 (  t_ENC_A                 )
   , .ENC_B              (  t_ENC_B                 )
   , .LCMOS_MisTrigger   (  t_LCMOS_MisTrig         )
   , .OCTF_ON_OFF        (                          )
   , .OCTF_AP            (                          )
   , .OCTF_BP            (                          )
   , .OCTF_AN            (                          )
   , .POLA_ON_OFF	     (                          )
   , .POLA_AP		     (                          )
   , .POLA_BP		     (                          )
   , .POLA_AN		     (                          )
   , .POLA_BN		     (                          )
   , .D_LINE_ON_OFF	     (                          )
   , .D_LINE_AP		     (                          )
   , .D_LINE_BP		     (                          )
   , .D_LINE_AN		     (                          )
   , .D_LINE_BN		     (                          )
   , .P_SW_ON_OFF		 (                          )
   , .P_SW_AP			 (                          )
   , .P_SW_BP			 (                          )
   , .P_SW_AN			 (                          )
   , .P_SW_BN			 (                          )
   
);



