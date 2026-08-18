`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2025 13:57:00
// Design Name: 
// Module Name: Instr_Decoder
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

module Instr_Decoder(
clk,shift_out ,smode ,  reset_instr , done , instr ,reset_reg,reset_SA, mode ,is_start
,is_datain,next , is_scale ,is_lut 
    );
    input logic clk,reset_instr , done ;
    input logic [63:0] instr ;
    output logic reset_reg,reset_SA, mode ,is_start,is_datain,next;
    output logic [4:0] shift_out ; 
    output logic smode ; 
    output logic is_scale, is_lut ; 
    logic state ;
    always_ff @(posedge clk)begin
        if(reset_instr ) state<=0;
        else begin
            shift_out <= instr[60:56] ;
            smode <= instr[55] ; 
            case(state)
                1'b0 : state<= 1'b1 ; 
                1'b1 : if(done) state <= 1'b0 ;
             
            endcase
            end   
    end 
    always_comb begin 
        if(!state)begin
                case(instr[63:61])      
                    3'b000:begin //
                        is_scale <= 0; 
                        is_lut <= 0 ; 
                        reset_reg<=0; // after assigning individual resets
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=1;
                        next<=0;
                    end
                    3'b001:begin //
                        is_scale <= 0; 
                        is_lut <= 0 ;  
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=1;
                        is_start<=0;
                        is_datain<=1;
                        next<=0;
                        
                    end
                    3'b010:begin //
                        is_scale <= 0; 
                        is_lut <= 0 ; 
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=1;
                        is_datain<=0;
                        next<=0;
                        
                    end
                    3'b011:begin //
                        is_scale <= 0; 
                        is_lut <= 0 ; 
                        shift_out <= 0 ; 
                        reset_reg<=0;
                        reset_SA<=1;
                        mode<=0;
                        is_start<=1;
                        is_datain<=0;
                        next<=0;
                        
                    end
                    3'b100:begin
                        is_scale <=1; 
                        is_lut <= 0 ;  
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next<=0;
                    end 
                    3'b101:begin
                        is_scale <=0; 
                        is_lut <= 1; 
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next=0;
                    end 
                    default:begin
                        reset_reg<=0; 
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next<=0;
                    end
                endcase 
            end
            else if(state == 1'b1) begin
            case(instr[63:61]) 
                    3'b000:begin //
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=1;
                        next<=0;
                        if(done) next <= 1 ; 
                    end 
                    3'b001:begin //
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=1;
                        is_start<=0;
                        is_datain<=1;
                        next<=0;
                        if(done) next <= 1 ; 
                    end
                    3'b010:begin //
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=1;
                        is_datain<=0;
                        next<=0;
                        if(done) next <= 1 ; 
                    end
                    3'b011:begin //
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=1;
                        is_datain<=0;
                        next<=0;
                        if(done) next <= 1 ; 
                    end
                    3'b100:begin
                        is_scale <=1; 
                        is_lut <= 0 ;  
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next<=0;
                        if(done) next <= 1 ;
                    end 
                    3'b101:begin
                        is_scale <=0; 
                        is_lut <= 1; 
                        reset_reg<=0;
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next<=0;
                        if(done) next <= 1 ;
                    end 
                    default:begin
                        reset_reg<=0; 
                        reset_SA<=0;
                        mode<=0;
                        is_start<=0;
                        is_datain<=0;
                        next<=0;
                    end
                endcase 
            end 
    end
endmodule
