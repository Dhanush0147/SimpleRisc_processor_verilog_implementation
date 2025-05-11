module test;
  reg [31:0] instruction_in;
  reg [31:0] pc_in;
  reg clk;
  reg reset;
  reg [3:0] wr_adr;
  reg [31:0] wr_data;
  reg is_wb;

  wire [31:0] pc_out;
  wire [31:0] instruction_out;
  wire [23:0] control_bus_out;
  wire [31:0] btarget;
  wire [31:0] B;
  wire [31:0] A;
  wire [31:0] op2_out;

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
  always #5 clk = ~clk;

  initial begin
    $display("\n--- Test Start ---");

    clk = 1;
    reset = 1;
    wr_adr = 4'd0;
    wr_data = 32'd0;
    is_wb = 0;
    pc_in = 32'h0000_0000;
    instruction_in = 32'h0000_0000;

    #10 reset = 0;

    // Write some data into registers
    is_wb = 1;
    wr_adr = 4'd1; wr_data = 32'hAAAA_AAAA; #10;
    wr_adr = 4'd2; wr_data = 32'hBBBB_BBBB; #10;

    is_wb = 0;

    // Provide instruction using rs1=1, rs2=2, rd=3
    instruction_in = 32'b00000_0001_0010_0011_00000_0000000000;
    pc_in = 32'h0000_0010;
    #10;

    $display("pc_out         = %h", pc_out);
    $display("instruction_out= %h", instruction_out);
    $display("control_bus_out= %b", control_bus_out);
    $display("btarget        = %h", btarget);
    $display("A              = %h", A);
    $display("B              = %h", B);
    $display("op2_out        = %h", op2_out);
    $display("--- Test End ---\n");
    $finish;
  end
endmodule
