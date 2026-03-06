% ==========================================================================================
% REFERENCIA COMPLETA: LISTAS Y SUS OPERACIONES
% ==========================================================================================
% Las listas son la estructura de datos principal en Prolog.
% Se representan como [Cabeza | Cola].
%
% ÍNDICE:
% 1. Definición y Unificación (Head/Tail)
% 2. Operaciones Básicas (Member, Length, Append)
% 3. Operaciones de Transformación (Map/Transformar)
% 4. Operaciones de Filtrado
% 5. Operaciones de Agregación (Findall)
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. DESCOMPOSICIÓN DE LISTAS
% ------------------------------------------------------------------------------------------

% Predicado para mostrar cabeza y cola
analizar_lista([]) :- writeln('La lista esta vacia.').
analizar_lista([Cabeza|Cola]) :-
    format('Cabeza: ~w | Cola: ~w~n', [Cabeza, Cola]).

% Prueba:
% ?- analizar_lista([a, b, c]). 
% Cabeza: a | Cola: [b, c]

% ------------------------------------------------------------------------------------------
% 2. OPERACIONES BÁSICAS (Implementación Manual)
% ------------------------------------------------------------------------------------------

% A. MI_MEMBER: Verificar si un elemento está en la lista.
% Caso Base: Es la cabeza.
mi_member(X, [X|_]).
% Caso Recursivo: Está en la cola.
mi_member(X, [_|Cola]) :- mi_member(X, Cola).

% B. MI_LENGTH: Contar elementos.
% Caso Base: Lista vacía tiene longitud 0.
mi_length([], 0).
% Caso Recursivo: 1 + longitud del resto.
mi_length([_|Cola], N) :-
    mi_length(Cola, N1),
    N is N1 + 1.

% C. MI_APPEND: Concatenar dos listas.
% Caso Base: Concatenar vacía con L da L.
mi_append([], L, L).
% Caso Recursivo: La cabeza de la primera pasa al resultado.
mi_append([H|T1], L2, [H|T3]) :-
    mi_append(T1, L2, T3).

% ------------------------------------------------------------------------------------------
% 3. TRANSFORMACIÓN (MAP)
% ------------------------------------------------------------------------------------------
% Aplicar una operación a cada elemento. Ej: Sumar 1.

sumar_uno_lista([], []).
sumar_uno_lista([H|T], [H1|T1]) :-
    H1 is H + 1,
    sumar_uno_lista(T, T1).

% ------------------------------------------------------------------------------------------
% 4. FILTRADO (FILTER)
% ------------------------------------------------------------------------------------------
% Seleccionar elementos que cumplan una condición. Ej: Solo pares.

filtrar_pares([], []).
% Caso 1: Cumple la condición (Es par) -> Se queda.
filtrar_pares([H|T], [H|T_Filtrada]) :-
    0 is H mod 2,
    filtrar_pares(T, T_Filtrada).
% Caso 2: No cumple (Es impar) -> Se descarta.
filtrar_pares([H|T], T_Filtrada) :-
    1 is H mod 2,
    filtrar_pares(T, T_Filtrada).

% ------------------------------------------------------------------------------------------
% 5. AGREGACIÓN (FINDALL)
% ------------------------------------------------------------------------------------------
% Herramienta poderosa para convertir soluciones de backtracking en una lista.

% Base de conocimientos para ejemplo
alumno(juan, 8).
alumno(ana, 9).
alumno(pedro, 4).
alumno(luis, 7).

obtener_aprobados(ListaAprobados) :-
    % findall(Template, Goal, Bag)
    findall(Nombre, (alumno(Nombre, Nota), Nota >= 6), ListaAprobados).

% Obtener promedio de notas
calcular_promedio_curso(Promedio) :-
    findall(Nota, alumno(_, Nota), ListaNotas),
    sum_list(ListaNotas, Suma), % Predicado nativo (o usar mi_sum_list)
    length(ListaNotas, Cantidad),
    Promedio is Suma / Cantidad.

% Implementación manual de suma (para referencia)
mi_suma_lista([], 0).
mi_suma_lista([H|T], Total) :-
    mi_suma_lista(T, SubTotal),
    Total is H + SubTotal.
