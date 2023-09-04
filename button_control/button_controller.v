module button_controller(input [8:0] buttons, input clock, output [4:0] ctrlWriteReg, output reg [31:0] writeReg, output wren);

    assign ctrlWriteReg = 5'd2;

    always @(posedge clock) begin
        case(buttons)
            9'b100000000: writeReg = 32'd9;
            9'b010000000: writeReg = 32'd8;
            9'b001000000: writeReg = 32'd7;
            9'b000100000: writeReg = 32'd6;
            9'b000010000: writeReg = 32'd5;
            9'b000001000: writeReg = 32'd4;
            9'b000000100: writeReg = 32'd3;
            9'b000000010: writeReg = 32'd2;
            9'b000000001: writeReg = 32'd1;
            default: writeReg = 32'd0;
        endcase
    end

    assign wren = |writeReg;

endmodule