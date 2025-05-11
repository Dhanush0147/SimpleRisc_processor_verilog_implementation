`timescale 1ns / 1ps

module if_of_pipo_tb;

  // Inputs
  reg [31:0] instruction_i;
  reg [31:0] pc_i;
  reg clk;
  reg reset;

  // Output
  wire [63:0] of;

  // Instantiate the Unit Under Test (UUT)
  if_of_pipo uut (
    .instruction_i(instruction_i),
    .pc_i(pc_i),
    .clk(clk),
    .reset(reset),
    .of(of)
  );
  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initial values
    clk = 0;
    reset = 1;
    instruction_i = 32'd0;
    pc_i = 32'd0;

    $display("Time\t\tclk reset\tinstruction_i\t\tpc_i\t\t\toutput (of)");
    $monitor("%0dns\t%b   %b\t%032b\t%032b\t%064b", $time, clk, reset, instruction_i, pc_i, of);

    // Reset the register
    #10 reset = 0;

    // Apply first instruction and PC
    #10 instruction_i = 32'hA5A5A5A5;
        pc_i = 32'h00000004;

    // Apply second instruction and PC
    #10 instruction_i = 32'hDEADBEEF;
        pc_i = 32'h00000008;

    // Reset again to see clearing behavior
    #10 reset = 1;
    #10 reset = 0;

    // Another instruction
    #10 instruction_i = 32'h12345678;
        pc_i = 32'h0000000C;

    #20 $finish;
  end

endmodule
