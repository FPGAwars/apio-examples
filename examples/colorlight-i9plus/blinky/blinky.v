`default_nettype none

//-- Blinking led (25 MHz clock -> ~0.75 Hz)
module main (
    input clk,
    output wire led
);

    //-- Contador de 25 bits
    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Mostrar en el LED el bit de mayor peso del contador
    assign led = counter[24];

    //-- This is for simulation
    //-- the counter should start in 0
    initial begin
        counter = 0;
    end

endmodule
