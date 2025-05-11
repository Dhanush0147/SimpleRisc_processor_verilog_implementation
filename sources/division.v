module division(
    input [31:0] a,
    input [31:0] b,
    input modulus,
    input division,
    output [31:0] aluResult
);

    wire [31:0] modd, divv;

    div alu_div(
        .a(a),
        .b(b),
        .y(divv)
    );

    mod alu_mod(
        .a(a),
        .b(b),
        .y(modd)
    );
    
    assign aluResult = (division) ? divv :(modulus)  ? modd :32'b0;

endmodule
