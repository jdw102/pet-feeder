module sign_extender(input[31:0] instr, input ji, output[31:0] out);
    wire[4:0] op;
    wire [31:0] extend16, extend26;
    wire ji;
    assign extend16 = {{15{instr[16]}}, {instr[16:0]}};
    assign extend26 = {{5{instr[26]}}, {instr[26:0]}};
    assign out = ji ? extend26: extend16;

endmodule