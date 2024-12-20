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
  leds UUT (
      .LED0(led0),
      .LED1(led1),
      .LED2(led2),
      .LED3(led3),
      .LED4(led4),
      .LED5(led5),
      .LED6(led6),
      .LED7(led7)
  );


  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, ledon_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
