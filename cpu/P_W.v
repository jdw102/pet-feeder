module P_W(input [31:0] p_in, instruction, input clk, reset, irwe, rdy_in, output[31:0] p_out, instr_out, output mult, div, rdy_out);
    register instr_reg(instruction, clk, reset, irwe, instr_out);
    register p_reg(p_in, clk, reset, 1'b1, p_out);
    PW_control contrl(instr_out, mult, div);
    dffe_ref rdy_flop(rdy_out, rdy_in, clk, irwe, reset);
endmodule