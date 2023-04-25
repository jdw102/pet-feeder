module D_X(input [31:0] pc_in, instr_in, a_in, b_in, input clk, reset, branch_met, wren, output [31:0] pc_out, instr_out, a_out, b_out, exception, output immediate, jExtend, writePC, flush, loadPC, readRegPC, bne, blt, loadT, bex, mult, div);
    register instr_reg((flush || branch_met) ? 32'b0: instr_in, clk, reset, wren, instr_out);
    register pc_reg(pc_in, clk, reset, wren, pc_out);

    register a_reg(a_in, clk, reset, wren, a_out);
    register b_reg(b_in, clk, reset, wren, b_out);

    DX_control contrl(instr_out, immediate, jExtend, writePC, flush, loadPC, readRegPC, bne, blt, loadT, bex, mult, div, exception);
endmodule