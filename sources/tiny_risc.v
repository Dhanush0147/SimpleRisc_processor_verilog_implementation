`timescale 1ns / 1ps


module tiny_risc(
    input clk,
    //output [31:0] pc_out,
    //output [31:0] instruction_out,
    input reset,
    output [31:0] data_out,
    output [3:0] rd_out,
    output  wb_out
    );
    wire [3:0]wr_adr;
    wire [31:0] wr_data;
    wire is_wb;
    
    wire [31:0] pc_in_ff;
    wire [31:0] instruction_in_ff;
    wire [31:0] pc_out_ff;
    wire [31:0] instruction_out_ff;
    
    
    wire [31:0] pc_ex_in;
    wire [31:0] op2_ex_in;
    wire [31:0] instruction_ex_in;
    wire [23:0] control_ex_in;
    wire [31:0] btarget_ex_in;
    wire [31:0] A_ex_in;
    wire [31:0] B_ex_in;
    wire isBranchTaken_ex;
    
    
    wire [31:0] pc_me_in ;
    wire [31:0] aluResult_me_in ;
    wire [31:0] op2_me_in ;
    wire [31:0] instruction_me_in ;
    wire [23:0] control_me_in ;
    
    wire [31:0] pc_wb_in;
    wire [31:0] ldResult_wb_in;
    wire [31:0] aluResult_wb_in;
    wire [31:0] instruction_wb_in;
    wire [23:0] control_wb_in;
    wire [31:0] branch_ex_out;
  
  

instruction_fetch if_unit(
        .isBranchTaken(isBranchTaken_ex),
        .branchPC(branch_ex_out),
        .clk(clk),
        .pc(pc_in_ff),
        .instruction(instruction_in_ff)
        );
  if_of_pipo if_of_pp(
        .pc_in(pc_in_ff),
        .instruction_in(instruction_in_ff),
        .reset(reset),
        .clk(clk),
        .instruction_out(instruction_out_ff),
        .pc_out(pc_out_ff)
        );
  of_unit of(
    .pc_in(pc_out_ff),
    .instruction_in(instruction_out_ff),
    .wr_data(wr_data),
    .is_wb(is_wb),
    .wr_adr(wr_adr),
    .reset(reset),
    .clk(clk),
    .A_out(A_ex_in),
    .B_out(B_ex_in),
    .op2_out(op2_ex_in),
    .instruction_out(instruction_ex_in),
    .pc_out(pc_ex_in),
    .btarget_out(btarget_ex_in),
    .control_bus_out(control_ex_in)
  );
  
  execution_pipeline ex_pipeline (
        .clk(clk),
        .rst(reset),
        .pc(pc_ex_in),
        .A(A_ex_in),
        .B(B_ex_in),
        .branchTarget(btarget_ex_in),
        .op2(op2_ex_in),
        .instruction(instruction_ex_in),
        .control(control_ex_in), 
        
        .pc_out(pc_me_in),
        .aluResult_out(aluResult_me_in),
        .op2_out(op2_me_in),
        .instruction_out(instruction_me_in),
        .control_out(control_me_in),
        .branch(branch_ex_out),
        .isBranchTaken(isBranchTaken_ex)
    );
    
    
    me_pipeline_rw me_pipeline(
    .clk(clk),
    .rst(reset),
    .pc(pc_me_in),
    .aluResult(aluResult_me_in),
    .op2(op2_me_in),
    .instruction(instruction_me_in),
    .control(control_me_in),
    .pc_out(pc_wb_in),
    .ldResult_out(ldResult_wb_in),
    .aluResult_out(aluResult_wb_in),
    .instruction_out(instruction_wb_in),
    .control_out(control_wb_in)
    );
  
    
    
     writeback wb_stage (
        .pc(pc_wb_in),
        .ldresult(ldResult_wb_in),
        .aluresult(aluResult_wb_in),
        .instruction(instruction_wb_in),
        .is_wb(control_wb_in[21]),
        .is_call(control_wb_in[18]),
        .is_ld(control_wb_in[13]),
        .data_out(data_out),
        .rd_out(rd_out),
        .is_wb_out(wb_out)
    );
    assign wr_adr =rd_out;
    assign wr_data =data_out;
    assign is_wb =wb_out;

endmodule