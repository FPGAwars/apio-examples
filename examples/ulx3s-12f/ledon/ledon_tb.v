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
  wire led0, led1, led2, led3, led4, led5, led6, led7;

  //-- Instantiate the unit to test
  led_on UUT (.led({led7, led6, led5, led4, led3, led2, led1, led0}));


  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, ledon_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
