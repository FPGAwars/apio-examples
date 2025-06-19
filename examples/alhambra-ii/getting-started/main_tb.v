`timescale 1ns / 1ps

module testbench;

  // Clock and DUT signals
  reg CLK = 0;
  wire LED1, LED2;

  // Instantiate DUT with N = 3 for quick testing
  Main #(
      .N(3)
  ) dut (
      .CLK (CLK),
      .LED1(LED1),
      .LED2(LED2)
  );

  // Generate 12 MHz-like clock (approx. 83 ns period)
  always #42 CLK = ~CLK;

  // Expected state tracker
  reg expected_led = 0;

  integer i;

  initial begin
    $dumpvars(0, testbench);

    // Simulate 12 rising edges of CLK
    for (i = 0; i < 12; i = i + 1) begin
      @(posedge CLK);

      // Check LED values before updating expected state
      if (LED1 !== expected_led || LED2 !== ~expected_led) begin
        $display("ERROR at cycle %0d: LED1 = %b, expected = %b", i, LED1, expected_led);
        if (!`APIO_SIM) $fatal(1, "LED state mismatch");
      end

      // Update expected LED every N=3 cycles
      if ((i + 1) % 3 == 0) begin
        expected_led = ~expected_led;
      end
    end

    $finish;
  end

endmodule
