
#-- Placa Cmod A7-35T

#-- Reloj del sistema (12 MHz)
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports {clk}]

#-- LEDs
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]

#-- Fuente de los pines: Digilent/digilent-xdc Cmod-A7-Master.xdc
