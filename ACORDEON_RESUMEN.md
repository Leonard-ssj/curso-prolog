# 📖 Acordeón de Prolog: Resumen Todo-en-Uno

Este documento es tu "hoja de trucos" (cheat sheet). Contiene las estructuras clave que necesitas para resolver ejercicios en Prolog.

---

## 1. Tipos de Datos y Variables

| Tipo | Descripción | Ejemplos |
| :--- | :--- | :--- |
| **Átomos** | Constantes de texto. Empiezan con **minúscula**. | `juan`, `perro`, `'San Francisco'` |
| **Números** | Enteros y decimales. | `1`, `42`, `3.14` |
| **Variables** | Huecos para valores. Empiezan con **Mayúscula** o `_`. | `X`, `Resultado`, `_` (Anónima) |
| **Estructuras** | Datos compuestos. | `fecha(12, 10, 2023)` |

---

## 2. Hechos y Reglas (Sintaxis Básica)

### Hechos
Verdades absolutas.
```prolog
es_gato(tom).
padre(homero, bart).
```

### Reglas
Verdades condicionales ("Si... entonces").
*   `:-` se lee **"SI"**.
*   `,` se lee **"Y"**.
*   `;` se lee **"O"**.

```prolog
abuelo(X, Y) :- 
    padre(X, Z),  % X es padre de Z
    padre(Z, Y).  % Y Z es padre de Y
```

---

## 3. Entrada y Salida (I/O)

Interactuar con el usuario en la consola.

```prolog
prueba_io :-
    writeln('Escribe algo terminado en punto:'), % Escribe y salta línea
    read(X),                                     % Lee input (terminar con .)
    write('Escribiste: '), write(X), nl,         % write no salta, nl sí
    format('Formateado: El valor es ~w', [X]).   % ~w es el placeholder
```

---

## 4. Condicionales (If-Then-Else)

**Estructura:** `( Condicion -> Verdad ; Falso )`
> ⚠️ **Importante:** Los paréntesis `( )` son obligatorios.

```prolog
verificar_edad(Edad) :-
    ( Edad >= 18 ->
        writeln('Mayor de edad')   % Bloque SI
    ;                              % ELSE
        writeln('Menor de edad')   % Bloque NO
    ).
```

### Anidado (Else-If)
```prolog
nota(N) :-
    ( N >= 9 -> writeln('A')
    ; N >= 7 -> writeln('B')
    ;           writeln('C')
    ).
```

---

## 5. Estructura de Menú (Patrón Recursivo)

Para mantener el programa corriendo, la regla se llama a sí misma.

```prolog
iniciar :- menu.

menu :-
    writeln('1. Opcion Uno'),
    writeln('2. Opcion Dos'),
    writeln('0. Salir'),
    read(Opc),
    opcion(Opc). % Llama al "switch"

% Switch de opciones
opcion(1) :- writeln('Elegiste 1'), menu. % Vuelve a llamar a menu
opcion(2) :- writeln('Elegiste 2'), menu. % Vuelve a llamar a menu
opcion(0) :- writeln('Adios').            % NO llama a menu -> Termina.
opcion(_) :- writeln('Invalido'), menu.   % Catch-all para errores
```

---

## 6. Listas y Recursividad

Una lista es `[Cabeza | Cola]`.
*   **Cabeza (Head):** El primer elemento.
*   **Cola (Tail):** El resto de la lista (es otra lista).

### Recorrer una lista
```prolog
imprimir_lista([]). % Caso Base: Lista vacía -> Parar.
imprimir_lista([H|T]) :-
    writeln(H),        % Procesa Cabeza
    imprimir_lista(T). % Llama con Cola
```

### Buscar en una lista
```prolog
buscar(X, [X|_]).      % Lo encontré en la cabeza.
buscar(X, [_|T]) :-    % No es la cabeza, busco en la cola.
    buscar(X, T).
```

---

## 7. Base de Datos Dinámica (Memoria)

Para guardar y modificar datos mientras corre el programa.

```prolog
:- dynamic inventario/2. % Avisar que esto cambia

% Agregar (Create)
agregar(Item, Cantidad) :-
    assertz(inventario(Item, Cantidad)).

% Borrar (Delete)
borrar(Item) :-
    retract(inventario(Item, _)).

% Modificar (Update) = Borrar viejo + Agregar nuevo
actualizar(Item, NuevaCant) :-
    retract(inventario(Item, _)),          % 1. Sacar
    assertz(inventario(Item, NuevaCant)).  % 2. Meter nuevo
```

### Consultar Todo
```prolog
listar_todo :-
    inventario(I, C),
    format('Item: ~w, Cant: ~w~n', [I, C]),
    fail.        % Falla a propósito para buscar el siguiente
listar_todo.     % Cláusula final para terminar con true
```

---

## 8. Herramientas Útiles

| Predicado | Descripción |
| :--- | :--- |
| `length(Lista, N)` | `N` es el largo de la lista. |
| `append(L1, L2, L3)` | Une L1 y L2 en L3. |
| `member(X, Lista)` | Verifica si X está en Lista. |
| `findall(X, regla(X), L)` | Guarda todas las soluciones en una lista `L`. |
| `atom_number(A, N)` | Convierte átomo a número y viceversa. |
