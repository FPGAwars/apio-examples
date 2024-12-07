// Instanciates the internal high speed oscilator. This is needed
// only if the external Upduino oscilator is not connected to the FPGA.

module oscilator (
    output clk
);

  SB_HFOSC interal_osc (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF  (clk),

      // Unused
      .TRIM0(),
      .TRIM1(),
      .TRIM2(),
      .TRIM3(),
      .TRIM4(),
      .TRIM5(),
      .TRIM6(),
      .TRIM7(),
      .TRIM8(),
      .TRIM9()
  );

endmodule
