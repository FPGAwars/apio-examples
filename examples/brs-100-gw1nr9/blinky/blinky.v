module blinky #(
    // Num of clock cycle per led transition.
    parameter integer DIV = (27000000 / 6)
) (
    input            sys_clk,
    output reg [5:0] leds      // Active low
);

  // ---- Reset generator.

  reg [3:0] reset_counter = 0;
  reg sys_reset = 1;

  always @(posedge sys_clk) begin
    if (reset_counter < 3) begin
      sys_reset <= 1;
      reset_counter <= reset_counter + 1;
    end else begin
      sys_reset <= 0;
    end
  end

  // ---- Blinker

  reg [31:0] blink_counter;

  always @(posedge sys_clk) begin
    if (sys_reset) begin
      // Reset
      blink_counter <= 0;
      leds <= 6'b111110;
    end else if (blink_counter < (DIV - 1)) begin
      // Delay
      blink_counter <= blink_counter + 1;
    end else begin
      // Transition
      blink_counter <= 0;
      leds = {leds[4:0], leds[5]};
    end
  end

endmodule
