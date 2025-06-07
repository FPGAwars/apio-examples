`timescale 1ns / 1ps

module led_matrix_tb;

  reg         clk = 0;
  reg  [31:0] data;
  wire [ 7:0] rows;
  wire [ 3:0] cols;
  wire        frame_tick;

  // Instantiate the module under test
  led_matrix #(
      .N(5)
  ) led_matrix (
      .clk(clk),
      .data(data),
      .intensity(15),
      .frame_tick(frame_tick),
      .rows(rows),
      .cols(cols)
  );

  // Clock generation: 12MHz => 83.33ns period
  always #42 clk = ~clk;

  initial begin
    // Enable waveform dumping
    $dumpvars(0, led_matrix_tb);

    // Initialize input
    data = 32'h3F_9A_7C_21;  // Example LED pattern

    // Run simulation for some time
    #4000;

    $display("End of simulation");
    $finish;
  end

endmodule
