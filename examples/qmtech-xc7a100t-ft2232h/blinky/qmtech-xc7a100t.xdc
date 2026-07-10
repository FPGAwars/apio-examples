
#-- Placa QMTECH XC7A100T core board

#-- Reloj del sistema (50 MHz)
set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports {clk}]

#-- LEDs (activos a nivel bajo)
set_property -dict { PACKAGE_PIN T23   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN R23   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]

#-- Fuente de los pines: ChinaQMTECH XC7A75T-100T-200T Core Board V01 (Test01_led_key)
