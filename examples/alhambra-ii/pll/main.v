//------------------------------------------------------------------
//-- Using PLL for 48Mhz clock.
//------------------------------------------------------------------

module main (
    input  ext_clk,  // 12MHz clock
    output LED       // LED to blink
);

  // PLL 12Mhz -> 28Mhz
  //
  // Generated with:
  //   apio raw -- icepll -i 12 -o 48 -q -m -f pll.v
  //   apio format pll.v
  //
  // (See pll.v for additional args that were added manually)

  wire sys_clk;

  pll pll (
      .clock_in(ext_clk),
      .clock_out(sys_clk),
      .locked()
  );

  reg [23:0] counter = 0;

  always @(posedge sys_clk) counter <= counter + 1;

  // Should blink at about 2.82Hz
  // 48M / 2^24 = 2.82
  assign LED = counter[23];

endmodule


