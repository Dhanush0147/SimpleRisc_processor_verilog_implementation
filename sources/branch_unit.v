module branch_unit(
    input beq,
    input gt,
    input is_b,
    input is_beq,
    input is_bgt,
    input is_call,
    input is_ret,
    output is_branchtaken
    );
    assign is_branchtaken = ((beq&is_beq)|(gt&is_bgt)|(is_b) |(is_call) | (is_ret) );
endmodule
