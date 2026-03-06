# Listas a Profundidad: Patrones y Predicados

Ya sabes que `[H|T]` separa la cabeza de la cola. Ahora vamos a ver cómo usar esto para resolver problemas reales.

## 1. Operaciones Fundamentales

### A. Member (Pertenencia)
Verifica si un elemento está en la lista.

```prolog
% Caso Base: Si es la cabeza, lo encontramos.
mi_member(X, [X|_]).

% Caso Recursivo: Si no es la cabeza, busca en la cola.
mi_member(X, [_|Cola]) :- mi_member(X, Cola).
```

**Uso:**
*   `mi_member(3, [1, 2, 3]).` -> `true`.
*   `mi_member(X, [1, 2]).` -> Devuelve `X=1`, luego `X=2`. (Generador).

### B. Append (Concatenar)
Une dos listas en una tercera. Es bidireccional (puedes usarlo para unir o para separar).

```prolog
% Caso Base: Unir una lista vacía con L da L.
mi_append([], L, L).

% Caso Recursivo: 
% La cabeza de la primera lista (H) será la cabeza del resultado.
% El resto (T) se une con L2 para formar el resto del resultado (T3).
mi_append([H|T], L2, [H|T3]) :-
    mi_append(T, L2, T3).
```

**Escenarios:**
1.  **Unir:** `append([1,2], [3,4], R).` -> `R = [1,2,3,4]`.
2.  **Separar:** `append(A, B, [1,2,3]).` -> Prolog te da todas las combinaciones posibles (`A=[], B=[1,2,3]`, `A=[1], B=[2,3]`, etc.).

---

## 2. Recolección de Datos (`findall`)

A menudo quieres obtener *todas* las soluciones de una consulta en una sola lista, en lugar de presionar `;` mil veces.

**Sintaxis:** `findall(Plantilla, Objetivo, ListaResultado).`

**Ejemplo:**
Supongamos que tienes `vuelo(Codigo, Destino)`.

```prolog
vuelo(v1, paris).
vuelo(v2, madrid).
vuelo(v3, paris).
```

Si quieres una lista de todos los códigos de vuelos a París:

```prolog
?- findall(C, vuelo(C, paris), Lista).
% Resultado: Lista = [v1, v3].
```

*   `C`: Es lo que quieres guardar en la lista.
*   `vuelo(C, paris)`: Es la condición que debe cumplirse.
*   `Lista`: Donde se guardará el resultado.

---

## 3. Ejercicios de Listas (Paso a Paso)

### Ejercicio 1: Eliminar un elemento (`delete`)
Queremos quitar todas las apariciones de `X` en una lista.

```prolog
% 1. Si la lista es vacía, el resultado es vacío.
borrar(_, [], []).

% 2. Si la cabeza ES lo que quiero borrar, la ignoro y sigo con la cola.
borrar(X, [X|Cola], Resultado) :-
    borrar(X, Cola, Resultado).

% 3. Si la cabeza NO es lo que quiero borrar, la conservo.
borrar(X, [Cabeza|Cola], [Cabeza|RestoResultado]) :-
    X \= Cabeza,
    borrar(X, Cola, RestoResultado).
```

### Ejercicio 2: Último elemento (`last`)
Encontrar el último ítem.

```prolog
% Caso Base: Una lista con un solo elemento. Ese es el último.
ultimo([X], X).

% Caso Recursivo: Ignoro la cabeza, el último está en la cola.
ultimo([_|Cola], X) :-
    ultimo(Cola, X).
```
