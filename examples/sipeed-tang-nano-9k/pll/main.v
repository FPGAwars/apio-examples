module main (
    input      sys_clk,  // 27 Mhz
    output reg led       // Active low
);

  wire pll_clk;

  // Clock multiplier.
  pll pll (
      .clk_in  (sys_clk),  // 27 Mhz
      .clk_out (pll_clk),  // 54 Mhz
      .clk_lock()
  );

  // The blinker. Runs on pll clock and prints once a second.
  localparam DIV = (54000000 / 2);

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
