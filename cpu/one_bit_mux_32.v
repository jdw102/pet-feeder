module one_bit_mux_32(out, select, in);
    input[4:0] select;
    input [31:0] in;
    output out;
    wire w1, w2, w3, w4;

    one_bit_mux_8 first_8(w1, select[2:0], in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]);
    one_bit_mux_8 second_8(w2, select[2:0], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15]);
    one_bit_mux_8 third_8(w3, select[2:0], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23]);
    one_bit_mux_8 four_8(w4, select[2:0], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]);

    one_bit_mux_4 final(out, select[4:3], w1, w2, w3, w4);

endmodule