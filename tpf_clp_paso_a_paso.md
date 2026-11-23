# Paso a paso de que hice

## Desde el Vivado del proyecto original en VHDL
- Modifique el codigo para tener una señal de 32 bits para leer desde AXI-GPIO
- No hace falta la sintesis, ni la implementacion
- Hacer el proceso de Generar la IP y Empaquetar
- En el empaquetado, no olvidar seleccionar 


## Desde el Vivado del nuevo proyecto basado en Block Desing
- Hacer el proceso de agregado de ZYNQ
- Habilitar el Master para AXI GPIO
- Agregar una IP AXI-GPIO
- Cambiarlo a input con 32 bits; 
- Agregar my_ip.
- Conectar a mano el ps_... al AXI-GPIO que corresponde
- Click derecho en my_ip y "Make External"
- En la pestaña File hacer Save Block Design
- Cerrar todo lo abierto porque por ahi no se actualiza bien


### Paso de generar productos y hacer el Wrapper actualizado
- Como es copy-paste del otro, esta desactualizado el wrapper
- Click derecho en .bd del block desing, y "Generate Outputs Products.
- Click en el .bd y "Create HDL Wrapper.
- Solo actualizar el anterior
- Revisar que haya quedado como "Top" el wrapper.
- Revisar con doble click que tenga todas las cosas nuevas

### Uso de constraints del proyecto VHDL original
- Copiar las restricciones, y hacer la modificacion con los nombres que genero el import del IP.
- Me agrego _0 a todo.
- Add de nuevo archivo en Constraints.

### Cierre de Vivado 
- Validar diseño: Click en el icono de Validate Design.
- Generar Bitstream: Desde el flow Navigator; Generate Bitstream
- Desde la pestaña File. Export y Export Hardware - Tildar que incluya el bitstream.
- Abrir el SDK.
- Revisar que este actualizado con lo nuevo


## En el SDK
- Cerrar todo lo que este abierto
- Abrir solo abierto solo el que hace referencia al wrapper creado en Vivado
- File; New; Board Support package, y elegir lo del proyecto anterior
- Despues File; New, App; y crear una hello world asociada al BSP creado anteriormente
- Con el codigo listo ir a:
- Xilinx Tools -> Program FPGA
- Run As ► Launch on Hardware (GDB) para descargar la aplicación
