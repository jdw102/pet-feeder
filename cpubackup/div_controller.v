module div_controller(input[31:0] A, Q, M, output[31:0] Anew, Qnew);
    wire sign1;
    wire [63:0] AQtemp, AQ;
    wire [31:0] Ashifted;
    wire isNotEqual, isLessThan, ovf;

    assign sign1 = A[31];
    assign AQtemp[63:32] = A;
    assign AQtemp[31:0] = Q;

    assign AQ = AQtemp << 1;

    wire [4:0] aluOp;
    assign aluOp[4:1] = 4'b0;
    assign aluOp[0] = !A[31];
    alu adder(AQ[63:32], M, aluOp, 5'b0, Anew, isNotEqual, isLessThan, ovf);


    assign Qnew[31:1] = AQ[31:1];
    assign Qnew[0] = ! Anew[31];

endmodule