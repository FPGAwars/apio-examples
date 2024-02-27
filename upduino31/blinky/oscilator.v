// Instanciates the internal high speed oscilator. This is needed
// only if the external Upduino oscilator is not connected to the FPGA.

module oscilator (
    output clk
);

  SB_HFOSC interal_osc (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF  (clk)
  );

endmodule
