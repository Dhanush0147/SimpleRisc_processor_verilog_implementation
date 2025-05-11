module flag(
    input clk,
    input isCmp,
    input gt,
    input eq,
    output reg gt_out,
    output reg eq_out
);

    always @(posedge clk) begin
        if (isCmp) begin
            gt_out <= gt;
            eq_out <= eq;
        end
    end

endmodule
