Nombre y apellido
Integrante 1: Fadel Jachuf
Integrante 2: Ayala Garcia Luis Facundo
Integrante 3:
Integrante 4:

Descripción ejercicio 1:
Hicimos un atardecer en el cual las principales funciones que programamos son:
- Dibujar una elipse: se puede controlar el radio mayor y menor, el color, el borde y la posición.
- Dibujar un cuadrado: permite definir su posición, color y tamaño. También hicimos una variante con colores en gradiente lineal.
- Rellenar fondo: puede hacerse con un color sólido o con un gradiente entre dos colores.
- Dibujar estrellas: se puede ajustar la densidad, el área y el color. Ideal para añadir detalles decorativos.
- Dibujar texto: se puede controlar el color, la escala y la posición del texto.

Descripción ejercicio 2:
Partiendo del ejercicio 1, movimos las posiciones y colores constantes a registros. Al finalizar cada fotograma, estos registros se modifican para actualizar valores como posición y color según el elemento.
Por ejemplo, al sol le asignamos un registro para su altura, otro para el ancho de su reflejo, y otros para controlar los gradientes. Usamos una función auxiliar que reduce el brillo progresivamente.
También añadimos una función de delay para introducir una pausa entre fotogramas.
Por ultimo añadimos un outro que muestra a legv8 en pantalla.

Justificación instrucciones ARMv8:
- **LDR**: permite cargar valores en registros desde memoria de forma más rápida y directa, en lugar de usar múltiples `MOVK` con desplazamiento (`LSL`).
- **UBFX**: extrae ciertos bits de un registro. Lo usamos para obtener los valores individuales de los canales A, R, G y B de los colores.
- **CSEL**: permite seleccionar entre dos registros según una condición, útil para lógica condicional sin usar saltos.
- **TST**: realiza un `AND` entre dos registros sin guardar el resultado, pero sí actualiza las banderas del procesador. Se usó para comparar registros en un caso específico.
- **.include**: Para poder modularizar en varios archivos y tener un assembly mas legible.
