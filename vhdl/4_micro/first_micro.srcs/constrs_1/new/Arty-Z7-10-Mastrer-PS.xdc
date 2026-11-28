# Inputs usadas:
## Switch: selectores de frecuencia
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33 } [get_ports { sw_frec_pe_0[0] }]; #IO_L7N_T1_AD2N_35 Sch=SW0
set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports { sw_frec_pe_0[1] }]; #IO_L7P_T1_AD2P_35 Sch=SW1

## Botones: subir, bajar; reset clock (reset duty solo desde PS; sin puerto fisico)
set_property -dict { PACKAGE_PIN D19    IOSTANDARD LVCMOS33 } [get_ports { btn_subir_pe_0 }]; #IO_L4P_T0_35 Sch=BTN0
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports { btn_bajar_pe_0 }]; #IO_L4N_T0_35 Sch=BTN1
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { btn_reset_pe_0 }]; # sin puerto en wrapper
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { btn_reset_clk_pe }]; #IO_L17N_T2_34 Sch=JA1_N (Pin 2)
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { btn_reset_clk_pe_0  }]; #IO_L5P_T0_34            Sch=CK_IO0
set_property -dict { PACKAGE_PIN L20    IOSTANDARD LVCMOS33 } [get_ports { btn_subir_1_pe_0 }]; #IO_L9N_T1_DQS_AD3N_35 Sch=BTN2
set_property -dict { PACKAGE_PIN L19    IOSTANDARD LVCMOS33 } [get_ports { btn_bajar_1_pe_0 }]; #IO_L9P_T1_DQS_AD3P_35 Sch=BTN3

# Outpus usados:
## Leds RGBs: uno para indicar la frecuencia y el otro para cuando se presiona un boton de control de duty
set_property -dict { PACKAGE_PIN L15    IOSTANDARD LVCMOS33 } [get_ports { leds_rgb_pe_o_0[0] }]; #IO_L22N_T3_AD7P_35 Sch=LED4_B
set_property -dict { PACKAGE_PIN G17    IOSTANDARD LVCMOS33 } [get_ports { leds_rgb_pe_o_0[1] }]; #IO_L16P_T2_35 Sch=LED4_G
set_property -dict { PACKAGE_PIN N15    IOSTANDARD LVCMOS33 } [get_ports { leds_rgb_pe_o_0[2] }]; #IO_L21P_T3_DQS_AD14P_35 Sch=LED4_R
set_property -dict { PACKAGE_PIN G14    IOSTANDARD LVCMOS33 } [get_ports { led_bajar_pe_o_0 }]; #IO_0_35 Sch=LED5_B
set_property -dict { PACKAGE_PIN L14    IOSTANDARD LVCMOS33 } [get_ports { led_subir_pe_o_0 }]; #IO_L22P_T3_AD7P_35 Sch=LED5_G
set_property -dict { PACKAGE_PIN M15    IOSTANDARD LVCMOS33 } [get_ports { led_reset_pe_o_0 }]; #IO_L23N_T3_35 Sch=LED5_R
## Leds: usados para representar en binario porcentaje de duty de salida 0 a 10.
set_property -dict { PACKAGE_PIN R14    IOSTANDARD LVCMOS33 } [get_ports { leds_duty_pe_o_0[0] }]; #IO_L6N_T0_VREF_34 Sch=LED0
set_property -dict { PACKAGE_PIN P14    IOSTANDARD LVCMOS33 } [get_ports { leds_duty_pe_o_0[1] }]; #IO_L6P_T0_34 Sch=LED1
set_property -dict { PACKAGE_PIN N16    IOSTANDARD LVCMOS33 } [get_ports { leds_duty_pe_o_0[2] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=LED2
set_property -dict { PACKAGE_PIN M14    IOSTANDARD LVCMOS33 } [get_ports { leds_duty_pe_o_0[3] }]; #IO_L23P_T3_35 Sch=LED3
## PWM: Salida de PWM en pin.
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { pwm_pe_o_0 }]; #IO_L8P_T1_34 Sch=JB1_P (Pin 1)
# Clock
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { clk_in_pe_0 }]; #IO_L13P_T2_MRCC_35 Sch=SYSCLK
