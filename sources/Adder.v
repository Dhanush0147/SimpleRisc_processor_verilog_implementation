module Adder(
    input [31:0] a,
    input [31:0] b,
    input isAdd,
    input isSub,
    input isCmp,
    output [31:0] aluResult,
    output gt,
    output eq
);
    wire w, Cout;
    wire [31:0] sum;

    assign w = (isSub | isCmp) ? 1'b1 : 1'b0;

    Adder_Subtracter alu_add (
        .A(a),
        .B(b),
        .s(w),
        .Sum(sum),
        .Cout(Cout)
    );

    assign aluResult = sum;

    assign eq = (isCmp && (sum == 32'b0)) ? 1'b1 : 1'b0;
    assign gt = (isCmp && (sum[31] == 1'b0) && (sum != 32'b0)) ? 1'b1 : 1'b0;
    

endmodule
