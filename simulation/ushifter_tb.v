`timescale 1ns / 1ps

module ushifter_tb;

    reg [31:0] m;
    reg is_lsl, is_lsr, is_asr;
    reg [4:0] n;
    wire [31:0] aluResult;

    // Instantiate the Unit Under Test (UUT)
    ushifter uut (
        .m(m),
        .is_lsl(is_lsl),
        .is_lsr(is_lsr),
        .is_asr(is_asr),
        .n(n),
        .aluResult(aluResult)
    );

    initial begin
        $display("Time\tOperation\tShiftAmt\tInput\t\t\tOutput");

        // Test LSL
        m = 32'h0000_00F0; // test left shift
        n = 5'd4;
        is_lsl = 1; is_lsr = 0; is_asr = 0;
        #10;
        $display("%0t\tLSL\t\t%b\t\t%b\t%b", $time, n, m, aluResult);

        // Test LSR
        m = 32'hF000_0000; // test logical right shift
        n = 5'd4;
        is_lsl = 0; is_lsr = 1; is_asr = 0;
        #10;
        $display("%0t\tLSR\t\t%b\t\t%b\t%b", $time, n, m, aluResult);

        // Test ASR
        m = 32'hF000_0000; // test arithmetic right shift (should preserve sign)
        n = 5'd4;
        is_lsl = 0; is_lsr = 0; is_asr = 1;
        #10;
        $display("%0t\tASR\t\t%d\t\t%b\t%b", $time, n, m, aluResult);

        // Another LSL
        m = 32'h0000_000F;
        n = 5'd8;
        is_lsl = 1; is_lsr = 0; is_asr = 0;
        #10;
        $display("%0t\tLSL\t\t%d\t\t%b\t%b", $time, n, m, aluResult);

        // Another LSR
        m = 32'h0F00_0000;
        n = 5'd8;
        is_lsl = 0; is_lsr = 1; is_asr = 0;
        #10;
        $display("%0t\tLSR\t\t%d\t\t%h\t%h", $time, n, m, aluResult);

        // Another ASR with sign extension
        m = 32'hFF00_0000;
        n = 5'd8;
        is_lsl = 0; is_lsr = 0; is_asr = 1;
        #10;
        $display("%0t\tASR\t\t%d\t\t%h\t%h", $time, n, m, aluResult);
        $finish;
    end

endmodule
