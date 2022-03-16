//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_tx 
  #(parameter CLKS_PER_BIT = 87)
  (
   input       Clk,
   input       Tx_DV,
   input [7:0] Tx_Byte, 
   output      o_Tx_Active,
   output reg  Tx_Serial,
   output      o_Tx_Done
   );
  
  parameter IDLE         = 3'b000;
  parameter START_BIT    = 3'b001;
  parameter DATA_BITS    = 3'b010;
  parameter STOP_BIT     = 3'b011;
  parameter CLEANUP      = 3'b100;
   
  reg [2:0]    state         = 0;
  reg [7:0]    Clock_Count   = 0;
  reg [2:0]    Bit_Index     = 0;
  reg [7:0]    Tx_Data       = 0;
  reg          Tx_Done       = 0;
  reg          Tx_Active     = 0;
     
  always @(posedge Clk)
    begin
       
      case (state)
        IDLE :
          begin
            Tx_Serial   <= 1'b1;         // Drive Line High for Idle
            Tx_Done     <= 1'b0;
            Clock_Count <= 0;
            Bit_Index   <= 0;
             
            if (Tx_DV == 1'b1)
              begin
                Tx_Active <= 1'b1;
                Tx_Data   <= Tx_Byte;
                state     <= START_BIT;
              end
            else
              state <= IDLE;
          end // case: s_IDLE
         
         
        // Send out Start Bit. Start bit = 0
        START_BIT :
          begin
            Tx_Serial <= 1'b0;
             
            // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
                Clock_Count <= Clock_Count + 1;
                state       <= START_BIT;
              end
            else
              begin
                Clock_Count <= 0;
                state       <= DATA_BITS;
              end
          end // case: s_TX_START_BIT
         
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        DATA_BITS :
          begin
            Tx_Serial <= Tx_Data[Bit_Index];
             
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
                Clock_Count <= Clock_Count + 1;
                state       <= DATA_BITS;
              end
            else
              begin
                Clock_Count <= 0;
                 
                // Check if we have sent out all bits
                if (Bit_Index < 7)
                  begin
                    Bit_Index <= Bit_Index + 1;
                    state     <= DATA_BITS;
                  end
                else
                  begin
                    Bit_Index <= 0;
                    state     <= STOP_BIT;
                  end
              end
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        STOP_BIT :
          begin
            Tx_Serial <= 1'b1;
             
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
                Clock_Count <= Clock_Count + 1;
                state       <= STOP_BIT;
              end
            else
              begin
                Tx_Done     <= 1'b1;
                Clock_Count <= 0;
                state       <= CLEANUP;
                Tx_Active   <= 1'b0;
              end
          end // case: s_Tx_STOP_BIT
         
         
        // Stay here 1 clock
        CLEANUP :
          begin
            Tx_Done <= 1'b1;
            state   <= IDLE;
          end
         
         
        default :
          state <= IDLE;
         
      endcase
    end
 
  assign o_Tx_Active = Tx_Active;
  assign o_Tx_Done   = Tx_Done;
   
endmodule
