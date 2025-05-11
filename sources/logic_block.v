module logic_block(
    input [31:0] a,
    input [31:0] b,
    input isAnd,
    input isOr,
    input isNot,
    output reg [31:0] aluResult
);

    always @(*) begin
        if (isAnd)
            aluResult = a & b;
        else if (isOr)
            aluResult = a | b;
        else if (isNot)
            aluResult = ~b;
        else
            aluResult = 32'b0;
    end

endmodule
