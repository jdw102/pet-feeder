module motor_controller(input activate, clock, reset, output reg pwm);
    reg[31:0] counter = 0;
    wire[31:0] counterLimit;
    assign counterLimit = 32'd50000000;
    reg [31:0] sec = 0;
    wire [31:0] secLimit;
    assign secLimit = 5;

    always @(posedge clock) begin
        if (activate) begin
            pwm <= 1;
        end
        if (counter < counterLimit)begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            if (sec < secLimit && activate) begin
                sec <= sec + 1;
                pwm <= 1;
            end
            else begin
                sec <= 0;
                pwm <= 0;
            end
        end
    end
    
endmodule