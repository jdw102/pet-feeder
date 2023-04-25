module hazard(input[31:0] fdIR, dxIR, xmIR, output haz);
    wire [4:0] dxIROp, fdIRRS1, dxIRRD, fdIRRS2, fdIROp;
    assign dxIROp = dxIR[31:27];
    assign fdIRRS1 = fdIR[21:17];
    assign dxIRRD = dxIR[26:22];
    assign fdIRRS2 = fdIR[16:12];
    assign fdIROp = fdIR[31:27];

    assign haz = (dxIROp == 5'b01000) && ((fdIRRS1 == dxIRRD) || ((fdIRRS2 == dxIRRD) && (fdIROp != 5'b00111)));
endmodule