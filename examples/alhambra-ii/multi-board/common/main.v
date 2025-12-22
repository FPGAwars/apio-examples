//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module main #(
    parameter integer CLKS_PER_CYCLE = `CLKS_PER_CYCLE
) (
    input  CLK,  // Main clock
    output LED   // LED to blink
);

  // The counter should count this number of clocks
  // between flipping the led state.
  localparam LIMIT = ((CLKS_PER_CYCLE) / 2) - 1;

  reg [31:0] counter = 0;

  reg led = 0;

  always @(posedge CLK) begin
    if (counter < LIMIT) begin
      counter <= counter + 1;
    end else begin
      counter <= 0;
      led <= ~led;
    end
  end

  assign LED = led;

endmodule


