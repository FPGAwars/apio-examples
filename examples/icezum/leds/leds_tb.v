//-------------------------------------------------------------------
//-- leds_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- Jesus Arroyo Torrens
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module leds_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

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

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, leds_tb);

   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
