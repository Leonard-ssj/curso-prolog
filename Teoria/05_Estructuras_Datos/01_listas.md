# Estructuras de Datos: Listas a Fondo

Las listas son la navaja suiza de Prolog. Si entiendes las listas, entiendes el 80% de la manipulación de datos en este lenguaje.

## 1. ¿Qué es realmente una lista?

En lenguajes como C, una lista (array) es un bloque de memoria contiguo: `[1][2][3]`. Puedes acceder al tercero directamente `arr[2]`.

En Prolog (y Lisp), una lista es una cadena de nodos.
*   Cada nodo tiene dos huecos:
    1.  El **Valor** (Cabeza / Head).
    2.  Una **Flecha** al siguiente nodo (Cola / Tail).

La lista `[a, b, c]` en realidad es:
`[a | -> [b | -> [c | -> [] ] ] ]`

*   El final de la lista siempre es la **lista vacía** `[]`.

### La Analogía del Tren
Imagina un tren.
*   **La lista completa** es el tren entero.
*   **La Cabeza (`Head`)** es la locomotora (el primer vagón). Es un objeto individual.
*   **La Cola (`Tail`)** es *todo el resto del tren* enganchado a la locomotora.

Si tienes un tren de 1 vagón `[a]`:
*   Cabeza: `a` (el vagón).
*   Cola: `[]` (nada enganchado atrás).

Si tienes un tren vacío `[]`:
*   No tiene cabeza ni cola. Intentar separarlo da error.

---

## 2. Unificación de Listas: El Operador `|` (Pipe)

El símbolo `|` es el separador mágico. Sirve para **construir** listas o para **desarmarlas**.

**Sintaxis:** `[Cabeza | Cola]`

### Ejercicios de Unificación (Pruébalos en tu mente)

**Caso 1: Extracción Simple**
`[H | T] = [lunes, martes, miercoles]`
*   `H` = `lunes` (El primer elemento).
*   `T` = `[martes, miercoles]` (La lista restante). **¡Nota que T es una lista!**

**Caso 2: Extracción de dos elementos**
`[X, Y | Z] = [10, 20, 30, 40]`
*   `X` = `10`
*   `Y` = `20`
*   `Z` = `[30, 40]`

**Caso 3: Lista de un solo elemento**
`[H | T] = [sol]`
*   `H` = `sol`
*   `T` = `[]` (La cola vacía).

**Caso 4: Error común**
`[H | T] = []`
*   **Fallo (false).** No puedes quitarle la cabeza a algo vacío.

---

## 3. Patrones Recursivos Comunes

Como las listas son estructuras recursivas (una lista contiene una lista, que contiene una lista...), la forma natural de trabajarlas es con recursividad.

### A. El Patrón "Recorrer" (Member)
Queremos saber si algo está en la lista.

1.  **Caso Base (Éxito inmediato):** ¿Es lo que busco igual a la Cabeza?
    `member(X, [X | _]).`
    (Si la cabeza es X, entonces X está en la lista. No me importa el resto `_`).

2.  **Caso Recursivo (Seguir buscando):** Si no es la cabeza, ¿está en la Cola?
    `member(X, [_ | Cola]) :- member(X, Cola).`
    (Ignoro la cabeza `_`, y busco X dentro de la Cola).

### B. El Patrón "Transformar" (Map)
Queremos sumar 1 a cada número de una lista. `[1, 2, 3] -> [2, 3, 4]`.

1.  **Caso Base:** Transformar una lista vacía da una lista vacía.
    `sumar_uno([], []).`

2.  **Caso Recursivo:**
    *   Separo la cabeza original `H`.
    *   Calculo la nueva cabeza `H1 is H + 1`.
    *   Transformo el resto de la lista (recursión) `T -> T1`.
    *   Construyo la nueva lista `[H1 | T1]`.

    ```prolog
    sumar_uno([H|T], [H1|T1]) :-
        H1 is H + 1,
        sumar_uno(T, T1).
    ```
    *Observa cómo construimos el resultado en el segundo argumento.*

---

## 4. Operaciones Poderosas: `findall`

A veces quieres obtener todos los resultados de una consulta y guardarlos en una lista, en lugar de que Prolog te los dé uno por uno con Backtracking.

**Problema:** Tienes `hijo(juan, pepe)`, `hijo(juan, maria)`, `hijo(juan, jose)`.
Quieres una lista: `[pepe, maria, jose]`.

**Solución:**
`findall(Plantilla, Objetivo, ListaResultado).`

```prolog
?- findall(Hijo, hijo(juan, Hijo), ListaHijos).
ListaHijos = [pepe, maria, jose].
```

*   **Plantilla (`Hijo`):** Qué variable quiero guardar.
*   **Objetivo (`hijo(juan, Hijo)`):** La consulta que Prolog va a ejecutar repetidamente.
*   **ListaResultado:** Donde se acumulan los resultados.

Es como un `SELECT Hijo FROM hijo WHERE padre=juan` de SQL.

---

## 5. Listas de Listas (Matrices)

Una matriz no es más que una lista donde cada elemento es otra lista.
`M = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]`.

Para acceder al número 5 (fila 2, columna 2):
1.  Sacas la segunda fila (que es una lista).
2.  Sacas el segundo elemento de esa fila.

```prolog
obtener_elemento(Matriz, Fila, Columna, Valor) :-
    nth1(Fila, Matriz, FilaLista),      % nth1 obtiene el elemento N (índice 1)
    nth1(Columna, FilaLista, Valor).
```
(Prolog tiene predicados predefinidos como `nth1` para acceder por índice, aunque purísticamente solemos usar recursión).
