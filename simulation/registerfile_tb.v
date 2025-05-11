`timescale 1ns/1ps

module registerfile_tb;

  reg clk, reset, is_wb, is_ret, is_st;
  reg [31:0] wr_data, instruction;
  reg [3:0] wr_adr;
  wire [31:0] op1, op2;

  // Instantiate the Device Under Test
  registerfile dut (
    .is_ret(is_ret),
    .is_st(is_st),
    .clk(clk),
    .instruction(instruction),
    .is_wb(is_wb),
    .wr_data(wr_data),
    .op1(op1),
    .op2(op2),
    .wr_adr(wr_adr),
    .reset(reset)
  );

  // Clock generation
  always #5 clk = ~clk;

  integer i;

  initial begin
    $display("Time | is_st | is_ret | wr_adr | wr_data | instruction | op1 | op2");
    $monitor("%4t | %b     | %b      | %d      | %d      | %h   | %d | %d",
             $time, is_st, is_ret, wr_adr, wr_data, instruction, op1, op2);

    // Initialize
    clk = 0;
    reset = 1;
    is_wb = 0;
    is_ret = 0;
    is_st = 0;
    wr_adr = 0;
    wr_data = 0;
    instruction = 0;

    #10 reset = 0;

    // Write to all 16 registers
    for (i = 0; i < 16; i = i + 1) begin
      @(posedge clk);
      wr_adr = i;
      wr_data = i * 10;
      is_wb = 1;
    end

    @(posedge clk);
    is_wb = 0;

    // Test is_ret: op1 should come from reg[15]
    instruction = 32'b00000000000000001001000000000000; // rs1 = 1001 = reg[9]
    is_ret = 1; is_st = 0;
    @(posedge clk);

    is_ret = 0;
    @(posedge clk);

    // Test is_st: op2 should use bits 25:22 = 1010 = reg[10]
    instruction = 32'b10100000000000000000000000000000; // rs2 = 1010 = reg[10]
    is_st = 1;
    @(posedge clk);

    is_st = 0;
    @(posedge clk);

    $finish;
  end
endmodule
