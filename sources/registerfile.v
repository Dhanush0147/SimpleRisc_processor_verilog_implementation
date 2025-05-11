// regfile module
module regfile(
  input clk,
  input is_wb,
  input reset,
  input [31:0] wr_data,
  output [31:0] rd_data_1,
  output [31:0] rd_data_2,
  input [3:0] rd_adr_1,
  input [3:0] rd_adr_2,
  input [3:0] wr_adr
);
  integer k;
  reg [31:0] reg_file[0:15];
  assign rd_data_1 = reg_file[rd_adr_1];
  assign rd_data_2 = reg_file[rd_adr_2];
  
  always @(posedge clk or posedge reset) begin
      if (reset) begin
          for (k = 0; k < 16; k = k + 1) begin
          if(k==2)
          begin 
              reg_file[k] <= 32'h00000005;
           end 
           else 
           begin 
            reg_file[k] <= 32'h00000001;
            end 
          end
      end else begin
          if (is_wb)
              reg_file[wr_adr] <= wr_data;
      end
  end
endmodule

// selector module

// regbank module
module registerfile(
  input is_ret,
  input is_st,
  input clk,
  input [31:0] instruction,
  input is_wb,
  input [31:0] wr_data,
  output [31:0] op1,
  output [31:0] op2,
  input [3:0] wr_adr,
  input reset
);
  wire [3:0] w1, w2;

  selector_4 s1( // for is_ret
      .s(is_ret),
      .a(4'b1111),
      .b(instruction[21:18]),
      .out(w1)
  );
  selector_4 s2(//for is_st
      .s(is_st),
      .a(instruction[25:22]),
      .b(instruction[17:14]),
      .out(w2)
  );

  regfile file(
      .clk(clk),
      .reset(reset),
      .is_wb(is_wb),
      .wr_data(wr_data),
      .wr_adr(wr_adr),
      .rd_data_1(op1),
      .rd_data_2(op2),
      .rd_adr_1(w1),
      .rd_adr_2(w2)
  );
endmodule
