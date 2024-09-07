// An example of an automated test. Run 'apio test' to test and
// 'apio sim' to examine the wave signals.

`include "apio_testing.vh"

`timescale 10 ns / 1 ns

// A macro to increment the tested counter by n.
`define INCREMENT(n) \
    begin \
        `CLK \
        count_en = 1; \
        `CLKS(n) \
        count_en = 0; \
        `CLK \
    end

module main_tb ();
  // Declare the 'signal' name that is managed by apio_testings.vh.
  `DEF_CLK;

  // Inputs to the tested module.
  reg reset;
  reg count_en;


  // Outputs of the tested module
  wire [3:0] digit_1;
  wire [3:0] digit_10;
  wire carry;

  // A utility signal that indicates the number of clocks on which
  // the carry output of the tested module was high.
  reg [5:0] carry_count = 0;

  always @(posedge clk) begin
    carry_count <= reset ? 0 : carry ? carry_count + 1 : carry_count;
  end

  // The instance of the tested module.
  main tested (
      .clk(clk),
      .reset(reset),
      .count_en(count_en),
      .digit_1(digit_1),
      .digit_10(digit_10),
      .carry(carry)
  );

  // The test sequence.
  initial begin
    `TEST_BEGIN(main_tb)

    // Reset the tested module.
    count_en = 0;
    reset = 1;
    `CLKS(3)
    reset = 0;
    `EXPECT(digit_10, 0)  // count = 00
    `EXPECT(digit_1, 0)
    `EXPECT(carry_count, 0)
    `CLKS(3);

    // Count to 09.
    `INCREMENT(9)
    `EXPECT(digit_10, 0)
    `EXPECT(digit_1, 9)
    `EXPECT(carry_count, 0)

    // Test transition from 09 to 10,
    `INCREMENT(1)
    `EXPECT(digit_10, 1)  // count = 10
    `EXPECT(digit_1, 0)
    `EXPECT(carry_count, 0)

    // Count to 99
    `INCREMENT(89)
    `EXPECT(digit_10, 9)  // count = 99
    `EXPECT(digit_1, 9)
    `EXPECT(carry_count, 0)

    // Test transition from 99 to 00.
    `INCREMENT(1)
    `EXPECT(digit_10, 0)  // count = 00
    `EXPECT(digit_1, 0)
    `EXPECT(carry_count, 1)

    // Count to 12.
    `INCREMENT(12)
    `EXPECT(digit_10, 1)  // count = 12
    `EXPECT(digit_1, 2)
    `EXPECT(carry_count, 1)

    // All done.
    `CLKS(10)
    `TEST_END
  end

endmodule
