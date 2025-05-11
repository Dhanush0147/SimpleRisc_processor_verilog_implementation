module tb_execution_pipeline_ld_st;

    // Inputs
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

    // Instantiate the execution_pipeline
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
    always #5 clk = ~clk;

    // Task to display outputs
    task display_outputs;
        begin
            $display("Time=%0t | PC=%0h | ALUResult=%h | op2=%0h | Instruction=%0h | Control=%b | BranchAddr=%0h | isBranchTaken=%b",
                $time, pc_out, aluResult_out, op2_out, instruction_out, control_out, branch, isBranchTaken);
        end
    endtask

    initial begin
        // Init signals
        clk = 0;
        rst = 1;
        pc = 32'h00000000;
        branchTarget = 32'h00000000;
        B = 32'd4;
        A = 32'h0F0F0F0F;
        op2 = 32'hF0F0F0F0;
        instruction = 32'hAAAAAAAA;
        control = 32'b0;

        // Apply reset
        #10;
        rst = 0;

       
        // ----------- AND Instruction -------------
        #10;
        pc = 32'h00000018;
        A = 32'h0F0F0F0F;
        B = 32'hF0F0F0F0;
        instruction = 32'h33333333;
        control = 32'b00000000000000000000000001000000;  // is_and = 1 (bit 6)

        #10 display_outputs();

        // ----------- OR Instruction -------------
        #10;
        pc = 32'h0000001C;
        A = 32'h0F0F0F0F;
        B = 32'hF0F0F0F0;
        instruction = 32'h44444444;
        control = 32'b00000000000000000000000010000000;  // is_or = 1 (bit 7)

        #10 display_outputs();

        // ----------- NOT Instruction -------------
        #10;
        pc = 32'h00000020;
        A = 32'hAAAAAAAA;
        B = 32'h00000000;  // Irrelevant
        instruction = 32'h55555555;
        control = 32'b00000000000000000000000100000000;  // is_not = 1 (bit 8)

        #10 display_outputs();

        // ----------- End Simulation -------------
        #10;
        $finish;
    end

endmodule