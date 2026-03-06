# Curso Práctico de Prolog

Bienvenido al repositorio definitivo para aprender Prolog desde cero hasta un nivel avanzado. Este material ha sido diseñado para guiarte paso a paso a través del paradigma lógico.

## 🚀 Guía de Inicio Rápido

### 1. Prerrequisitos
*   Tener instalado **SWI-Prolog**.
    *   Verifica abriendo una terminal y escribiendo `swipl`.
    *   Si da error, asegúrate de que la ruta `bin` de instalación esté en tu PATH.
*   Un editor de texto (VS Code recomendado con extensión "Prolog").

### 2. Cómo usar la Terminal de Prolog
La terminal (o REPL) es donde ocurre la magia. Aquí tienes los comandos esenciales:

*   **Entrar:** Escribe `swipl` en tu consola.
*   **Cargar un archivo:** `['nombre_archivo.pl'].` (¡Con punto al final!).
*   **Hacer una consulta:** Escribe tu pregunta, ej: `padre(juan, X).`
*   **Ver más respuestas:** Si Prolog dice `true` o devuelve un valor y se queda esperando, presiona `;` (punto y coma) o `ESPACIO` para ver la siguiente solución.
*   **Salir:** Escribe `halt.` y Enter.

### 3. Estructura del Curso

El material está dividido en **Teoría** (lectura y ejemplos) y **Práctica** (ejercicios).

#### 📚 Fase 1: Fundamentos (La nueva forma de pensar)
*   [01_Fundamentos/01_introduccion.md](./Teoria/01_Fundamentos/01_introduccion.md): Entiende por qué Prolog es como pedir en un restaurante.
*   [02_Sintaxis_Basica/variables.md](./Teoria/02_Sintaxis_Basica/variables.md): Descubre por qué `X = 5` no es una asignación.

#### 🧠 Fase 2: Lógica y Conocimiento
*   [03_Hechos_y_Reglas/01_base_conocimiento.md](./Teoria/03_Hechos_y_Reglas/01_base_conocimiento.md): Aprende a modelar el universo con hechos y reglas.
*   [04_Mecanismos_Control/condicionales_y_menus.md](./Teoria/04_Mecanismos_Control/condicionales_y_menus.md): Crea menús interactivos y toma decisiones.

#### 🛠️ Fase 3: Estructuras y Algoritmos
*   [05_Estructuras_Datos/01_listas.md](./Teoria/05_Estructuras_Datos/01_listas.md): Domina la estructura principal de Prolog (Cabezas y Colas).
*   [06_Recursividad/01_recursividad.md](./Teoria/06_Recursividad/01_recursividad.md): La técnica maestra para iterar sin bucles.

#### 💾 Fase 4: Aplicaciones Reales
*   [08_Persistencia_Dinamica/01_manejo_memoria.md](./Teoria/08_Persistencia_Dinamica/01_manejo_memoria.md): Crea sistemas que recuerdan datos (Bases de datos dinámicas).

### 4. Ejercicios Prácticos
En la carpeta `Practica/` encontrarás retos graduados.
1.  `01_Nivel_Basico`: Consultas simples (Comida, Familia).
2.  `02_Nivel_Intermedio`: Manipulación de listas y recursión matemática.
3.  `03_Nivel_Avanzado`: **Sistema de Vuelos** (Aplicación completa con menús y persistencia).

## 💡 Consejos de Oro
1.  **Todo termina en punto `.`**: Si Prolog no responde, probablemente olvidaste el punto.
2.  **Mayúsculas = Variables**: `juan` es un átomo, `Juan` es una variable.
3.  **Trace es tu amigo**: Si no entiendes qué hace tu código, escribe `trace.` antes de tu consulta para verlo paso a paso.

¡Buena suerte en tu viaje hacia la programación lógica!
