//-------------------------------------------------------------------
//-- ledon_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module ledon_tb ();

  //-- Simulation time: 1us (10 * 100ns)
  parameter DURATION = 10;

  //-- Leds port
  wire [15:0] leds;

  wire led15 = leds[15];

  //-- Instantiate the unit to test
  ledon UUT (
      .leds(leds)
  );


  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, ledon_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
