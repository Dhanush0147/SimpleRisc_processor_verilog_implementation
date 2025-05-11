module execution_pipeline(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] branchTarget,
    input [31:0] B,
    input [31:0] A,
    input [31:0] op2,
    input [31:0] instruction,
    input [23:0] control,
    output [31:0] pc_out,
    output [31:0] aluResult_out,
    output [31:0] op2_out,
    output [31:0] instruction_out,
    output [23:0] control_out,
    output [31:0] branch,
    output isBranchTaken
);

    // Wires for the outputs from execution_unit
    wire [31:0] ex_pc_out;
    wire [31:0] ex_aluResult_out;
    wire [31:0] ex_op2_out;
    wire [31:0] ex_instruction_out;
    wire [23:0] ex_control_out;
    wire [31:0] ex_branch;
    wire ex_isBranchTaken;

    // Instantiate execution_unit
    execution_unit exu (
        .clk(clk),
        .pc(pc),
        .branchTarget(branchTarget),
        .B(B),
        .A(A),
        .op2(op2),
        .instruction(instruction),
        .control(control),
        .pc_out(ex_pc_out),
        .aluResult_out(ex_aluResult_out),
        .op2_out(ex_op2_out),
        .instruction_out(ex_instruction_out),
        .control_out(ex_control_out),
        .branch(ex_branch),
        .isBranchTaken(ex_isBranchTaken)
    );

    // Instantiate ex_to_mr
    ex_to_mr ex_to_mr_inst (
        .clk(clk),
        .rst(rst),
        .pc(ex_pc_out),
        .aluResult(ex_aluResult_out),
        .op2(ex_op2_out),
        .instruction(ex_instruction_out),
        .control(ex_control_out),
        .pc_out(pc_out),
        .aluResult_out(aluResult_out),
        .op2_out(op2_out),
        .instruction_out(instruction_out),
        .control_out(control_out)
    );

    // Forward the branch and branch taken signals
    assign branch = ex_branch;
    assign isBranchTaken = ex_isBranchTaken;

endmodule