module main #(
    // Num of click cycle per led toggle.
    parameter integer DIV = (180_000_000 / 2)
) (
    input      ext_clk,
    output reg led       // Active low
);

  // ---- PLL, 27Mhz -> 180Mhz
  //
  // Generated using the commands:
  //   apio raw -- gowin_pll -d "GW2A-18 C8/I7" -i 27 -o 180 -f pll.v
  //   apio format pll.v
  //
  wire sys_clk;
  pll pll (
      .clock_in(ext_clk),
      .clock_out(sys_clk),
      .locked()
  );

  // ---- Blinker

  reg [31:0] blink_counter;

  always @(posedge sys_clk) begin
    if (blink_counter < (DIV - 1)) begin
      blink_counter <= blink_counter + 1;
    end else begin
      blink_counter <= 0;
      led <= ~led;
    end
  end

endmodule
