//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module main (
    input ext_clk,  // 25MHz clock
    output led  // LED to blink
);

  wire sys_clk;

  pll pll (
      .clkin  (ext_clk),  // 25 Mhz in
      .clkout0(sys_clk),  // 120 Mhz out
      .locked ()
  );

  reg [24:0] counter = 0;

  always @(posedge sys_clk) begin
    counter <= counter + 1;
  end

  assign led = counter[24];

endmodule
