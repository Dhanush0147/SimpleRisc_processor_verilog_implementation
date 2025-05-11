module control(
  input [5:0] opcode,
  output [23:0] control_bus
);

  assign control_bus[0]  = (opcode[5:1] == 5'b00000) ? 1'b1 : 1'b0; // is_add
  assign control_bus[1]  = (opcode[5:1] == 5'b00001) ? 1'b1 : 1'b0; // is_sub
  assign control_bus[2]  = (opcode[5:1] == 5'b00010) ? 1'b1 : 1'b0; // is_mul
  assign control_bus[3]  = (opcode[5:1] == 5'b00011) ? 1'b1 : 1'b0; // is_div
  assign control_bus[4]  = (opcode[5:1] == 5'b00100) ? 1'b1 : 1'b0; // is_mod
  assign control_bus[5]  = (opcode[5:1] == 5'b00101) ? 1'b1 : 1'b0; // is_cmp
  assign control_bus[6]  = (opcode[5:1] == 5'b00110) ? 1'b1 : 1'b0; // is_and
  assign control_bus[7]  = (opcode[5:1] == 5'b00111) ? 1'b1 : 1'b0; // is_or
  assign control_bus[8]  = (opcode[5:1] == 5'b01000) ? 1'b1 : 1'b0; // is_not
  assign control_bus[9]  = (opcode[5:1] == 5'b01001) ? 1'b1 : 1'b0; // is_mov
  assign control_bus[10] = (opcode[5:1] == 5'b01010) ? 1'b1 : 1'b0; // is_lsl
  assign control_bus[11] = (opcode[5:1] == 5'b01011) ? 1'b1 : 1'b0; // is_lsr
  assign control_bus[12] = (opcode[5:1] == 5'b01100) ? 1'b1 : 1'b0; // is_asr
  assign control_bus[13] = (opcode[5:1] == 5'b01110) ? 1'b1 : 1'b0; // is_ld
  assign control_bus[14] = (opcode[5:1] == 5'b01111) ? 1'b1 : 1'b0; // is_st
  assign control_bus[15] = (opcode[5:1] == 5'b10000) ? 1'b1 : 1'b0; // is_beq
  assign control_bus[16] = (opcode[5:1] == 5'b10001) ? 1'b1 : 1'b0; // is_bgt
  assign control_bus[17] = (opcode[5:1] == 5'b10010) ? 1'b1 : 1'b0; // is_ubranch
  assign control_bus[18] = (opcode[5:1] == 5'b10011) ? 1'b1 : 1'b0; // is_call
  assign control_bus[19] = (opcode[5:1] == 5'b10100) ? 1'b1 : 1'b0; // is_ret
  assign control_bus[20] = (opcode[0] == 1'b1) ? 1'b1 : 1'b0;       // is_immediate
  assign control_bus[21] = (opcode[5:1] == 5'b00101 || opcode[5:1] == 5'b01101 || opcode[5:1] == 5'b01111 || opcode[5] == 1'b1) ? 1'b0 : 1'b1; // is_wb
  assign control_bus[22] = (opcode[5:1] == 5'b01101) ? 1'b1 : 1'b0; // is_nop
  assign control_bus[23] = (opcode[5:1] == 5'b11111) ? 1'b1 : 1'b0; // is_hlt

endmodule
