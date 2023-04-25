module cla(
    output [31:0] s,
    output ovf,
    input [31:0] x, y,
    input c0, sub
);

    wire c8, c16, c24, c32;

    wire [3:0] p, g;
    wire c_out1, c_out2, c_out3, c_out4;

    cla_block block0(s[7:0], g[0], p[0], c_out1, x[7:0], y[7:0], c0, sub);
    cla_block block1(s[15:8], g[1], p[1], c_out2, x[15:8], y[15:8], c8, sub); 
    cla_block block2(s[23:16], g[2], p[2], c_out3, x[23:16], y[23:16], c16, sub);
    cla_block block3(s[31:24], g[3], p[3], c_out4, x[31:24], y[31:24], c24, sub);

    cla_carry carry(c8, c16, c24, c32, p, g, c0);
    xor ovf_xor(ovf, c32, c_out4);
endmodule