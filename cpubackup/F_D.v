module F_D(input [31:0] pc_in, instr_in, input clk, reset, we, flush,  output [31:0] pc_out, instr_out, output readRd, readRStatus);
    register instr_reg(flush ? 32'b0: instr_in, clk, reset, we, instr_out);
    register pc_reg(pc_in, clk, reset, we, pc_out);
    FD_control contr(instr_out, readRd, readRStatus);
endmodule