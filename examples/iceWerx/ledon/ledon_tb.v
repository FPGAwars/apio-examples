//-------------------------------------------------------------------
//-- ledon_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module ledon_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Red led
wire ledr;

//-- Instantiate the unit to test
leds UUT (
           .LEDR(ledr)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, ledon_tb);

   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
