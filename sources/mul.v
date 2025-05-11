module mul(
    input [31:0] a,
    input [31:0] b,
    input isMul,
    output [31:0] aluResult
);

    wire [31:0] w ;
    assign w = a*b;
    assign aluResult = (isMul)?  w: 32'b0;
    
endmodule
