`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2025 16:21:08
// Design Name: 
// Module Name: TEST_Mem
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


module TEST_Mem(
clk,wr,data_in,addr , data_out
    );
    input logic clk,wr; 
    input logic [31:0] data_in [0:3] ; 
    output logic [31:0] data_out [0:3] ; 
    input logic [19:0] addr ; 
    logic [31:0] mem [0:1048577] ; 
    integer i;
    initial begin
        for (i = 0; i < 1048577; i = i + 1)
            mem[i] = 32'b0;
        $readmemb("test_mem.mem",mem); 
    end 
    always @(posedge clk)begin
        if(wr) begin
            mem[addr] <= data_in[0] ; 
            mem[addr+20'b0000_0000_0000_0000_0001] <= data_in[1] ; 
            mem[addr+20'b0000_0000_0000_0000_0010] <= data_in[2] ; 
            mem[addr+20'b0000_0000_0000_0000_0011] <= data_in[3] ; 
        end
    end
    always_comb begin
        if(!wr)begin
            data_out[0] <= mem[addr];
            data_out[1] <= mem[addr+20'b0000_0000_0000_0000_0001] ; 
            data_out[2] <= mem[addr+20'b0000_0000_0000_0000_0010] ;
            data_out[3] <= mem[addr+20'b0000_0000_0000_0000_0011] ;
        end 
        else begin
            data_out[0] <= 32'b0 ;
            data_out[1] <= 32'b0 ; 
            data_out[2] <= 32'b0 ;
            data_out[3] <= 32'b0 ; 
        end 
    end 
endmodule
