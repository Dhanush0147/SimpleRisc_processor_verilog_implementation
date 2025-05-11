module tb_writeback;

    reg  [31:0] pc;
    reg  [31:0] ldresult;
    reg  [31:0] aluresult;
    reg  [31:0] instruction;
    reg         is_wb;
    reg         is_call;
    reg         is_ld;

    wire [31:0] data_out;
    wire [3:0]  rd_out;
    wire        is_wb_out;

    // Instantiate the writeback module
    writeback uut (
        .pc(pc),
        .ldresult(ldresult),
        .aluresult(aluresult),
        .instruction(instruction),
        .is_wb(is_wb),
        .is_call(is_call),
        .is_ld(is_ld),
        .data_out(data_out),
        .rd_out(rd_out),
        .is_wb_out(is_wb_out)
    );

    initial begin
        $display("\n--- Writeback Testbench Start ---\n");

        // ----------- Test 1: ALU Result ------------
        pc          = 32'h00000010;
        aluresult   = 32'hAABBCCDD;
        ldresult    = 32'h12345678;
        instruction = 32'b00000000000000000001000100000000;  // RD = 4'b0100 (bits 26:23)
        is_wb       = 1;
        is_call     = 0;
        is_ld       = 0;

        #5;
        $display("Test 1: ALU result");
        $display("Data Out     = 0x%h", data_out);
        $display("RD Out       = %d", rd_out);
        $display("WB Enable    = %b\n", is_wb_out);

        // ----------- Test 2: Load Result ------------
        pc          = 32'h00000020;
        aluresult   = 32'hDEADDEAD;
        ldresult    = 32'hCAFEBABE;
        instruction = 32'b00000000000000000001001000000000;  // RD = 4'b0100 (bits 26:23)
        is_wb       = 1;
        is_call     = 0;
        is_ld       = 1;

        #5;
        $display("Test 2: Load result");
        $display("Data Out     = 0x%h", data_out);
        $display("RD Out       = %d", rd_out);
        $display("WB Enable    = %b\n", is_wb_out);

        // ----------- Test 3: Call Instruction ------------
        pc          = 32'h00000030;
        aluresult   = 32'h00000000;
        ldresult    = 32'h00000000;
        instruction = 32'b00000000000000000000000000000000;  // ignored since call forces rd = 4'b1111
        is_wb       = 1;
        is_call     = 1;
        is_ld       = 0;

        #5;
        $display("Test 3: Call instruction");
        $display("Data Out     = 0x%h", data_out);
        $display("RD Out       = %d", rd_out);
        $display("WB Enable    = %b\n", is_wb_out);

        $display("--- Writeback Testbench End ---\n");
        $finish;
    end

endmodule