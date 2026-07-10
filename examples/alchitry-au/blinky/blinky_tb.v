//-------------------------------------------------------------------
//-- Testbench
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module blinky_tb ();

  //-- Simulation time: 3us (30 * 100ns)
  parameter DURATION = 10 * 3;

  //-- System clock
  reg clk;

  //-- Leds port
  wire [7:0] leds;

  //-- Instantiate the unit to test
  main UUT (
      .clk(clk),
      .leds(leds)
  );

  //-- Real blinking led (always constant: the simulation is too short)
  wire led0 = leds[0];

  //-- Clock generation
  always #0.5 clk = ~clk;

  initial begin
    clk = 0;

    //-- File were to store the simulation results
    $dumpfile("blinky_tb.vcd");
    $dumpvars(0, blinky_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
