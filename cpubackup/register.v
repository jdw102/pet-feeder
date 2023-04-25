module register(
    input [31:0] in,
    input clk, clr, in_en,
    output [31:0] out
    );

    genvar c;
    generate
        for (c = 0; c <= 31; c = c + 1) begin: loop1
            dffe_ref dff(out[c], in[c], clk, in_en, clr);
        end
    endgenerate

endmodule