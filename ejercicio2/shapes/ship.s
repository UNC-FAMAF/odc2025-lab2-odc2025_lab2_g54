// x0: framebuffer
// w1: color bandera (extendido a 64 bits)
// w2: color barco (extendido a 64 bits)
// x3: x
// x4: y
// w5: sombra color
drawship:
  sub sp, sp, #48
  stp x10, x11, [sp, #0]
  stp x12, x13, [sp, #16]
  stp x29, x30, [sp, #32]

  mov w10, w1      // Color bandera
  mov w11, w2      // Color barco
  mov x12, x3      // x posición
  mov x13, x4      // y posición
  mov w29, w5      // Color sombra

  // Dibujar sombra (ellipse)
  mov w1, w29
  mov x2, x12
  mov x3, x13
  add x2, x2, #16    // mover x
  add x3, x3, #20    // mover y
  mov x4, #40
  mov x5, #4
  mov w7, #1        // relleno
  mov w8, #0        // grosor de borde
  bl drawellipse

  // Dibujar casco del barco
  mov w1, w11
  mov x2, x12
  mov x3, x13
  mov x4, #40
  mov x5, #20
  bl drawsquare

  // Mástil
  add x12, x12, #16    // mover x
  sub x13, x13, #32    // mover y
  mov w1, w11
  mov x2, x12
  mov x3, x13
  mov x4, #4
  mov x5, #32
  bl drawsquare

  // Bandera
  add x12, x12, #4
  mov w1, w10
  mov x2, x12
  mov x3, x13
  mov x4, #16
  mov x5, #12
  bl drawsquare

  // Restaurar
  ldp x10, x11, [sp, #0]
  ldp x12, x13, [sp, #16]
  ldp x29, x30, [sp, #32]
  add sp, sp, #48
  ret
