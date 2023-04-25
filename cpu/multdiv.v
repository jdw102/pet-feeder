module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // op latching
    wire div_op, mult_op;
    dffe_ref div_ff(div_op, ctrl_DIV, clock, ctrl_DIV || ctrl_MULT, 1'b0);
    dffe_ref mult_ff(mult_op, ctrl_MULT, clock,  ctrl_DIV || ctrl_MULT, 1'b0);

    // counter stuff
    wire[5:0] count;
    wire start, reset, mult_rdy, div_rdy, div_reset, mult_reset;
    counter counter(clock, reset, count);
    assign reset = (mult_reset && mult_op) || (div_reset && div_op) || (ctrl_MULT && !mult_op) || (ctrl_DIV && !div_op);
    assign start = ~| count;
    assign mult_reset =  count[4] && !count[3] && !count[2] && !count[1] && count[0];
    assign div_reset = count[5] && !count[4] && !count[3] && !count[2] && !count[1] && count[0]; 
    assign mult_rdy = count[4] && !count[3] && !count[2] && !count[1] && !count[0];
    assign div_rdy = count[5] && !count[4] && !count[3] && !count[2] && !count[1] && !count[0]; 
    assign data_resultRDY = (mult_rdy && mult_op) || (div_rdy && div_op);

    // mult exception handling
    wire sign_mismatch, zero_mismatch, a_zero, b_zero, res_zero, mult_exception;
    assign mult_exception = data_resultRDY? ((sign_mismatch && !(!a_zero || !b_zero)) || zero_mismatch) || ovf: 1'b0;
    assign a_zero = |data_operandA;
    assign b_zero = |data_operandB;
    assign res_zero = |data_result;
    assign sign_mismatch = data_operandA[31] ^ data_operandB[31] ^ data_result[31];
    assign zero_mismatch = (res_zero && !b_zero) || (res_zero && !a_zero) || (a_zero && b_zero && !res_zero);

    //div exception handling
    wire divide_by_zero, div_exception;
    assign divide_by_zero = ~|data_operandB;
    assign div_exception = divide_by_zero;

    assign data_exception = (mult_op && mult_exception) || (div_op && div_exception);

    // mult outputs result when data ready
    wire ovf;
    wire [31:0] mult_result;
    mult_unit multiplication(data_operandA, data_operandB, clock, start, mult_result, ovf);

    // div outputs result when data ready
    wire [31:0] remainder, init_div_result, init_a, init_b, fin_div_result, div_result;
    pre_div_op pre(data_operandA, data_operandB, init_a, init_b);
    div_unit division(init_a, init_b, clock, div_rdy, start, init_div_result, remainder);
    post_div_op post(init_div_result, data_operandB[31], data_operandA[31], fin_div_result);
    assign div_result = (divide_by_zero && div_op) ? 31'b0: fin_div_result;

    assign data_result = mult_op ? mult_result: div_result;
endmodule
