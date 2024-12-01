//------------------------------------------------------------------
//-- Verilog template
//-- Top entity
//-- Board: icoboard
//------------------------------------------------------------------
`default_nettype none

//-- Template for the top entity
module top(output wire LED1);

//-- Turn on the LED1 (green led) on the icoboard
assign LED1 = 1'b1;

endmodule
