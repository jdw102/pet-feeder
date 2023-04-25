/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal
    cpuStall,

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset, cpuStall;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
    // Program Counter
	wire [31:0] instrAddrIntrmd, PCIn;
    wire pcLT, pcNEQ, pcOvf;
	alu pc_adder(address_imem, 32'd1, 5'b00000, 5'b00000, instrAddrIntrmd, pcNEQ, pcLT, pcOvf);
	PC pc_counter(PCIn, !clock, reset, (!hazard || writePC || branchMet || statusNonZero) && !stall && !cpuStall, address_imem);

    // hazard
    wire hazard;
    hazard haz(fdIROut, dxIROut, xmIROut, hazard);

    // F/D Pipeline
	wire [31:0] fdPCOut, fdIROut;
    wire readRd, readR30, readRStatus;
	F_D fd_stage(instrAddrIntrmd, q_imem, !clock, reset, !hazard && !stall && !cpuStall, flush || branchMet || statusNonZero, fdPCOut, fdIROut, readRd, readRStatus);

    // Assign read registers
    assign ctrl_readRegA = readRStatus ? 5'b11110: fdIROut[21:17];
    assign ctrl_readRegB = readRd ? fdIROut[26:22] :fdIROut[16:12];

    // D/X Pipeline
    wire [31:0] dxPCOut, dxIROut, dxAOut, dxBOut, dxIRIn, exception;
    wire immediate, jExtend, writePC, flush, loadPC, readRegPC, bne, blt, loadT, mult, div, stall;
    assign dxIRIn = hazard ? 32'b0: fdIROut;
	D_X dx_stage(fdPCOut, dxIRIn, data_readRegA, data_readRegB, !clock, reset, branchMet || statusNonZero, !stall && !cpuStall, dxPCOut, dxIROut, dxAOut, dxBOut, exception, immediate, jExtend, writePC, flush, loadPC, readRegPC, bne, blt, loadT, bex, mult, div);
    assign stall = (mult || div) && !multdivRdy;

    // Branch ALU
    wire [31:0] addedPC;
    wire branchALUOvf; 
    alu branch_alu(dxPCOut, intermediate, 5'b0, 5'b0, addedPC, x, x, branchALUOvf);

    // pre ALU mux and sign extension
    wire [31:0] intermediate, aluBin, newPC;
    wire branchMet, statusNonZero, bex;
    assign statusNonZero = (bex && |aluAin);
    assign branchMet = (blt && !lt && neq || bne && neq);
    sign_extender sign_ext(dxIROut, jExtend, intermediate);
    assign aluBin = immediate ? intermediate: xmBIn;
    assign newPC = branchMet ? addedPC: readRegPC ? xmBIn: intermediate; 
    assign PCIn = (writePC || branchMet || statusNonZero) ? newPC: instrAddrIntrmd;

    // ALU
    wire [31:0] ALUOut;
    wire ovf, neq, lt;
    wire [4:0] ALUOpcode;
    assign ALUOpcode = immediate ? 5'b0: dxIROut[6:2];
    alu ALU(aluAin, aluBin, (bne || blt) ? 5'b00001: ALUOpcode, dxIROut[11:7], ALUOut, neq, lt, ovf);

    // Multdiv
    wire [31:0]  multdivRes, multA, multB, pwIROut;
    wire multException, multdivRdy, multdivRunning;
    assign multdivRunning = (mult || div) || !multdivRdy;
    // multdiv mult_div(aluAin, aluBin, mult, div, !clock, multdivRes, multException, multdivRdy);

    // X/M Pipeline
    wire [31:0] xmIROut, xmOOut, xmBOut, xmOIn;
    wire writeMem, xmExceptionIn, xmExceptionOut;
    assign xmExceptionIn = ovf || (multException && (multdivRdy) && (mult || div));
    assign xmOIn = xmExceptionIn? exception: loadT ? intermediate :loadPC ? dxPCOut: ALUOut;
    X_M xm_stage(dxIROut, xmOIn, xmBIn, !clock, reset, !stall && !cpuStall, xmExceptionIn, xmIROut, xmOOut, xmBOut, writeMem, xmExceptionOut);

    // Bypassing
    wire [31:0] aluAin, xmBIn, mem_in;
    bypass bp(dxIROut, xmIROut, mwIROut, data_writeReg, xmOOut, xmBOut, dxAOut, dxBOut, q_dmem, xmExceptionOut, writeException, aluAin, xmBIn, mem_in);

    // Data memory wiring
    assign address_dmem = xmOOut;
    assign data = mem_in;
    assign wren = writeMem;

    // M/W Pipeline
    wire [31:0] mwOOut, mwDOut, mwIROut;
    wire readMem, writeReg, writeR31, writeRStatus, writeException;
    M_W mw_stage(xmIROut, xmOOut, q_dmem, !clock, reset, !stall && !cpuStall, xmExceptionOut, mwIROut, mwOOut, mwDOut, readMem, writeReg, writeR31, writeRStatus, writeException);

    // Register write mux
    assign data_writeReg = ((mult || div) && multdivRdy) ?  multdivRes :readMem ? mwDOut :mwOOut;
    
    assign ctrl_writeReg = ((mult || div) && multdivRdy) ?  dxIROut[26:22]: (writeRStatus || writeException) ? 5'b11110: writeR31? 5'b11111: mwIROut[26:22];
    assign ctrl_writeEnable = writeReg || ((mult || div) && multdivRdy) || writeException;

	/* END CODE */  
endmodule
