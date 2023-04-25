module X_M(input [31:0] instr_in, o_in, b_in, input clk, reset, wren, exception_in, output [31:0] instr_out, o_out, b_out, output writeMem, exception_out);
    register instr_reg(instr_in, clk, reset, wren, instr_out);

    register a_reg(o_in, clk, reset, wren, o_out);
    register b_reg(b_in, clk, reset, wren, b_out);

    XM_control contrl(instr_out, writeMem);
    dffe_ref exception_flop(exception_out, exception_in, clk, wren, reset);
endmodule