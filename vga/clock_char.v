module clock_display(
  input [7:0] hour,
  input [7:0] minute,
  output reg [7:0] digit1,
  output reg [7:0] digit2,
  output reg [7:0] digit3,
  output reg [7:0] digit4
);

  always @(*) begin
    // Calculate the digits based on the hour and minute inputs
    digit1 = hour / 10;
    digit2 = hour % 10;
    digit3 = minute / 10;
    digit4 = minute % 10;
  end

endmodule
