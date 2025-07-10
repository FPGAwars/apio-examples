//------------------------------------------------------------------
//-- Blinking LED using a custom PLL clock.
//------------------------------------------------------------------

module main (
    input  ext_clk,  // 25MHz clock
    output led       // LED to blink
);

  wire sys_clk;

  // PLL. Generated with;
  //   apio raw -- ecppll -i 25 -o 120 -f pll.v
  //   apio format pll.v
  //
  // Also, added manually the unused signals to make 'apio lint' happy.
  //
  pll pll (
      .clkin  (ext_clk),  // 25 MHz, 0 deg
      .clkout0(sys_clk),  // 120 MHz, 0 deg
      .locked ()
  );

  reg [23:0] counter = 0;

  always @(posedge sys_clk) counter <= counter + 1;

  assign led = counter[23];

endmodule
