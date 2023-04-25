module mult_register(
    input [64:0] in,
    input clk, clr, in_en,
    output [64:0] out
    );

    genvar c;
    generate
        for (c = 0; c <= 64; c = c + 1) begin: loop1
            dffe_ref dff(out[c], in[c], clk, in_en, clr);
        end
    endgenerate

endmodule