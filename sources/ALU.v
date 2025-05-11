

module ALU(
  input [31:0] a,
  input [31:0] b,
  input [14:0] alu_bus,
  output [31:0] aluResult,
  output gt,
  output eq
);

  wire [31:0] Adder_Result,shift_Result,mov_Result,logic_Result,division_Result,mul_Result;


Adder alu_adder(
  .a(a),
  .b(b),
  .isAdd(alu_bus[0] | alu_bus[13] | alu_bus[14]),
  .isSub(alu_bus[1]),
  .isCmp(alu_bus[5]),
  .aluResult(Adder_Result),
  .gt(gt),
  .eq(eq)
);

ushifter alu_sh(
  .m(a),
  .n(b[4:0]),
  .is_lsl(alu_bus[10]),
  .is_lsr(alu_bus[11]),
  .is_asr(alu_bus[12]),
  .aluResult(shift_Result)
);

mov alu_mv(
  .b(b),
  .isMov(alu_bus[9]),
  .aluResult(mov_Result)
);

logic_block alu_lg(
  .a(a),
  .b(b),
  .isAnd(alu_bus[6]),
  .isOr(alu_bus[7]),
  .isNot(alu_bus[8]),
  .aluResult(logic_Result)
);

division alu_dvmd(
  .a(a),
  .b(b),
  .modulus(alu_bus[4]),
  .division(alu_bus[3]),
  .aluResult(division_Result)
);

mul alu_mll(
  .a(a),
  .b(b),
  .isMul(alu_bus[2]),
  .aluResult(mul_Result)
);

assign aluResult = alu_bus[0]  ? Adder_Result :   // ADD
                 alu_bus[1]  ? Adder_Result :   // SUB
                 alu_bus[2]  ? mul_Result    :
                 alu_bus[3]  ? division_Result :
                 alu_bus[4]  ? division_Result :
                 alu_bus[5]  ? Adder_Result :   // CMP
                 alu_bus[6]  ? logic_Result  :
                 alu_bus[7]  ? logic_Result  :
                 alu_bus[8]  ? logic_Result  :
                 alu_bus[9]  ? mov_Result    :
                 alu_bus[10] ? shift_Result  :
                 alu_bus[11] ? shift_Result  :
                 alu_bus[12] ? shift_Result  :
                 alu_bus[13] ? Adder_Result  :  // LD uses address
                 alu_bus[14] ? Adder_Result  :  // ST uses address
                 32'b0;



endmodule