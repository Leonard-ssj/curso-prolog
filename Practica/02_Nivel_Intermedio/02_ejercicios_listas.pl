% ==========================================
% EJERCICIOS INTERMEDIOS: LISTAS Y RECURSIÓN
% ==========================================
% Objetivo: Practicar manipulación de listas sin usar predicados
% predefinidos como sum_list o max_list.

% 1. SUMA DE LISTA
% Escribe un predicado sumar_lista(L, Total).
% sumar_lista([1, 2, 3], R) -> R = 6.

sumar_lista([], 0).
sumar_lista([H|T], Total) :-
    sumar_lista(T, SubTotal),
    Total is H + SubTotal.

% 2. FILTRAR PARES
% Escribe filtrar_pares(Lista, Pares).
% filtrar_pares([1, 2, 3, 4], R) -> R = [2, 4].

filtrar_pares([], []).
filtrar_pares([H|T], [H|R]) :- % Caso: Es par, lo guardamos
    0 is H mod 2,
    filtrar_pares(T, R).
filtrar_pares([H|T], R) :-     % Caso: No es par, lo saltamos
    1 is H mod 2,
    filtrar_pares(T, R).

% 3. CONTAR OCURRENCIAS
% contar(Elemento, Lista, N).
% contar(a, [a, b, a, c], R) -> R = 2.

contar(_, [], 0).
contar(X, [X|T], N) :- % Coincide
    contar(X, T, N1),
    N is N1 + 1.
contar(X, [Y|T], N) :- % No coincide
    X \= Y,
    contar(X, T, N).

% 4. PALÍNDROMO
% Una lista es palíndromo si es igual a su inversa.
% es_palindromo([a,n,a]). -> true.

es_palindromo(L) :-
    reverse(L, L). % Usamos reverse nativo por simplicidad, o implementa el tuyo.

% 5. MÁXIMO DE UNA LISTA
% Encontrar el número mayor.

maximo([X], X). % Caso base: lista de 1 elemento, ese es el maximo.
maximo([H|T], M) :-
    maximo(T, MaxResto),
    (H > MaxResto -> M = H ; M = MaxResto).

% --- PRUEBAS ---
% ?- sumar_lista([10, 20, 5], X).
% ?- filtrar_pares([1, 2, 3, 4, 5, 6], P).
% ?- contar(a, [a, b, a, a, c], C).
