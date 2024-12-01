//------------------------------------------------------------------
//-- Hello world example for the iceWerx board
//-- Turn on the Red LED
//------------------------------------------------------------------
module leds(output wire LEDR
           );
 
  //-- Red LED on
  //-- Inverse logic: 0: ON, 1: OFF
  assign LEDR = 1'b0;
  
endmodule

