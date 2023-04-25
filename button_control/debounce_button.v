// module debounce_button (
//     input clk,         // clock input
//     input button,      // button input to be debounced
//     output reg debounced_button  // debounced button output
// );

// // Define constants for debounce timer
// localparam DEBOUNCE_TIME = 50_000;  // 50ms debounce time
// localparam MAX_COUNT = DEBOUNCE_TIME - 1;

// // Define state variables
// reg [15:0] count;  // counter to measure debounce time
// reg [1:0] state;   // state machine state

// // Define state machine states
// parameter IDLE = 2'b00;
// parameter PRESS = 2'b01;
// parameter RELEASE = 2'b10;

// // State machine logic
// always @ (posedge clk) begin
//     case (state)
//         IDLE:
//             if (button == 1'b0) begin
//                 count <= 0;
//                 state <= PRESS;
//             end else begin
//                 debounced_button <= 1'b0;
//             end
//         PRESS:
//             if (button == 1'b1) begin
//                 count <= 0;
//                 state <= RELEASE;
//             end else if (count == MAX_COUNT) begin
//                 debounced_button <= 1'b1;
//                 state <= IDLE;
//             end else begin
//                 count <= count + 1;
//             end
//         RELEASE:
//             if (button == 1'b0) begin
//                 count <= 0;
//                 state <= PRESS;
//             end else if (count == MAX_COUNT) begin
//                 debounced_button <= 1'b0;
//                 state <= IDLE;
//             end else begin
//                 count <= count + 1;
//             end
//     endcase
// end

// endmodule
// module debounce_button (
//   input clk,
//   input btn,
//   output reg debounced_btn
// );

// parameter debounce_cycles = 10; // number of cycles for debounce

// reg [debounce_cycles-1:0] history;
// reg stable;
// reg [debounce_cycles - 1 : 0] check;
// integer i;
// initial begin
//     for (i = 0; i < debounce_cycles; i = i + 1) begin
//         check[i] = 1'b1;
//     end
// end
// always @(posedge clk) begin
//   history <= {history[debounce_cycles-2:0], btn};
//   stable <= (history == check); // all ones
  
//   if (stable && !debounced_btn) begin
//     debounced_btn <= 1;
//   end else if (!stable && debounced_btn) begin
//     debounced_btn <= 0;
//   end
// end

// endmodule
module debounce_button(
    input clk,
    input PB,  // "PB" is the glitchy, asynchronous to clk, active low push-button signal

    // from which we make three outputs, all synchronous to the clock
    output reg PB_state=0,  // 1 as long as the push-button is active (down)
    output PB_down  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)
);

// First use two flip-flops to synchronize the PB signal the "clk" clock domain
reg PB_sync_0;  
always @(posedge clk) PB_sync_0 <= ~PB;  // invert PB to make PB_sync_0 active high
reg PB_sync_1; 
always @(posedge clk) PB_sync_1 <= PB_sync_0;

// Next declare a 16-bits counter
reg [7:0] PB_cnt = 0;

wire PB_up;
// When the push-button is pushed or released, we increment the counter
// The counter has to be maxed out before we decide that the push-button state has changed

wire PB_idle = (PB_state==PB_sync_1);
wire PB_cnt_max = &PB_cnt;	// true when all bits of PB_cnt are 1's

always @(posedge clk)
if(PB_idle)
    PB_cnt <= 0;  // nothing's going on
else
begin
    PB_cnt <= PB_cnt + 8'd1;  // something's going on, increment the counter
    if(PB_cnt_max) PB_state <= ~PB_state;  // if the counter is maxed out, PB changed!
end

assign PB_down = ~PB_idle & PB_cnt_max & ~PB_state;
assign PB_up   = ~PB_idle & PB_cnt_max &  PB_state;
endmodule
