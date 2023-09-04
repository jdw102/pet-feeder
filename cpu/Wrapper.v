`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, buttonInputs, hSync, vSync, motorPWM, VGA_R, VGA_G, VGA_B, lights);
	input clock, reset;
	input [8:0] buttonInputs;
	output hSync; 		// H Sync Signal
	output vSync; 		// Veritcal Sync Signal
	output motorPWM;
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G; // Green Signal Bits
	output[3:0] VGA_B;
	output[12:0] lights;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	wire [8:0] buttons;
	wire [8:0] audioPress;

	debounce_button deb1(clock, buttonInputs[0], audioPress[0], buttons[0]);
	debounce_button deb2(clock, buttonInputs[1], audioPress[1], buttons[1]);
	debounce_button deb3(clock, buttonInputs[2], audioPress[2], buttons[2]);
	debounce_button deb4(clock, buttonInputs[3], audioPress[3], buttons[3]);
	debounce_button deb5(clock, buttonInputs[4], audioPress[4], buttons[4]);
	debounce_button deb6(clock, buttonInputs[5], audioPress[5], buttons[5]);
	debounce_button deb7(clock, buttonInputs[6], audioPress[6], buttons[6]);
	debounce_button deb8(clock, buttonInputs[7], audioPress[7], buttons[7]);
	debounce_button deb9(clock, buttonInputs[8], audioPress[8], buttons[8]);

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "C:/Users/User/Documents/Spring2023/ece350/pet_feeder_repo/program/pet_feed_test";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), .cpuStall(buttonWrite),
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut));	
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));

	wire[31:0] hour1, min1, ampm1, hour2, min2, ampm2, hour3, min3, ampm3, pwmControl,
	currHour, currMin, currAmpm, buttonID, screenState, buttonRegData, duration;
	wire [4:0] buttonReg;
	wire buttonWrite;

	button_controller button_control(buttons, clock, buttonReg, buttonID, buttonWrite);
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe || buttonWrite), .ctrl_reset(reset), 
		.ctrl_writeReg(buttonWrite? buttonReg: rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(buttonWrite? buttonID: rData),
		.data_readRegA(regA), .data_readRegB(regB), 
		.currHour(currHour), .currMin(currMin), .currAmpm(currAmpm),
		.hour1(hour1), .min1(min1), .ampm1(ampm1), 
		.hour2(hour2), .min2(min2), .ampm2(ampm2),
		.hour3(hour3), .min3(min3), .ampm3(ampm3), .pwmControl(pwmControl), .screenState(screenState), .out3(buttonRegData), .duration(duration));

	assign lights[3:0] = hour1[3:0];
	assign lights[12:4] = audioPress;
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

	VGAController VGA(.clk(!clock), .reset(reset), .motor(motorPWM), 
	.currAmpm(currAmpm[0]), .ampm1(ampm1[0]), .ampm2(ampm2[0]), .ampm3(ampm3[0]), 
	.currHour(currHour[7:0]), .currMin(currMin[7:0]), 
	.hour1(hour1[7:0]), .min1(min1[7:0]), 
	.hour2(hour2[7:0]), .min2(min2[7:0]), 
	.hour3(hour3[7:0]), .min3(min3[7:0]), .dur(duration), .state(screenState),
	.hSync(hSync), .vSync(vSync), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

	assign motorPWM = pwmControl[0];

	// AudioController audio_controller(clock, motorPWm, |audioPress, audioOut, audioEn);

endmodule
