module main (
    input      ext_clk,  // 27 Mhz
    output reg led       // Active low
);

  wire pll_clk;

  // PLL 27Mhz -> 75Mhz
  //
  // Generated with:
  //   apio raw -- gowin_pll -d "GW1NR-9 C6/I5" -i 27 -o 75 -f pll.v
  //   apio format pll.v
  //
  pll pll (
      .clock_in(ext_clk),   // 27 Mhz
      .clock_out(pll_clk),  // 75 Mhz
      .locked()
  );

  // The blinker. Runs on pll clock and prints once a second.
  localparam integer DIV = (75_000_000 / 2);

  reg [31:0] blink_counter;

  always @(posedge pll_clk) begin
    if (blink_counter < (DIV - 1)) begin
      blink_counter <= blink_counter + 1;
    end else begin
      blink_counter <= 0;
      led <= ~led;
    end
  end

endmodule
