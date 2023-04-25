module PC(input [31:0] in, input clk, reset, we, output[31:0] out);
    register pc_reg(in, clk, reset, we, out);
endmodule