`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2022 05:00:46 PM
// Design Name: 
// Module Name: SPI_Slave_Draft_TB
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


module SPI_Slave_Draft_TB();


reg SClk_TB,MOSI_TB;
reg Clk_TB,Reset_TB;
wire [7:0] MISO_TB;
wire MOSI_SB_TB;
wire [1:0] Current_State_TB;
wire [1:0] Next_State_TB;
wire [4:0] counter_TB;

// instantiate

    SPI_Slave_Draft uut (.Clk(Clk_TB),.Reset(Reset_TB),.SClk(SClk_TB),.MOSI(MOSI_TB),.Current_State(Current_State_TB),
                         .Next_State(Next_State_TB),.MISO(MISO_TB),.MOSI_SB(MOSI_SB_TB),.counter_TB(counter_TB));

    initial 
    begin
        SClk_TB = 0;
        Clk_TB = 1;
        Reset_TB = 1;
        MOSI_TB = 0;
    end
    
    always 
    begin
        Clk_TB = ~Clk_TB;
        #5;
    end
    
    always
    begin
        #20
        Reset_TB = 0;
        #5
    // 1st Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5
    // 2nd Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 0;
        #5
        SClk_TB = ~SClk_TB;
        #5        
    // 3rd Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5
    // 4th Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5    
    // 5th Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 0;
        #5
        SClk_TB = ~SClk_TB;
        #5
    // 6th Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5        
    // 7th Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5
    // 8th Bit
        SClk_TB = ~SClk_TB;
        MOSI_TB = 1;
        #5
        SClk_TB = ~SClk_TB;
        #5
        MOSI_TB = 0;
    end
    
    
endmodule
