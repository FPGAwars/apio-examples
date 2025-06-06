
module Main #(
    parameter integer N = 3_000_000
) (
    input        CLK,   // 12MHz clock
    output [7:0] ROWS,  // LED rows
    output [3:0] COLS   // LED columns
);

  reg [31:0] counter = 0;

  reg toggle = 0;

  // Rows and columns are active low.
  assign ROWS = {6'b111111, toggle, ~toggle};
  assign COLS = 4'b1110;

  always @(posedge CLK) begin
    if (counter >= N - 1) begin
      counter <= 0;
      toggle  <= !toggle;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule


