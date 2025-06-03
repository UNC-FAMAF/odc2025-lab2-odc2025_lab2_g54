// Entradas:
// x0 = framebuffer
// w1 = color
// x2 = center_x
// x3 = center_y
// x4 = radius_x
// x5 = radius_y
// w7 = fill_flag (1 = filled, 0 = border)
// w8 = border_thickness (si fill_flag == 0)
drawellipse:
  stp x0, x1, [sp, #-16]!
  stp x2, x3, [sp, #-16]!
  stp x4, x5, [sp, #-16]!
  stp x6, x7, [sp, #-16]!
  stp x8, x9, [sp, #-16]!
  stp x10, x11, [sp, #-16]!
  stp x12, x13, [sp, #-16]!
  stp x14, x15, [sp, #-16]!
  stp x16, x17, [sp, #-16]!
  stp x18, x19, [sp, #-16]!
  stp x20, x21, [sp, #-16]!
  stp x22, x23, [sp, #-16]!
  stp x24, x25, [sp, #-16]!
  stp x26, x27, [sp, #-16]!
  stp x28, x29, [sp, #-16]!

  // Calcular rx² y ry²
  mov x9, x4
  mov x10, x5
  mul x11, x9, x9        // x11 = rx²
  mul x12, x10, x10      // x12 = ry²
  mul x13, x11, x12      // x13 = denom = rx² * ry²

  // -ry <= y <= ry
  neg x14, x10           // x14 = y = -ry
.el_y_loop:
  neg x15, x9            // x15 = x = -rx
.el_x_loop:
  // Calcular valor de la ecuación elíptica:
  // (x² * ry² + y² * rx²)
  mul x16, x15, x15      // x16 = x²
  mul x16, x16, x12      // x16 = x² * ry²
  mul x17, x14, x14      // x17 = y²
  mul x17, x17, x11      // x17 = y² * rx²
  add x18, x16, x17      // x18 = elip_val

  // Relleno
  cmp w7, #1
  beq .el_check_inside

  // Borde con tolerancia (basada en grosor)
  // [den * (100 - thickness)%, den * 100%]
  mov x19, #100
  sub x20, x19, x8       // porcentaje_inferior = 100 - grosor
  mul x21, x13, x20
  udiv x21, x21, x19     // x21 = límite inferior
  mov x22, x13           // x22 = límite superior (den)

  cmp x18, x21
  blt .el_skip_pixel
  cmp x18, x22
  bgt .el_skip_pixel
  b .draw_pixel

.el_check_inside:
  // Aceptamos margen inferior de 1/64 por redondeo
  lsr x19, x13, #6        // tolerancia = den / 64
  add x20, x18, x19
  cmp x20, x13
  bgt .el_skip_pixel

.draw_pixel:
  // Posición en pantalla
  add x21, x2, x15        // x_real
  add x22, x3, x14        // y_real

  // Validar límites de pantalla
  cmp x21, #0
  blt .el_skip_pixel
  cmp x22, #0
  blt .el_skip_pixel

  ldr x23, =SCREEN_WIDTH
  cmp x21, x23
  bge .el_skip_pixel
  ldr x24, =SCREEN_HEIGH
  cmp x22, x24
  bge .el_skip_pixel

  // offset = (y * SCREEN_WIDTH + x) * 4
  mul x25, x22, x23
  add x25, x25, x21
  lsl x25, x25, #2
  add x25, x0, x25
  str w1, [x25]

.el_skip_pixel:
  add x15, x15, #1
  cmp x15, x9
  ble .el_x_loop

  add x14, x14, #1
  cmp x14, x10
  ble .el_y_loop

  ldp x28, x29, [sp], #16
  ldp x26, x27, [sp], #16
  ldp x24, x25, [sp], #16
  ldp x22, x23, [sp], #16
  ldp x20, x21, [sp], #16
  ldp x18, x19, [sp], #16
  ldp x16, x17, [sp], #16
  ldp x14, x15, [sp], #16
  ldp x12, x13, [sp], #16
  ldp x10, x11, [sp], #16
  ldp x8, x9, [sp], #16
  ldp x6, x7, [sp], #16
  ldp x4, x5, [sp], #16
  ldp x2, x3, [sp], #16
  ldp x0, x1, [sp], #16

  ret
