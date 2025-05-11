module execution_unit(
    input clk,
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

    wire gt_flag,eq_flag;
    wire gt_out,eq_out;
    
    branch_mux mbranch(
        .branchTarget(branchTarget),
        .A(A),
        .isRet(control[19]),
        .address(branch)
    );
    
    ALU alu_exu(
    .a(A),
    .b(B),
    .alu_bus(control[14:0]),
    .aluResult(aluResult_out),
    .gt(gt_flag),
    .eq(eq_flag)
    );
    
    flag f_ex(
    .clk(clk),
    .isCmp(control[5]),
    .gt(gt_flag),
    .eq(eq_flag),
    .gt_out(gt_out),
    .eq_out(eq_out)
    );
    
    branch_unit b_unt(
    .beq(eq_out),
    .gt(gt_out),
    .is_b(control[17]),
    .is_beq(control[15]),
    .is_bgt(control[16]),
    .is_call(control[18]),
    .is_ret(control[19]),
    .is_branchtaken(isBranchTaken)
    );
    
    assign pc_out = pc;
    assign op2_out = op2;
    assign instruction_out = instruction;
    assign control_out = control;
    
endmodule
