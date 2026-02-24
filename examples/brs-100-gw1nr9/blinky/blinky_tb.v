// A testbench for testing the blinky module.

`timescale 10 ns / 1 ns

module blinky_tb ();

  // Clock.
  reg     sys_clk = 0;
  integer clk_num = 0;

  always begin
    #10 sys_clk = ~sys_clk;
    if (sys_clk) clk_num = clk_num + 1;
  end

  // Outputs.
  wire [5:0] leds;

  // Tested module. Transition the leds every 5 clocks.
  blinky #(
      .DIV(5)
  ) ticker (
      .sys_clk(sys_clk),
      .leds(leds)
  );

  // Test main
  initial begin
    $dumpvars(0, blinky_tb);

    // Wait 100 clocks.
    repeat (100) @(posedge sys_clk);

    // End of test
    $display("End of simulation");
    $finish;
  end

endmodule
