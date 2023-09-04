
ALLOW_COMBINATORIAL_LOOPS TRUE[get_nets CPU/dx_stage/instr_reg/loop1[0].dff/q_reg_1]

//Motor PWM
set_property PACKAGE_PIN D17 [get_ports motorPWM]
set_property IOSTANDARD LVCMOS33 [get_ports motorPWM]

// Buttons
set_property IOSTANDARD LVCMOS33 [get_ports buttonInputs]
set_property PACKAGE_PIN F16 [get_ports buttonInputs[0]]
set_property PACKAGE_PIN C17 [get_ports buttonInputs[1]]
set_property PACKAGE_PIN G17 [get_ports buttonInputs[2]]
set_property PACKAGE_PIN G16 [get_ports buttonInputs[3]]
set_property PACKAGE_PIN E18 [get_ports buttonInputs[4]]
set_property PACKAGE_PIN E17 [get_ports buttonInputs[5]]
set_property PACKAGE_PIN D14 [get_ports buttonInputs[6]]
set_property PACKAGE_PIN H14 [get_ports buttonInputs[7]]
set_property PACKAGE_PIN D18 [get_ports buttonInputs[8]]

// Clock on E3
set_property PACKAGE_PIN E3 [get_ports {clock}]
set_property IOSTANDARD LVCMOS33 [get_ports {clock}]

// Reset Signal
set_property PACKAGE_PIN M18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

// light
#set_property PACKAGE_PIN H17 [get_ports lights[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports lights[0]]
#set_property PACKAGE_PIN K15 [get_ports lights[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports lights[1]]
#set_property PACKAGE_PIN J13 [get_ports lights[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports lights[2]]

// VGA Port
set_property PACKAGE_PIN D8 [get_ports {VGA_B[3]}]
set_property PACKAGE_PIN D7 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN C7 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN B7 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN A6 [get_ports {VGA_G[3]}]
set_property PACKAGE_PIN B6 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN A5 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN C6 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN A4 [get_ports {VGA_R[3]}]
set_property PACKAGE_PIN C5 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN B4 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN A3 [get_ports {VGA_R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[0]}]

## Register 1 Ports
set_property IOSTANDARD LVCMOS33 [get_ports lights]
set_property PACKAGE_PIN H17 [get_ports lights[0]]
set_property PACKAGE_PIN K15 [get_ports lights[1]]
set_property PACKAGE_PIN J13 [get_ports lights[2]]
set_property PACKAGE_PIN N14 [get_ports lights[3]]
set_property PACKAGE_PIN R18 [get_ports lights[4]]
set_property PACKAGE_PIN V17 [get_ports lights[5]]
set_property PACKAGE_PIN U17 [get_ports lights[6]]
set_property PACKAGE_PIN U16 [get_ports lights[7]]
set_property PACKAGE_PIN V16 [get_ports lights[8]]
set_property PACKAGE_PIN T15 [get_ports lights[9]]
set_property PACKAGE_PIN U14 [get_ports lights[10]]
set_property PACKAGE_PIN T16 [get_ports lights[11]]
set_property PACKAGE_PIN V15 [get_ports lights[12]]
#set_property PACKAGE_PIN V14 [get_ports reg1Out[13]]
#set_property PACKAGE_PIN V12 [get_ports reg1Out[14]]
#set_property PACKAGE_PIN V11 [get_ports reg1Out[15]]


// Sync Ports
set_property PACKAGE_PIN B11 [get_ports hSync]
set_property PACKAGE_PIN B12 [get_ports vSync]
set_property IOSTANDARD LVCMOS33 [get_ports hSync]
set_property IOSTANDARD LVCMOS33 [get_ports vSync]

#// Set push buttons
#set_property PACKAGE_PIN P18 [get_ports {BTN[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[0]}]
#set_property PACKAGE_PIN P17 [get_ports {BTN[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[1]}]
#set_property PACKAGE_PIN M18 [get_ports {BTN[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[2]}]
#set_property PACKAGE_PIN M17 [get_ports {BTN[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[3]}]