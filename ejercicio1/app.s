.include "constants.s"
.include "shapes.s"
.include "letters.s"

.globl main

main:
  mov x20, x0          // x0 contiene framebuffer

  // Llenar pantalla con degradado
  mov x0, x20          // framebuffer (64 bits)
  ldr w1, =TWILIGHT_PURPLE        // color base (32 bits)
  ldr w2, =SUNSET_PEACH           // ajustar cada 4 filas (32 bits)
  bl fillscreen_gradient_color_to_color

  mov x0, x20
  ldr w1, =SNOW
  mov x2, #0             // X position
  mov x3, #0             // Y position
  mov x4, #640           // Width
  mov x5, #480           // Height
  mov x6, #200          // Densidad de estrellas
  bl drawstars

   // Dibujar sol (círculo relleno)
  mov x0, x20
  ldr w1, =SUNSET_PEACH     // color cálido del sol
  mov x2, #320              // centro x (asumiendo 640x480)
  mov x3, #240              // centro y
  mov x4, #80               // radio x
  mov x5, #80               // radio y
  mov w7, #1                // fill = true
  mov w8, #0                // grosor ignorado
  bl drawellipse

   // Dibujar sol (círculo relleno)
  mov x0, x20
  ldr w1, =SUNGLOW     // color cálido del sol
  mov x2, #320              // centro x (asumiendo 640x480)
  mov x3, #240              // centro y
  mov x4, #75               // radio x
  mov x5, #75               // radio y
  mov w7, #1                // fill = true
  mov w8, #0                // grosor ignorado
  bl drawellipse


  mov x0, x20
  ldr w1, =SEA              // azul muy oscuro, como mar al atardecer
  ldr w2, =SEA_DEEP              // azul muy oscuro, como mar al atardecer
  mov x3, #0             // X position
  mov x4, #260              // Y position
  mov x5, #640             // Width
  mov x6, #220             // Height
  bl drawsquare_gradient

  mov x0, x20
  ldr w1, =BLUEGRAY
  mov x2, #0             // X position
  mov x3, #260             // Y position
  mov x4, #640           // Width
  mov x5, #220           // Height
  mov x6, #200          // Densidad de estrellas
  bl drawstars


  ldr w0, =SUNGLOW
  mov w1, #150
  bl adjust_color_brightness
  mov w1, w0

  // Dibujar reflejo del sol en el mar (elipse ancha y baja)
  mov x0, x20
  mov x2, #320                // centro x (mismo que sol)
  mov x3, #275                // centro y (justo arriba del mar)
  mov x4, #100                // radio x (más ancho)
  mov x5, #20                 // radio y (bajo, aplanado)
  mov w7, #1                  // fill = true
  mov w8, #0                  // grosor ignorado
  bl drawellipse

  mov x0, x20                // destino
  ldr w1, =SNOW         // color ARGB

  // Letra 'O'
  mov x2, #150               // x
  mov x3, #50                // y
  ldr x4, =O_font
  mov x5, #4
  bl drawchar_direct

  // Letra 'D'
  mov x2, #200               // x + 10
  ldr x4, =D_font
  bl drawchar_direct

  // Letra 'C'
  mov x2, #250               // x + 20
  ldr x4, =C_font
  bl drawchar_direct

  // Número '2'
  mov x2, #300               // x + 40
  ldr x4, =Two_font
  bl drawchar_direct

  // Número '0'
  mov x2, #350               // x + 50
  ldr x4, =Zero_font
  bl drawchar_direct

  // Número '2'
  mov x2, #400               // x + 60
  ldr x4, =Two2_font         // o reutilizar Two_font
  bl drawchar_direct

  // Número '5'
  mov x2, #450               // x + 70
  ldr x4, =Five_font
  bl drawchar_direct

  // Setear GPIOs como entrada
  ldr x9, =GPIO_BASE
  str wzr, [x9, GPIO_GPFSEL0]

  // Leer GPIO 2
  ldr w10, [x9, GPIO_GPLEV0]
  and w11, w10, 0b100
  lsr w11, w11, 2  // w11 = 0 o 1 dependiendo del estado de GPIO 2

InfLoop:
  b InfLoop
