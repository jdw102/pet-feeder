module feed_display(input clk, reset, feed, input[31:0] duration, print, input[9:0] x, input[8:0] y, output squareTotal, loadSquare, output [7:0] char, output [18:0] spriteAddress);
    wire [7:0] char, offset;
    reg [9:0] xOffset, yOffset;
    reg [19:0] inSquare;
	reg [31:0] counter = 0;
    reg [31:0] seconds = 0;
    reg [9:0] add = 10'b0;
    wire[31:0] counterLimit;
    assign counterLimit = 32'd50000000;
    
	assign char = inSquare[0] ? 8'd126: inSquare[1] ? 8'd104: inSquare[2] ? 8'd104 : inSquare[3] ? 8'd103: inSquare[4] ? 8'd108: inSquare[5] ? 8'd113: inSquare[6] ? 8'd106: inSquare[7]? 8'd11: inSquare[8]? 8'd11: inSquare[9]? 8'd11:
                    1'b0;
	assign spriteAddress = (print - 33) * 2500 + (x - xOffset) + ((y - yOffset) * 50);
	assign squareTotal = |inSquare;
    assign loadSquare = inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[15] || inSquare[16] || inSquare[17] || inSquare[18] || inSquare[19];

	always @(posedge clk) begin
		inSquare[0] = (x >= 60) & (x < 110) & (y >= 165) & (y <= 215);
		inSquare[1] = (x >= 110) & (x < 160) & (y >= 165) & (y <= 215);
		inSquare[2] = (x >= 160) & (x < 210) & (y >= 165) & (y <= 215);
		inSquare[3] = (x >= 210) & (x < 260) & (y >= 165) & (y <= 215);
		inSquare[4] = (x >= 260) & (x < 310) & (y >= 165) & (y <= 215);
		inSquare[5] = (x >= 310) & (x < 360) & (y >= 165) & (y <= 215);
		inSquare[6] = (x >= 360) & (x < 410) & (y >= 165) & (y <= 215);
        inSquare[7] = (x >= 410) & (x < 460) & (y >= 165) & (y <= 215);
		inSquare[8] = (x >= 460) & (x < 520) & (y >= 165) & (y <= 215);
        inSquare[9] = (x >= 520) & (x <= 580) & (y >= 165) & (y <= 215);

        inSquare[10] = add[0]? (x >= 14) & (x < 64) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[11] = add[1]? (x >= 78) & (x < 128) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[12] = add[2]? (x >= 142) & (x < 192) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[13] = add[3]? (x >= 206) & (x < 256) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[14] = add[4]? (x >= 270) & (x < 320) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[15] = add[5]? (x >= 334) & (x < 384) & (y >= 10) & (y <= 90): 1'b0;
		inSquare[16] = add[6]? (x >= 398) & (x < 448) & (y >= 10) & (y <= 90): 1'b0;
        inSquare[17] = add[7]? (x >= 462) & (x < 512) & (y >= 10) & (y <= 90): 1'b0;
        inSquare[18] = add[8]? (x >= 526) & (x < 576) & (y >= 10) & (y <= 90): 1'b0;
        inSquare[19] = add[9]? (x >= 590) & (x < 640) & (y >= 10) & (y <= 90): 1'b0;

		xOffset = 	inSquare[0] ? 60: 
					inSquare[1] ? 110: 
					inSquare[2] ? 160: 
					inSquare[3] ? 210: 
					inSquare[4] ? 260: 
					inSquare[5] ? 310:
					inSquare[6] ? 360:
                    inSquare[7] ? 410:
                    inSquare[8] ? 460:
                    inSquare[9] ? 520:
                    inSquare[10] ? 14:
                    inSquare[11] ? 78:
                    inSquare[12] ? 142:
                    inSquare[13] ? 206:
                    inSquare[14] ? 270:
                    inSquare[15] ? 334:
                    inSquare[16] ? 398:
                    inSquare[17] ? 462:
                    inSquare[18] ? 526:
                    inSquare[19] ? 590:
					1'b0;
	    yOffset = inSquare[0] || inSquare[1] || inSquare[2] || inSquare[3] || inSquare[4] || inSquare[5] || inSquare[6] || inSquare[7] || inSquare[8] || inSquare[9] ? 165:
                    inSquare[10] || inSquare[11] || inSquare[12] || inSquare[13] || inSquare[14] || inSquare[15] || inSquare[16] || inSquare[17] || inSquare[18] || inSquare[19] ? 10: 
                    1'b0;      
        if (counter < counterLimit && feed == 1'b1 && seconds < duration + 1) begin
            counter <= counter + 1;
        end
        else begin
            counter <= 0;
            if (feed) begin
                seconds <= seconds + 1;
                if (duration == 5) begin
                    case (seconds)
                        32'd1: add = 10'b0000000111;
                        32'd2: add = 10'b0000111111;
                        32'd3: add = 10'b1111111111;
                        default: add = 10'b0;
                    endcase
                end
                if (duration == 8) begin
                    case (seconds)
                        32'd1: add = 10'b0000000011;
                        32'd2: add = 10'b0000001111;
                        32'd3: add = 10'b0000111111;
                        32'd4: add = 10'b0011111111;
                        32'd5: add = 10'b1111111111;
                        default: add = 10'b0;
                    endcase
                end
                if (duration == 11) begin
                    case (seconds)
                        32'd1: add = 10'b0000000001;
                        32'd2: add = 10'b0000000011;
                        32'd3: add = 10'b0000000111;
                        32'd4: add = 10'b0000001111;
                        32'd5: add = 10'b0000011111;
                        32'd6: add = 10'b0000111111;
                        32'd7: add = 10'b0001111111;
                        32'd8: add = 10'b0011111111;
                        32'd9: add = 10'b0111111111;
                        32'd10: add = 10'b1111111111;
                        default: add = 10'b0;
                    endcase
                end
            end
            else begin
                seconds <= 0;
                add = 10'b0;
            end
        end
	end
endmodule