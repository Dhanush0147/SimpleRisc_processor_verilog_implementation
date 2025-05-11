`timescale 1ns / 1ps

module tb_tiny_risc;

  reg clk;
  reg reset;

  wire [31:0] data_out;
  wire [3:0] rd_out;
  wire  wb_out;
  wire [31:0] final_instrcution_out ;

  // Instantiate the DUT
  tiny_risc uut (
    .clk(clk),
    .reset(reset),
    .data_out(data_out),
    .rd_out(rd_out),
    .wb_out(wb_out)
  );

  integer clk_cycle = 0;

  // Clock generation
  always #5 clk = ~clk;

  // Monitor block
  always @(posedge clk) begin
    clk_cycle = clk_cycle + 1;
 $display("\n================ Clock Cycle %0d ================\n", clk_cycle);
    // instruction_fetch
    $display("IF Unit:");
    $display("  clk             = %b", uut.if_unit.clk);
    $display("  isBranchTaken   = %b", uut.if_unit.isBranchTaken);
    $display("  branchPC        = %h", uut.if_unit.branchPC);
    $display("  pc              = %h", uut.if_unit.pc);
    $display("  instruction     = %h", uut.if_unit.instruction);

    // if_of_pipo
    $display("IF/OF PIPO:");
    $display("  clk             = %b", uut.if_of_pp.clk);
    $display("  reset           = %b", uut.if_of_pp.reset);
    $display("  pc_in           = %h", uut.if_of_pp.pc_in);
    $display("  instruction_in  = %h", uut.if_of_pp.instruction_in);
    $display("  pc_out          = %h", uut.if_of_pp.pc_out);
    $display("  instruction_out = %h", uut.if_of_pp.instruction_out);

    // of_unit
    $display("OF Unit:");
    $display("  clk             = %b", uut.of.clk);
    $display("  reset           = %b", uut.of.reset);
    $display("  pc_in           = %h", uut.of.pc_in);
    $display("  instruction_in  = %h", uut.of.instruction_in);
    $display("  wr_data         = %h", uut.of.wr_data);
    $display("  is_wb           = %b", uut.of.is_wb);
    $display("  wr_adr          = %h", uut.of.wr_adr);
    $display("  A_out           = %h", uut.of.A_out);
    $display("  B_out           = %h", uut.of.B_out);
    $display("  op2_out         = %h", uut.of.op2_out);
    $display("  instruction_out = %h", uut.of.instruction_out);
    $display("  pc_out          = %h", uut.of.pc_out);
    $display("  btarget_out     = %h", uut.of.btarget_out);
    $display("  control_bus_out = %h", uut.of.control_bus_out);

    // execution_pipeline
    $display("Execution Pipeline:");
    $display("  clk             = %b", uut.ex_pipeline.clk);
    $display("  rst             = %b", uut.ex_pipeline.rst);
    $display("  pc              = %h", uut.ex_pipeline.pc);
    $display("  A               = %h", uut.ex_pipeline.A);
    $display("  B               = %h", uut.ex_pipeline.B);
    $display("  branchTarget    = %h", uut.ex_pipeline.branchTarget);
    $display("  op2             = %h", uut.ex_pipeline.op2);
    $display("  instruction     = %h", uut.ex_pipeline.instruction);
    $display("  control         = %h", uut.ex_pipeline.control);
    $display("  pc_out          = %h", uut.ex_pipeline.pc_out);
    $display("  aluResult_out   = %h", uut.ex_pipeline.aluResult_out);
    $display("  op2_out         = %h", uut.ex_pipeline.op2_out);
    $display("  instruction_out = %h", uut.ex_pipeline.instruction_out);
    $display("  control_out     = %h", uut.ex_pipeline.control_out);
    $display("  branch          = %h", uut.ex_pipeline.branch);
    $display("  isBranchTaken   = %b", uut.ex_pipeline.isBranchTaken);

    // me_pipeline_rw
    $display("ME Pipeline:");
    $display("  clk             = %b", uut.me_pipeline.clk);
    $display("  rst             = %b", uut.me_pipeline.rst);
    $display("  pc              = %h", uut.me_pipeline.pc);
    $display("  aluResult       = %h", uut.me_pipeline.aluResult);
    $display("  op2             = %h", uut.me_pipeline.op2);
    $display("  instruction     = %h", uut.me_pipeline.instruction);
    $display("  control         = %h", uut.me_pipeline.control);
    $display("  pc_out          = %h", uut.me_pipeline.pc_out);
    $display("  ldResult_out    = %h", uut.me_pipeline.ldResult_out);
    $display("  aluResult_out   = %h", uut.me_pipeline.aluResult_out);
    $display("  instruction_out = %h", uut.me_pipeline.instruction_out);
    $display("  control_out     = %h", uut.me_pipeline.control_out);

    // writeback
    $display("Writeback Stage:");
    $display("  pc              = %h", uut.wb_stage.pc);
    $display("  ldresult        = %h", uut.wb_stage.ldresult);
    $display("  aluresult       = %h", uut.wb_stage.aluresult);
    $display("  instruction     = %h", uut.wb_stage.instruction);
    $display("  is_wb           = %b", uut.wb_stage.is_wb);
    $display("  is_call         = %b", uut.wb_stage.is_call);
    $display("  is_ld           = %b", uut.wb_stage.is_ld);
    $display("  data_out        = %h", uut.wb_stage.data_out);
    $display("  rd_out          = %h", uut.wb_stage.rd_out);
    $display("  is_wb_out       = %b", uut.wb_stage.is_wb_out);
    $display(" wire             =%h " ,uut.control_wb_in);
  end
assign final_instrcution_out = uut.wb_stage.instruction;
  // Stimulus
  initial begin
    $dumpfile("tiny_risc.vcd");
    $dumpvars(0, tb_tiny_risc);

    $display("===== Starting tiny_risc Full Testbench =====");
    clk = 0;
    reset = 1;
    #5 reset = 0;

    repeat (25) #10; // 20 clock cycles

    $display("===== Testbench Complete =====");
    $finish;
  end

endmodule
