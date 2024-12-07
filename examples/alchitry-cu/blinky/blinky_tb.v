
// Testbench template

`default_nettype none `timescale 10 ns / 1 ns


module blinky_tb;

  // Input.
  reg clk = 0;

  // Output
  wire [7:0] led;

  // Module instance
  blinky #(
      .DELAY(5)
  ) dut (
      .clk(clk),
      .led(led)
  );

  initial begin
    // Dump vars to the output .vcd file
    $dumpvars(0, blinky_tb);

    repeat(50) begin
      #10 clk = ~clk;
    end

    $display("End of simulation");
    $finish;
  end

endmodule
