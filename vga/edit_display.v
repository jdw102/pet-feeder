module edit_display(
	input clk, reset, 
	input [5:0] state,
	input ampm1, ampm2, ampm3,
	input[7:0] hour1, min1, hour2, min2, hour3, min3, print,
	input[9:0] x, input[8:0] y, 
	output squareTotal, output highlight, output [7:0] char, output [18:0] spriteAddress);

    reg [34:0] inSquare;
	reg [31:0] xOffset;
	reg [31:0] yOffset;

	wire [7:0] hour1char1, hour1char2, min1char1, min1char2, hour2char1, hour2char2, min2char1, min2char2, 
	hour3char1, hour3char2, min3char1, min3char2, 
	ampm1char1, ampm1char2, ampm2char1, ampm2char2, ampm3char1, ampm3char2,
	colon1, colon2, colon3;
	char_converter char_con1(hour1, min1, ampm1, hour1char1, hour1char2, min1char1, min1char2, ampm1char1, ampm1char2, colon1);
	char_converter char_con2(hour2, min2, ampm2, hour2char1, hour2char2, min2char1, min2char2, ampm2char1, ampm2char2, colon2);
	char_converter char_con3(hour3, min3, ampm3, hour3char1, hour3char2, min3char1, min3char2, ampm3char1, ampm3char2, colon3);
	wire [2:0] saves;
	assign saves[0] = inSquare[0] || inSquare[1] || inSquare[2] || inSquare[3] || inSquare[4] || inSquare[15] || inSquare[18] || inSquare[19];
	assign saves[1] = inSquare[5] || inSquare[6] || inSquare[7] || inSquare[8] || inSquare[9] || inSquare[16] || inSquare[20] || inSquare[21];
	assign saves[2] = inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[17] || inSquare[22] || inSquare[23];

	assign highlight = state[0] ? saves[0]: state[1] ? saves[1]: state[2] ? saves[2]: 1'b0;

	assign char = 	inSquare[0] ? hour1char1: inSquare[1] ? hour1char2: inSquare[2] ? colon1 : inSquare[3] ? min1char1: inSquare[4] ? min1char2: 
					inSquare[5] ? hour2char1: inSquare[6] ? hour2char2: inSquare[7] ? colon2 : inSquare[8] ? min2char1: inSquare[9] ? min2char2:
					inSquare[10] ? hour3char1: inSquare[11] ? hour3char2: inSquare[12] ? colon3 : inSquare[13] ? min3char1: inSquare[14] ? min3char2:
					inSquare[15] ? 8'd1: inSquare[16] ? 8'd2: inSquare[17] ? 8'd3:
					inSquare[18] ? ampm1char1: inSquare[19] ? ampm1char2:
					inSquare[20] ? ampm2char1: inSquare[21] ? ampm2char2:
					inSquare[22] ? ampm3char1: inSquare[23] ? ampm3char2:
					inSquare[24] ? 8'd96: inSquare[25] ? 8'd100 :inSquare[26] ? 8'd121 :inSquare[27] ? 8'd104: inSquare[28] ? 8'd103: inSquare[29] ? 8'd13 : inSquare[30] ? 8'd99 : inSquare[31] ? 8'd108: inSquare[32] ? 8'd112: inSquare[33] ? 8'd104: inSquare[34]? 8'd118:
					8'b0;
	assign spriteAddress = (print - 33) * 2500 + (x - xOffset) + ((y - yOffset) * 50);
	assign squareTotal = |inSquare;

	always @(posedge clk) begin
		inSquare[0] = (x >= 195) & (x < 245) & (y >= 165) & (y <= 215);
		inSquare[1] = (x >= 245) & (x < 295) & (y >= 165) & (y <= 215);
		inSquare[2] = (x >= 295) & (x < 345) & (y >= 165) & (y <= 215);
		inSquare[3] = (x >= 345) & (x < 395) & (y >= 165) & (y <= 215);
		inSquare[4] = (x >= 395) & (x <= 445) & (y >= 165) & (y <= 215);
		inSquare[18] = (x >= 470) & (x < 520) & (y >= 165) & (y <= 215);
		inSquare[19] = (x >= 520) & (x <= 570) & (y >= 165) & (y <= 215);

		inSquare[5] = (x >= 195) & (x < 245) & (y >= 265) & (y <= 315);
		inSquare[6] = (x >= 245) & (x < 295) & (y >= 265) & (y <= 315);
		inSquare[7] = (x >= 295) & (x < 345) & (y >= 265) & (y <= 315);
		inSquare[8] = (x >= 345) & (x < 395) & (y >= 265) & (y <= 315);
		inSquare[9] = (x >= 395) & (x <= 445) & (y >= 265) & (y <= 315);
		inSquare[20] = (x >= 470) & (x < 520) & (y >= 265) & (y <= 315);
		inSquare[21] = (x >= 520) & (x <= 570) & (y >= 265) & (y <= 315);

		inSquare[10] = (x >= 195) & (x < 245) & (y >= 365) & (y <= 415);
		inSquare[11] = (x >= 245) & (x < 295) & (y >= 365) & (y <= 415);
		inSquare[12] = (x >= 295) & (x < 345) & (y >= 365) & (y <= 415);
		inSquare[13] = (x >= 345) & (x < 395) & (y >= 365) & (y <= 415);
		inSquare[14] = (x >= 395) & (x <= 445) & (y >= 365) & (y <= 415);
		inSquare[22] = (x >= 470) & (x < 520) & (y >= 365) & (y <= 415);
		inSquare[23] = (x >= 520) & (x <= 570) & (y >= 365) & (y <= 415);

		inSquare[15] = (x >= 95) & (x < 145) & (y >= 165) & (y <= 215);
		inSquare[16] = (x >= 95) & (x < 145) & (y >= 265) & (y <= 315);
		inSquare[17] = (x >= 95) & (x < 145) & (y >= 365) & (y <= 415);

		inSquare[24] = (x >= 45) & (x < 95) & (y >= 25) & (y <= 75);
		inSquare[25] = (x >= 95) & (x < 145) & (y >= 25) & (y <= 75);
		inSquare[26] = (x >= 145) & (x < 195) & (y >= 25) & (y <= 75);
		inSquare[27] = (x >= 195) & (x < 245) & (y >= 25) & (y <= 75);
		inSquare[28] = (x >= 245) & (x < 295) & (y >= 25) & (y <= 75);
		inSquare[29] = (x >= 295) & (x < 345) & (y >= 25) & (y <= 75);
		inSquare[30] = (x >= 345) & (x < 395) & (y >= 25) & (y <= 75);
		inSquare[31] = (x >= 395) & (x < 445) & (y >= 25) & (y <= 75);
		inSquare[32] = (x >= 445) & (x < 495) & (y >= 25) & (y <= 75);
		inSquare[33] = (x >= 495) & (x < 545) & (y >= 25) & (y <= 75);
		inSquare[34] = (x >= 545) & (x <= 595) & (y >= 25) & (y <= 75);
		
		
	    xOffset = 	inSquare[15] || inSquare[16] || inSquare[17] || inSquare[25] ? 95:
					inSquare[0] || inSquare[5] || inSquare[10] || inSquare[27] ? 195: 
					inSquare[1] || inSquare[6] || inSquare[11] || inSquare[28]  ? 245: 
					inSquare[2] || inSquare[7] || inSquare[12] || inSquare[29] ? 295: 
					inSquare[3] || inSquare[8] || inSquare[13]|| inSquare[30]  ? 345: 
					inSquare[4] || inSquare[9] || inSquare[14]|| inSquare[31]  ? 395: 
					inSquare[18] || inSquare[20] || inSquare[22] ? 470:
					inSquare[19] || inSquare[21] || inSquare[23] ? 520:
					inSquare[24] ? 45:
					inSquare[26] ? 145:
					inSquare[32] ? 445:
					inSquare[33] ? 495:
					inSquare[34] ? 545:
					1'b0;
	    yOffset = inSquare[0] || inSquare[1] || inSquare[2] || inSquare[3] || inSquare[4] || inSquare[15] || inSquare[18] || inSquare[19]? 165: 
					inSquare[5] || inSquare[6] || inSquare[7] || inSquare[8] || inSquare[9] || inSquare[16] || inSquare[20] || inSquare[21] ? 265: 
					inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[17] || inSquare[22] || inSquare[23] ? 365: 
					inSquare[24] || inSquare[25] || inSquare[26] || inSquare[27] || inSquare[28] || inSquare[29] || inSquare[30] || inSquare[31] || inSquare[32] || inSquare[33] || inSquare[34]? 25:
					1'b0;
	end
endmodule