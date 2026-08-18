`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2025 15:33:31
// Design Name: 
// Module Name: input_tb
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


module input_tb;
logic clk,reset_instr  ; 
logic [31:0] in_data [0:3] ; 
Coprocessor cp(
clk,
reset_instr,
in_data);
initial begin
clk = 0 ; reset_instr = 0 ; 
forever #5 clk = ~clk ; 
end
initial begin
#4 reset_instr = 1;
#10 reset_instr = 0 ; 
#800000 ; 

$writememb("_final_mem.mem", cp.main_mem.mem);
$display("Memory dumped");
$finish;
end

endmodule
