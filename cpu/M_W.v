module M_W(input [31:0] instr_in, o_in, d_in, input clk, reset, wren, exception_in, output [31:0] instr_out, o_out, d_out, output readMem, writeReg, writeR31, writeRStatus, exception_out);
    register instr_reg(instr_in, clk, reset, wren, instr_out);

    register a_reg(o_in, clk, reset, wren, o_out);
    register b_reg(d_in, clk, reset, wren, d_out);

    MW_control contrl(instr_out, writeReg, readMem, writeR31, writeRStatus);
    dffe_ref exception_flop(exception_out, exception_in, clk, wren, reset);
endmodule