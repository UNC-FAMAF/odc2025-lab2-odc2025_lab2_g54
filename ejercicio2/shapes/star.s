// x0 = framebuffer
// w1 = color de la estrella (ARGB8888)
// x2 = x posición del área
// x3 = y posición del área
// x4 = ancho del área
// x5 = alto del área
// x6 = densidad (número de estrellas)
drawstars:
  // Guardar registros usados (incluyendo x21 que usará rand)
  sub sp, sp, #128
  stp x1, x2, [sp, #0]    // w1 = color de estrella, x2 = x posición
  stp x3, x4, [sp, #16]   // x3 = y posición, x4 = ancho del área
  stp x5, x6, [sp, #32]   // x5 = alto del área, x6 = densidad
  stp x7, x8, [sp, #48]   // x7 = contador de estrellas, x8 = dirección base
  stp x9, x10, [sp, #64]  // x9 = offset base, x10 = contador de estrellas
  stp x11, x12, [sp, #80] // x11 = posición X, x12 = posición Y
  stp x13, x14, [sp, #96] // x13 = offset píxel, x14 = semilla rand
  stp x21, x30, [sp, #112] // x21 = número aleatorio, x30 = LR
  // Calcular dirección base del área
  ldr x8, =SCREEN_WIDTH
  mul x9, x3, x8        // y * SCREEN_WIDTH
  add x9, x9, x2        // + x posición
  lsl x9, x9, #2        // convertir a offset en bytes
  add x9, x0, x9        // x9 = dirección base del área

  // Bucle para dibujar estrellas
  mov x10, x6           // contador de estrellas
.star_loop:
  cbz x10, .end_drawstars // terminar si no hay más estrellas

  // Generar posición X aleatoria dentro del área
  bl rand               // x21 = número aleatorio
  udiv x11, x21, x4     // x11 = rand() / width (posición x)
  msub x11, x11, x4, x21 // x11 = x posición dentro del área

  // Generar posición Y aleatoria dentro del área
  bl rand               // x21 = número aleatorio
  udiv x12, x21, x5     // x12 = rand() / height (posición y)
  msub x12, x12, x5, x21 // x12 = y posición dentro del área

  // Calcular offset del píxel central
  mul x13, x12, x8      // y * SCREEN_WIDTH
  add x13, x13, x11     // + x
  lsl x13, x13, #2      // convertir a offset en bytes
  add x13, x9, x13      // dirección final del píxel

  // Dibujar estrella básica (patrón de cruz)
  str w1, [x13]         // centro

  // Píxel izquierdo (si está dentro del área)
  cmp x11, #0
  ble .skip_left
  str w1, [x13, #-4]    // izquierda
.skip_left:

  // Píxel derecho (si está dentro del área)
  add x7, x11, #1
  cmp x7, x4
  bge .skip_right
  str w1, [x13, #4]     // derecha
.skip_right:

  // Píxel superior (si está dentro del área)
  cmp x12, #0
  ble .skip_up
  ldr x7, =SCREEN_WIDTH
  lsl x7, x7, #2        // SCREEN_WIDTH en bytes
  neg x7, x7            // offset negativo
  str w1, [x13, x7]     // arriba
.skip_up:

  // Píxel inferior (si está dentro del área)
  add x7, x12, #1
  cmp x7, x5
  bge .skip_down
  ldr x7, =SCREEN_WIDTH
  lsl x7, x7, #2        // SCREEN_WIDTH en bytes
  str w1, [x13, x7]     // abajo
.skip_down:

  sub x10, x10, #1      // decrementar contador
  b .star_loop

.end_drawstars:
  // Restaurar registros
  ldp x1, x2, [sp, #0]
  ldp x3, x4, [sp, #16]
  ldp x5, x6, [sp, #32]
  ldp x7, x8, [sp, #48]
  ldp x9, x10, [sp, #64]
  ldp x11, x12, [sp, #80]
  ldp x13, x14, [sp, #96]
  ldp x21, x30, [sp, #112]
  add sp, sp, #128       // Liberar espacio en stack
  ret
