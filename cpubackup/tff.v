module tff(input t, clk, clr, output q);
    wire w;
    assign w = (!t && q) || (t && !q);
    dffe_ref dff(q, w, clk, 1'b1, clr);
endmodule