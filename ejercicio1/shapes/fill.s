// x0 = framebuffer (64 bits)
// w1 = color inicio (ARGB8888, 32 bits)
fillscreen:
  // Guardar registros usados
  sub sp, sp, #16
  str x2, [sp, #0]

  ldr x2, =SCREEN_WIDTH * SCREEN_HEIGH

.fillscreen_loop:
  str w1, [x0], #4        // escribir color (ARGB, 4 bytes) y avanzar framebuffer
  subs x2, x2, #1         // decrementar contador de píxeles
  bne .fillscreen_loop

  // Restaurar registros
  ldr x2, [sp, #0]
  add sp, sp, #16
  ret

// x0 = framebuffer (64 bits)
// w1 = color inicio (ARGB8888, 32 bits)
// w2 = color fin    (ARGB8888, 32 bits)
fillscreen_gradient_color_to_color:
  sub sp, sp, #32
  stp x2, x3, [sp, #0]
  stp x4, x5, [sp, #16]

  mov w5, #SCREEN_WIDTH    // ancho
  mov w6, #SCREEN_HEIGH    // alto

  // Separar componentes de inicio
  ubfx w10, w1, #16, #8   // R1
  ubfx w11, w1, #8,  #8   // G1
  ubfx w12, w1, #0,  #8   // B1

  // Separar componentes de fin
  ubfx w13, w2, #16, #8   // R2
  ubfx w14, w2, #8,  #8   // G2
  ubfx w15, w2, #0,  #8   // B2

  mov w4, #0            // fila actual
  mov x1, x0            // framebuffer ptr

.fgloop_fila:
  cmp w4, w6
  bge .fgend_gradient

  mov w21, #255         // para porcentaje
  // porcentaje = fila_actual * 255 / (alto - 1)
  mov w7, w4
  mul w7, w7, w21
  udiv w7, w7, w6       // w7 = porcentaje [0-255]

  // Interpolación lineal para R
  sub w8, w13, w10
  mul w8, w8, w7
  udiv w8, w8, w21
  add w8, w8, w10
  mov w16, w8           // R final

  // Interpolación lineal para G
  sub w8, w14, w11
  mul w8, w8, w7
  udiv w8, w8, w21
  add w8, w8, w11
  mov w17, w8           // G final

  // Interpolación lineal para B
  sub w8, w15, w12
  mul w8, w8, w7
  udiv w8, w8, w21
  add w8, w8, w12
  mov w18, w8           // B final

  // Construir color con alpha FF
  mov w8, w16
  lsl w8, w8, #8
  orr w8, w8, w17
  lsl w8, w8, #8
  orr w8, w8, w18
  mov w9, #0xFF
  lsl w9, w9, #24
  orr w8, w8, w9        // w8 = color final

  // Pintar fila completa
  mov w19, w5           // columnas

.fgloop_columna:
  str w8, [x1], #4
  subs w19, w19, #1
  bne .fgloop_columna

  add w4, w4, #1
  b .fgloop_fila

.fgend_gradient:
  ldp x2, x3, [sp, #0]
  ldp x4, x5, [sp, #16]
  add sp, sp, #32
  ret
