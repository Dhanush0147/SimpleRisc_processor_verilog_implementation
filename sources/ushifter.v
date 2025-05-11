module proto(
    input d,
    input d3,
    input d2,
    input d1,
    input d0,
    input s,
    input s0,
    input s1,
    output Y
);
wire m0, m1, m2, m3;

mux2x1 M0(.s(s), .A(d), .B(d0), .Y(m0));
mux2x1 M1(.s(s), .A(d), .B(d1), .Y(m1));
mux2x1 M2(.s(s), .A(d), .B(d2), .Y(m2));
mux2x1 M3(.s(s), .A(d), .B(d3), .Y(m3));

mux_4x1 final_mux(
    .s0(s0), 
    .s1(s1), 
    .d3(m3), 
    .d2(m2), 
    .d1(m1), 
    .d0(m0), 
    .Y(Y)
);
endmodule

module shift_layer_1(
    input [31:0] m,
    output [31:0] y,
    input [1:0] a,
    input s
);
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin : gen_shift
        proto p(
            .s(s),
            .d(m[i]),
            .d3((i < 31) ? m[i + 1] : m[0]),
            .d2((i ==31) ? m[0] :  (i >0) ? m[i-1] : 1'b0),
            .d1((i < 31) ? m[i + 1] : 1'b0),
            .d0((i > 0) ? m[i - 1] : 1'b0),
            .Y(y[i]),
            .s0(a[0]),
            .s1(a[1])
        );
    end
endgenerate
endmodule

module shift_layer_2(
    input [31:0] m,
    output [31:0] y,
    input [1:0] a,
    input s
);
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin : gen_shift
        proto p(
            .s(s),
            .d(m[i]),
            .d3((i < 30) ? m[i + 2] : m[0]),
            .d2((i ==31) ? m[0] :  (i >1) ? m[i-2] : 1'b0),
            .d1((i < 30) ? m[i + 2] : 1'b0),
            .d0((i > 1) ? m[i - 2] :1'b0),
            .Y(y[i]),
            .s0(a[0]),
            .s1(a[1])
        );
    end
endgenerate
endmodule

module shift_layer_4(
    input [31:0] m,
    output [31:0] y,
    input [1:0] a,
    input s
);
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin : gen_shift
        proto p(
            .s(s),
            .d(m[i]),
            .d3((i < 28) ? m[i + 4] :  m[0]),
            .d2((i ==31) ? m[0] :  (i >3) ? m[i-4] : 1'b0),
            .d1((i < 28) ? m[i + 4] : 1'b0),
            .d0((i > 3) ? m[i - 4] : 1'b0),
            .Y(y[i]),
            .s0(a[0]),
            .s1(a[1])
        );
    end
endgenerate
endmodule

module shift_layer_8(
    input [31:0] m,
    output [31:0] y,
    input [1:0] a,
    input s
);
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin : gen_shift
        proto p(
            .s(s),
            .d(m[i]),
            .d3((i < 24) ? m[i + 8] : m[31]),
            .d2((i ==31) ? m[0] :  (i >7) ? m[i-8] : m[31]),
            .d1((i < 24) ? m[i + 8] : 1'b0),
            .d0((i > 7) ? m[i - 8] : 1'b0),
            .Y(y[i]),
            .s0(a[0]),
            .s1(a[1])
        );
    end
endgenerate
endmodule

module shift_layer_16(
    input [31:0] m,
    output [31:0] y,
    input [1:0] a,
    input s
);
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin : gen_shift
        proto p(
            .s(s),
            .d(m[i]),
            .d3((i < 16) ? m[i + 16] : m[0]),
            .d2((i ==31) ? m[0] :  (i >15) ? m[i-16] : 1'b0),
            .d1((i < 16) ? m[i + 16] : 1'b0),
            .d0((i > 15) ? m[i - 16] : 1'b0),
            .Y(y[i]),
            .s0(a[0]),
            .s1(a[1])
        );
    end
endgenerate
endmodule

module ushifter(
    input [31:0] m,
    input [4:0] n,
    input is_lsl,
    input is_lsr,
    input is_asr,
    output[31:0] aluResult
);
wire [31:0] w1, w2, w3, w4, w5;
wire [1:0] shift_type;
wire [31:0] out;

assign shift_type =(is_lsl) ? 2'b00 : (is_lsr) ? 2'b01 : (is_asr) ? 2'b11 : 2'bxx;

shift_layer_1 sl1 (.m(m),   .a(shift_type), .s(n[0]), .y(w1));
shift_layer_2 sl2 (.m(w1),  .a(shift_type), .s(n[1]), .y(w2));
shift_layer_4 sl3 (.m(w2),  .a(shift_type), .s(n[2]), .y(w3));
shift_layer_8 sl4 (.m(w3),  .a(shift_type), .s(n[3]), .y(w4));
shift_layer_16 sl5(.m(w4),  .a(shift_type), .s(n[4]), .y(out));
assign aluResult =(is_lsl | is_lsr | is_asr)? out : 32'b0;
endmodule
