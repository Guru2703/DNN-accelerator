`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 21:28:01
// Design Name: 
// Module Name: Instr_Mem
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


module Instr_Mem(
clk, addr , instr 
    );
    input logic clk ; 
    input logic [15:0] addr ; 
    output logic [63:0] instr ; 
    logic [63:0] mem [0:65535] ; 
    initial begin 
        $readmemb("test_instr.mem",mem) ; 
    end  
    always @(posedge clk )begin
        instr <= mem[addr] ; 
    end 
endmodule
