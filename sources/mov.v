module mov(
    input [31:0]  b,
    input isMov,
    output [31:0] aluResult
);
    assign  aluResult = (isMov)? b : 32'b0 ;
endmodule
