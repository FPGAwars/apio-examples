//--------------------------------------
//-- Blink the LED
//--------------------------------------

module top(
    input clk,      //-- CLK
    output led   //-- LEDs
);
  wire clk_out;  

  prescaler #(
     .N(22)
  ) pre1 (
      .clk_in(clk),
      .clk_out(clk_out)
  );  

   // assign led to clk output 
  assign led = clk_out;

endmodule



module prescaler #(
  parameter N = 22   //-- Number of bits of the prescaler
) (
   input clk_in,
   output clk_out
);
    //-- divisor register
    reg [N-1:0] divcounter;
 
    //-- N bit counter
    always @(posedge clk_in)
          divcounter <= divcounter + 1;
 
     //-- Use the most significant bit as output
     assign clk_out = divcounter[N-1];

endmodule 