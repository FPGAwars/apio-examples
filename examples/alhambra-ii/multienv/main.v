//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module main (
    input        CLK,  // 12MHz clock
    output [7:0] LEDS  // LED to blink
);

  // The counter should count this number of clocks
  // between flipping LED state.
  localparam limit = (`CLK_DIV / 2) - 1;

  reg led = 0;

  reg [23:0] counter = 0;

  always @(posedge CLK) begin
    if (counter < limit) begin
      counter <= counter + 1;
    end else begin
      counter <= 0;
      led  <= ~led;
    end
  end

  assign LEDS = {led, 7'b0};

endmodule


