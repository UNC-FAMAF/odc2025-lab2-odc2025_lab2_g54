// x0 = framebuffer
// w1 = color
// x2 = x_start (X)
// x3 = y_start (Y)
draw_odc2025:
  sub sp, sp, #32
  stp x9, x10, [sp, #0]
  stp x29, x30, [sp, #16]

  mov x9, x2        // guardar x inicial
  mov x10, x3       // y inicial

  // Draw O
  mov x2, x9
  mov x3, x10
  bl draw_o
  add x9, x9, #28

  // Draw D
  mov x2, x9
  mov x3, x10
  bl draw_d
  add x9, x9, #28

  // Draw C
  mov x2, x9
  mov x3, x10
  bl draw_c
  add x9, x9, #28

  // Draw 2
  mov x2, x9
  mov x3, x10
  bl draw_2
  add x9, x9, #28

  // Draw 0
  mov x2, x9
  mov x3, x10
  bl draw_0
  add x9, x9, #28

  // Draw 2
  mov x2, x9
  mov x3, x10
  bl draw_2
  add x9, x9, #28

  // Draw 5
  mov x2, x9
  mov x3, x10
  bl draw_5

  ldp x9, x10, [sp, #0]
  ldp x29, x30, [sp, #16]
  add sp, sp, #32
  ret

// =============================
// DRAW LETTER: O
// =============================
draw_o:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  add x3, x3, #24
  bl drawsquare            // bottom

  sub x3, x3, #24
  mov x4, #4
  mov x5, #28
  bl drawsquare            // left

  add x2, x2, #16
  bl drawsquare            // right

  ldr x30, [sp]
  add sp, sp, #16
  ret

// =============================
// DRAW LETTER: D
// =============================
draw_d:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  add x3, x3, #24
  bl drawsquare            // bottom

  sub x3, x3, #24
  mov x4, #4
  mov x5, #28
  bl drawsquare            // left

  add x2, x2, #20
  add x3, x3, #4
  mov x5, #20
  bl drawsquare            // right curve

  ldr x30, [sp]
  add sp, sp, #16
  ret

// =============================
// DRAW LETTER: C
// =============================
draw_c:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  add x3, x3, #24
  bl drawsquare            // bottom

  sub x3, x3, #24
  mov x4, #4
  mov x5, #28
  bl drawsquare            // left only

  ldr x30, [sp]
  add sp, sp, #16
  ret

// =============================
// DRAW NUMBER: 2
// =============================
draw_2:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  add x2, x2, #16
  add x3, x3, #4
  mov x4, #4
  mov x5, #8
  bl drawsquare            // top right

  sub x2, x2, #16
  add x3, x3, #8
  mov x4, #20
  mov x5, #4
  bl drawsquare            // middle

  mov x4, #4
  mov x5, #12
  bl drawsquare            // bottom left

  add x3, x3, #12
  mov x4, #20
  mov x5, #4
  bl drawsquare            // bottom

  ldr x30, [sp]
  add sp, sp, #16
  ret

// =============================
// DRAW NUMBER: 0
// =============================
draw_0:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  add x3, x3, #24
  bl drawsquare            // bottom

  sub x3, x3, #24
  mov x4, #4
  mov x5, #28
  bl drawsquare            // left

  add x2, x2, #16
  bl drawsquare            // right

  ldr x30, [sp]
  add sp, sp, #16
  ret

// =============================
// DRAW NUMBER: 5
// =============================
draw_5:
  sub sp, sp, #16
  str x30, [sp]

  mov x4, #20
  mov x5, #4
  bl drawsquare            // top

  mov x4, #4
  mov x5, #12
  bl drawsquare            // top left

  add x3, x3, #12
  mov x4, #20
  mov x5, #4
  bl drawsquare            // middle

  add x2, x2, #16
  add x3, x3, #4
  mov x4, #4
  mov x5, #8
  bl drawsquare            // bottom right

  sub x2, x2, #16
  add x3, x3, #8
  mov x4, #20
  mov x5, #4
  bl drawsquare            // bottom

  ldr x30, [sp]
  add sp, sp, #16
  ret
