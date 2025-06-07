
module led_matrix #(
    parameter integer N = 50_000
) (
    input             clk,                 // 12MHz clock
    input      [31:0] data,                // 4x32 LEDs data, '1' is on
    output reg        frame_tick = 0,      // High for one clock per frame
    output reg [ 7:0] rows = 8'b11111111,  // LED rows, active low
    output reg [ 3:0] cols = 4'b1111       // LED columns, active low
);

  // Timer for column time.
  reg [31:0] timer = 0;

  // The current displayed col.
  reg [1:0] col = 0;

  // Tick on each column start.
  reg col_tick = 0;

  // Column and frame timing generator.
  always @(posedge clk) begin
    if (timer >= N - 1) begin
      col_tick <= 1;
      timer <= 0;
      if (col == 3) begin
        frame_tick <= 1;
      end
      col <= col + 1;
    end else begin
      frame_tick <= 0;
      col_tick <= 0;
      timer <= timer + 1;
    end
  end

  // Selecting the current column's 8 LEDs data. We use
  // the data directly without sampling it every frame.
  wire [31:0] shifted_data = data << (col * 8);

  // Update LEDs on each column tick.
  always @(posedge clk) begin
    if (col_tick) begin
      cols <= ~(4'b0001 << col);  // Active low
      rows <= ~(shifted_data[31:24]);  // Active low
    end
  end

endmodule


