module idle_display(input clk, reset, input [5:0] state, input[31:0] dur, input ampm, input[7:0] hour, min, print, input[9:0] x, input[8:0] y, output squareTotal, highlight, welcome, output [7:0] char, output [18:0] spriteAddress);

    wire [7:0] char, offset;
    reg [9:0] xOffset, yOffset;
    reg [15:0] inSquare;
	reg [7:0] size = 8'd96;
	
	wire [7:0] dig1, dig2, dig3, dig4, dig5, dig6, colon, size;
	char_converter char_con(hour, min, ampm, dig1, dig2, dig3, dig4, dig5, dig6, colon);

	assign highlight = state[4] ?  inSquare[0] || inSquare[1] || inSquare[2] || inSquare[3] || inSquare[4] || inSquare[5] || inSquare[6] : 1'b0;

	assign char = inSquare[0] ? dig1: inSquare[1] ? dig2: inSquare[2] ? colon : inSquare[3] ? dig3: inSquare[4] ? dig4: 
					inSquare[5] ? dig5: inSquare[6] ? dig6: inSquare[7]? size:
					inSquare[8] ? 8'd95: inSquare[9] ? 8'd104: inSquare[10] ? 8'd111 : inSquare[11] ? 8'd102: inSquare[12] ? 8'd114: inSquare[13] ? 8'd112: inSquare[14] ? 8'd104: inSquare[15] ? 8'd15:
					1'b0;
	assign welcome = inSquare[8] || inSquare[9] || inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[15];
	assign spriteAddress = (print - 33) * 2500 + (x - xOffset) + ((y - yOffset) * 50);
	assign squareTotal = |inSquare;

	always @(dur) begin
		case (dur)
			32'd6: size = 8'd97;
			32'd11: size = 8'd98;
			default: size = 8'd96;
		endcase
	end

	always @(posedge clk) begin
		inSquare[0] = (x >= 145) & (x < 195) & (y >= 25) & (y <= 75);
		inSquare[1] = (x >= 195) & (x < 245) & (y >= 25) & (y <= 75);
		inSquare[2] = (x >= 245) & (x < 295) & (y >= 25) & (y <= 75);
		inSquare[3] = (x >= 295) & (x < 345) & (y >= 25) & (y <= 75);
		inSquare[4] = (x >= 345) & (x <= 395) & (y >= 25) & (y <= 75);
		inSquare[5] = (x >= 420) & (x < 470) & (y >= 25) & (y <= 75);
		inSquare[6] = (x >= 470) & (x <= 520) & (y >= 25) & (y <= 75);

		inSquare[7] = (x >= 0) & (x <= 50) & (y >= 25) & (y <= 75);

		inSquare[8] = (x >= 120) & (x < 170) & (y >= 215) & (y <= 265);
		inSquare[9] = (x >= 170) & (x < 220) & (y >= 215) & (y <= 265);
		inSquare[10] = (x >= 220) & (x < 270) & (y >= 215) & (y <= 265);
		inSquare[11] = (x >= 270) & (x < 320) & (y >= 215) & (y <= 265);
		inSquare[12] = (x >= 320) & (x <= 370) & (y >= 215) & (y <= 265);
		inSquare[13] = (x >= 370) & (x < 420) & (y >= 215) & (y <= 265);
		inSquare[14] = (x >= 420) & (x <= 470) & (y >= 215) & (y <= 265);
		inSquare[15] = (x >= 470) & (x <= 520) & (y >= 215) & (y <= 265);

		xOffset = 	inSquare[0] ? 145: 
					inSquare[1] ? 195: 
					inSquare[2] ? 245: 
					inSquare[3] ? 295: 
					inSquare[4] ? 345: 
					inSquare[5] ? 420:
					inSquare[6] ? 470:
					inSquare[7] ? 0:
					inSquare[8] ? 120: 
					inSquare[9] ? 170: 
					inSquare[10] ? 220: 
					inSquare[11] ? 270: 
					inSquare[12] ? 320: 
					inSquare[13] ? 370:
					inSquare[14] ? 420:
					inSquare[15] ? 470:
					1'b0;
	    yOffset = inSquare[0] || inSquare[1] || inSquare[2] || inSquare[3] || inSquare[4] || inSquare[5] || inSquare[6] || inSquare[7] ? 25:
					inSquare[8] || inSquare[9] || inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[15]? 215:
				 	1'b0;

	end
endmodule