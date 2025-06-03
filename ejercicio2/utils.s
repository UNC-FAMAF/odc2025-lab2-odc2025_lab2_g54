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

// x0 = centisegundos (1/100 de segundo)
// Mejorado para mayor fluidez y precisión
delay:
    stp     x0, x1, [sp, #-16]!   // Guardar registros
    stp     x2, x3, [sp, #-16]!   // Guardar registros adicionales

    // Calcular ciclos totales de espera
    // Asumiendo un CPU de ~1GHz: 1 centisegundo = 10,000,000 ciclos
    mov     x1, #10000             // Base para centisegundos
    mul     x1, x0, x1             // x1 = centisegundos * 10,000
    lsl     x1, x1, #10            // x1 = x1 * 1024 (~10,240,000 ciclos por centisegundo)

    // Bucle principal de espera
    // Usamos 4 instrucciones por iteración para mejor granularidad
    lsr     x1, x1, #2             // Dividir entre 4 (4 instrucciones por ciclo)

    // Bucle optimizado
    mov     x2, #0                 // Contador interno 1
    mov     x3, #0                 // Contador interno 2
.delay_loop:
    add     x2, x2, #1             // 1 ciclo
    cmp     x2, x1                 // 1 ciclo
    b.lo    .delay_loop            // 2 ciclos (3 si se toma el salto)

    // Restaurar registros
    ldp     x2, x3, [sp], #16
    ldp     x0, x1, [sp], #16
    ret
