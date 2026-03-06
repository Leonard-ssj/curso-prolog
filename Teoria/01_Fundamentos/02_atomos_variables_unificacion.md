# Teoría Profunda: Átomos, Variables y Unificación

Para dominar Prolog, debes entender cómo "piensa" el motor. A diferencia de C++ o Java, donde asignas valores a variables (`x = 5`), en Prolog *unificas* términos.

## 1. Términos: Los ladrillos de construcción

Todo en Prolog es un **término**.

### A. Átomos (Constantes)
Son identificadores fijos.
*   Empiezan con minúscula: `gato`, `juan`, `x`.
*   Entre comillas simples (para incluir espacios o empezar con mayúscula): `'San Francisco'`, `'Juan Perez'`.
*   Símbolos especiales: `+`, `:-`, `->`.

### B. Números
Enteros (`1`, `42`) y Flotantes (`3.14`).

### C. Variables
Son contenedores *vacíos* esperando ser llenados (instanciados).
*   Empiezan con **Mayúscula** o `_`: `X`, `Resultado`, `_lista`.
*   **Variable Anónima (`_`)**: Úsala cuando la sintaxis requiere un argumento pero no te interesa su valor.
    *   `padre(X, _)`: "¿Es X padre de alguien?". No me importa de quién.

### D. Estructuras (Predicados compuestos)
Tienen un nombre (functor) y argumentos.
*   `fecha(12, diciembre, 2023)`
*   `persona(juan, perez, 25)`

---

## 2. La Unificación (`=`)

El operador `=` en Prolog NO es asignación. Es una petición de unificación: "¿Puedes hacer que el lado izquierdo sea igual al derecho?".

### Reglas de Unificación (Paso a Paso)

1.  **Átomo = Átomo:**
    *   `juan = juan` -> ✅ `true`.
    *   `juan = pedro` -> ❌ `false`.

2.  **Variable = Cualquier cosa:**
    *   Si la variable está libre (sin valor), toma el valor del otro lado.
    *   `X = juan` -> ✅ `X` ahora vale `juan`.

3.  **Variable Instanciada = Valor:**
    *   Si `X` ya vale `juan`:
    *   `X = juan` -> ✅ `true` (Coincide).
    *   `X = pedro` -> ❌ `false` (Conflicto).

4.  **Estructura = Estructura:**
    *   Deben tener el mismo nombre (functor) y el mismo número de argumentos (aridad).
    *   Luego, Prolog intenta unificar argumento por argumento.
    *   `padre(X) = padre(homero)` -> ✅ `X = homero`.
    *   `fecha(D, M, 2023) = fecha(12, enero, A)` -> ✅ `D=12, M=enero, A=2023`.

### Escenario de Conflicto (Backtracking)
Imagina esta consulta: `f(X, X) = f(a, b).`
1.  Prolog intenta unificar el primer argumento: `X = a`. (Ahora `X` vale `a`).
2.  Intenta unificar el segundo: `X = b`.
3.  Como `X` ya vale `a`, esto equivale a `a = b`.
4.  ❌ Falla. Toda la unificación falla.

---

## 3. Traza de Ejecución (Trace)

La mejor forma de ver esto es usando `trace.`.

```prolog
% Hechos
amigo(juan, pedro).
amigo(pedro, ana).

% Regla
amigo_de_amigo(X, Z) :- 
    amigo(X, Y), 
    amigo(Y, Z).
```

**Consulta:** `?- trace, amigo_de_amigo(juan, Quien).`

**Lo que verás (Explicado):**
1.  `Call: amigo_de_amigo(juan, _G123)` -> Llamamos a la regla. `X` es `juan`. `Z` es una variable interna `_G123`.
2.  `Call: amigo(juan, _G124)` -> Primera parte de la regla: busca un amigo de Juan (`Y`).
3.  `Exit: amigo(juan, pedro)` -> ¡Encontró uno! `Y` se unifica con `pedro`.
4.  `Call: amigo(pedro, _G123)` -> Segunda parte: busca un amigo de `pedro` (`Z`).
5.  `Exit: amigo(pedro, ana)` -> ¡Encontró uno! `Z` se unifica con `ana`.
6.  `Exit: amigo_de_amigo(juan, ana)` -> Éxito total. `Quien = ana`.

**Comandos de Debug:**
*   `Enter`: Paso a paso (Creep).
*   `s`: Saltar detalles (Skip).
*   `a`: Abortar ejecución.
