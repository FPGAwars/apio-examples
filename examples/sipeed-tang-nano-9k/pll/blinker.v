module blinker #(
    parameter integer DIV = (54000000 / 2)
) (
    input  clk,  // 27 Mhz
    output led   // Active low
);

  reg [31:0] blink_counter;
  reg led_reg = 0;

  assign led = led_reg;

  always @(posedge clk) begin
    if (blink_counter < (DIV - 1)) begin
      blink_counter <= blink_counter + 1;
    end else begin
      blink_counter <= 0;
      led_reg <= ~led_reg;
    end
  end

endmodule
