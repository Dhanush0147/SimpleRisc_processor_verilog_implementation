module Adder_Subtracter(
    input [31:0] A,
    input [31:0] B,
    input s,
    output [31:0] Sum,
    output Cout
);
    wire [31:0] B_xor; 
    wire [31:0] carry; 

    assign B_xor = B ^ {32{s}}; 

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) 
        begin : adders
            if (i == 0)
            begin
                Full_Adder add0 (
                    .A(A[i]),
                    .B(B_xor[i]),
                    .Cin(s),  
                    .Sum(Sum[i]),
                    .Cout(carry[i])
                );
            end 
            else 
            begin
                Full_Adder addN (
                    .A(A[i]),
                    .B(B_xor[i]),
                    .Cin(carry[i-1]),
                    .Sum(Sum[i]),
                    .Cout(carry[i])
                );
            end
        end
        
    endgenerate
    
    assign Cout = carry[31];
    
endmodule
