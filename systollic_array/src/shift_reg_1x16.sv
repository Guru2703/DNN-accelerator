`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 11:20:27
// Design Name: 
// Module Name: Shift_Reg_1x16
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


module Shift_Reg_1x16(
clk,reset,data_in,shift,en,data_out 
    );
    input logic clk,reset,shift,en;
    input logic [31:0] data_in[0:3] ; 
    output logic [7:0] data_out ; 
    logic [7:0] shift_reg[0:15] ;
    always_ff @(posedge clk)begin
        
        if(reset)begin
            shift_reg[0] <= 0 ;
            shift_reg[1] <= 0 ;
            shift_reg[2] <= 0 ;
            shift_reg[3] <= 0 ;
            shift_reg[4] <= 0 ;
            shift_reg[5] <= 0 ;
            shift_reg[6] <= 0 ;
            shift_reg[7] <= 0 ;
            shift_reg[8] <= 0 ;
            shift_reg[9] <= 0 ;
            shift_reg[10] <= 0 ;
            shift_reg[11] <= 0 ;
            shift_reg[12] <= 0 ;
            shift_reg[13] <= 0 ;
            shift_reg[14] <= 0 ;
            shift_reg[15] <= 0 ;
        end
        else begin
            if(en) begin
                shift_reg[0] <= data_in[3][7:0] ;
                shift_reg[1] <= data_in[3][15:8] ;
                shift_reg[2] <= data_in[3][23:16] ;
                shift_reg[3] <= data_in[3][31:24] ;
                shift_reg[4] <= data_in[2][7:0] ;
                shift_reg[5] <= data_in[2][15:8] ;
                shift_reg[6] <= data_in[2][23:16] ;
                shift_reg[7] <= data_in[2][31:24] ;
                shift_reg[8] <= data_in[1][7:0] ;
                shift_reg[9] <= data_in[1][15:8] ;
                shift_reg[10] <= data_in[1][23:16] ;
                shift_reg[11] <= data_in[1][31:24] ;
                shift_reg[12] <= data_in[0][7:0] ;
                shift_reg[13] <= data_in[0][15:8] ;
                shift_reg[14] <= data_in[0][23:16] ;
                shift_reg[15] <= data_in[0][31:24] ;
            end 
            else if(shift  && !en ) begin
                shift_reg[0]<=0;
                shift_reg[1]<=shift_reg[0] ; 
                shift_reg[2]<=shift_reg[1] ; 
                shift_reg[3]<=shift_reg[2] ; 
                shift_reg[4]<=shift_reg[3] ; 
                shift_reg[5]<=shift_reg[4] ; 
                shift_reg[6]<=shift_reg[5] ; 
                shift_reg[7]<=shift_reg[6] ; 
                shift_reg[8]<=shift_reg[7] ; 
                shift_reg[9]<=shift_reg[8] ; 
                shift_reg[10]<=shift_reg[9] ; 
                shift_reg[11]<=shift_reg[10] ; 
                shift_reg[12]<=shift_reg[11] ; 
                shift_reg[13]<=shift_reg[12] ; 
                shift_reg[14]<=shift_reg[13] ; 
                shift_reg[15]<=shift_reg[14] ; 
            end 
            
        end
    end 
    always_comb begin
        data_out = shift_reg[15] ; 
    end 
endmodule
