// Here I will create a mux which will have 32 bits input and output
module ProgramCounter (
    input clk,
    input [31:0] nextPC,
    output reg [31:0] pc
);
    initial begin
        pc = 32'b0; 
    end

    always @(posedge clk) begin
        pc <= nextPC;
    end
endmodule
module Counter_Adder(                       
    input [31:0] pc,
    output [31:0] nextPC
);

    assign nextPC = pc + 4;

endmodule


module instruction_memory (
    input [31:0] address,
    output [31:0] out
);
    reg [7:0] mem [0:1023];  // 1KB instruction memory

    initial begin
    //mov r1,5
        
      //mov r1,5
        
        mem[0] = 8'h05;
        mem[1] = 8'h00;
        mem[2] = 8'h40;
        mem[3] = 8'h4C;
        
        //mov r2,2
        mem[4] = 8'h02;
        mem[5] = 8'h00;
        mem[6] = 8'h80;
        mem[7] = 8'h4C;
        
        // nop   68000000
        mem[8] = 8'h00;
        mem[9] = 8'h00;
        mem[10] = 8'h00;
        mem[11] = 8'h68;
        
        //nop
        mem[12] = 8'h00;
        mem[13] = 8'h00;
        mem[14] = 8'h00;
        mem[15] = 8'h68;
        
        //nop
        mem[16] = 8'h00;
        mem[17] = 8'h00;
        mem[18] = 8'h00;
        mem[19] = 8'h68;
        
        //add r3,r1,r2  00C48000
        mem[20] = 8'h00;
        mem[21] = 8'h80;
        mem[22] = 8'hC4;
        mem[23] = 8'h00;
        
        //lsl r4,r1,2  55040002
        mem[24] = 8'h02;
        mem[25] = 8'h00;
        mem[26] = 8'h04;
        mem[27] = 8'h55;
        
        //cmp r1,r2  28408000
        mem[28] = 8'h00;
        mem[29] = 8'h80;
        mem[30] = 8'h40;
        mem[31] = 8'h28;
        
        //bgt 0x10 88000010
        mem[32] = 8'h10;
        mem[33] = 8'h00;
        mem[34] = 8'h00;
        mem[35] = 8'h88;
        mem[27] = 8'h88;
    end

    assign out = {mem[address + 3], mem[address + 2], mem[address + 1], mem[address]};
endmodule
module instruction_fetch(
    input clk,
    input isBranchTaken,
    input [31:0] branchPC,
    output [31:0] pc,
    output [31:0] instruction
);

    wire [31:0] w1,w2,w3;
    
    ProgramCounter cut(
        .clk(clk),
        .nextPC(w1),
        .pc(w2)
    );
    
    assign pc = w2;
    
    Counter_Adder add_if(
        .pc(w2),
        .nextPC(w3)
    );
    
    instruction_memory im_if(
    .address(w2),
    .out(instruction)
    );
    
    selector_32 if_mux(
        .a(w3),
        .b(branchPC),
        .s(isBranchTaken),
        .out(w1)
    );
    
endmodule


