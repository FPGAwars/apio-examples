//blink all 8 leds on Alchitry-Cu Board

module blinky #(
    // Default blink 1Hz. Can override in a testbench.
    parameter integer DELAY = 100000000 / 2
) (
    //inputs
    input clk,  //100MHz

    //outputs
    output reg [7:0] led = 8'b11111111  //start with all on
);

  // Blink counter.
  reg [26:0] count = 0;

  // Blink the leds
  always @(posedge clk) begin
    if (count >= DELAY[26:0]) begin
      if (led == 8'b0) begin  //if off
        led <= 8'b11111111;  //turn all leds on
      end else begin
        led <= 8'b0;  // turn all leds off
      end
      count = 27'b0;  //reset count
    end else begin
      count = count + 1'b1;
    end
  end

endmodule
