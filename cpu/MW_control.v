module MW_control(input[31:0] instruction, output writeReg, readMem, writeR31, writeRStatus);
    wire [4:0] opCode;
    wire [31:0] decOut;
    wire alu, j, bne, jal, jr, addi, blt, sw, lw, bex, setx, mult, div;
    assign opCode = instruction[31:27];
    
    decoder32 decoder(decOut, opCode, 1'b1);
    assign alu = decOut[0];
    assign mult = alu && instruction[6:2] == 5'b00110;
    assign div =  alu && instruction[6:2] == 5'b00111;
    assign j = decOut[1];
    assign bne = decOut[2];
    assign jal = decOut[3];
    assign jr = decOut[4];
    assign addi = decOut[5];
    assign blt = decOut[6];
    assign sw = decOut[7];
    assign lw = decOut[8];
    assign bex = decOut[22];
    assign setx = decOut[21];

    assign writeReg = addi || (alu && !mult && !div) || lw || jal || setx;
    assign readMem = lw;    
    assign writeR31 = jal;
    assign writeRStatus = setx;

endmodule