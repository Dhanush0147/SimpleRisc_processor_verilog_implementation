`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 23:23:37
// Design Name: 
// Module Name: of_ex_pipo
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


module of_ex_pipo(
    input clk,
    input reset,
    input [31:0] pc_in,
    input [31:0] instruction_in,
    input [31:0] B_in,
    input [31:0] A_in,
    input [31:0] op2_in,
    input [23:0] control_bus_in,
     input [31:0] btarget_in,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out,
     output reg [31:0] B_out,
    output reg[31:0] A_out,
    output reg[31:0] op2_out,
    output reg[23:0] control_bus_out,
    output reg [31:0] btarget_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;
            instruction_out <= 32'b0;
            B_out<=32'b0;
            A_out<=32'b0;
            op2_out<=32'b0;
            control_bus_out<=32'b0;
            btarget_out<=32'b0;
            
        end else begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
             B_out<=B_in;
            A_out<= A_in;
            op2_out<=op2_in;
            control_bus_out<=control_bus_in;
            btarget_out<=btarget_in;
            
        end
    end
endmodule