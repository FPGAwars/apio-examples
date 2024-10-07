//------------------------------------------------------------------
//-- Blinking FPGA LED5 (Red)
//------------------------------------------------------------------

module top(
    input clk_60mhz,    //-- 60Mhz clock
    output [5:0] led    //-- FPGA LEDs
);

    //-- Turn off all the LEDs except LED0
    //-- (note that Cynthion LED logic is inverted: 0=on, 1=off)
    assign led[4:0] = 5'b11111;

    //-- 24 bits counter
    reg [23:0] counter = 0;

    always @(posedge clk_60mhz)
        counter <= counter + 1;

    //-- The most significant bit of the counter
    //-- is displayed on LED5 (Red)
    assign led[5] = counter[23];

endmodule
