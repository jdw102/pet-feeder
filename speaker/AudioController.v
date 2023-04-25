module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
	input feedActivation,
	input buttonPress,
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
	reg enable = 0;

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:15];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end
	
	reg [3:0] freq = 0;
	reg audioClk = 0;
    reg[17:0] counter = 0;
	wire[17:0] counterLimit;
	assign counterLimit = ((SYSTEM_FREQ / FREQs[freq]) >> 1) - 1;
	wire[31:0] secondLimit;
    assign secondLimit = 32'd25000000;
	reg [31:0] c = 0;
	reg [31:0] seconds = 0;
    always @(posedge clk) begin
        if (counter < counterLimit) begin
			counter <= counter + 1;
		end
		else begin
			counter <= 0;
			audioClk <= ~ audioClk;
		end
		if (c < secondLimit && feedActivation) begin 
			c <= c + 1;
			enable <= 1'b1;
		end
		else begin
			c <= 0;
			if (feedActivation) begin
				seconds <= seconds + 1;
				case (seconds)
				32'd1: freq = 4'd2;
				32'd2: freq = 4'd4;
				32'd3: freq = 4'd7;
				default: freq = 4'd9;
				endcase
			end
			else begin
				seconds <= 0;
				if (buttonPress) begin
					enable = 1'b1;
				end
				else begin
					enable = 1'b0;
				end
			end
		end
    end

	wire [6:0] duty_cycle;
	assign duty_cycle = audioClk ? 7'd100 : 7'd0;

	PWMSerializer serializer(clk, 1'b0, duty_cycle, audioOut);

	assign audioEn = enable;
	

endmodule