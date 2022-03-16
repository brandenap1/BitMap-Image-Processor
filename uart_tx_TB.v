//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
 
// This testbench will exercise both the UART Tx and Rx.
// It sends out byte 0xAB over the transmitter
// It then exercises the receive by receiving byte 0x3F
`timescale 1ns/10ps
 
module uart_tx_TB ();
 
  // Testbench uses a 10 MHz clock
  // Want to interface to 115200 baud UART
  // 10000000 / 115200 = 87 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 100;
//  parameter c_CLKS_PER_BIT    = 87;
  parameter c_BIT_PERIOD      = 8600;
   
  reg Clk = 0;
  reg r_Tx_DV = 0;
  reg r_Rx_Serial;
  wire w_Tx_Done;
  reg [7:0] r_Tx_Byte = 8'b0010011;
  wire [7:0] w_Rx_Byte;
   
   uart_tx UUT
    (Clk,r_Tx_DV,r_Tx_Byte,w_Tx_Active,w_Tx_Serial,w_Tx_Done);
  // Takes in input byte and serializes it 
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin
       
      // Send Start Bit
      r_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;
       
       
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          r_Rx_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end
       
      // Send Stop Bit
      r_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
 
   
  always
    #(c_CLOCK_PERIOD_NS/2) Clk <= !Clk;
 
   
  // Main Testing:
  initial
    begin
       
      // Tell UART to send a command (exercise Tx)
      @(posedge Clk);
      @(posedge Clk);
      r_Tx_DV <= 1'b1;
      r_Tx_Byte <= 8'hAB;
      @(posedge Clk);
      r_Tx_DV <= 1'b0;
      @(posedge w_Tx_Done);
       
      // Send a command to the UART (exercise Rx)
      @(posedge Clk);
      UART_WRITE_BYTE(8'h3F);
      @(posedge Clk);
             
      // Check that the correct command was received
      if (w_Rx_Byte == 8'h3F)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
   
endmodule
