// A testbench for testing the blinky module.

`include "apio_testing.vh"

`timescale 10 ns / 1 ns

module blinker_tb ();

  // This defines a managed signal called 'clk'.
  `DEF_CLK

  // Outputs.
  wire led;

  // Instantiate a blinker that toggles the led every 5 clocks.
  blinker #(
      .DIV(5)
  ) blinker (
      .clk(clk),
      .led(led)
  );

  initial begin
    `TEST_BEGIN(blinker_tb)

    // Free run for 50 clocks.
    `CLKS(30)

    `TEST_END
  end

endmodule
