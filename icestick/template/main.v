//------------------------------------------------------------------
//-- Verilog template
//-- Top entity
//-- Board: icestick
//------------------------------------------------------------------
`default_nettype none

//-- Template for the top entity
module top(output wire D1);

//-- Turn on the D1 (red led) on the icestick
assign D1 = 1'b1;

endmodule
