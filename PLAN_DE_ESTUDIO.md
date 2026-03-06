# Plan de Estudio y Análisis de Prolog

Este documento detalla el análisis del lenguaje Prolog y la hoja de ruta para el aprendizaje práctico.

## 1. Análisis de Prolog

### 1.1 Paradigma de Programación Lógica

Prolog (PROgramming in LOGic) es un lenguaje declarativo. A diferencia de los lenguajes imperativos (como C, Java, Python) donde se detallan los pasos para resolver un problema, en Prolog se describe el problema mediante hechos y reglas, y se deja que el motor de inferencia encuentre la solución.

- **Base de Conocimiento:** Conjunto de hechos y reglas.
- **Consultas (Queries):** Preguntas que se hacen a la base de conocimiento.

### 1.2 Sintaxis Básica

- **Átomos:** Constantes de texto (ej. `juan`, `gato`, `'Nueva York'`).
- **Números:** Enteros y flotantes.
- **Variables:** Empiezan con mayúscula o guion bajo (ej. `X`, `Resultado`, `_`).
- **Predicados:** Relaciones entre objetos (ej. `padre(juan, maria)`).
- **Cláusulas:**
  - **Hechos:** Afirmaciones incondicionales. `es_gato(tom).`
  - **Reglas:** Afirmaciones condicionales. `mortal(X) :- humano(X).` (X es mortal SI X es humano).

### 1.3 Mecanismos Fundamentales

- **Unificación:** El corazón de Prolog. Es el proceso de hacer que dos términos sean idénticos encontrando sustituciones para las variables. Ej: `padre(X, maria)` unifica con `padre(juan, maria)` si `X = juan`.
- **Backtracking (Retroceso):** Estrategia de búsqueda. Prolog intenta satisfacer una meta; si falla, retrocede al punto de elección más reciente y prueba una alternativa.
- **Recursividad:** Dado que no hay bucles `for` o `while` tradicionales, la iteración se logra mediante reglas que se llaman a sí mismas.

### 1.4 Estructuras de Datos

La estructura principal es la **Lista**.

- Sintaxis: `[a, b, c]`.
- Cabeza y Cola: `[H|T]` donde `H` es el primer elemento y `T` es el resto de la lista.

***

## 2. Estructura del Proyecto

El repositorio está organizado para separar la teoría conceptual de la práctica aplicada.

```
/
├── Teoria/
│   ├── 01_Fundamentos/         # Introducción y configuración
│   ├── 02_Sintaxis_Basica/     # Átomos, variables, predicados
│   ├── 03_Hechos_y_Reglas/     # Base de conocimiento simple
│   ├── 04_Mecanismos_Control/  # Unificación y trazas (trace)
│   ├── 05_Estructuras_Datos/   # Listas y pares
│   └── 06_Recursividad/        # Pensamiento recursivo
├── Practica/
│   ├── 01_Nivel_Basico/        # Consultas simples y familiares
│   ├── 02_Nivel_Intermedio/    # Aritmética y recursión simple
│   └── 03_Nivel_Avanzado/      # Problemas lógicos y listas complejas
├── README.md                   # Guía de inicio
└── PLAN_DE_ESTUDIO.md          # Este documento
```

***

## 3. Plan de Estudio Intensivo (Crash Course)

Este plan está diseñado para una inmersión rápida y práctica, cubriendo los conceptos esenciales y patrones comunes utilizados en clase (como menús y manejo dinámico de datos).

### Módulo 1: Fundamentos y Sintaxis
- **Variables:**
  - **Nombradas:** (`X`, `Resultado`, `Lista`) - Guardan valores y se unifican.
  - **Anónimas:** (`_`) - "No me importa este valor". Útil para ignorar argumentos en predicados.
- **Átomos y Números:** Elementos básicos de información.
- **Estructura:** Cabeza y Cuerpo (`Cabeza :- Cuerpo.`).

### Módulo 2: Control de Flujo y Lógica
- **Condicionales:** Estructura If-Then-Else en Prolog.
  - Sintaxis: `( Condicion -> Verdad ; Falso )`.
  - Uso de paréntesis `()` para agrupar la lógica.
- **Operadores Lógicos:** AND (`,`), OR (`;`), NOT (`\+`).
- **Aritmética:** Uso de `is` para asignar resultados matemáticos.

### Módulo 3: Listas y Recursividad
- **Manejo de Listas:** `[Cabeza|Cola]`.
- **Predicados comunes:** `append/3`, `member/2`.
- **Recursividad:** La forma de "iterar" en Prolog.

### Módulo 4: Interacción y Persistencia (Estilo Imperativo)
- **Base de Datos Dinámica:**
  - `:- dynamic nombre/aridad.`
  - `assert/1`: Agregar hechos en tiempo de ejecución.
  - `retract/1`: Eliminar hechos.
- **Menús de Consola:**
  - Patrón de recursión para mantener el programa corriendo (`menu :- ..., opcion(X).`).
  - Entrada/Salida: `read/1`, `write/1`, `writeln/1`.

***

## 4. Recursos y Evaluación

### Entornos Recomendados

1. **SWI-Prolog:** El estándar de facto para aprendizaje y desarrollo.
2. **GNU Prolog:** Alternativa ligera.
3. **Editor:** VS Code con extensión "Prolog" (Arthur Wang) para resaltado de sintaxis y linter.

### Criterios de Evaluación

1. **Correctitud:** El programa debe dar las respuestas correctas (y no dar respuestas incorrectas adicionales).
2. **Eficiencia:** Uso apropiado de cortes (cuts) para evitar backtracking innecesario.
3. **Estilo:** Nombres de predicados descriptivos, código comentado.
4. **Recursividad de Cola (Tail Recursion):** Preferible para optimización de memoria.

### Bibliografía

- *Programming in Prolog* (Clocksin & Mellish).
- *The Art of Prolog* (Sterling & Shapiro).
- Documentación oficial de SWI-Prolog (swi-prolog.org).

