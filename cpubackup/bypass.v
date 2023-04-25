module bypass(input[31:0] dxIR, xmIR, mwIR, reg_in, xmO, xmBin, dxA, dxB, q_dmem, input xmExc, mwExc, output[31:0] aluA, aluB, xmBOut);
    wire[4:0] dxIRRS1, dxIRRS2, dxIRRD, xmIRRD, mwIRRD, xmIRRS1;
    wire dxNoOp, xmNoOp, mwNoOp, dxsw, xmsw, mwsw, aluAMux1, aluAMux2, aluBMux1, aluBMux2, aluBMux3, xmBMux, dxjr, dxbr, xmbr, mwbr, xmsetx, mwsetx, dxsetx, xmbex, mwbex, dxbex, xmmult, xmdiv, mwmult, mwdiv, xmlw;

    assign dxIRRS1 = dxIR[21:17];
    assign dxIRRS2 = dxIR[16:12];
    assign dxIRRD = dxIR[26:22];
    assign xmIRRD = xmIR[26:22];
    assign mwIRRD = mwIR[26:22];
    assign xmIRRS1 = xmIR[21:17];

    assign dxsw = dxIR[31:27] == 5'b00111;
    assign xmsw = xmIR[31:27] == 5'b00111;
    assign mwsw = mwIR[31:27] == 5'b00111;
    assign dxjr = dxIR[31:27] == 5'b00100;
    assign dxbr = dxIR[31:27] == 5'b00010 || dxIR[31:27] == 5'b00110;
    assign xmbr = xmIR[31:27] == 5'b00010 || xmIR[31:27] == 5'b00110;
    assign mwbr = mwIR[31:27] == 5'b00010 || mwIR[31:27] == 5'b00110;
    assign xmsetx = xmIR[31:27] == 5'b10101;
    assign mwsetx = mwIR[31:27] == 5'b10101;
    assign dxsetx = dxIR[31:27] == 5'b10101;
    assign xmbex = xmIR[31:27] == 5'b10110;
    assign mwbex = mwIR[31:27] == 5'b10110;
    assign dxbex = dxIR[31:27] == 5'b10110;
    assign xmmult = xmIR[31:27] == 5'b00000 && xmIR[6:2] == 5'b00110;
    assign xmdiv =  xmIR[31:27] == 5'b00000 && xmIR[6:2] == 5'b00111;
    assign mwmult = xmIR[31:27] == 5'b00000 && mwIR[6:2] == 5'b00110;
    assign mwdiv = xmIR[31:27] == 5'b00000 && mwIR[6:2] == 5'b00111;
    assign xmlw = xmIR[31:27] == 5'b01000;

    assign dxNoOp = ~|dxIR;
    assign xmNoOp = ~|xmIR;
    assign mwNoOp = ~|mwIR;

    assign aluAMux1 = (dxIRRS1 == xmIRRD) && (!dxNoOp && !xmNoOp) && !xmsw && !xmsetx && !xmbex && !xmmult && !xmdiv && !xmbr && xmIRRD != 5'b0 || ((xmsetx || xmExc) && (dxIRRS1 == 5'b11110)) || (dxbex && xmIRRD == 5'b11110);
    assign aluAMux2 = (dxIRRS1 == mwIRRD) && (!dxNoOp && !mwNoOp) && !mwsw && !mwsetx && !mwbex && !mwmult && !mwdiv && !mwbr && mwIRRD != 5'b0 || ((mwsetx || mwExc) && (dxIRRS1 == 5'b11110)) || (dxbex && mwIRRD == 5'b11110);
    assign aluBMux1 = ((dxIRRS2 == xmIRRD) && (!dxNoOp && !xmNoOp && !xmbr)) && !xmmult && !xmdiv && xmIRRD != 5'b0 || ((dxIRRD == xmIRRD) && (dxsw || dxbr)) && !xmsw && !xmlw && xmIRRD != 5'b0 || (dxjr && !xmlw && xmIRRD == dxIRRD && xmIRRD != 5'b0) || ((xmsetx || xmExc) && dxIRRS2 == 5'b11110);
    assign aluBMux2 = ((dxIRRS2 == mwIRRD) && (!dxNoOp && !mwNoOp && !mwbr && mwIRRD != 5'b0)) && !mwmult && !mwdiv || ((dxsw || dxbr) && (dxIRRD == mwIRRD)) && !mwsw && mwIRRD != 5'b0 || ((mwsetx || mwExc) && dxIRRS2 == 5'b11110);
    assign aluBMux3 = ((dxjr || dxbr) && xmlw && xmIRRD == dxIRRD && xmIRRD != 5'b0);
    assign xmBMux = ((xmIRRS1 == mwIRRD) && (!mwNoOp && !xmNoOp) && !mwsw && mwIRRD != 5'b0) || (xmsw && xmIRRD == mwIRRD && mwIRRD != 5'b0);

    assign aluA = aluAMux1 ? xmO : aluAMux2 ? reg_in: dxA;
    assign aluB = aluBMux1 ? xmO : aluBMux2 ? reg_in:  aluBMux3? q_dmem:dxB;
    assign xmBOut = xmBMux ? reg_in: xmBin;
endmodule