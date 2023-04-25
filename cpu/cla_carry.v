module cla_carry(
    output c8, c16, c24, c32,
    input [3:0] p, g,
    input c0
    );

    wire a1;
    wire b1, b2;
    wire c1, c2, c3;
    wire d1, d2, d3, d4;

    and a1_and(a1, p[0], c0);
    or a_or(c8, g[0], a1);

    and b1_and(b1, p[1], g[0]);
    and b2_and(b2, p[1], p[0], c0);
    or b_or(c16, g[1], b1, b2);

    and c1_and(c1, p[2], g[1]);
    and c2_and(c2, p[2], p[1], g[0]);
    and c3_and(c3, p[2], p[1], p[0], c0);
    or c_or(c24, g[2], c1, c2, c3);

    and d1_and(d1, p[3], g[2]);
    and d2_and(d2, p[3], p[2], g[1]);
    and d3_and(d3, p[3], p[2], p[1], g[0]);
    and d4_and(d4, p[3], p[2], p[1], p[0], c0);
    or d_or(c32, g[3], d1, d2, d3, d4);
endmodule