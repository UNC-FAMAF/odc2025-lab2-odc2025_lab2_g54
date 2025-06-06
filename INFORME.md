**Nombre y apellido**  
**Integrante 1:** Fadel Jachuf  (SrWither)
**Integrante 2:** Ayala Garcia Luis Facundo  
**Integrante 3:** Felipe Rayano Fernández  
**Integrante 4:** Axel Lissandro Bosque  

### **Descripción ejercicio 1:**  
Creamos una escena de atardecer en el mar usando funciones como:  
- Dibujar elipses y cuadrados con color, posición y tamaño.  
- Rellenar el fondo con color sólido o gradiente.  
- Dibujar estrellas con control de densidad y área.  
- Mostrar texto en pantalla con color, escala y posición.

### **Descripción ejercicio 2:**  
Convertimos constantes en registros y actualizamos sus valores en cada fotograma.  
Agregamos movimiento al sol, el barco y cambios dinámicos en el reflejo y los colores.  
Incorporamos una función `delay` para pausar entre cuadros.  
Al final, se muestra un logo animado de **LEGv8**.

### **Justificación instrucciones ARMv8:**  
- **LDR:** carga mas rapida de registros.  
- **UBFX:** extrae bits útiles (A, R, G, B) de colores.  
- **CSEL:** elige entre dos valores según condición, evitando saltos.  
- **TST:** compara bits sin guardar el resultado, solo modifica banderas.  
- **.include:** permite modularizar el código y mejorar la organización.
