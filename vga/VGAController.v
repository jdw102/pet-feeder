	`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input motor,
	input currAmpm, ampm1, ampm2, ampm3,
	input[7:0] currHour, currMin, hour1, min1, hour2, min2, hour3, min3,
	input [31:0] dur,
	input [31:0] state,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B);  // Blue Signal Bits
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/User/Documents/Spring2023/ece350/pet_feeder_repo/vga/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;

	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	VGARAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	
	// ascii RAM
	VGARAM #(
		.DEPTH(256), 		     // Set depth to contain every color		
		.DATA_WIDTH(8), 		// Set data width according to the bits per color
		.ADDRESS_WIDTH(9),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "ascii.mem"}))  // Memory initialization
	AsciiData(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(char),				   // Address from the ImageData RAM
		.dataOut(print),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading

	wire db, inSquare;
	wire[7:0] char, print;
	wire [18:0] spriteAddress;
	// sprites RAM
	VGARAM #(
		.DEPTH(94*2500), 		  // Set depth to contain every color		
		.DATA_WIDTH(1), 		 // Set data width according to the bits per color
		.ADDRESS_WIDTH(19),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "sprites.mem"}))  // Memory initialization
	SpriteData(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(spriteAddress),				   // Address from the ImageData RAM
		.dataOut(db),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading

	wire [7:0] idleChar, editChar, feedChar;
	wire [18:0] idleAddress, editAddress, feedAddress;
	wire homeButton, editButton, idleSquare, editSquare, feedSquare, feedLoadSquare;

	reg[5:0] screenState = 6'b000000;
	
	always @(state) begin
		case(state)
            32'd1: 	screenState = 6'b000001;
            32'd2: 	screenState = 6'b000010;
            32'd3: 	screenState = 6'b000100;
			32'd4: 	screenState = 6'b001000;
			32'd5:	screenState = 6'b010000;
			32'd6:	screenState = 6'b100000;
            default: screenState = 6'b000000;
        endcase
	end

	wire saveHighlight, clockHighlight, highlight, welcome;

	assign highlight = screenState[0] || screenState[1]  || screenState[2] || screenState[3] ? saveHighlight: clockHighlight;
	assign char = screenState[0] || screenState[1]  || screenState[2] || screenState[3] ? editChar: screenState[5] ? feedChar: idleChar;
	assign spriteAddress = screenState[0] || screenState[1]  || screenState[2] || screenState[3]  ? editAddress: screenState[5] ? feedAddress: idleAddress;
	assign inSquare = screenState[0] || screenState[1]  || screenState[2] || screenState[3]  ? editSquare: screenState[5] ? feedSquare: idleSquare;


	idle_display idle(clk, reset, screenState, dur, currAmpm, currHour, currMin, print, x, y, idleSquare, clockHighlight, welcome, idleChar, idleAddress);
	edit_display edit(clk, reset, screenState, ampm1, ampm2, ampm3, hour1, min1, hour2, min2, hour3, min3, print, x, y, editSquare, saveHighlight, editChar, editAddress);
	feed_display feed(clk, reset, motor, dur, print, x,  y, feedSquare, feedLoadSquare, feedChar, feedAddress);

	wire [11:0] charColor, squareColor, loadColor;
	assign charColor =  highlight || (welcome && screenState == 6'b0) ? 12'h33cc33: 12'h00ffff;
	assign squareColor = highlight ? 12'h00ffff: welcome && screenState == 6'b0 ? colorData: 12'h33cc33;
	assign loadColor = 12'hf00;
	
	assign colorOut = active & !inSquare ? colorData : (motor && feedLoadSquare) ? loadColor: db ? charColor : squareColor; // When not active, output 

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule