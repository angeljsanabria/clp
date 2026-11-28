/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 *
 * ------------------------------------------------
 * | AXI GPIO - read y writes                        |
 * ------------------------------------------------
 *   Buscar "AXI_GPIO_READ_FREC_AND_DUTY" para encontrar la definicion del registro y el ID
 *   Buscar "XPAR_AXI_GPIO_WRITE_DUTY_AND_RESET_DEVICE_ID"
 *   XPAR_AXI_GPIO_READ_FREC_AND_DUTY_DEVICE_ID 0
 *   XPAR_AXI_GPIO_WRITE_DUTY_AND_RESET_DEVICE_ID 1
 *   XPAR_AXI_GPIO_READ_FREC_AND_DUTY_BASEADDR 0x41200000
 *
 *   Dejar abierto:
 *    design_block_base_wrapper_hw_platform_2
 *    standalone_bsp_2
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xbasic_types.h"
#include "xgpio.h"
#include "xparameters.h"
#include "sleep.h"
#include "xuartps_hw.h"

// Mascaras AXI GPIO Lectura de Frec y Duty
#define IP_MASK_READ_DUTY_1			0x000F
#define IP_SHIFT_READ_DUTY_1		0
#define IP_MASK_READ_DUTY_10		0x00F0
#define IP_SHIFT_READ_DUTY_10		4
#define IP_MASK_READ_FREC			0x0300
#define IP_SHIFT_READ_FREC			8

// Caracteres de comandos
#define CMD_DUTY_MENOS_1			'A'
#define CMD_DUTY_MENOS_1m			'a'
#define AXI_GPIO_BIT_DUTY_MENOS_1	0x08
#define CMD_DUTY_MAS_1				'S'
#define CMD_DUTY_MAS_1m				's'
#define AXI_GPIO_BIT_DUTY_MAS_1		0x04
#define CMD_DUTY_MENOS_10			'Q'
#define CMD_DUTY_MENOS_10m			'q'
#define AXI_GPIO_BIT_DUTY_MENOS_10 	0x02
#define CMD_DUTY_MAS_10				'W'
#define CMD_DUTY_MAS_10m			'w'
#define AXI_GPIO_BIT_DUTY_MAS_10	0x01
#define CMD_DUTY_RESET				'R'
#define CMD_DUTY_RESETm				'r'
#define AXI_GPIO_BIT_DUTY_RESET		0x10


// CMDs para terminal serial
#define TERM_CLEAR  	"\x1B[2J\x1B[H"
#define TERM_SEPARADOR  "#########################\r\n"

// Variables globales
Xuint32 duty = 0;
Xuint8 frec = 0;

void print_info_pwm(void) {

	xil_printf(TERM_CLEAR);
	xil_printf(TERM_SEPARADOR);

	if(frec == 0) {
		xil_printf("Frecuencia Base = 1 kHZ\r\n");
	} else if(frec == 1) {
		xil_printf("Frecuencia Base = 10 kHZ\r\n");
	} else if(frec == 2) {
		xil_printf("Frecuencia Base = 100 kHZ\r\n");
	} else if(frec == 3) {
		xil_printf("Frecuencia Base = 1 MHZ\r\n");
	} else {
		xil_printf("Frecuencia Base NO DEFINIDA\r\n");
	}

	xil_printf("Duty = %lu\r\n", duty);
	xil_printf(TERM_SEPARADOR);
}


int main()
{
	// Control AXI de Lectura de Frecuencia y Duty
	XGpio readFD;
	Xuint32 frec_and_duty;
	Xuint32 frec_and_duty_bck = 0;

	// Mostrar frecuencia y Duty
	Xuint8 aux, duty_10, duty_1;

	// Control AXI para escritura de duty y reset
	char c;

	// Control AXI de Escritura de Duty y Reset
	XGpio writeDR;

	// Inicializo con el _DEVICE_ID
	XGpio_Initialize(&readFD, XPAR_AXI_GPIO_READ_FREC_AND_DUTY_DEVICE_ID);
	XGpio_Initialize(&writeDR, XPAR_AXI_GPIO_WRITE_DUTY_AND_RESET_DEVICE_ID);

	// Direccion de la data  1 - para mascara de entrada con 0xffffffff
	XGpio_SetDataDirection(&readFD, 1, 0xffffffff);
	XGpio_SetDataDirection(&writeDR, 1, 0x00000000);


    init_platform();

    xil_printf(TERM_CLEAR);
    xil_printf("Inicio APP\r\n");

    while(1){

    	// Lectura de FREQ Y DUTY con AXI-GPIO 1
    	frec_and_duty = XGpio_DiscreteRead(&readFD, 1);
    	if(frec_and_duty_bck != frec_and_duty){
    		frec_and_duty_bck = frec_and_duty;
    		aux = ((frec_and_duty & IP_MASK_READ_DUTY_1)>>IP_SHIFT_READ_DUTY_1);
    		duty_1 = (Xuint8)aux;

    		aux = ((frec_and_duty & IP_MASK_READ_DUTY_10)>>IP_SHIFT_READ_DUTY_10);
    		duty_10 = (Xuint8)aux;

    		aux = ((frec_and_duty & IP_MASK_READ_FREC)>>IP_SHIFT_READ_FREC);

    		frec = (Xuint8)aux;
    		duty = duty_1 + (duty_10*10);
    		print_info_pwm();

    	}

    	// Check si recibi algo:
    	if (XUartPs_IsReceiveData(STDIN_BASEADDRESS)) {
    		print_info_pwm();
    	    c = (char)XUartPs_ReadReg(STDIN_BASEADDRESS, XUARTPS_FIFO_OFFSET);
    	    //xil_printf("RX: %c\r\n", c);

    	    if((c == CMD_DUTY_MENOS_10) || (c == CMD_DUTY_MENOS_10m)) {
    	    	XGpio_DiscreteWrite(&writeDR, 1, AXI_GPIO_BIT_DUTY_MENOS_10);
    	    } else if((c == CMD_DUTY_MENOS_1) || (c == CMD_DUTY_MENOS_1m)) {
    	    	XGpio_DiscreteWrite(&writeDR, 1, AXI_GPIO_BIT_DUTY_MENOS_1);
    	    } else if((c == CMD_DUTY_MAS_10) || (c == CMD_DUTY_MAS_10m)) {
    	    	XGpio_DiscreteWrite(&writeDR, 1, AXI_GPIO_BIT_DUTY_MAS_10);
    	    } else if((c == CMD_DUTY_MAS_1) || (c == CMD_DUTY_MAS_1m)) {
				XGpio_DiscreteWrite(&writeDR, 1, AXI_GPIO_BIT_DUTY_MAS_1);
    	    } else if((c == CMD_DUTY_RESET) || (c == CMD_DUTY_RESETm)) {
    	    	XGpio_DiscreteWrite(&writeDR, 1, AXI_GPIO_BIT_DUTY_RESET);
    	    }

    	    usleep(100*1000);	// 50 ms
    	    XGpio_DiscreteWrite(&writeDR, 1, 0);	// Todos los bits en off
    	}

    	//sleep(1);
    }

    cleanup_platform();
    return 0;
}
