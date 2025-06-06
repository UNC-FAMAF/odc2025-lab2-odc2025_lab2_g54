// x0 = framebuffer
// w1 = color
// x2 = x
// x3 = y
// x4 = width
// x5 = height
drawsquare:
  // Guardar registros usados
  sub sp, sp, #64
  stp x6, x7, [sp, #0]
  stp x8, x9, [sp, #16]
  stp x10, x11, [sp, #32]
  stp x12, x13, [sp, #48]

  mov x6, x3
  ldr x8, =SCREEN_WIDTH
  mul x6, x6, x8
  add x6, x6, x2
  lsl x6, x6, #2              // convertir a offset en bytes
  add x6, x0, x6              // x6 = dirección inicial del primer píxel

  mov x9, x5                  // contador de filas
.dsrow_loop:
  mov x10, x4                 // contador de columnas
  mov x11, x6                 // dirección base de la fila actual
.dscol_loop:
  str w1, [x11], #4           // escribir píxel y avanzar
  subs x10, x10, #1
  bne .dscol_loop

  ldr x12, =SCREEN_WIDTH
  lsl x12, x12, #2            // ancho en bytes de una fila
  add x6, x6, x12             // avanzar a siguiente fila
  subs x9, x9, #1
  bne .dsrow_loop

  // Restaurar registros
  ldp x6, x7, [sp, #0]
  ldp x8, x9, [sp, #16]
  ldp x10, x11, [sp, #32]
  ldp x12, x13, [sp, #48]
  add sp, sp, #64
  ret

// x0 = framebuffer
// w1 = color inicio (ARGB8888)
// w2 = color fin    (ARGB8888)
// x3 = x posición
// x4 = y posición
// x5 = ancho
// x6 = alto
drawsquare_gradient:
  sub sp, sp, #160
  stp x7, x8, [sp, #0]
  stp x9, x10, [sp, #16]
  stp x11, x12, [sp, #32]
  stp x13, x14, [sp, #48]
  stp x15, x16, [sp, #64]
  stp x17, x18, [sp, #80]
  stp x19, x21, [sp, #96]
  stp x22, x23, [sp, #112]
  stp x24, x25, [sp, #128]
  stp x26, x27, [sp, #144]

  // Separar componentes de inicio
  ubfx w10, w1, #16, #8   // R1
  ubfx w11, w1, #8,  #8   // G1
  ubfx w12, w1, #0,  #8   // B1

  // Separar componentes de fin
  ubfx w13, w2, #16, #8   // R2
  ubfx w14, w2, #8,  #8   // G2
  ubfx w15, w2, #0,  #8   // B2

  // Calcular dirección inicial en framebuffer
  ldr x7, =SCREEN_WIDTH
  mul x8, x4, x7          // y * SCREEN_WIDTH
  add x8, x8, x3          // + x
  lsl x8, x8, #2          // * 4 (bytes por pixel)
  add x8, x0, x8          // framebuffer + offset
  mov x9, x8              // x9 = ptr actual

  // Si alto es 1, usar color final directamente
  cmp x6, #1
  ble .dsgrad_single_row

  mov w7, #255            // para porcentaje
  sub w16, w6, #1         // alto - 1 (para evitar división por 0)
  mov x17, #0             // fila actual

.dsgrad_loop_row:
  cmp x17, x6
  bge .dsgrad_end

  // porcentaje = fila_actual * 255 / (alto - 1)
  mul x18, x17, x7
  udiv x18, x18, x16      // x18 = porcentaje [0-255]

  // Interpolación lineal para R
  sub w19, w13, w10
  mul w19, w19, w18
  udiv w19, w19, w7
  add w19, w19, w10       // R final

  // Interpolación lineal para G
  sub w21, w14, w11
  mul w21, w21, w18
  udiv w21, w21, w7
  add w21, w21, w11       // G final

  // Interpolación lineal para B
  sub w22, w15, w12
  mul w22, w22, w18
  udiv w22, w22, w7
  add w22, w22, w12       // B final

  // Construir color con alpha FF
  mov w23, #0xFF
  lsl w23, w23, #24       // Alpha
  orr w23, w23, w19, lsl #16  // R
  orr w23, w23, w21, lsl #8   // G
  orr w23, w23, w22           // B

  // Pintar fila completa
  mov x24, x5             // columnas
  mov x25, x9             // puntero a píxeles de la fila

.dsgrad_loop_col:
  str w23, [x25], #4
  subs x24, x24, #1
  bne .dsgrad_loop_col

  // Avanzar puntero a la siguiente fila
  ldr x26, =SCREEN_WIDTH
  lsl x26, x26, #2
  add x9, x9, x26
  add x17, x17, #1
  b .dsgrad_loop_row

.dsgrad_single_row:
  // Caso especial: altura = 1, usar color final
  mov w23, w2
  mov x24, x5
  mov x25, x9

.dsgrad_loop_col_single:
  str w23, [x25], #4
  subs x24, x24, #1
  bne .dsgrad_loop_col_single

.dsgrad_end:
  ldp x7, x8, [sp, #0]
  ldp x9, x10, [sp, #16]
  ldp x11, x12, [sp, #32]
  ldp x13, x14, [sp, #48]
  ldp x15, x16, [sp, #64]
  ldp x17, x18, [sp, #80]
  ldp x19, x21, [sp, #96]
  ldp x22, x23, [sp, #112]
  ldp x24, x25, [sp, #128]
  ldp x26, x27, [sp, #144]
  add sp, sp, #160
  ret
