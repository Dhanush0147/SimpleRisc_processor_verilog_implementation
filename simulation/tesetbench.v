


`timescale 1ns / 1ps

module test_of_unit;

  // Inputs
  reg [31:0] instruction_in;
  reg [31:0] pc_in;
  reg clk;
  reg reset;
  reg [3:0] wr_adr;
  reg [31:0] wr_data;
  reg is_wb;

  // Outputs
  wire [31:0] pc_out;
  wire [31:0] instruction_out;
  wire [23:0] control_bus_out;
  wire [31:0] btarget;
  wire [31:0] B;
  wire [31:0] A;
  wire [31:0] op2_out;

  // Instantiate the Unit Under Test (UUT)
  of_unit uut (
    .instruction_in(instruction_in),
    .pc_in(pc_in),
    .clk(clk),
    .reset(reset),
    .wr_adr(wr_adr),
    .wr_data(wr_data),
    .is_wb(is_wb),
    .pc_out(pc_out),
    .instruction_out(instruction_out),
    .control_bus_out(control_bus_out),
    .btarget(btarget),
    .B(B),
    .A(A),
    .op2_out(op2_out)
  );

  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  // Test Sequence
  integer i;
  reg [3:0] rd, rs1, rs2;
  reg [5:0]opcode ;
  reg [17:0] immediate;
  reg[26:0] branchtarget;
  initial begin
    $display("\n--- Vivado Simulation Start ---");

    // Initial reset
    instruction_in = 0;
    pc_in = 0;
    wr_adr = 0;
    wr_data = 0;
    is_wb = 0;

    #10 reset = 0;

    // Step 1: Fill all 16 registers
    $display("Writing data to all registers...");
    is_wb = 1;
    for (i = 0; i < 16; i = i + 1) begin
      wr_adr = i[3:0];
      #10;
      
      wr_data = i[31:0]; // Unique value for each reg
    end
    is_wb = 0;
    #10;

    // Step 2: Send ADD instructions to read registers
    $display("\nReading register values using ADD instructions...");
    for (i = 0; i < 13; i = i + 1) begin
      rs1 = i[3:0];
    rs2 = 4'b0011;
    rd  = (i + 2) & 4'b1111; 
      
      // Format: opcode(5) rd(4) rs1(4) rs2(4) func(5) unused(10)
      instruction_in = {6'b101000, rd, rs1, rs2, 14'b10000000000000};
      opcode = instruction_in[31:26];
      immediate = instruction_in[17:0];
      branchtarget = instruction_in[26:0];
      pc_in = 32'h00000020 + i*4;
      #10;

      $display("instruction : %b", instruction_in);
      $display("rd  (%2d) --> R%0d", instruction_in[25:22], rd);
      $display("rs1 (%2d) --> R%0d", instruction_in[21:18], rs1);
      $display("rs2 (%2d) --> R%0d", instruction_in[17:14], rs2);
      $display("op (%2d) ---> R%0d",instruction_in[31:26],opcode);
      $display("ret         --> R15 (4'b1111)");
      $display("A (R%0d)    : %h", rs1, A);
      $display("B (R%0d)    : %h", rs2, B);
      $display("op2_out     : %h", op2_out);
      $display("PC          : %h", pc_out);
      $display("branchtarget : %h", branchtarget);
      $display("imm         : %h",immediate);
      
    end

    $display("--- Vivado Simulation End ---\n");
    $stop;
  end

endmodule
