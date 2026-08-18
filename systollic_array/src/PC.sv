`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 22:11:28
// Design Name: 
// Module Name: PC
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


module PC(
clk ,reset,next , addr
    );
    input logic clk ,next, reset ; 
    output logic [15:0] addr ; 
    always_ff @(negedge clk)begin
        if(reset) addr<= 0 ; 
        else begin
            if(next) addr<=addr+16'h0001 ; 
        end 
    end 
endmodule
