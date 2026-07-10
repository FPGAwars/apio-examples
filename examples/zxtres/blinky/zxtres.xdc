
#-- Placa ZXTRES

#-- Reloj del sistema (50 MHz)
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports {clk}]

#-- LEDs
set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]

#-- Fuente de los pines: zxtres/test_carta_ajuste pines_zxtres.xdc
#-- (pinout comun a ZXTRES / ZXTRES+ / ZXTRES++)
