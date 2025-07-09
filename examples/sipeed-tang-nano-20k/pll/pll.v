// PLL 27Mhz -> 60Mhz
// Computed with Gowin pll generator and cleanup manually.
//Part Number: GW2AR-LV18QN88PFC8/I7

module pll (
    input  clkin,
    output clkout,
    output lock
);

  wire clkoutp_o;
  wire clkoutd_o;
  wire clkoutd3_o;


  rPLL #(
      .FCLKIN("27"),
      .DYN_IDIV_SEL("false"),
      .IDIV_SEL(8),
      .DYN_FBDIV_SEL("false"),
      .FBDIV_SEL(19),
      .DYN_ODIV_SEL("false"),
      .ODIV_SEL(16),
      .PSDA_SEL("0000"),
      .DYN_DA_EN("false"),
      .DUTYDA_SEL("1000"),
      .CLKOUT_FT_DIR(1'b1),
      .CLKOUTP_FT_DIR(1'b1),
      .CLKOUT_DLY_STEP(0),
      .CLKOUTP_DLY_STEP(0),
      .CLKFB_SEL("internal"),
      .CLKOUT_BYPASS("false"),
      .CLKOUTP_BYPASS("false"),
      .CLKOUTD_BYPASS("false"),
      .DYN_SDIV_SEL(2),
      .CLKOUTD_SRC("CLKOUT"),
      .CLKOUTD3_SRC("CLKOUT"),
      .DEVICE("GW2AR-18C")
  ) rpll_inst (
      .CLKOUT(clkout),
      .LOCK(lock),
      .CLKOUTP(clkoutp_o),
      .CLKOUTD(clkoutd_o),
      .CLKOUTD3(clkoutd3_o),
      .RESET(1'b0),
      .RESET_P(1'b0),
      .CLKIN(clkin),
      .CLKFB(1'b0),
      .FBDSEL(6'b0),
      .IDSEL(6'b0),
      .ODSEL(6'b0),
      .PSDA(4'b0),
      .DUTYDA(4'b0),
      .FDLY(4'b0)
  );



endmodule
