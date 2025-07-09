/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the gowin-pll tool.
 * Use at your own risk.
 *
 * Target-Device:                GW1NR-9 C6/I5
 * Given input frequency:        27.000 MHz
 * Requested output frequency:   75.000 MHz
 * Achieved output frequency:    75.000 MHz
 */

module pll (
    input  clock_in,
    output clock_out,
    output locked
);

  rPLL #(
      .FCLKIN("27.0"),
      .IDIV_SEL(8),  // -> PFD = 3.0 MHz (range: 3-400 MHz)
      .FBDIV_SEL(24),  // -> CLKOUT = 75.0 MHz (range: 3.125-600 MHz)
      .ODIV_SEL(8)  // -> VCO = 600.0 MHz (range: 400-1200 MHz)
  ) pll (
      .CLKOUTP(),
      .CLKOUTD(),
      .CLKOUTD3(),
      .RESET(1'b0),
      .RESET_P(1'b0),
      .CLKFB(1'b0),
      .FBDSEL(6'b0),
      .IDSEL(6'b0),
      .ODSEL(6'b0),
      .PSDA(4'b0),
      .DUTYDA(4'b0),
      .FDLY(4'b0),
      .CLKIN(clock_in),  // 27.0 MHz
      .CLKOUT(clock_out),  // 75.0 MHz
      .LOCK(locked)
  );

endmodule
