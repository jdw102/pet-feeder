module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, 
	currHour, currMin, currAmpm,
	hour1, min1, ampm1, hour2, min2, ampm2, hour3, min3, ampm3, pwmControl, screenState, out3, duration
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;
	output [31:0] hour1, hour2, hour3, min1, min2, min3, ampm1, ampm2, ampm3, pwmControl, currHour, currMin, currAmpm, screenState, out3, duration;
	
	wire [31:0] write, readA, readB;
	decoder32 write_decoder(write, ctrl_writeReg, 1'b1);
	decoder32 A_decoder(readA, ctrl_readRegA, 1'b1);
	decoder32 B_decoder(readB, ctrl_readRegB, 1'b1);

	wire[31:0] 	out0, out1, out2, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, 
				out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31;
			
	register r0(.in(32'b0), .clk(clock), .clr(ctrl_reset), .in_en(1'b0), .out(out0));
	tristate ts1(out0, readA[0], data_readRegA);
	tristate ts2(out0, readB[0], data_readRegB);

	register r1(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[1] ), .out(pwmControl));
	tristate ts1a(pwmControl, readA[1], data_readRegA);
	tristate ts1b(pwmControl, readB[1], data_readRegB);

	register r2(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[2] ), .out(out2));
	tristate ts2a(out2, readA[2], data_readRegA);
	tristate ts2b(out2, readB[2], data_readRegB);

	register r3(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[3] ), .out(screenState));
	tristate ts3a(screenState, readA[3], data_readRegA);
	tristate ts3b(screenState, readB[3], data_readRegB);

	register r4(.in(runningTime), .clk(clock), .clr(ctrl_reset), .in_en(1'b1 ), .out(out4));
	tristate ts4a(out4, readA[4], data_readRegA);
	tristate ts4b(out4, readB[4], data_readRegB);

	register r5(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[5] ), .out(out5));
	tristate ts5a(out5, readA[5], data_readRegA);
	tristate ts5b(out5, readB[5], data_readRegB);

	register r6(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[6] ), .out(out6));
	tristate ts6a(out6, readA[6], data_readRegA);
	tristate ts6b(out6, readB[6], data_readRegB);

	register r7(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[7]), .out(out7));
	tristate ts7a(out7, readA[7], data_readRegA);
	tristate ts7b(out7, readB[7], data_readRegB);

	register r8(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[8] ), .out(out8));
	tristate ts8a(out8, readA[8], data_readRegA);
	tristate ts8b(out8, readB[8], data_readRegB);

	register r9(.in(second), .clk(clock), .clr(ctrl_reset), .in_en(1'b1 ), .out(out9));
	tristate ts9a(out9, readA[9], data_readRegA);
	tristate ts9b(out9, readB[9], data_readRegB);

	register r10(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[10] ), .out(hour1));
	tristate ts10a(hour1, readA[10], data_readRegA);
	tristate ts10b(hour1, readB[10], data_readRegB);

	register r11(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[11] ), .out(min1));
	tristate ts11a(min1, readA[11], data_readRegA);
	tristate ts11b(min1, readB[11], data_readRegB);

	register r12(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[12] ), .out(ampm1));
	tristate ts12a(ampm1, readA[12], data_readRegA);
	tristate ts12b(ampm1, readB[12], data_readRegB);

	register r13(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[13] ), .out(hour2));
	tristate ts13a(hour2, readA[13], data_readRegA);
	tristate ts13b(hour2, readB[13], data_readRegB);

	register r14(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[14] ), .out(min2));
	tristate ts14a(min2, readA[14], data_readRegA);
	tristate ts14b(min2, readB[14], data_readRegB);

	register r15(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[15] ), .out(ampm2));
	tristate ts15a(ampm2, readA[15], data_readRegA);
	tristate ts15b(ampm2, readB[15], data_readRegB);

	register r16(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[16] ), .out(hour3));
	tristate ts16a(hour3, readA[16], data_readRegA);
	tristate ts16b(hour3, readB[16], data_readRegB);

	register r17(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[17] ), .out(min3));
	tristate ts17a(min3, readA[17], data_readRegA);
	tristate ts17b(min3, readB[17], data_readRegB);

	register r18(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[18] ), .out(ampm3));
	tristate ts18a(ampm3, readA[18], data_readRegA);
	tristate ts18b(ampm3, readB[18], data_readRegB);

	register r19(.in(hour), .clk(clock), .clr(ctrl_reset), .in_en(1'b1 ), .out(currHour));
	tristate ts19a(currHour, readA[19], data_readRegA);
	tristate ts19b(currHour, readB[19], data_readRegB);

	register r20(.in(min), .clk(clock), .clr(ctrl_reset), .in_en(1'b1 ), .out(currMin));
	tristate ts20a(currMin, readA[20], data_readRegA);
	tristate ts20b(currMin, readB[20], data_readRegB);

	register r21(.in(ampm), .clk(clock), .clr(ctrl_reset), .in_en(1'b1 ), .out(currAmpm));
	tristate ts21a(currAmpm, readA[21], data_readRegA);
	tristate ts21b(currAmpm, readB[21], data_readRegB);

	register r22(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[22]), .out(duration));
	tristate ts22a(duration, readA[22], data_readRegA);
	tristate ts22b(duration, readB[22], data_readRegB);

	register r23(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[23]), .out(out23));
	tristate ts23a(out23, readA[23], data_readRegA);
	tristate ts23b(out23, readB[23], data_readRegB);

	register r24(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[24] ), .out(out24));
	tristate ts24a(out24, readA[24], data_readRegA);
	tristate ts24b(out24, readB[24], data_readRegB);

	register r25(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[25] ), .out(out25));
	tristate ts25a(out25, readA[25], data_readRegA);
	tristate ts25b(out25, readB[25], data_readRegB);

	register r26(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[26] ), .out(out26));
	tristate ts26a(out26, readA[26], data_readRegA);
	tristate ts26b(out26, readB[26], data_readRegB);

	register r27(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[27] ), .out(out27));
	tristate ts27a(out27, readA[27], data_readRegA);
	tristate ts27b(out27, readB[27], data_readRegB);

	register r28(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[28] ), .out(out28));
	tristate ts28a(out28, readA[28], data_readRegA);
	tristate ts28b(out28, readB[28], data_readRegB);

	register r29(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[29] ), .out(out29));
	tristate ts29a(out29, readA[29], data_readRegA);
	tristate ts29b(out29, readB[29], data_readRegB);

	register r30(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[30] ), .out(out30));
	tristate ts30a(out30, readA[30], data_readRegA);
	tristate ts30b(out30, readB[30], data_readRegB);

	register r31(.in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_en(ctrl_writeEnable && write[31] ), .out(out31));
	tristate ts31a(out31, readA[31], data_readRegA);
	tristate ts31b(out31, readB[31], data_readRegB);

	wire [7:0] hour, min, second;
	wire ampm;
	wire [31:0] runningTime;
	clock clock_module(clock, write[19] && ctrl_writeEnable, write[20] && ctrl_writeEnable, write[21] && ctrl_writeEnable, data_writeReg[7:0], hour, min, second, runningTime, ampm);

endmodule
