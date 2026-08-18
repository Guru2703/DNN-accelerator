`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 11:43:05
// Design Name: 
// Module Name: Coprocessor
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
module Coprocessor(
clk,
reset_instr,
in_data);

input logic clk,reset_instr;
input logic [31:0] in_data[0:3] ; 
logic [4:0] shift ; 
logic is_start,is_datain ;
logic [15:0] pe_en , out_en ; 
logic [7:0] inps;
logic [7:0] wghts[0:15] ,out[0:15] ;
logic [15:0] w_shift , w_en ; 
logic i_shift,i_en ,mode; 
logic reset_reg,reset_SA ; 
logic next ;
logic [15:0] addr ;
logic [63:0] instr ; 
logic [31:0] data_in [0:3] ;
logic wr; 
logic is_scale ;
logic is_lut ; 
logic scale_en ; 
logic lut_en ; 

PC pc(
.clk(clk),
.reset(reset_instr),
.next(next),
.addr(addr));

Instr_Mem instr_me(
.clk(clk), 
.addr(addr) ,
.instr(instr) 
    );
    
Instr_Decoder instr_dec(
.clk(clk),
.shift_out(shift) , 
.smode(smode) , 
.reset_instr(reset_instr),
.done(done ),
.instr(instr),
.reset_reg(reset_reg),
.reset_SA(reset_SA),
.mode(mode ),
.is_start(is_start),
.is_datain(is_datain),
.next(next),
.is_scale(is_scale ) , 
.is_lut(is_lut)
    );
logic [5:0] count ;
logic wr_out ; 
logic [31:0] wr_datain [0:3] ;
always_comb begin
    wr_datain[0] = wr_out?{out[0],out[1],out[2],out[3]}:in_data[0]; 
    wr_datain[1] = wr_out?{out[4],out[5],out[6],out[7]}:in_data[1];
    wr_datain[2] = wr_out?{out[8],out[9],out[10],out[11]}:in_data[2];
    wr_datain[3] = wr_out?{out[12],out[13],out[14],out[15]}:in_data[3];
    
end
TEST_Mem main_mem(
.clk(clk),
.wr(wr),
.data_in(wr_datain),
.addr(instr[19:0]+count) ,
.data_out(data_in)
    );  

Shift_Reg_1x16 inp_reg(
.clk(clk),
.reset(reset_reg&(!mode)),
.data_in(data_in),
.shift(i_shift),
.en(i_en),
.data_out(inps) 
    );

genvar i ; 
generate 
for(i = 0 ; i<16 ; i= i+1) begin:Wghts_reg
    Shift_Reg_1x16 wghts_subreg(
        .clk(clk),
        .reset(reset_reg&mode),
        .data_in(data_in),
        .shift(w_shift[i]),
        .en(w_en[i]),
        .data_out(wghts[i])
    );
end
endgenerate

SA systollic_array(
.smode(smode) , 
.shift(shift) , 
.clk(clk) ,
.reset_pe(reset_SA) , 
.pe_en(pe_en) , 
.out_en(out_en) , 
.east(inps) ,
.wghts(wghts) , 
.acc_out(out) ,
.scale_en(scale_en),
.lut_en(lut_en),
.count(count),
.datain(data_in)
    );

control_unit ctrl_unit(
.clk(clk) ,
.reset(reset_reg) , 
.pe_en(pe_en) ,
.out_en(out_en) , 
.i_shift(i_shift) , 
.i_en(i_en) , 
.w_shift(w_shift ) , 
.w_en(w_en) ,
.is_start(is_start) , 
.is_datain(is_datain),
.mode(mode) ,
.done(done) ,
.wr_out(wr_out) ,
.wr(wr),
.count(count),
.is_scale(is_scale ) , 
.is_lut(is_lut),
.scale_en(scale_en ),
.lut_en(lut_en)
    );

//always @(posedge clk)begin
//    $monitor("Time:%t,data_out:%h",$time,wghts[0]);
//end 

endmodule
