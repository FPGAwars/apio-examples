// A testbench for testing the blinky module.

`include "apio_testing.vh"

`timescale 10 ns / 1 ns

module blinky_tb ();

  // This defines a managed signal called 'clk'.
  `DEF_CLK

  // Inputs.
  reg  reset = 0;

  // Outputs.
  wire led;

  // Instantiate a blinky that toggles the led every 5 clocks.
  blinky #(
      .DIV(5)
  ) ticker (
      .sys_clk(clk),
      .sys_reset(reset),
      .led(led)
  );

  initial begin
    `TEST_BEGIN(blinky_tb)

    // Reset for 2 clocks.
    `CLKS(2)
    reset = 1;

    // Free run for 30 clocks.
    `CLKS(30)

    `TEST_END
  end

endmodule
