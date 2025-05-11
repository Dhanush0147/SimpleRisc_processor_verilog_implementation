module mux_4x1(
    input s0,
    input s1,
    input d3,	


    input d2,
    input d1,
    input d0,
    output Y
);

assign Y = (~s1 & ~s0 & d0) |
           (~s1 &  s0 & d1) |
           ( s1 & ~s0 & d2) |
           ( s1 &  s0 & d3);
endmodule
