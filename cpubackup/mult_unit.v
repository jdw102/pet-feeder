module mult_unit(input [31:0] multiplier, multiplicand, input clk, start, output[31:0] out, output ovf);

    //initiliazies wires for register and shifting
    wire [64:0] init, reg_in, reg_out;
    wire [31:0] const_multiplicand;
    wire [2:0] opcode;
    wire [31:0] addend;

    // assigns the initial wire to an array of 0s and multiplier witha additional bit at the end
    assign init[64:33] = 32'b0;
    assign init[32:1] = multiplier;
    assign init[0] = 1'b0;

    // if a new mult cycle is started, the initial is value is passed to the register, otherwise the previous shifted value is passed
    assign reg_in = start ? init: shifted;

    // the mult register holds the current shifted value and the multiplicand register holds a copy of the multiplicand 
    register multiplicand_reg(multiplicand, clk, 1'b0, 1'b1, const_multiplicand);
    mult_register total_reg(reg_in, clk, 1'b0, 1'b1, reg_out);

    // the opcode and addend are extracted from the register
    assign opcode = reg_out[2:0];
    assign addend = reg_out[64:33];

    //  the opcode is read and the correct operation performed on the left 32 bits of the mult register's contents
    wire [31:0] result;
    mult_controller mult_control(addend, const_multiplicand, opcode, result);

    // the new register value is extracted from the previous and the result of the operation
    // it is shifted and assigned to the wire that acts as the input to the register while the counter is running
    wire [64:0] final, shifted;
    assign final [64:33] = result;
    assign final[32:0] = reg_out[32:0];
    assign shifted = $signed(final) >>> 2;
    
    // the current output is extracted from a final shift of the register's contents
    // wire [64:0] temp;
    // assign temp = $signed(shifted) >>> 2;
    assign out = shifted[32:1];

    // overflow checking
    wire all_zeros, all_ones;
    assign all_zeros = ~| shifted[64:33];
    assign all_ones = & shifted[64:33];
    assign ovf = (!all_zeros && !all_ones) || (all_zeros && out[31]) || (all_ones && !out[31]);
endmodule