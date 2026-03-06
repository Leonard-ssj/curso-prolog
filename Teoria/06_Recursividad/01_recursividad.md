# Recursividad: El Arte de Definirse a Sí Mismo

La recursividad es probablemente el concepto más difícil de captar para un principiante, pero en Prolog es **obligatorio**. No hay bucles `for` ni `while`. La única forma de repetir algo es que una regla se llame a sí misma.

## 1. ¿Qué es la Recursividad?

Es definir algo en términos de sí mismo, pero más pequeño.

### Analogía 1: Las Muñecas Rusas (Matrioshkas)
Imagina que quieres saber cuántas muñecas hay una dentro de otra.
1.  Abres la muñeca grande.
2.  Ves una más pequeña dentro.
3.  Te preguntas: "¿Cuántas muñecas hay dentro de esta pequeña?" (El problema se repite).
4.  Sigues abriendo hasta llegar a la muñeca sólida más chiquita que no se abre.
5.  Ese es el **Caso Base**. Ahí dejas de preguntar y empiezas a contar hacia atrás.

### Analogía 2: Dominó
Para que caiga una fila infinita de fichas de dominó, necesitas dos cosas:
1.  **Caso Base:** Alguien debe empujar la primera ficha.
2.  **Regla Recursiva:** Si una ficha cae, empuja a la siguiente.

---

## 2. Estructura de una Regla Recursiva

Siempre, SIEMPRE debe tener dos partes. Si te falta una, el programa falla.

### Parte A: El Caso Base (La salida de emergencia)
Es la condición que detiene la recursión. Suele ser el problema más trivial posible:
*   Una lista vacía `[]`.
*   El número 0.
*   Llegar al destino.

Sin esto, tu programa entrará en un **Bucle Infinito** y colapsará (Stack Overflow).

### Parte B: El Paso Recursivo (La reducción)
Es la regla que:
1.  Hace una pequeña parte del trabajo.
2.  Se llama a sí misma con el **resto** del trabajo.
3.  **IMPORTANTE:** El "resto" debe ser más pequeño que el original. Si llamas a la función con los mismos datos, nunca terminarás.

---

## 3. Ejemplo Visual: Longitud de una Lista

Queremos calcular `longitud([a, b, c], N)`.

**Lógica Humana:**
"La longitud de una lista es 1 más la longitud del resto de la lista."
"La longitud de una lista vacía es 0."

**Código Prolog:**

```prolog
% 1. Caso Base
longitud([], 0).

% 2. Paso Recursivo
longitud([_ | Cola], N) :-
    longitud(Cola, N_Cola),  % Llamada recursiva (Preguntamos por el resto)
    N is 1 + N_Cola.         % Sumamos 1 al resultado
```

### La Pila de Llamadas (Trace Mental)

Imagina que Prolog apila tareas pendientes:

1.  **Llamada:** `longitud([a,b,c], N)`
    *   Separa `a` y `[b,c]`.
    *   Dice: "Esperaré a saber la longitud de `[b,c]` para sumar 1".
    *   **PILA:** `Esperando: 1 + longitud([b,c])`

2.  **Llamada:** `longitud([b,c], N2)`
    *   Separa `b` y `[c]`.
    *   **PILA:** `Esperando: 1 + (1 + longitud([c]))`

3.  **Llamada:** `longitud([c], N3)`
    *   Separa `c` y `[]`.
    *   **PILA:** `Esperando: 1 + (1 + (1 + longitud([])))`

4.  **Llamada:** `longitud([], N4)`
    *   ¡CASO BASE! Coincide con `longitud([], 0)`.
    *   `N4` vale 0.
    *   **PILA:** Empieza a resolverse.

5.  **Retorno:**
    *   N3 = 1 + 0 = 1.
    *   N2 = 1 + 1 = 2.
    *   N = 1 + 2 = 3.
    *   Resultado final: 3.

---

## 4. Recursividad de Cola (Tail Recursion)

El ejemplo anterior es intuitivo pero ineficiente. Prolog tiene que guardar toda la pila de "esperas". Si la lista tiene 1 millón de elementos, la memoria explota.

La **Recursividad de Cola** es una técnica donde pasamos el resultado parcial como un argumento (Acumulador), de modo que Prolog no necesita recordar nada pendiente.

### Analogía: El Contador
En lugar de decir "cuenta el resto y luego suma 1", le dices al siguiente paso: "Llevo 1 contado, sigue tú".

**Código Optimizado:**

```prolog
% Wrapper (Envoltorio para inicializar el acumulador en 0)
longitud_tail(Lista, N) :- longitud_aux(Lista, 0, N).

% Caso Base: Cuando la lista se acaba, el Acumulador es el Resultado Final.
longitud_aux([], Acumulador, Acumulador).

% Paso Recursivo:
longitud_aux([_ | Cola], Acumulador, Resultado) :-
    NuevoAcumulador is Acumulador + 1,        % Calculamos AHORA
    longitud_aux(Cola, NuevoAcumulador, Resultado). % Pasamos el dato
```

**Diferencia Clave:** La llamada recursiva `longitud_aux` es **lo último** que sucede en la regla. No hay un "sumar 1 después". Prolog detecta esto y recicla la memoria.

---

## 5. Ejercicio Guiado: Factorial

Intenta escribir el factorial (`N!`) en papel antes de ver la solución.
Pista: `5! = 5 * 4!`. `0! = 1`.

**Solución Simple:**
```prolog
factorial(0, 1).
factorial(N, R) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, R1),
    R is N * R1.
```

**Solución Tail Recursive (Avanzada):**
```prolog
factorial_tail(N, R) :- fact_acc(N, 1, R).

fact_acc(0, Acc, Acc).
fact_acc(N, Acc, R) :-
    N > 0,
    N1 is N - 1,
    NewAcc is Acc * N,
    fact_acc(N1, NewAcc, R).
```
