module left_shifter(
    output [31:0] out,
    input [31:0] in,
    input [4:0] amt
    );
    
    genvar i;
    generate
        for (i = 0; i <= 31; i = i + 1) begin: loop1
            wire [31:0] w;            
            genvar k, j;
            for (k = 0; k <= i; k = k + 1) begin: loop2
                assign w[k] = in[i - k];
            end
            genvar l;
            for (l = i + 1; l <= 31; l = l + 1) begin: loop3
                assign w[l] = 1'b0;
            end           
            one_bit_mux_32 mux(out[i], amt, w);
        end
    endgenerate

endmodule