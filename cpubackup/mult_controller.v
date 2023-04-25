module mult_controller(input[31:0] addend, multiplicand, input[2:0] control, output[31:0] result);
    wire isNotEqual1, isLessThan1, ovf1;
    wire isNotEqual2, isLessThan2, ovf2;


    // opcode reading
    wire sub;
    assign sub = (control[2] && !control[0]) || (control[2] && !control[1]);

    wire do_nothing;
    assign do_nothing = (!control[2] && !control[1] && !control[0]) || (control[2] && control[1] && control[0]);

    wire shift;
    assign shift = (!control[2] && control[1] && control[0]) || (control[2] && !control[1] && !control[0]);

    // performs shift if necessary then adds or subtracts result to addend
    wire [31:0] shifted, intermediate;
    assign intermediate = shift ? multiplicand << 1: multiplicand;
    wire [31:0] intermediate_res;
    wire [4:0] add_opcode;
    assign add_opcode =  sub ? 5'b00001: 5'b0;
    alu adder(addend, intermediate, add_opcode, 5'b0, intermediate_res, isNotEqual2, isLessThan2, ovf2);

    //returns the result if given specific opcode
    assign result = do_nothing ? addend: intermediate_res;
endmodule