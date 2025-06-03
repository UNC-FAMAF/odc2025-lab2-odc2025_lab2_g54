.include "constants.s"
.include "shapes.s"
.include "letters.s"

.globl main

main:
  mov x20, x0          // x0 contiene framebuffer
  adr x21, BackFB      // x21 apunta al framebuffer de fondo
  mov x19, #0          // contador de fotogramas

  ldr w12, =TWILIGHT_PURPLE        // color base (32 bits)
  ldr w13, =SUNSET_PEACH           // color de ajuste (32 bits)
  mov x14, #240                    // posicion inicial del sol
  ldr w15, =SEA                    // color inicial del mar (32 bits)
  ldr w16, =SEA_DEEP               // color de ajuste del mar (32 bits)
  ldr w17, =SUNREFLECTION          // color del reflejo del sol (32 bits)
  mov x18, #20                     // altura del sol (radio y)
  ldr w22, =BLUEGRAY              // color del agua en movimiento (32 bits)

animloop:
  mov x1, x21
  mov x2, x20
  bl render

  // Llenar pantalla con degradado
  mov x0, x21
  mov w1, w12
  mov w2, w13
  bl fillscreen_gradient_color_to_color

  // Dibujar sol (dos círculos concéntricos para efecto)
  mov x0, x21
  ldr w1, =SUNSET_PEACH
  mov x2, #320
  mov x3, x14
  mov x4, #80
  mov x5, #80
  mov w7, #1
  mov w8, #0
  bl drawellipse

  mov x0, x21
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, x14
  mov x4, #75
  mov x5, #75
  mov w7, #1
  mov w8, #0
  bl drawellipse

  // Mar con degradado
  mov x0, x21
  mov w1, w15
  mov w2, w16
  mov x3, #0
  mov x4, #260
  mov x5, #640
  mov x6, #220
  bl drawsquare_gradient

  // movimiento del agua
  mov x0, x21
  mov w1, w22
  mov x2, #0
  mov x3, #260
  mov x4, #640
  mov x5, #220
  mov x6, #1000
  bl drawstars

  // Reflejo del sol
  mov x0, x21
  mov w1, w17
  mov x2, #320
  mov x3, #275
  mov x4, #100
  mov x5, x18
  mov w7, #1
  mov w8, #0
  bl drawellipse

  // Texto "ODC2025"
  mov x0, x21
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


  // Mover el sol hacia abajo
  add x14, x14, #1

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
  mov x1, x21
  mov x2, x20
  bl render

  mov x0, x21
  ldr w1, =BLACK
  bl fillscreen

  mov x0, x21
  ldr w1, =SNOW

  mov x2, #150
  mov x3, x13
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

  mov x0, #5
  bl delay

  add x13, x13, #1
  cmp x13, #240
  b.lt animloop_outro

  b circle_growing

circle_growing:
  mov x1, x21
  mov x2, x20
  bl render

  mov x0, x21
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, #240
  mov x4, x12
  mov x5, x12
  mov w7, #1
  mov w8, #0
  bl drawellipse

  mov x0, x21
  ldr w1, =SNOW

  mov x2, #150
  mov x3, x13
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

  mov x0, #0
  bl delay

  add x12, x12, #1
  cmp x12, #410
  b.lt circle_growing

  b legv8_falling

legv8_falling:
  mov x1, x21
  mov x2, x20
  bl render

  // Dibujar el círculo lleno
  mov x0, x21
  ldr w1, =SUNGLOW
  mov x2, #320
  mov x3, #240
  mov x4, x12
  mov x5, x12
  mov w7, #1
  mov w8, #0
  bl drawellipse

  // Dibuja "ODC 2025"
  mov x0, x21
  ldr w1, =SNOW

  mov x2, #150
  mov x3, x13
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

  // Dibuja "LegV8" cayendo
  mov x2, #180
  mov x3, x14
  ldr x4, =L_font
  mov x5, #4
  bl drawchar_direct

  mov x2, #230
  ldr x4, =E_font
  bl drawchar_direct

  mov x2, #280
  ldr x4, =G_font
  bl drawchar_direct

  mov x2, #330
  ldr x4, =V_font
  bl drawchar_direct

  mov x2, #380
  ldr x4, =Eight_font
  bl drawchar_direct

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
