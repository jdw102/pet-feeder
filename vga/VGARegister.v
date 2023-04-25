module VGARegister(
    input [7:0] in,
    input clk, clr, in_en,
    output [7:0] out
    );

    genvar c;
    generate
        for (c = 0; c <= 7; c = c + 1) begin: loop1
            dffe_ref dff(out[c], in[c], clk, in_en, clr);
        end
    endgenerate

endmodule