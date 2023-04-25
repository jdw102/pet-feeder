module PW_control(input[31:0] instruction, output mult, div);
    wire [4:0] opCode;
    wire [31:0] decOut;
    wire alu, j, bne, jal, jr, addi, blt, sw, lw, bex, setx;
    assign opCode = instruction[31:27];
    
    decoder32 decoder(decOut, opCode, 1'b1);
    assign alu = decOut[0];
    assign mult = alu && instruction[6:2] == 5'b00110;
    assign div =  alu && instruction[6:2] == 5'b00111;

endmodule