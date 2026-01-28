`timescale 1ns / 1ps

module main_tb;

  // Inputs
  reg  ext_clk = 0;

  // Outputs
  wire LED;

  // Instantiate the Unit Under Test (UUT)
  main #(
      .DIV(4)  // Reduced for faster simulation.
  ) main (
      .ext_clk(ext_clk),
      .LED(LED)
  );

  // Continious clock
  always #5 ext_clk = ~ext_clk;

  initial begin
    // Dump signals to Apio specified .vcd file.
    $dumpvars(0, main_tb);

    // Run for 20 full clock cycles
    repeat (20) @(posedge ext_clk);

    // Finish simulation
    $finish;
  end

endmodule
