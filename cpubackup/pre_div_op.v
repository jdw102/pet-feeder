module pre_div_op(input [31:0] in_a, in_b, output[31:0] out_a, out_b);
    wire notEq1, notEq2, lessThan1, lessThan2, ovf1, ovf2;
    wire [31:0] const_one, inverted_a, inverted_b;
    assign const_one[31:1] = 31'b0;
    assign const_one[0] = 1'b1;

    alu adderA(~in_a, const_one, 5'b0, 5'b0, inverted_a, notEq1, lessThan1, ovf1);
    alu adderB(~in_b, const_one, 5'b0, 5'b0, inverted_b, notEq2, lessThan2, ovf2);

    assign out_a = in_a[31] ? inverted_a: in_a;
    assign out_b = in_b[31] ? inverted_b: in_b;
endmodule