
module Main #(
    parameter integer N = 3_000_000
) (
    input  CLK,   // 12MHz clock
    output LED1,
    output LED2
);

  reg [31:0] counter = 0;

  reg led = 0;

  assign LED1 = led;
  assign LED2 = !led;

  always @(posedge CLK) begin
    if (counter >= N - 1) begin
      counter <= 0;
      led <= !led;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule


