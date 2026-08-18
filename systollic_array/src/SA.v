`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 08:38:01
// Design Name: 
// Module Name: SA
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


module SA(
smode , shift,clk ,reset_pe , pe_en , out_en , east,wghts, acc_out ,
scale_en,lut_en , count ,datain
    );
    input logic smode ; 
    input logic [4:0] shift ; 
    input logic clk ,reset_pe ;
    input logic [15:0] pe_en ,out_en; 
    input logic [7:0] east ;
    input logic [7:0] wghts[0:15];
    output logic [7:0] acc_out[0:15] ; 
    input logic scale_en , lut_en ;
    input logic [5:0] count ; 
    input logic [31:0] datain [0:3] ; 
    logic [7:0] lut_in[0:15] ; 
    logic [31:0] acc_o[0:15] ; 
    logic [7:0] inps [0:15] ; 
    logic [7:0] north_out_dummy [0:15] ; 
    logic [31:0] scale ; 
    logic [31:0] data_in [0:3] ; 
    always_comb begin
        inps[0] = east ; 
    end
    genvar i ; 
    generate 
        for(i = 0 ; i< 16 ; i++)begin:PE_ARRAY
            PE pe(
            .smode(smode) , 
            .shift(shift) , 
            .north(wghts[i]), 
            .east(inps[i]), 
            .pe_en(pe_en[i]),
            .out_en(out_en[i]), 
            .clk(clk) , 
            .reset(reset_pe) , 
            .north_out(north_out_dummy[i] ), 
            .east_out(inps[i+1]),
            .acc_out(acc_o[i]) ,
            .num(i)
    );
            scale s(
            .inp(acc_o[i]) , 
            .scale(scale) , 
            .out(lut_in[i])
            )  ; 
            LUT_AF lut(
            .clk (clk),
            .addr (lut_en? {count,2'b00}:{lut_in[i][7] ? 0: 1  ,lut_in[i][6:0]}),
            .wr (lut_en) ,
            .rd (~lut_en) ,
            .data_in (data_in), 
            .data_out(acc_out[i])
            ) ; 
    end
    
endgenerate
always @(posedge clk)begin
    if(scale_en)
        scale <= datain[0]; 
    if(lut_en) begin
        data_in[0] <= datain[0 ] ;  
        data_in[1] <= datain[1 ] ; 
        data_in[2] <= datain[2 ] ; 
        data_in[3] <= datain[3 ] ; 
        end 
end 
endmodule
