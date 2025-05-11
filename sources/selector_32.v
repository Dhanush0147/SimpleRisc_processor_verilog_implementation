`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 01:59:15
// Design Name: 
// Module Name: selector_32
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


module selector_32(
input [31:0]a ,
input [31:0] b,
input s,
output [31:0] out
);

assign out = ({32{~s}}&a) | 
               ({32{s}}&b) ;
endmodule
