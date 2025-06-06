.include "constants.s"
.include "shapes.s"

.globl main

main:
  mov x20, x0          // x0 contiene framebuffer
  mov x19, #0          // contador de fotogramas

  ldr w12, =TWILIGHT_PURPLE        // color base (32 bits)
  ldr w13, =SUNSET_PEACH           // color de ajuste (32 bits)
  mov x14, #240                    // posicion inicial del sol
  ldr w15, =SEA                    // color inicial del mar (32 bits)
  ldr w16, =SEA_DEEP               // color de ajuste del mar (32 bits)
  ldr w17, =SUNREFLECTION          // color del reflejo del sol (32 bits)
  mov x18, #20                     // altura del sol (radio y)
  ldr w22, =BLUEGRAY              // color del agua en movimiento (32 bits)
  ldr w23, =RED_ALERT              // color de la bandera (32 bits)
  ldr w24, =WOOD_BROWN             // color del barco (32 bits)
  mov x25, #200                   // posición inicial del barco
  ldr w26, =SEA_DARK              // sombra del barco

animloop:
  mov x1, x20
  mov x2, x20
  bl render

  // Llenar pantalla con degradado
  mov x0, x20
  mov w1, w12
  mov w2, w13
  bl fillscreen_gradient_color_to_color

  // Dibujar sol (dos círculos concéntricos para efecto)
  mov x0, x20
  ldr w1, =SUNSET_PEACH
  mov x2, #320
  mov x3, x14
  mov x4, #80
  mov x5, #80
  mov w7, #1
  mov w8, #0
  bl drawellipse

  mov x0, x20
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, x14
  mov x4, #75
  mov x5, #75
  mov w7, #1
  mov w8, #0
  bl drawellipse

  // Mar con degradado
  mov x0, x20
  mov w1, w15
  mov w2, w16
  mov x3, #0
  mov x4, #260
  mov x5, #640
  mov x6, #220
  bl drawsquare_gradient

  // movimiento del agua
  mov x0, x20
  mov w1, w22
  mov x2, #0
  mov x3, #260
  mov x4, #640
  mov x5, #220
  mov x6, #1000
  bl drawstars

  // Reflejo del sol
  mov x0, x20
  mov w1, w17
  mov x2, #320
  mov x3, #275
  mov x4, #100
  mov x5, x18
  mov w7, #1
  mov w8, #0
  bl drawellipse

  mov x0, x20
  mov w1, w23
  mov w2, w24
  mov x3, x25
  mov x4, #250
  mov w5, w26
  bl drawship

  // Texto "ODC2025"
  mov x0, x20
  ldr w1, =SNOW

  mov x2, #220
  mov x3, #50
  bl draw_odc2025

  // Atenuar colores
  mov w0, w12
  mov w1, #126
  bl adjust_color_brightness
  mov w12, w0

  mov w0, w13
  mov w1, #126
  bl adjust_color_brightness
  mov w13, w0

  mov w0, w15
  mov w1, #126
  bl adjust_color_brightness
  mov w15, w0

  mov w0, w16
  mov w1, #126
  bl adjust_color_brightness
  mov w16, w0

  mov w0, w17
  mov w1, #126
  bl adjust_color_brightness
  mov w17, w0

  mov w0, w22
  mov w1, #126
  bl adjust_color_brightness
  mov w22, w0

  mov w0, w23
  mov w1, #126
  bl adjust_color_brightness
  mov w23, w0

  mov w0, w24
  mov w1, #126
  bl adjust_color_brightness
  mov w24, w0

  mov w0, w26
  mov w1, #126
  bl adjust_color_brightness
  mov w26, w0

  // Mover el sol hacia abajo
  add x14, x14, #1

  // Mover el barco hacia la derecha
  add x25, x25, #1

  // Reducir altura del sol cada 4 frames
  and x3, x19, #3      // x3 = x19 % 4
  cbnz x3, skip_sun_height
  sub x18, x18, #1
skip_sun_height:

   // Incrementar contador de frames
  add x19, x19, #1

  // Pequeño delay entre frames
  mov x0, #10
  bl delay

  // Repetir animación hasta 100 frames
  cmp x19, #120
  b.lt animloop

  b outroanim


outroanim:
  mov x19, #0          // Reiniciar contador de frames
  mov x12, #0          // Tamaño del radio del circulo
  mov x13, #50         // Posicion de las letras
  mov x14, #0          // Posición de "LegV8" cayendo

animloop_outro:
  mov x1, x20
  mov x2, x20
  bl render

  mov x0, x20
  ldr w1, =BLACK
  bl fillscreen

  mov x0, x20
  ldr w1, =SNOW

  mov x2, #220
  mov x3, x13
  bl draw_odc2025

  mov x0, #5
  bl delay

  add x13, x13, #1
  cmp x13, #240
  b.lt animloop_outro

  b circle_growing

circle_growing:
  mov x1, x20
  mov x2, x20
  bl render

  mov x0, x20
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, #240
  mov x4, x12
  mov x5, x12
  mov w7, #1
  mov w8, #0
  bl drawellipse

  mov x0, x20
  ldr w1, =SNOW

  mov x2, #220
  mov x3, x13
  bl draw_odc2025

  mov x0, #0
  bl delay

  add x12, x12, #1
  cmp x12, #410
  b.lt circle_growing

  b legv8_falling

legv8_falling:
  mov x1, x20
  mov x2, x20
  bl render

  // Dibujar el círculo lleno
  mov x0, x20
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, #240
  mov x4, x12
  mov x5, x12
  mov w7, #1
  mov w8, #0
  bl drawellipse

  // Dibuja "ODC 2025"
  mov x0, x20
  ldr w1, =SNOW

  mov x2, #220
  mov x3, x13
  bl draw_odc2025

  // Dibuja "LegV8" cayendo
  mov x2, #180
  mov x3, x14
  bl draw_legv8

  mov x0, #2
  bl delay

  // Hacer que "LegV8" caiga hasta una altura fija
  sub x15, x13, #40
  cmp x14, x15
  b.ge endanim
  add x14, x14, #1    // velocidad de caída
  b legv8_falling

endanim:
  // Setear GPIOs como entrada
  ldr x9, =GPIO_BASE
  str wzr, [x9, GPIO_GPFSEL0]

  // Leer GPIO 2
  ldr w10, [x9, GPIO_GPLEV0]
  and w11, w10, 0b100
  lsr w11, w11, 2  // w11 = 0 o 1 dependiendo del estado de GPIO 2

InfLoop:
  b InfLoop
