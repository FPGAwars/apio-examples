// Utilities for testbenches that are compatible with apio.

// Clock signal.
logic clk;

// Clock signals counter. Helps with diagnostics.
integer clk_num = 0;

// Generates a continuous clock, and clock num.
initial begin
  clk = 0;
  forever begin
    #10 clk = ~clk;
    if (clk) clk_num += 1;
  end
end

// Assertion that signal == value. Continues if running 'apio sim', aborts if running
// 'apio test'. 
`define CHECK_EQ(signal, expected) \
    _check_eq(signal, expected, `__FILE__, `__LINE__)


// Helper task. Do not call directly, use `CHECK_EQ() instead.
task automatic _check_eq(input logic signal, input logic expected, input string file, input int line);
  if (signal != expected) begin
    $display("*** Check failed @%s/%1d (clk_num=%0d): expected: 'h%1h (%1d), actual: 'h%1h (%1d)",
             (file), line, clk_num, expected, expected, signal, signal);
    if (!`APIO_SIM) $fatal;
  end
endtask


// Wait for clk low to high transition.
task automatic clk_high;
  _check_eq(clk, 0, `__FILE__, `__LINE__);
  @(posedge clk);
  // A short delay post the transition to avoid ambiguity.
  #2;
  _check_eq(clk, 1, `__FILE__, `__LINE__);
endtask


// Wait for clk high to low transition.
task automatic clk_low;
  _check_eq(clk, 1, `__FILE__, `__LINE__);
  @(negedge clk);
  // A short delay post the transition to avoid ambiguity.
  #2;
  _check_eq(clk, 0, `__FILE__, `__LINE__);
endtask


// Wait one clock.
task automatic clk1;
  clk_high();
  clk_low();
endtask

// Wait N clocks.
task automatic clks(input integer n);
  repeat (n) clk1();
endtask


