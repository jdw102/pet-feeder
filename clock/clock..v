module clock(input clk, writeHour, writeMin, writeAmpm, input[7:0] data, output[7:0] hour, minute, second, output [31:0] runningTime, output ampm);

    reg clk1Hz = 0;
    reg[31:0] counter = 0;
    reg[7:0] seconds = 0;
    reg[7:0] minutes = 0;
    reg[7:0] hours = 12;
    reg[31:0] totalTime = 0;
    reg ampmReg = 0;
    wire[31:0] counterLimit;
    assign counterLimit = 32'd50000000;

    always @(posedge clk) begin
        if (counter < counterLimit)begin
            counter <= counter + 1;
            if (writeHour == 1'b1) begin
                hours <= data;
            end
            if (writeMin == 1'b1) begin
                minutes <= data;
            end
            if (writeAmpm == 1'b1) begin
                ampmReg <= data[0];
            end
        end
        else begin
            counter <= 0;
            clk1Hz <= ~clk1Hz;
            if (totalTime == 32'b1) begin
                totalTime <= 0;
            end
            totalTime <= totalTime + 1;
            if (seconds < 59) begin
                seconds <= seconds + 1;
            end else begin
                seconds <= 0;
                if (minutes < 59)begin
                    minutes = minutes + 1;
                end else begin
                    minutes <= 0;
                    if (hours >= 12)begin
                        hours <= 1;
                    end else begin
                        hours <= hours + 1;
                        if (hours == 12) begin
                            ampmReg <= ~ampmReg;
                        end
                    end
                end
            end
        end
    end      

    assign hour = hours;
    assign minute = minutes;
    assign second = seconds;
    assign ampm = ampmReg;
    assign runningTime = totalTime;

endmodule