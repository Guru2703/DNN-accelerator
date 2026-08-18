`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 14:55:34
// Design Name: 
// Module Name: scale
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


module scale(
inp ,
scale , 
out
    );
    input logic signed  [31:0] inp ; 
    input logic [31:0] scale ; 
    logic [31:0] l1,l2,l3,l4 ; 
    output logic [7:0] out  ; 
logic [31:0] _l1, _l2 , _l3 , _l4  ; 
    
    always_comb begin
        l1 = inp*scale[7:0]   ;
        _l1 = l1[31]== 1 ? {8'hFF,l1[31:8]} : {8'h00,l1[31:8]}   ;  
        l2 = (_l1+(inp*scale[15:8])) ;
        _l2 = l2[31]== 1 ? {8'hFF,l2[31:8]} : {8'h00,l2[31:8]}   ;  
        l3 = (_l2+(inp*scale[23:16]));
        _l3 = l3[31]== 1 ? {8'hFF,l3[31:8]} : {8'h00,l3[31:8]}   ;  
        l4 = (_l3+(inp*scale[31:24]));
        _l4 = l4[31]== 1 ? {8'hFF,l4[31:8]} : {8'h00,l4[31:8]}   ;  
        out = _l4[7:0] ; 
    end 
    
endmodule
