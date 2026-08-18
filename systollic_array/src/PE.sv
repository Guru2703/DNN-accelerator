`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 08:37:39
// Design Name: 
// Module Name: PE
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


module PE(
    input  logic        smode,
    input  logic [4:0]  shift,
    input  logic [7:0]  north,
    input  logic [7:0]  east,
    input  logic        pe_en,
    input  logic        out_en,
    input  logic        clk,
    input  logic        reset,
    input integer num ,
    output logic [7:0]  north_out,
    output logic [7:0]  east_out,
    output logic [31:0] acc_out
);

logic signed [7:0] north_s, east_s;
logic signed [31:0] acc;

assign north_s = north;
assign east_s  = east;

always_ff @(posedge clk) begin
    if(reset) begin
        acc <= 0;
        north_out <= 0;
        east_out  <= 0;
    end
    else begin

        north_out <= north;
        east_out  <= east;

        if(pe_en) begin
            if(smode == 1'b0 )
                acc <= acc + ((north_s * east_s) <<< shift);
            else begin
                if(shift == 5'b00000)
                    acc <= acc + north*east;
                else if(shift == 5'b01000)
                    acc <= acc + {north*east , 8'b00000000};
                else if(shift == 5'b10000)
                    acc <= acc + {north*east , 16'b0000000000000000};
                else if(shift == 5'b11000)
                    acc <= acc +{north*east , 24'b000000000000000000000000};
                if(num == 0 )begin
                    $display("tine:%t,acc:%h,shift:%b,east:%b,id:%0d",$time, acc,shift,east,num );
                end     
            end
        end

    end
end
    always_comb begin
        if(out_en) acc_out = acc ; 
        else acc_out = 8'b0 ;
    end
endmodule
