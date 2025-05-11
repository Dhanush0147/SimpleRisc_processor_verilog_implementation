module data_memory(
    input write_en,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] out
);
    reg [7:0] mem [0:1023];

    initial begin
        mem[0] = 8'h13;
        mem[1] = 8'h00;
        mem[2] = 8'h00;
        mem[3] = 8'h00;

        mem[4] = 8'h93;
        mem[5] = 8'h00;
        mem[6] = 8'h10;
        mem[7] = 8'h00;

        mem[8]  = 8'hB3;
        mem[9]  = 8'h80;
        mem[10] = 8'h10;
        mem[11] = 8'h00;
    end

    always @(posedge write_en) begin
        mem[address]     <= write_data[7:0];
        mem[address + 1] <= write_data[15:8];
        mem[address + 2] <= write_data[23:16];
        mem[address + 3] <= write_data[31:24];
    end

    assign out = {mem[address + 3], mem[address + 2], mem[address + 1], mem[address]};
endmodule

module memory_unit(
    input isLd,
    input isSt,
    input [31:0] op2,
    input [31:0] aluResult,
    output reg [31:0] ldResult
);
    wire [31:0] out;
    
    // Instantiate the data memory
    data_memory mem1(
        .write_en(isSt),
        .address(aluResult),
        .write_data(op2),
        .out(out)
    );
    
    always @(*) begin
        if (isLd)
            ldResult = out;  // Use blocking assignment here for combinatorial logic
        else
            ldResult = 32'b0;
    end
endmodule

module me_ff_rw(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] ldResult,
    input [31:0] aluResult,
    input [31:0] instruction,       
    input [23:0] control,
    output reg [31:0] pc_out_mu,
    output reg [31:0] ldResult_out_mu,
    output reg [31:0] aluResult_out_mu,
    output reg [31:0] instruction_out_mu,
    output reg [23:0] control_out_mu
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out_mu          <= 32'b0;
            ldResult_out_mu    <= 32'b0;
            aluResult_out_mu   <= 32'b0;
            instruction_out_mu <= 32'b0;
            control_out_mu     <= 32'b0;
        end else begin
            pc_out_mu          <= pc;
            ldResult_out_mu    <= ldResult;
            aluResult_out_mu   <= aluResult;
            instruction_out_mu <= instruction;
            control_out_mu     <= control;
        end
    end

endmodule

module me_pipeline_rw(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] aluResult,
    input [31:0] op2,
    input [31:0] instruction,
    input [23:0] control,
    output [31:0] pc_out,
    output [31:0] ldResult_out,
    output [31:0] aluResult_out,
    output [31:0] instruction_out,
    output [23:0] control_out
);

wire [31:0] ldResult_w;

    memory_unit m_mem(
    .isLd(control[13]),
    .isSt(control[14]),
    .op2(op2),
    .aluResult(aluResult),
    .ldResult(ldResult_w)
    );
    
    me_ff_rw uuwu(
    .clk(clk),
    .rst(rst),
    .pc(pc),
    .ldResult(ldResult_w),
    .aluResult(aluResult),
    .instruction(instruction),       
    .control(control),
    .pc_out_mu(pc_out),
    .ldResult_out_mu(ldResult_out),
    .aluResult_out_mu(aluResult_out),
    .instruction_out_mu(instruction_out),
    .control_out_mu(control_out)
    );
endmodule

module selector_32_4bus(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input s1,
    input s2,   
    output [31:0] out
);
    assign out = ({32{(~s1)&(~s2)}} & a) | 
                 ({32{(~s1)&(s2)}}  & b) |
                 ({32{(s1)&(~s2)}}  & c);
endmodule


module writeback(
    input [31:0] pc,
    input [31:0] ldresult,
    input [31:0] aluresult,
    input [31:0] instruction,
    input is_wb,
    input is_call,
    input is_ld,
    output reg [31:0] data_out,
    output [3:0] rd_out,
    output reg is_wb_out
);
    wire [31:0] w1;
    wire [3:0] w2;

    selector_32_4bus mux(
        .a(aluresult),
        .b(ldresult),
        .c(pc + 32'd4),
        .s1(is_call),
        .s2(is_ld),
        .out(w1)
    );

    selector_4 reg_mux(
        .a(4'b1111),
        .b(instruction[25:22]),
        .s(is_call),
        .out(rd_out)
    );
always@(*)
begin
      data_out   <= w1;
      is_wb_out  <= is_wb;
end

endmodule

module me_to_wb_pipeline_top (
    input clk,
    input rst,
    input [31:0] pc_in,
    input [31:0] aluResult_in,
    input [31:0] op2_in,
    input [31:0] instruction_in,
    input [31:0] control_in,

    output [31:0] wb_data_out,
    output [3:0]  wb_rd_out,
    output        wb_enable_out
);

    // Wires between ME and WB
    wire [31:0] pc_me_wb;
    wire [31:0] ldResult_me_wb;
    wire [31:0] aluResult_me_wb;
    wire [31:0] instruction_me_wb;
    wire [31:0] control_me_wb;

    // Extracted control signals
    wire is_wb   = control_me_wb[21];
    wire is_call = control_me_wb[18];
    wire is_ld   = control_me_wb[13];

    // ME stage including memory and flip-flop
    me_pipeline_rw me_stage (
        .clk(clk),
        .rst(rst),
        .pc(pc_in),
        .aluResult(aluResult_in),
        .op2(op2_in),
        .instruction(instruction_in),
        .control(control_in),
        .pc_out(pc_me_wb),
        .ldResult_out(ldResult_me_wb),
        .aluResult_out(aluResult_me_wb),
        .instruction_out(instruction_me_wb),
        .control_out(control_me_wb)
    );

    // WB stage logic
    writeback wb_stage (
        .pc(pc_me_wb),
        .ldresult(ldResult_me_wb),
        .aluresult(aluResult_me_wb),
        .instruction(instruction_me_wb),
        .is_wb(is_wb),
        .is_call(is_call),
        .is_ld(is_ld),
        .data_out(wb_data_out),
        .rd_out(wb_rd_out),
        .is_wb_out(wb_enable_out)
    );

endmodule