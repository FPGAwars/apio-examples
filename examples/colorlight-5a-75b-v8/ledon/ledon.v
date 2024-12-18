//--------------------------------------
//-- Turning on the LED
//--------------------------------------

module ledon (
    output led  //-- LED
);

  // -- The LED on the ColorLight-5A-75E works
  // -- with inverse logic:
  // -- 0: Turn on the LED 
  // -- 1: Turn off the LED

  // Turn on the led
  // (output the bit 0 to the led)
  assign led = 1'b0;

endmodule

