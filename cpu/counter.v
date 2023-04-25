module counter(input clk, clr, output[5:0] count);

    tff flop1(1'b1, clk, clr, count[0]);
    tff flop2(count[0], clk, clr, count[1]);
    tff flop3(count[0] && count[1], clk, clr, count[2]);
    tff flop4(count[0] && count[1] && count[2], clk, clr, count[3]);
    tff flop5(count[0] && count[1] && count[2] && count[3], clk, clr, count[4]);
    tff flop6(count[0] && count[1] && count[2] && count[3] && count[4], clk, clr, count[5]);

endmodule