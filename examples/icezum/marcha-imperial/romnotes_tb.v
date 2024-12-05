//-------------------------------------------------------------------
//-- romnotes_tb.v
//-- Banco de pruebas para el reproductor de melodias
//-------------------------------------------------------------------
//-- BQ October 2015. Written by Juan Gonzalez (Obijuan)
//-------------------------------------------------------------------
//-- GPL License
//-------------------------------------------------------------------

`define DUMP_FILE_NAME(x) `"x.vcd`"

module romnotes_tb();

//-- Registro para generar la señal de reloj
reg clk = 0;

//-- Salidas de los canales
wire ch_out;


//-- Instanciar el componente y establecer el valor del divisor
//-- Se pone un valor bajo para simular (de lo contrario tardaria mucho)
romnotes #(.DUR(2))
  dut(
    .clk(clk),
    .ch_out(ch_out)
  );

//-- Generador de reloj. Periodo 2 unidades
always 
  # 1 clk <= ~clk;


//-- Proceso al inicio
initial begin

  //-- Dump vars to the .vcd output file
  $dumpvars(0, romnotes_tb);

  # 200 $display("FIN de la simulacion");
  $finish;
end

endmodule

