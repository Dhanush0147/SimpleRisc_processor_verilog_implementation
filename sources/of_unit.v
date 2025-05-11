

module of_unit(
     input [31:0] instruction_in,
    input [31:0] pc_in,
    input clk,
    input reset,
    input [3:0]wr_adr,
    input [31:0] wr_data,
    input is_wb,
    output [31:0] pc_out,
    output [31:0] instruction_out,
    output [23:0] control_bus_out,
    output [31:0] btarget_out,
    output [31:0] B_out,
    output [31:0] A_out,
    output [31:0] op2_out
   
    );
    wire [23:0]control_bus;
    wire [31:0] op1,op2;
    wire [31:0] immediate;
    wire [31:0] A,B ;
    wire [31:0] btarget;
   
   control cunit(
   .opcode(instruction_in[31:26]),
   .control_bus(control_bus)
   );
   registerfile register(
   .clk(clk),
   .is_wb(is_wb),
   .wr_data(wr_data),
   .wr_adr(wr_adr),
   .instruction(instruction_in),
   .op1(op1),
   .op2(op2),
   .reset(reset),
   .is_st(control_bus[14]),
   .is_ret(control_bus[19])
  );
  
   imm_btarget immx_btarget(
    .instruction(instruction_in),
    .pc(pc_in),
    .immediate(immediate),
    .btarget(btarget)
  );
    selector_32 imm(
  .a(op2),
  .b(immediate),
  .s(control_bus[20]),
  .out(B)
  );
  of_ex_pipo of_ex_pipeline(
       .clk(clk),
     .reset(reset),
     .pc_in(pc_in),
      .instruction_in(instruction_in),
      .B_in(B),
     .A_in(op1),
      .op2_in(op2),
      .btarget_in(btarget),
     .control_bus_in(control_bus),
     . pc_out(pc_out),
    . instruction_out(instruction_out),
     .B_out(B_out),
    . A_out(A_out),
     .op2_out(op2_out),
     .control_bus_out(control_bus_out),
     .btarget_out(btarget_out)
  );
       
endmodule
