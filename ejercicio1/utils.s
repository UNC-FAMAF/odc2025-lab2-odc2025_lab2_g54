.include "constants.s"

rand:
  sub sp, sp, #32          // Reservar espacio en stack
  stp x1, x2, [sp, #0]     // Guardar x1 y x2
  stp x3, x4, [sp, #16]    // Guardar x3 y x4

  // Cargar semilla (sin usar inmediatos grandes)
  ldr x21, =RAND_SEED      // x21 = dirección de la semilla
  ldr x1, [x21]            // x1 = valor actual de la semilla

  // Multiplicar por constante (1103515245)
  mov x2, #11035           // Parte baja de la constante
  movk x2, #15245, lsl #16 // Parte alta de la constante
  mul x1, x1, x2

  ldr x3, =12345
  // Sumar constante (12345)
  add x1, x1, x3

  // Guardar nueva semilla
  str x1, [x21]

  // Asegurar número positivo (0x7FFFFFFF)
  mov x2, #0x7FFF          // Parte baja de la máscara
  movk x2, #0xFFFF, lsl #16 // Parte alta de la máscara
  and x21, x1, x2          // Resultado en x21

  // Restaurar registros
  ldp x1, x2, [sp, #0]     // Restaurar x1 y x2
  ldp x3, x4, [sp, #16]    // Restaurar x3 y x4
  add sp, sp, #32          // Liberar espacio en stack

  ret
