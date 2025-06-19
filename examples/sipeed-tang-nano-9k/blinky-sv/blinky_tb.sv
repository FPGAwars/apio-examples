// A testbench for testing the blinky module.

`default_nettype none `timescale 10 ns / 1 ns

module blinky_tb ();

  // Defines clk, clk_num, and testing utilities.
  `include "apio_testing.svh"

  // Outputs.
  wire led;

  // Instantiate a blinky that toggles the led every 5 clocks.
  blinky #(
      .DIV(5)
  ) blinky (
      .sys_clk(clk),
      .led(led)
  );

  initial begin
    // Dump all signals of blinky_tb.
    $dumpvars(0, blinky_tb);

    // Go through the reset.
    clk1();
    `CHECK_EQ(blinky.sys_reset, 1);
    clks(3);
    `CHECK_EQ(blinky.sys_reset, 0);

    // Free run for 30 clocks.
    clks(30);

    // All done.
    `CHECK_EQ(blinky.sys_reset, 0);
    $finish;
  end

endmodule
