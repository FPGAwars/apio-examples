// An RGB led rotator for the Sipeed Tang Nano 1K board. Adapted from the
// official Sipeed example at
// https://github.com/sipeed/TangNano-1K-examples/tree/main/example_led

module blinky #(
    // Num of clock cycles per led color change. With the board's 27 MHz
    // system clock, the default value changes the color every 0.5 sec.
    parameter integer DIV = (27000000 / 2)
) (
    input            sys_clk,    // 27 MHz system clock.
    input            sys_rst_n,  // Button 'A', active low.
    output reg [2:0] led         // RGB led {g, b, r}, active low. 110 R, 101 B, 011 G.
);

  // ---- Color change timer.

  reg [31:0] counter;

  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      counter <= 0;
    end else if (counter < (DIV - 1)) begin
      counter <= counter + 1;
    end else begin
      counter <= 0;
    end
  end

  // ---- Color rotator.

  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      led <= 3'b110;
    end else if (counter == (DIV - 1)) begin
      led <= {led[1:0], led[2]};
    end
  end

endmodule
