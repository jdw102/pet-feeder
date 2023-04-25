module one_bit_adder(S, g, p, A, B, Cin, sub);
    input A, B, Cin, sub;
    output S, g, p;

    wire w1;
    wire not_B, b;
    not n(not_B, B);
    one_bit_mux_2 mux(b, sub, B, not_B);

    xor Sresult(S, A, b, Cin);

    and A_and_B(g, A, b);
    or A_or_B(p, A, b);
    and p_and_C(w1, p, Cin);
endmodule