module right_shifter(
    output [31:0] out,
    input [31:0] in,
    input [4:0] amt
    );
    assign out[31] = in[31];

    genvar i;
    generate
        for (i = 0; i <= 30; i = i + 1) begin: loop1
            wire [31:0] w;            
            genvar k;
            for (k = 0; k <= 30 - i; k = k + 1) begin: loop2
                assign w[k] = in[k + i];
            end
            genvar l;
            for (l = 30 - i + 1; l <= 30; l = l + 1) begin: loop3
                assign w[l] = in[31];
            end  
            assign w[31] = in[31];        
            one_bit_mux_32 mux(out[i], amt, w);
        end

    endgenerate

    // genvar i;
    // generate
    //     for (i = 0; i <= 30; i = i + 1) begin: loop1
    //         wire [30:0] w;            
    //         genvar k;
    //         for (k = 0; k <= 30 - i; k = k + 1) begin: loop2
    //             assign w[k] = in[k + i];
    //         end
    //         genvar l;
    //         for (l = 30 - i + 1; l <= 30; l = l + 1) begin: loop3
    //             assign w[l] = 1'b0
    //         end           
    //         one_bit_mux_32 mux(out[i], amt, w);
    //     end
    // endgenerate
endmodule