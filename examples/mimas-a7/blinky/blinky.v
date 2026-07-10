`default_nettype none

//-- Blinking led (100 MHz clock -> ~1 Hz on LED0)
module main (
    input clk,
    output wire [7:0] leds
);

    //-- Contador de 27 bits
    reg [26:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Mostrar en el LED0 el bit de mayor peso del contador
    assign leds[0] = counter[26];

    assign leds[7:1] = 0;

    //-- This is for simulation
    //-- the counter should start in 0
    initial begin
        counter = 0;
    end

endmodule
