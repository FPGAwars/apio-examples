
module main #(
    parameter integer N1 = 50_000,
    parameter integer N2 = 6_000_000
) (
    input        CLK,   // 12MHz clock
    output [7:0] ROWS,  // LED rows
    output [3:0] COLS   // LED columns
);

  // Running rand value.
  wire [31:0] rnd;

  // Sampled rand to display
  reg  [31:0] sampled_rnd = 0;

  // wire frame_tick;

  rand_gen rand_gen (
      .clk(CLK),
      .rnd(rnd)
  );

  led_matrix #(
      .N(N1)
  ) led_matrix (
      .clk(CLK),
      .data(sampled_rnd),
      .frame_tick(),
      .rows(ROWS),
      .cols(COLS)
  );

  reg [31:0] timer = 0;


  always @(posedge CLK) begin
    // Increment timer mod N2.
    timer = (timer >= N2 - 1) ? 0 : timer + 1;
    if (timer == 0) begin
      // Get a new rand.
      sampled_rnd <= rnd;
    end
  end

endmodule


