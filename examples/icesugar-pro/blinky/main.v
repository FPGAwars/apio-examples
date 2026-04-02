//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module main (
    input  CLK,  // 25MHz clock
    output led   // LED to blink
);

  reg [22:0] counter = 0;

  always @(posedge CLK) counter <= counter + 1;

  assign led = counter[22];

endmodule
