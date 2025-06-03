// Color Palette
.equ CHARCOAL,       0xFF2B2B2B
.equ ASH_GRAY,       0xFF6D6D6D
.equ SNOW,           0xFFF8F8F8
.equ RED_ALERT,      0xFFD13438
.equ GOLDENROD,      0xFFDAA520
.equ SKYBLUE,        0xFF00BFFF
.equ DARKGREEN,      0xFF14532D
.equ MIDNIGHT,       0xFF121212
.equ LIME,           0xFF32CD32
.equ ORANGE,         0xFFFFA500
.equ MAGENTA,        0xFFFF00FF
.equ CYAN,           0xFF00FFFF
.equ BLUEGRAY,       0xFF6699CC
.equ LAVENDER,       0xFFE6E6FA
.equ OLIVE,          0xFF808000
.equ MAROON,         0xFF800000
.equ TEAL,           0xFF008080
.equ PINK,           0xFFFFC0CB
.equ MINT,           0xFF98FF98
.equ SEA,            0xFF4682B4
.equ SEA_LIGHT,      0xFF5CA0C9
.equ SEA_DEEP,       0xFF2B557F
.equ SKY_LIGHT,      0xFFC0D9F9
.equ SKY_MEDIUM,     0xFF7AB8D6
.equ SEA_DARK,       0xFF0F2D45


.equ SUNGLOW,        0xFFFFCC33
.equ SUNREFLECTION,  0xFFFFE6B3
.equ TANGERINE,      0xFFFF6600
.equ AMBER,          0xFFFFBF00
.equ CORAL,          0xFFFF7F50
.equ GOLDEN_HOUR,    0xFFFFD700
.equ SUNSET_ORANGE,  0xFFFF4500
.equ PALE_GOLD,      0xFFFFE066
.equ MELON,          0xFFFFA07A
.equ LIGHT_APRICOT,  0xFFFFE0B2
.equ SALMON,         0xFFFA8072
.equ MANGO,          0xFFFFC324
.equ BLOOD_ORANGE,   0xFFFF3F34
.equ TWILIGHT_PURPLE,0xFF6A0DAD
.equ SUNSET_PEACH,   0xFFFF8C42


// Ajusta el brillo de un color ARGB8888.
// Entradas:
//   w0 = color original (ARGB8888)
//   w1 = factor de brillo (0–255), donde 128 = sin cambio
// Salida:
//   w0 = color ajustado (ARGB8888)

adjust_color_brightness:
  // Preservar registros en pila
  sub sp, sp, #16
  str w2, [sp, #0]
  str w3, [sp, #4]
  str w4, [sp, #8]
  str w5, [sp, #12]

  // Constantes
  mov w5, #128      // factor neutro
  mov w6, #255      // valor máximo

  // Extraer canales RGB
  ubfx w2, w0, #16, #8   // R
  ubfx w3, w0, #8,  #8   // G
  ubfx w4, w0, #0,  #8   // B

  // R
  mul w7, w2, w1
  udiv w2, w7, w5
  cmp w2, w6
  csel w2, w2, w6, le

  // G
  mul w7, w3, w1
  udiv w3, w7, w5
  cmp w3, w6
  csel w3, w3, w6, le

  // B
  mul w7, w4, w1
  udiv w4, w7, w5
  cmp w4, w6
  csel w4, w4, w6, le

  // Reconstruir ARGB (alpha 0xFF)
  mov w0, w2          // w0 = R
  lsl w0, w0, #8      // w0 = R << 8
  orr w0, w0, w3      // w0 |= G
  lsl w0, w0, #8      // w0 = R << 16 | G << 8
  orr w0, w0, w4      // w0 |= B
  mov w7, #0xFF
  lsl w7, w7, #24     // w7 = A << 24
  orr w0, w0, w7      // w0 |= A << 24

  // Restaurar registros
  ldr w2, [sp, #0]
  ldr w3, [sp, #4]
  ldr w4, [sp, #8]
  ldr w5, [sp, #12]
  add sp, sp, #16
  ret
