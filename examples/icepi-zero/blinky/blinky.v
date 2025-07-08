// Blink the on-board leds
module top (
    input  clk,        // 50 MHZ
    output [4:0] led   // LEDs
);

  // Turn off all leds
  assign led[3:0]   = 4'b0;

  // Count to 2^25
  reg [25:0] counter = 0;

  always @(posedge clk) counter <= counter + 1;

  // Blink led 4
  assign led[4] = counter[25];

endmodule
