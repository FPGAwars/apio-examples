`timescale 1ns / 1ps

module area_test_tb;

  reg clk;
  wire led0, led1, led2, led3, led4, led5, led6, led7;
  wire [7:0] leds;

  assign leds = {led7, led6, led5, led4, led3, led2, led1, led0};

  area_test dut (
      .CLK (clk),
      .LED0(led0),
      .LED1(led1),
      .LED2(led2),
      .LED3(led3),
      .LED4(led4),
      .LED5(led5),
      .LED6(led6),
      .LED7(led7)
  );

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    $dumpvars(0, area_test_tb);

    $display("Start simulation for  area_test");
    $display("Time\tLEDs (hex)\tLEDs (bin)");
    $display("------\t----------\t----------");

    #100;

    repeat (10000) begin
      @(posedge clk);
      if ($time % 2000 == 0) begin
        $display("%6t\t%h\t\t%b", $time, leds, leds);
      end
    end

    $display("\nSimulation end");
    $display("Final state LEDs: %b (hex: %h)", leds, leds);

    $finish;
  end

  initial begin
    $monitor("Time=%0t LEDs=%b", $time, leds);
  end

endmodule
