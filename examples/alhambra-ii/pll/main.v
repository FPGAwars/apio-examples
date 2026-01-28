//------------------------------------------------------------------
//-- Using PLL for 48Mhz clock.
//------------------------------------------------------------------

module main #(
    parameter integer DIV = 8_000_000
) (
    input      ext_clk,  // 12MHz clock
    output reg LED       // LED to blink
);

  // PLL 12Mhz -> 48Mhz
  //
  // Generated with:
  //   apio raw -- icepll -i 12 -o 48 -q -m -f pll.v
  //   apio format pll.v
  //
  // (See pll.v for additional args that were added manually)

  // 48 Mhz clock from the pll.
  wire sys_clk;

  // Generates the main clock .
  pll pll (
      .clock_in(ext_clk),  // In 12 Mhz
      .clock_out(sys_clk),  // Out 48 Mhz
      .locked()
  );

  reg initialized = 1'b0;

  reg [31:0] counter;

  always @(posedge sys_clk) begin
    if (!initialized) begin
      // One time initialization.
      initialized <= 1'b1;
      LED <= 1'b1;
      counter <= 0;
    end else if (counter >= (DIV - 1)) begin
      // Delay reached, flip LED and and reset counter.
      LED <= !LED;
      counter <= 0;
    end else begin
      // Incrementing the delay counter.
      counter <= counter + 1;
    end
  end



endmodule


