`default_nettype none

//-- Blinking led (50 MHz clock -> ~0.75 Hz on LED0)
module main (
    input clk,
    output wire [1:0] leds
);

    //-- Contador de 26 bits
    reg [25:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Mostrar en el LED0 el bit de mayor peso del contador
    assign leds[0] = counter[25];

    assign leds[1] = 0;

    //-- This is for simulation
    //-- the counter should start in 0
    initial begin
        counter = 0;
    end

endmodule
