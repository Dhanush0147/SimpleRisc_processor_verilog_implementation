module execution_pipeline_tb;

    // Declare inputs as reg and outputs as wire
    reg clk;
    reg rst;
    reg [31:0] pc;
    reg [31:0] branchTarget;
    reg [31:0] B;
    reg [31:0] A;
    reg [31:0] op2;
    reg [31:0] instruction;
    reg [31:0] control;
    
    // Outputs
    wire [31:0] pc_out;
    wire [31:0] aluResult_out;
    wire [31:0] op2_out;
    wire [31:0] instruction_out;
    wire [31:0] control_out;
    wire [31:0] branch;
    wire isBranchTaken;

    // Instantiate the execution_pipeline module
    execution_pipeline uut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .branchTarget(branchTarget),
        .B(B),
        .A(A),
        .op2(op2),
        .instruction(instruction),
        .control(control),
        .pc_out(pc_out),
        .aluResult_out(aluResult_out),
        .op2_out(op2_out),
        .instruction_out(instruction_out),
        .control_out(control_out),
        .branch(branch),
        .isBranchTaken(isBranchTaken)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Initialize signals
    initial begin
        clk = 0;
        rst = 1;
        pc = 32'b0;
        branchTarget = 32'h100;  // Example branch target address
        B = 32'd0;  // Operand B
        A = 32'd50;  // Operand A
        op2 = 32'd0;  // Example op2
        instruction = 32'b0;
        control = 32'b0;
        
        // Reset
        #10 rst = 0;

        // Test Case 1: CALL Operation (is_call)
        instruction = 32'b0;
        control = 32'b00000000000001000000000000000000; // is_call = 1
        #10;
        $display("Time: %d | CALL Operation", $time);
        $display("Inputs: control = %b", control);
        $display("Outputs: branch = %d | isBranchTaken = %b", branch, isBranchTaken);
        
        // Test Case 2: RET Operation (is_ret)
        instruction = 32'b0;
        control = 32'b00000000000010000000000000000000; // is_ret = 1
        #10;
        $display("Time: %d | RET Operation", $time);
        $display("Inputs: control = %b", control);
        $display("Outputs: branch = %d | isBranchTaken = %b", branch, isBranchTaken);
        
        // End simulation
        $finish;
    end

endmodule