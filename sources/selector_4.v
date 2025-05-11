module selector_4(
    input  [3:0]a, b,
    input  s,
    output  [3:0] out
);
    assign out = s ? a : b;
endmodule
