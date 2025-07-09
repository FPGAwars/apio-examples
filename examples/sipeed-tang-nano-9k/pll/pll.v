// PLL example. 

// See the Gowin PLL online calculator at:
// at https://juj.github.io/gowin_fpga_code_generators/pll_calculator.html
//
// Or use: apio raw -- gowin_pll ....

module pll (
    input  clk_in,
    output clk_out,  // 27 MHz
    output clk_lock  // 54 MHz
);

  rPLL #(  // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
      .FCLKIN("27"),
      .IDIV_SEL(0),  // -> PFD = 27 MHz (range: 3-400 MHz)
      .FBDIV_SEL(1),  // -> CLKOUT = 54 MHz (range: 3.125-600 MHz)
      .ODIV_SEL(16)  // -> VCO = 864 MHz (range: 400-1200 MHz)
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
      .CLKIN(clk_in),  // 27 MHz
      .CLKOUT(clk_out),  // 54 MHz
      .LOCK(clk_lock)
  );

endmodule
