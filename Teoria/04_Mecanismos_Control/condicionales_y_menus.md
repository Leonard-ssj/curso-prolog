# Mecanismos de Control: Condicionales, Menús y E/S

Aunque Prolog es declarativo ("dime qué quieres"), en el mundo real necesitamos interactuar con el usuario y tomar decisiones basadas en condiciones. Aquí es donde Prolog se vuelve un poco más imperativo.

## 1. El Operador de Corte (Cut `!`) - Breve Introducción
Antes de ver condicionales, debes saber que Prolog siempre intenta buscar **todas** las soluciones (Backtracking). A veces queremos que pare en cuanto encuentre una.

El símbolo `!` (se lee "cut" o "corte") le dice a Prolog: "Si llegaste hasta aquí, no vuelvas atrás. Comprométete con esta elección".
Es fundamental para la eficiencia y para implementar el "If-Else".

---

## 2. Condicionales: If-Then-Else

En Prolog estándar, la estructura `If-Then-Else` se escribe así:

```prolog
( Condicion -> AccionVerdad ; AccionFalso )
```

### Anatomía
1.  **Paréntesis `()`**: Son OBLIGATORIOS para agrupar todo el bloque. Sin ellos, Prolog se confunde con las comas y puntos y coma.
2.  **Flecha `->`**: Separa la condición de la acción. Actúa como un "Corte" implícito. Si la condición es cierta, Prolog **nunca** ejecutará la parte del `Else`.
3.  **Punto y coma `;`**: Separa el bloque "Then" del bloque "Else".

### Ejemplo Detallado: Clasificador de Números

```prolog
clasificar_numero(N) :-
    ( N > 0 ->
        writeln('Es positivo')      % THEN
    ;                               % ELSE
        writeln('Es negativo o cero')
    ).
```

### Condicionales Anidados (Else-If)
Para hacer múltiples comprobaciones, anidamos en la parte del `Else`.

```prolog
nota(N) :-
    ( N >= 90 -> writeln('Excelente')
    ; N >= 70 -> writeln('Aprobado')    % Else If
    ; N >= 50 -> writeln('Recuperacion')% Else If
    ;            writeln('Reprobado')   % Else Final
    ).
```
Fíjate en la indentación. Ayuda mucho a leerlo.

---

## 3. Entrada y Salida (I/O)

Para hacer menús, necesitamos hablar con el humano.

### Salida (Output)
*   `write('Texto')`: Escribe texto. No salta de línea.
*   `writeln('Texto')`: Escribe texto y salta de línea.
*   `nl`: Salta de línea (New Line).
*   `format('Hola ~w', [Nombre])`: Como el `printf` de C. `~w` se sustituye por la variable.

### Entrada (Input)
*   `read(Variable)`: Lee un **término** de Prolog terminado en punto `.`.
    *   Si el usuario escribe `hola.`, la variable toma el valor del átomo `hola`.
    *   Si escribe `5.`, toma el número `5`.
    *   **¡Cuidado!** El usuario *debe* poner el punto final. Si no, Prolog seguirá esperando.

---

## 4. Menús Recursivos: El "Bucle Infinito"

Prolog no tiene `while(true)`. Para mantener un programa corriendo (como un menú), usamos una regla que se llama a sí misma al final.

### Estructura de un Menú Robusto

```prolog
% 1. Punto de entrada
main :-
    writeln('--- BIENVENIDO ---'),
    menu_loop.

% 2. El Bucle del Menú
menu_loop :-
    writeln(''),
    writeln('1. Opcion A'),
    writeln('2. Opcion B'),
    writeln('0. Salir'),
    write('Elige: '),
    read(Opcion),
    procesar(Opcion).

% 3. Procesar las opciones

% Caso Salir: NO llamamos a menu_loop. La recursión termina aquí.
procesar(0) :-
    writeln('Adios!').

% Caso Opción 1: Hacemos la acción y VOLVEMOS al menú.
procesar(1) :-
    writeln('Ejecutando A...'),
    accion_a,
    menu_loop.  % <--- Llamada recursiva

% Caso Opción 2: Hacemos la acción y VOLVEMOS al menú.
procesar(2) :-
    writeln('Ejecutando B...'),
    accion_b,
    menu_loop.  % <--- Llamada recursiva

% Caso Default (Error): Captura cualquier otra cosa
procesar(_) :-
    writeln('Opcion no valida. Intenta de nuevo.'),
    menu_loop.  % <--- Volvemos a intentar
```

### ¿Por qué funciona?
Imagina una pila de platos.
1.  `main` llama a `menu_loop` (Plato 1).
2.  El usuario elige 1. `procesar(1)` llama de nuevo a `menu_loop` (Plato 2).
3.  El usuario elige 2. `procesar(2)` llama de nuevo a `menu_loop` (Plato 3).
4.  El usuario elige 0. `procesar(0)` termina. Se retira el Plato 3.
5.  Prolog vuelve al Plato 2, que ya terminó su tarea, y se retira.
6.  Prolog vuelve al Plato 1, y se retira.
7.  El programa termina.

*Nota técnica: Prolog optimiza esto (Last Call Optimization) para que no se llene la memoria, convirtiéndolo en un bucle real internamente.*

---

## 5. El predicado `fail` y el Backtracking forzado

A veces queremos recorrer todos los hechos y hacer algo (como imprimir una lista), sin usar recursividad explícita.

```prolog
imprimir_todos_alumnos :-
    alumno(Nombre),       % Busca un alumno
    writeln(Nombre),      % Lo imprime
    fail.                 % ¡Falla a propósito!
```

**¿Qué hace esto?**
1.  Encuentra al alumno 1. Lo imprime.
2.  Llega a `fail`. Como falla, Prolog hace **Backtracking**.
3.  Retrocede a `alumno(Nombre)` y busca *otro* alumno (el 2).
4.  Lo imprime. Falla. Retrocede.
5.  ...
6.  Cuando no quedan alumnos, `alumno(Nombre)` falla.
7.  La regla completa falla (devuelve `false`).

Para que termine "bonito" (true), solemos añadir una cláusula final vacía:

```prolog
imprimir_todos :-
    alumno(N), writeln(N), fail.
imprimir_todos.  % Esta siempre es verdad y atrapa el fallo final.
```

Esta técnica se llama **Failure-Driven Loop** (Bucle impulsado por fallo). Es muy útil para reportes simples.
