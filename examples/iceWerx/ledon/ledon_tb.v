//-------------------------------------------------------------------
//-- ledon_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none
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

  //-- Dump vars to the .vcd output file
  $dumpvars(0, ledon_tb);

   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
