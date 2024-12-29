module blinky #(
    // Num of click cycle per led toggle.
    parameter integer DIV = 13_499_999
) (
    input      sys_clk,
    input      sys_reset,  // Active low.
    output reg led         // Active low
);

  reg [31:0] counter;

  always @(posedge sys_clk) begin
    if (!sys_reset) begin
      counter <= 0;
      led <= 1;
    end else if (counter < DIV) begin
      counter <= counter + 1;
    end else begin
      counter <= 0;
      led <= ~led;
    end
  end

endmodule
