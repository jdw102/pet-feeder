module button_controller(input [7:0] buttons, input clock, output [4:0] ctrlWriteReg, output reg [31:0] writeReg, output wren);

    assign ctrlWriteReg = 5'd2;

    always @(posedge clock) begin
        case(buttons)
            8'b10000000: writeReg = 32'd8;
            8'b01000000: writeReg = 32'd7;
            8'b00100000: writeReg = 32'd6;
            8'b00010000: writeReg = 32'd5;
            8'b00001000: writeReg = 32'd4;
            8'b00000100: writeReg = 32'd3;
            8'b00000010: writeReg = 32'd2;
            8'b00000001: writeReg = 32'd1;
            default: writeReg = 32'd0;
        endcase
    end

    assign wren = |writeReg;

endmodule