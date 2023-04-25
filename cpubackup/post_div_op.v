module post_div_op(input[31:0] quotient, input divisor_sign, dividend_sign, output[31:0] final_quotient);
    wire invert;
    wire [31:0] inverted_quotient, const_one;
    assign invert = divisor_sign ^ dividend_sign;
    wire notEq, lessThan, ovf;
    assign const_one[31:1] = 31'b0;
    assign const_one[0] = 1'b1;

    alu adderA(~quotient, const_one, 5'b0, 5'b0, inverted_quotient, notEq, lessThan, ovf);

    assign final_quotient = invert ? inverted_quotient: quotient;

endmodule