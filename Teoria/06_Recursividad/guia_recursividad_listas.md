# Manejo de Listas y Recursividad en Prolog (Nivel Intensivo)

## 1. Anatomía de una Lista
En Prolog, una lista no es un array contiguo de memoria. Es una estructura recursiva formada por:
*   **Cabeza (Head):** El primer elemento.
*   **Cola (Tail):** El resto de la lista (que a su vez es otra lista).

La notación `[H | T]` es la herramienta clave para separar (desestructurar) una lista.

| Lista Original | Código `[H | T]` | Valor de H | Valor de T |
| :--- | :--- | :--- | :--- |
| `[a, b, c]` | `[H | T] = [a, b, c]` | `a` | `[b, c]` |
| `[a]` | `[H | T] = [a]` | `a` | `[]` (Lista vacía) |
| `[]` | `[H | T] = []` | **FALLA** | No se puede dividir |

---

## 2. Recursividad: El Bucle de Prolog

Como no hay `for` ni `while`, usamos recursividad. Una regla recursiva siempre tiene dos partes vitales:

### A. Regla de Parada (Caso Base)
Es la condición que detiene el bucle. Normalmente es cuando la lista está vacía `[]` o llegamos a un contador 0.
**Si olvidas esto, tu programa se colgará (Stack Overflow).**

### B. Regla Recursiva (El Bucle)
Es donde ocurre la magia.
1.  Haces algo con la **Cabeza**.
2.  Te llamas a ti mismo con la **Cola** (el resto).

---

## 3. Patrones Comunes de Recursividad (Recetas)

### Patrón 1: Recorrer (Imprimir cada elemento)
No devuelve nada, solo hace una acción por cada ítem.

```prolog
% PARADA: Si la lista es vacía, no hagas nada.
imprimir_lista([]).

% RECURSIÓN:
imprimir_lista([H | T]) :-
    writeln(H),        % 1. Procesa la cabeza
    imprimir_lista(T). % 2. Llama con el resto
```

### Patrón 2: Acumular/Transformar (Suma, Conteo)
Devuelve un valor al final. Usamos una variable `R` para traer el resultado.

**Ejemplo: Sumar una lista de números**
```prolog
% PARADA: La suma de una lista vacía es 0.
sumar([], 0).

% RECURSIÓN:
% [X|Resto] es la lista.
% Total es la variable donde queremos el resultado final.
sumar([X | Resto], Total) :-
    sumar(Resto, SubTotal), % 1. PRIMERO calcula la suma del resto (baja al fondo)
    Total is X + SubTotal.  % 2. DESPUÉS suma el actual al resultado parcial
```
*Nota: En este patrón, Prolog "baja" hasta la lista vacía y luego "sube" sumando los valores.*

### Patrón 3: Búsqueda
Busca un elemento y se detiene si lo encuentra.

```prolog
% PARADA (Éxito): La cabeza es lo que busco. ¡Terminé!
buscar(Elemento, [Elemento | _]).

% RECURSIÓN: La cabeza NO es lo que busco. Busco en la cola.
buscar(Elemento, [_ | Cola]) :-
    buscar(Elemento, Cola).
```

---

## 4. Ejercicios Resueltos Paso a Paso

### Ejercicio A: Contar elementos (Longitud)
Queremos saber cuántos elementos tiene una lista.

**Lógica:**
1.  Si la lista es vacía, tiene 0 elementos.
2.  Si tiene cabeza y cola, la longitud es `1 + longitud(cola)`.

**Código:**
```prolog
longitud([], 0).

longitud([_ | T], R) :- % Usamos _ porque no nos importa QUÉ es el elemento
    longitud(T, N),     % N es la longitud del resto
    R is N + 1.         % R es N + 1
```

### Ejercicio B: Recorrer dos listas paralelas
Útil para el reporte de vuelos. Tenemos `ListaVuelos` y `ListaDestinos`.

**Lógica:**
1.  Si ambas están vacías, terminamos.
2.  Sacamos la cabeza de ambas `V` y `D`.
3.  Las imprimimos juntas.
4.  Llamamos con los restos de ambas.

**Código:**
```prolog
imprimir_paralelo([], []).

imprimir_paralelo([V | RestoV], [D | RestoD]) :-
    write(V), write(' va a '), writeln(D),
    imprimir_paralelo(RestoV, RestoD).
```
