//-------------------------------------------------------------------
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module blinky_tb ();

  //-- Simulation time: 1us (10 * 100ns)
  parameter DURATION = 10 * 3; //-- 3us

  //-- System clock
  reg clk;

  //-- Leds port
  wire [15:0] leds;

  //-- Instantiate the unit to test
  main UUT (
      .clk(clk),
      .leds(leds)
  );

//-- Real blinking led
//-- It is always 0 because the simulation is too short
wire led0 = leds[0];

//-- Virtual led, to see it blinking in simulation
//-- The internal counter bit 1 is used instead of the
//-- one used for the real blinky (bit 24)
wire led_sim = UUT.counter[1];


// System clock
  initial begin
      clk = 1;
      forever begin
          #1;
          clk = ~clk;
      end
  end


  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, blinky_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
