// A testbench of main.v.

`include "common/apio_testing.vh"

`timescale 10 ns / 1 ns

module main_tb ();

  // This defines a managed signal called 'clk'.
  `DEF_CLK

  // Module's output.
  wire  led;

  main #(
      .CLK_DIV(6)
  ) main (
      .CLK (clk),
      .LED(led)
  );

  initial begin
    `TEST_BEGIN(main_tb)

    // Free run for 400 clocks.
    `CLKS(16)

    // Assert on expected bcd value.
    `EXPECT(led, 1'b1)

    `TEST_END
  end

endmodule
