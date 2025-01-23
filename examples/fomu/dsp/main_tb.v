
`include "apio_testing.vh"

`timescale 10 ns / 1 ns


module main_tb ();

  `DEF_CLK

  // Inputs
  wire user_1 = ^clk_num;

  // Outputs
  wire user_2;


  main tested (
      .clki(clk),
      .user_1(user_1),
      .user_2(user_2),
      .usb_dp(),
      .usb_dn(),
      .usb_dp_pu()
  );



  // The test sequence.
  initial begin
    `TEST_BEGIN(main_tb)

    `CLKS(200)

    `TEST_END
  end

endmodule
