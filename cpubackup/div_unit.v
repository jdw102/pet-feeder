module div_unit(input [31:0] dividend, divisor, input clock, result_rdy, start, output [31:0] quotient, remainder);
    wire [31:0] q_in, q_out, a_in, a_out, q_next, a_next;
    wire isNotEqual, isLessThan, overflow;
    assign q_in = start ? dividend: q_next;
    assign a_in = start ? 32'b0: a_next;
    
    register qReg(q_in, clock, 1'b0, 1'b1, q_out);
    register aReg(a_in, clock, 1'b0, 1'b1, a_out);

    div_controller controller(a_out, q_out, divisor, a_next, q_next);

    wire [31:0] transformedA;
    alu adder(a_next, divisor, 5'b0, 5'b0, transformedA, isNotEqual, isLessThan, overflow);

    assign quotient = result_rdy ? q_next : 32'b0;
    assign remainder = a_next[31] ? transformedA: a_next;
    

endmodule