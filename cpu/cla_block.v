module cla_block(
    output[7:0] s,
    output g_out, p_out, c_out,
    input[7:0] x, y,
    input c_in, sub
    );
    
    wire [7:0] c;
    wire [7:0] g, p;
    assign c[0] = c_in;
    assign c_out = c[7];

    one_bit_adder adder_one(s[0], g[0], p[0], x[0], y[0], c[0], sub);
    one_bit_adder adder_two(s[1], g[1], p[1], x[1], y[1], c[1], sub);
    one_bit_adder adder_three(s[2], g[2], p[2], x[2], y[2], c[2], sub);
    one_bit_adder adder_four(s[3], g[3], p[3], x[3], y[3], c[3], sub);
    one_bit_adder adder_five(s[4], g[4], p[4], x[4], y[4], c[4], sub);
    one_bit_adder adder_six(s[5], g[5], p[5], x[5], y[5], c[5], sub);
    one_bit_adder adder_seven(s[6], g[6], p[6], x[6], y[6], c[6], sub);
    one_bit_adder adder_eight(s[7], g[7], p[7], x[7], y[7], c[7], sub);

    block_carry carry_over(g_out, p_out, c, g, p);
endmodule