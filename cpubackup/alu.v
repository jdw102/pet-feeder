module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [2:0] select;
    assign select = ctrl_ALUopcode[2:0];
    wire [31:0] add_sub, and_result, or_result, sll, sra;

    cla adder(add_sub, overflow, data_operandA, data_operandB, select[0], select[0]);
    
    wire sub_ovf;
    and sub_and(sub_ovf, select[0], overflow);
    xor is_less_than(isLessThan, sub_ovf, data_result[31]);


    and_op and_operation(data_operandA, data_operandB, and_result);
    or_op or_operation(data_operandA, data_operandB, or_result);

    left_shifter lshifter(sll, data_operandA, ctrl_shiftamt);
    right_shifter rshifter(sra, data_operandA, ctrl_shiftamt);


    or is_not_equal(isNotEqual, data_result[0], data_result[1], data_result[2], data_result[3], data_result[4], data_result[5], data_result[6], data_result[7], data_result[8], 
    data_result[9],  data_result[10], data_result[11], data_result[12], data_result[13], data_result[14], data_result[15], data_result[16], data_result[17], data_result[18],
    data_result[19], data_result[20], data_result[21], data_result[22], data_result[23], data_result[24], data_result[25], data_result[26], data_result[27], data_result[28],
    data_result[29], data_result[30], data_result[31] );


    mux_8 mux(data_result, select, add_sub, add_sub, and_result, or_result, sll, sra, 0, 0);

endmodule