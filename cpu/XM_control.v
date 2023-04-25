module XM_control(input[31:0] instruction, output writeMem);
    wire [4:0] opCode;
    wire [31:0] decOut;
    wire alu, j, bne, jal, jr, addi, blt, sw, lw;
    assign opCode = instruction[31:27];
    
    decoder32 decoder(decOut, opCode, 1'b1);
    assign alu = decOut[0];
    assign j = decOut[1];
    assign bne = decOut[2];
    assign jal = decOut[3];
    assign jr = decOut[4];
    assign addi = decOut[5];
    assign blt = decOut[6];
    assign sw = decOut[7];
    assign lw = decOut[8];

    assign writeMem = sw;

endmodule