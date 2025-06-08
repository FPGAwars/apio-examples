

`default_nettype none `timescale 1ns / 1ps

module main_tb;

  reg clk = 0;
  wire [7:0] rows;
  wire [3:0] cols;

  // Instantiate the DUT (Device Under Test)
  main #(
      .N1(3),        // Small value for fast sim
      .N2(40),       // Small value for fast sim
      .INTENSITY(15) // Max intensity, no pwm
  ) main (
      .CLK (clk),
      .ROWS(rows),
      .COLS(cols)
  );

  // Clock generation: 12MHz → ~83ns period
  always #42 clk = ~clk;

  initial begin
    // Enable waveform capture
    $dumpvars(0, main_tb);

    $display("Starting simulation...");

    // Run for a limited time
    repeat (150) begin
      @(posedge clk);
      // $display("ROWS = %b, COLS = %b", rows, cols);
    end

    $display("End of simulation");
    $finish;
  end

endmodule

