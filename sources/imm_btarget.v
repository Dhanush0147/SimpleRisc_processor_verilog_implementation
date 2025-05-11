






module imm_btarget(
 input [31:0] instruction,
    input [31:0] pc,
    output [31:0] btarget,
    output [31:0] immediate
    );
    assign btarget = {{3{instruction[26]}},instruction[26:0],2'b00} + pc;
   assign immediate = (instruction[17:16] == 2'b00) ? {{16{instruction[15]}}, instruction[15:0]} :  
                   (instruction[17:16] == 2'b01) ? {{16{1'b0}}, instruction[15:0]} :     
                   (instruction[17:16] == 2'b10) ? {instruction[15:0], {16{1'b0}}} :    
                   {32{1'bz}};
endmodule
