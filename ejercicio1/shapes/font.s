// x0 = framebuffer
// w1 = color
// x2 = x
// x3 = y
// x4 = dirección de font (8 bytes)
// x5 = escala (entero)

drawchar_direct:
  sub sp, sp, #64
  stp x6, x7, [sp, #0]
  stp x8, x9, [sp, #16]
  stp x10, x11, [sp, #32]
  stp x12, x13, [sp, #48]

  mov x6, #0                  // fila (0–7)
.row_loop:
  cmp x6, #8
  bge .done

  ldrb w7, [x4, x6]           // byte de la fila
  mov x8, #0                  // columna (0–7)
.col_loop:
  cmp x8, #8
  bge .next_row

  // Comprobar bit más significativo a la izquierda
  mov w9, w7
  mov w10, w9
  lsl w10, w10, w8
  tst w10, #0x80
  beq .next_col

  // Si el bit está activo, dibujar un bloque escala x escala
  mov x10, #0                // fila dentro del bloque
.scale_y_loop:
  cmp x10, x5
  bge .next_col

  mov x11, #0                // columna dentro del bloque
.scale_x_loop:
  cmp x11, x5
  bge .next_scale_y

  // calcular dirección de píxel
  ldr x12, =SCREEN_WIDTH
  mul x13, x5, x6            // y_char * scale
  add x13, x13, x3           // y base
  add x13, x13, x10          // + desplazamiento interno

  mul x14, x5, x8            // x_char * scale
  add x14, x14, x2           // x base
  add x14, x14, x11          // + desplazamiento interno

  mul x13, x13, x12          // y * width
  add x13, x13, x14          // + x
  lsl x13, x13, #2           // * 4 bytes por píxel
  add x13, x0, x13           // framebuffer + offset

  str w1, [x13]              // escribir color

  add x11, x11, #1
  b .scale_x_loop

.next_scale_y:
  add x10, x10, #1
  b .scale_y_loop

.next_col:
  add x8, x8, #1
  b .col_loop

.next_row:
  add x6, x6, #1
  b .row_loop

.done:
  ldp x6, x7, [sp, #0]
  ldp x8, x9, [sp, #16]
  ldp x10, x11, [sp, #32]
  ldp x12, x13, [sp, #48]
  add sp, sp, #64
  ret
