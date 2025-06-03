.include "constants.s"
.include "shapes.s"
.include "letters.s"

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

animloop:
  // Llenar pantalla con degradado
  mov x0, x20
  mov w1, w12
  mov w2, w13
  bl fillscreen_gradient_color_to_color

  mov x0, x20
  ldr w1, =SNOW
  mov x2, #0
  mov x3, #0
  mov x4, #640
  mov x5, #480
  mov x6, #200
  bl drawstars

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

  // Estrellas en el mar (como reflejos)
  mov x0, x20
  ldr w1, =BLUEGRAY
  mov x2, #0
  mov x3, #260
  mov x4, #640
  mov x5, #220
  mov x6, #200
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

  // Texto "ODC2025"
  mov x0, x20
  ldr w1, =SNOW

  mov x2, #150
  mov x3, #50
  ldr x4, =O_font
  mov x5, #4
  bl drawchar_direct

  mov x2, #200
  ldr x4, =D_font
  bl drawchar_direct

  mov x2, #250
  ldr x4, =C_font
  bl drawchar_direct

  mov x2, #300
  ldr x4, =Two_font
  bl drawchar_direct

  mov x2, #350
  ldr x4, =Zero_font
  bl drawchar_direct

  mov x2, #400
  ldr x4, =Two2_font
  bl drawchar_direct

  mov x2, #450
  ldr x4, =Five_font
  bl drawchar_direct

  // Incrementar contador de frames
  add x19, x19, #1

  // Pequeño delay entre frames
  mov x0, #20
  bl delay

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

  // Mover el sol hacia abajo
  add x14, x14, #1

  // Reducir altura del sol cada 4 frames
  and x3, x19, #3      // x3 = x19 % 4
  cbnz x3, skip_sun_height
  sub x18, x18, #1
skip_sun_height:

  // Repetir animación hasta 100 frames
  cmp x19, #100
  b.lt animloop

  b endanim

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
