`timescale 1ns / 1ps

module rand_gen_tb;

  reg clk = 0;
  wire [31:0] rnd;

  // Instantiate the module under test
  rand_gen uut (
      .clk(clk),
      .rnd(rnd)
  );

  // Generate clock
  always #5 clk = ~clk;

  initial begin
    // Enable waveform dumping
    $dumpvars(0, rand_gen_tb);

    // Run for several cycles to observe randomness
    repeat (100) begin
      @(posedge clk);
      //   $display("Random: 0x%08X", rnd);
    end

    $display("End of simulation");
    $finish;
  end

endmodule
