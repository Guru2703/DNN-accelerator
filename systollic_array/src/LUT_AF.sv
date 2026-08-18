`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 18:07:14
// Design Name: 
// Module Name: LUT_AF
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


module LUT_AF(
clk ,addr , wr , rd  , data_in , data_out 
    );
    input logic clk ,rd ,wr ; 
    input logic [7:0] addr ; 
    input logic [31:0] data_in[0:3] ; 
    output logic [7:0] data_out ; 
    logic [7:0] LUT [0: 255 ] ; 
//    initial begin 
//        $readmemb("AF_LUT_memory.mem",LUT); 
//    end 
    logic [7:0] Addr ; 
    always_comb begin
        if(wr)  
            Addr = addr + 8'hF0 ; 
        if(rd)
            Addr = addr ; 
    end
    always_ff @(negedge clk )begin
        if(wr) begin
            LUT[Addr] <= data_in[0][31:24] ; 
            LUT[Addr+8'h01] <= data_in[0][23:16] ; 
            LUT[Addr+8'h02] <= data_in[0][15:8] ; 
            LUT[Addr+8'h03] <= data_in[0][7:0]; 
            LUT[Addr+8'h04] <= data_in[1][31:24] ; 
            LUT[Addr+8'h05] <= data_in[1][23:16]; 
            LUT[Addr+8'h06] <= data_in[1][15:8] ; 
            LUT[Addr+8'h07] <= data_in[1][7:0]; 
            LUT[Addr+8'h08] <= data_in[2][31:24]; 
            LUT[Addr+8'h09] <= data_in[2][23:16] ; 
            LUT[Addr+8'h0A] <= data_in[2][15:8] ; 
            LUT[Addr+8'h0B] <= data_in[2][7:0] ; 
            LUT[Addr+8'h0C] <= data_in[3][31:24] ; 
            LUT[Addr+8'h0D] <= data_in[3][23:16] ; 
            LUT[Addr+8'h0E] <= data_in[3][15:8] ; 
            LUT[Addr+8'h0F] <= data_in[3][7:0] ; 
        end 
    end 
    
    always_comb begin 
        if(rd)begin
            data_out <= LUT[Addr] ; 
        end
    end 
endmodule
