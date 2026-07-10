
#-- Placa Colorlight i9+

#-- Reloj del sistema (25 MHz)
set_property -dict { PACKAGE_PIN K4    IOSTANDARD LVCMOS33 } [get_ports {clk}]

#-- LEDs
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports {led}]

#-- Fuente de los pines: wuxx/Colorlight-FPGA-Projects (i9plus v6.1, blinky.xdc oficial)
