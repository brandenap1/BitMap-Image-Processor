`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 10:55:37 PM
// Design Name: 
// Module Name: spiControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SPI_Slave_Draft(
input  Clk, //On-board Zynq clock (100 MHz)
input  Reset,
input  MOSI, //Signal indicates new data for transmission
input  SClk,//10MHz max
input Chip_Sel,
output reg  [7:0] MISO,
output reg MOSI_SB
);

reg [2:0] counter=0;
reg [2:0] dataCount;
reg [7:0] shiftReg;
reg [1:0] state;
reg clock_10;

localparam IDLE = 'd0,
           SEND = 'd1,
           DONE = 'd2;

always @(negedge SClk or negedge Chip_Sel)
begin
    if(Reset)
    begin
        state <= IDLE;
        dataCount <= 0;
        MOSI_SB <= 0;
    end
    else
    begin
        case(state)
            IDLE:begin
                if(~Chip_Sel)
                begin
                    state <= SEND;
                    dataCount <= 0;
                    MOSI_SB <= 0;
                end
            end
            SEND:begin
                shiftReg[7] <= MOSI;
                shiftReg <= {shiftReg[6:0],1'b0};
                if(dataCount != 7)
                    dataCount <= dataCount + 1;
                else
                begin
                    MOSI_SB <= 1;
                    state <= DONE;
                end
            end
            DONE:begin
                if(Chip_Sel)
                begin
                    state <= IDLE;
                end
                else
                begin
                    state <= SEND;
                    dataCount <= 0;
                    MOSI_SB <= 0;
                end
            end
        endcase
    end
end

    
    
endmodule