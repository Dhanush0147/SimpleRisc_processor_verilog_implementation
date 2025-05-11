module branch_mux(
    input [31:0] branchTarget,
    input [31:0] A,
    input isRet,
    output [31:0] address
);

    assign address = (isRet)? A : branchTarget ;

endmodule
