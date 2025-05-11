module ex_to_mr(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] aluResult,
    input [31:0] op2,
    input [31:0] instruction,
    input [31:0] control,
    output reg [31:0] pc_out,
    output reg [31:0] aluResult_out,
    output reg [31:0] op2_out,
    output reg [31:0] instruction_out,
    output reg [31:0] control_out
);

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            pc_out <= 32'b0;
            aluResult_out <= 32'b0;
            op2_out <= 32'b0;
            instruction_out <= 32'b0;
            control_out <= 32'b0;
        end
        else
        begin
            pc_out <= pc;
            aluResult_out <= aluResult;
            op2_out <= op2;
            instruction_out <= instruction;
            control_out <= control;
        end
    end

endmodule
