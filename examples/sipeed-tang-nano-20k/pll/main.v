module main #(
    // Num of click cycle per led toggle.
    parameter integer DIV = (27_000_000 / 2)
) (
    input      ext_clk,
    output reg led       // Active low
);

  // ---- PLL, 27Mhz -> 60Mhz
  wire sys_clk;
  wire lock;
  pll pll (
      .clkin (ext_clk),
      .clkout(sys_clk),
      .lock  (lock)
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
