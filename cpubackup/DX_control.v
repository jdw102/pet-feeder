module DX_control(input[31:0] instruction, output immediate, jExtend, writePC, flush, loadPC, readRegPC, bne, blt, loadT, bex, mult, div, output [31:0] exception);
    wire [4:0] opCode;
    wire [31:0] decOut;
    wire alu, j, jal, jr, addi, sw, lw, setx, bex, add, sub;
    assign opCode = instruction[31:27];
    
    decoder32 decoder(decOut, opCode, 1'b1);
    assign alu = decOut[0];
    assign add = alu && instruction[6:2] == 5'b0;
    assign sub = alu && instruction[6:2] == 5'b00001;
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

    assign immediate = addi || lw || sw;
    assign jExtend = j || jal || setx || bex;
    assign writePC = j || jal || jr;
    assign flush = j || jal || jr;
    assign loadPC = jal;
    assign readRegPC = jr;
    assign loadT = setx;
    assign exception = add ? 32'd1: addi? 32'd2: sub? 32'd3: mult? 32'd4: div? 32'd5: 0;
endmodule