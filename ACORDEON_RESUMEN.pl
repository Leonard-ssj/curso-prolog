% ==========================================================================================
% ACORDEÓN DE PROLOG: RESUMEN TODO-EN-UNO
% ==========================================================================================
% Este archivo es tu "hoja de trucos" (cheat sheet). Contiene las estructuras clave
% que necesitas para resolver los ejercicios, todo en un solo lugar.
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. TIPOS DE DATOS Y VARIABLES
% ------------------------------------------------------------------------------------------

% ATOMOS (Constantes): Empiezan con minúscula.
% juan, perro, 'San Francisco'.

% NUMEROS: 
% 1, 42, 3.14.

% VARIABLES: Empiezan con Mayúscula o _.
% X, Resultado, Lista, _ (Variable anónima: "no me importa").

% ESTRUCTURAS: nombre(arg1, arg2).
% fecha(12, 10, 2023).

% ------------------------------------------------------------------------------------------
% 2. HECHOS Y REGLAS (SINTAXIS BÁSICA)
% ------------------------------------------------------------------------------------------

% HECHO: Es una verdad absoluta.
% sintaxis: predicado(argumentos).
es_gato(tom).
padre(homero, bart).

% REGLA: Es una verdad condicional ("Si... entonces").
% sintaxis: Cabeza :- Cuerpo.
% :- se lee "SI".
% , se lee "Y".
% ; se lee "O" (evitar si es posible, mejor usar dos reglas).

abuelo(X, Y) :- 
    padre(X, Z),  % X es padre de Z
    padre(Z, Y).  % Y Z es padre de Y

% ------------------------------------------------------------------------------------------
% 3. ENTRADA Y SALIDA (BUILT-INS)
% ------------------------------------------------------------------------------------------

prueba_io :-
    writeln('Escribe algo terminado en punto:'), % Escribe y salta linea
    read(X),                                     % Lee input del usuario (terminar con .)
    write('Escribiste: '), write(X), nl,         % write no salta linea, nl sí.
    format('Formateado: El valor es ~w', [X]).   % ~w se reemplaza por la variable

% ------------------------------------------------------------------------------------------
% 4. CONDICIONALES (IF-THEN-ELSE)
% ------------------------------------------------------------------------------------------
% Estructura: ( Condicion -> Verdad ; Falso )
% IMPORTANTE: Los parentesis ( ) son obligatorios.

verificar_edad(Edad) :-
    ( Edad >= 18 ->
        writeln('Mayor de edad')   % Bloque SI
    ;                              % ELSE
        writeln('Menor de edad')   % Bloque NO
    ).

% Condicional Anidado (Else-If)
nota(N) :-
    ( N >= 9 -> writeln('A')
    ; N >= 7 -> writeln('B')
    ;           writeln('C')
    ).

% ------------------------------------------------------------------------------------------
% 5. ESTRUCTURA DE MENÚ (PATRÓN RECURSIVO)
% ------------------------------------------------------------------------------------------
% Para hacer un menú que no se cierre, la regla se llama a sí misma.

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

% ------------------------------------------------------------------------------------------
% 6. LISTAS Y RECURSIVIDAD
% ------------------------------------------------------------------------------------------
% Una lista es [Cabeza | Cola].
% Cabeza (Head): El primer elemento.
% Cola (Tail): El resto de la lista (otra lista).

% Recorrer una lista (Imprimir elementos)
imprimir_lista([]). % Caso Base: Lista vacia -> Parar.
imprimir_lista([H|T]) :-
    writeln(H),        % Procesa Cabeza
    imprimir_lista(T). % Llama con Cola

% Buscar en una lista (Member manual)
buscar(X, [X|_]).      % Lo encontré en la cabeza.
buscar(X, [_|T]) :-    % No es la cabeza, busco en la cola.
    buscar(X, T).

% ------------------------------------------------------------------------------------------
% 7. BASE DE DATOS DINÁMICA (MEMORIA)
% ------------------------------------------------------------------------------------------
% Para guardar datos mientras corre el programa.

:- dynamic inventario/2. % Avisar que esto cambia

% Agregar (Create)
agregar(Item, Cantidad) :-
    assertz(inventario(Item, Cantidad)).

% Borrar (Delete) - retract borra el primero que coincida
borrar(Item) :-
    retract(inventario(Item, _)).

% Modificar (Update) = Borrar viejo + Agregar nuevo
actualizar(Item, NuevaCant) :-
    retract(inventario(Item, _)),    % 1. Sacar
    assertz(inventario(Item, NuevaCant)). % 2. Meter nuevo

% Consultar todo (Read All) - Usa fail para forzar backtracking
listar_todo :-
    inventario(I, C),
    format('Item: ~w, Cant: ~w~n', [I, C]),
    fail. % Falla a propósito para buscar el siguiente
listar_todo. % Clausula final para terminar con true

% ------------------------------------------------------------------------------------------
% 8. HERRAMIENTAS UTILES
% ------------------------------------------------------------------------------------------
% length(Lista, N).      -> N es el largo de la lista.
% append(L1, L2, L3).    -> Une listas.
% findall(X, regla(X), L). -> Guarda todas las soluciones de regla(X) en la lista L.
% atom_number(A, N).     -> Convierte atomo a numero y viceversa.
