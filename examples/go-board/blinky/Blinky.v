//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module Test (
    input  CLK,   // 25MHz clock
    output LED1,  //-- LED to Blink
    //-- The other LEDs
    output LED2,
    output LED3,
    output LED4  
);

  reg [23:0] counter = 0;

  always @(posedge CLK) counter <= counter + 1;

  assign LED1 = counter[23];

  //-- Turn off the other LEDs
  assign {LED2, LED3, LED4} = 3'b0;

endmodule

