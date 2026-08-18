`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2025 20:00:55
// Design Name: 
// Module Name: control_unit
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


module control_unit(
clk ,reset , pe_en ,out_en , i_shift , i_en , w_shift , w_en ,is_start , is_datain,mode ,done ,wr_out ,wr,
count , is_scale , is_lut , scale_en , lut_en
    );
    input logic clk ,reset ; 
    input logic is_start , is_datain ,mode , is_scale, is_lut; 
    output logic  i_shift , i_en ; 
    output logic [15:0] w_shift , w_en, pe_en , out_en  ; 
    output logic done ; 
    output logic wr_out ,wr ,scale_en ,lut_en ; 
    output logic [5:0] count ; 
    logic [5:0] state ; 
    always_ff @(posedge clk )begin 
//        $display("Time:%t , state:%h,is_datain:%b,mode:%b,i_en:%b",
//                                $time , state ,is_datain,mode,i_en); 
        if(reset) begin 
            state <= 0 ; 
            count<=0;
        end 
        else begin 
            if(is_start && is_datain && is_scale && is_lut  )begin
                state <= 0 ; 
                pe_en <=16'b0000000000000000 ; 
                out_en <= 16'b0000000000000000 ;
                w_shift <= 16'b0000000000000000 ; 
                w_en <= 16'b0000000000000000 ;
                i_shift <= 1'b0 ; 
                i_en <= 1'b0 ; 
                done <= 0 ;  
                wr <=0; 
                wr_out<= 1'b0 ;
                count<=0;
            end 
            else if(!is_start && !is_datain && !is_scale && !is_lut)begin
                state <= 0 ; 
                pe_en <=16'b0000000000000000 ; 
                out_en <= 16'b0000000000000000 ;
                w_shift <= 16'b0000000000000000 ; 
                w_en <= 16'b0000000000000000 ;
                i_shift <= 1'b0 ; 
                i_en <= 1'b0 ; 
                done <= 0 ;  
                wr <=0; 
                wr_out<= 1'b0 ;
                count<=0;
        
            end 
            else if(is_start && !is_datain && !is_scale && !is_lut )begin
                if(state < 6'd33) state <= state+6'b000001 ;
                else state<= 0 ; 
            end 
            else if(!is_start && is_datain && !is_scale && !is_lut )begin
                if(mode )begin
                    if(state <17) state<= state+6'b000001;
                    else state <= 0 ; 
                end 
                else begin
                    if(state<2) state<= state+6'b000001 ;
                    else state <= 0 ; 
                end  
            end 
            else if(!is_start && !is_datain && is_scale && !is_lut )begin
                if(state<2) state<= state+6'b000001 ;
                else state <= 0 ;
            end 
            else if(!is_start && !is_datain && !is_scale && is_lut )begin
                if(state <6'd18) state<= state+6'b000001;
                else state <= 0 ;
            end 
        end 
    end  
    
    always @(state)begin 
        if(is_start) begin
                case (state)
                   6'd0 : begin
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 0 ;  
                    wr <=0; 
                    wr_out<= 1'b0 ; 
                    count<=0; 
                    lut_en <=0 ; 
                   end 
                   6'd1 : begin
                    pe_en <=16'b0000_0000_0000_0001;
                    w_shift <= 16'b0000_0000_0000_0001 ; 
                    i_shift <= 1'b1; 
                    done<=1'b0; 
                    
                   end 
                  
                   6'd2 : begin
                    pe_en <=16'b0000000000000011;
                    w_shift <= 16'b0000000000000011 ; 
                    
                   end  
              
                   6'd3 : begin
                    pe_en <=16'b0000000000000111;
                    w_shift <= 16'b0000000000000111 ; 
                   end
                   6'd4 : begin
                    pe_en <=16'b0000000000001111;
                    w_shift <= 16'b0000000000001111 ; 
                   end
                   6'd5 : begin
                    pe_en <=16'b0000000000011111;
                    w_shift <= 16'b0000000000011111 ; 
                   end
                   6'd6 : begin
                    pe_en <=16'b0000000000111111 ; 
                    w_shift <= 16'b0000000000111111 ; 
                   end
                   6'd7 : begin
                    pe_en <= 16'b0000000001111111 ; 
                    w_shift <= 16'b0000000001111111 ; 
                   end
                   6'd8 : begin
                    pe_en <=16'b0000000011111111;
                    w_shift <= 16'b0000000011111111;
                   end
                   6'd9 : begin
                    pe_en <=16'b0000_0001_1111_1111;
                    w_shift <= 16'b0000_0001_1111_1111 ; 
                   end
                   6'd10 : begin
                    pe_en <=16'h03FF;
                    w_shift <= 16'h03FF ; 
                   end
                   6'd11: begin
                    pe_en <=16'h07FF;
                    w_shift <= 16'h07FF ; 
                   end
                   6'd12 : begin
                    pe_en <=16'h0FFF;
                    w_shift <= 16'h0FFF ; 
                   end
                   6'd13 : begin
                    pe_en <=16'h1FFF;
                    w_shift <= 16'h1FFF ; 
                   end
                   6'd14 : begin
                    pe_en <=16'h3FFF;
                    w_shift <= 16'h3FFF ; 
                   end
                   6'd15: begin
                    pe_en <=16'h7FFF;
                    w_shift <= 16'h7FFF ; 
                   end
                   6'd16: begin
                    pe_en <=16'hFFFF;
                    w_shift <= 16'hFFFF ; 
                   end
                   6'd17 : begin
                    pe_en <=16'hFFFE;
                    w_shift <=16'hFFFE ; 
                   end
                   6'd18: begin
                    pe_en <=16'hFFFC;
                    w_shift <=16'hFFFC ; 
                   end
                   6'd19: begin
                    pe_en <=16'hFFF8;
                    w_shift <=16'hFFF8; 
                   end
                   6'd20: begin
                    pe_en <=16'hFFF0;
                    w_shift <=16'hFFF0; 
                   end
                   6'd21: begin
                    pe_en <=16'hFFE0;
                    w_shift <=16'hFFE0; 
                   end
                   6'd22: begin
                    pe_en <=16'hFFC0;
                    w_shift <=16'hFFC0; 
                   end
                   6'd23: begin
                    pe_en <=16'hFF80;
                    w_shift <=16'hFF80; 
                   end
                   6'd24: begin
                    pe_en <=16'hFF00;
                    w_shift <=16'hFF00; 
                   end
                   6'd25: begin
                    pe_en <=16'hFE00;
                    w_shift <=16'hFE00; 
                   end
                   6'd26: begin
                    pe_en <=16'hFC00;
                    w_shift <=16'hFC00; 
                   end
                   6'd27: begin
                    pe_en <=16'hF800;
                    w_shift <=16'hF800; 
                   end
                   6'd28: begin
                    pe_en <=16'hF000;
                    w_shift <=16'hF000; 
                   end
                   6'd29: begin
                    pe_en <=16'hE000;
                    w_shift <=16'hE000; 
                   end
                   6'd30: begin
                    pe_en <=16'hC000;
                    w_shift <=16'hC000; 
                   end
                   6'd31: begin
                    pe_en <=16'h8000;
                    w_shift <=16'h8000; 
                    done<=1'b0 ;
                   end
                   6'd32: begin
                    pe_en <=16'h0000;
                    w_shift <=16'h0000; 
                    i_shift <= 1'b0 ; 
                     
                   end
                   6'd33: begin
                    out_en <=16'hFFFF ; 
                    done <= 1'b1 ; 
                    wr<=1'b1;
                    wr_out<=1'b1;
                   end
                   default :begin
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    wr_out<=1'b0 ;
                    count<=0;
                    lut_en <=0 ; 
                end 
                endcase
        end
        if (is_scale)begin
            case(state)
                6'b000000:begin
                    lut_en <=0 ; 
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    count<=0;
                    scale_en <= 0 ; 
                    wr<= 0 ; 
                end
                6'b000001:begin
                    scale_en <= 1'b1 ; 
                    done <= 1'b0; 
                end
                6'b000010:begin
                    scale_en <= 1'b0 ; 
                    done <= 1'b1; 
                end
                default:begin
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    count<=0;
                    scale_en <= 0 ; 
                    lut_en <=0 ; 
                end
            endcase
        end 
        if(is_lut)begin
            case(state)
                6'b000000:begin 
                    lut_en<=0 ; 
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    wr <=0; 
                    wr_out<= 1'b0 ;
                    count<=0;
                    lut_en <=0 ; 
                    wr<= 0 ; 
                end
                6'd1:begin 
                    lut_en <= 1;
//                  
                end
                6'd2:begin 
                    lut_en <= 1;
                    count<=count+6'b000100 ; 
                end
                6'd3:begin 
                    lut_en <= 1 ;
                    count<=count+6'b000100 ; 
                end
                6'd4:begin 
                    lut_en <=1 ;
                    count<=count+6'b000100 ;
                end
                6'd5:begin 
                    lut_en <= 1;
                    count<=count+6'b000100 ; 
                end
                6'd6:begin 
                    lut_en <= 1 ;
                        count<=count+6'b000100 ; 
                end
                6'd7:begin 
                    lut_en <= 1;
                    count<=count+6'b000100 ; 
                end
                6'd8:begin 
                     lut_en <= 1 ;
                        count<=count+6'b000100 ; 
                end
                6'd9:begin 
                    lut_en <= 1;
                        count<=count+6'b000100 ; 
                end
                6'd10:begin
                    lut_en <= 1 ;
                        count<=count+6'b000100 ; 
                end
                6'd11:begin 
                    lut_en <= 1 ;
                        count<=count+6'b000100 ;
                end
                6'd12:begin 
                    lut_en <= 1 ;
                        count<=count+6'b000100 ; 
                end
                6'd13:begin 
                    lut_en <= 1 ;
                        count<=count+6'b000100 ; 
                end
                6'd14:begin 
                    lut_en <= 1;
                        count<=count+6'b000100 ; 
                end
                6'd15:begin
                    lut_en <= 1;
                    count<=count+6'b000100 ; 
                end
                6'd16:begin 
                    lut_en <= 1 ;
                        count<=count+6'b000100 ;
                end
                6'd17:begin 
                    lut_en <=1;
                        done <= 1'b0 ;
                        count<=count+6'b000100 ; 
                end
                6'd18:begin 
                    lut_en <= 0 ;
                        done <= 1'b1 ; 
                        count<=0; 
                end
                default :begin
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    count<=0; 
                    lut_en <=0 ; 
                end
            endcase
        end 
        if (is_datain)begin
            case(state)
                6'b000000:begin 
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    wr <=0; 
                    wr_out<= 1'b0 ;
                    count<=0;
                    lut_en <= 0 ; 
                end
                6'b000001:begin 
                    if(mode) begin
                        w_en <= 16'b0000000000000001 ;
//                        count<=count+6'b000100 ; 
                    end 
                    else begin 
                        i_en <= 1'b1 ; 
                        done <= 1'b0; 
                    end
                end
                6'b000010:begin 
                    if(mode) begin
                        w_en <= 16'b0000000000000010 ;
                        count<=count+6'b000100 ; 
                    end 
                    else begin
                        i_en <= 1'b0 ; 
                        done <= 1'b1 ; 
                    end 
                end
                6'b000011:begin 
                    if(mode) begin
                        w_en <= 16'b0000000000000100 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b000100:begin 
                    if(mode) begin
                        w_en <= 16'b0000000000001000 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b000101:begin 
                    if(mode) begin
                        w_en <= 16'b0000000000010000 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b000110:begin 
                    if(mode) begin
                        w_en <= 16'h0020 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b000111:begin 
                    if(mode) begin
                        w_en <= 16'h0040 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001000:begin 
                    if(mode) begin
                        w_en <= 16'h0080 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001001:begin 
                    if(mode) begin
                        w_en <= 16'h0100 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001010:begin 
                    if(mode) begin
                        w_en <= 16'h0200 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001011:begin 
                    if(mode) begin
                        w_en <= 16'h0400 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001100:begin 
                    if(mode) begin
                        w_en <= 16'h0800 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001101:begin 
                    if(mode) begin
                        w_en <= 16'h1000 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001110:begin 
                    if(mode) begin
                        w_en <= 16'h2000 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b001111:begin 
                    if(mode) begin
                        w_en <= 16'h4000 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b010000:begin 
                    if(mode) begin
                        w_en <= 16'h8000 ;
                        done <= 1'b0 ;
                        count<=count+6'b000100 ; 
                    end 
                end
                6'b010001:begin 
                    if(mode) begin
                        w_en <= 16'h0000 ;
                        done <= 1'b1 ; 
                        count<=0; 
                    end 
                    
                end
                default :begin
                    pe_en <=16'b0000000000000000 ; 
                    out_en <= 16'b0000000000000000 ;
                    w_shift <= 16'b0000000000000000 ; 
                    w_en <= 16'b0000000000000000 ;
                    i_shift <= 1'b0 ; 
                    i_en <= 1'b0 ; 
                    done <= 1'b0  ; 
                    count<=0; 
                    lut_en <=0 ; 
                end 
            endcase
        end 
    end 
    
    
endmodule
