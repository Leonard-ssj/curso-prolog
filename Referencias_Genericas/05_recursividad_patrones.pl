% ==========================================================================================
% REFERENCIA COMPLETA: PATRONES DE RECURSIVIDAD
% ==========================================================================================
% La recursividad reemplaza a los bucles. Aquí verás los patrones más eficientes.
%
% ÍNDICE:
% 1. Recursividad Simple (Stack-Heavy)
% 2. Recursividad de Cola (Tail Recursion - Optimizada)
% 3. Recursividad con Acumuladores
% 4. Recursividad Numérica (Factorial, Fibonacci)
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. RECURSIVIDAD SIMPLE
% ------------------------------------------------------------------------------------------
% El cálculo se hace "a la vuelta" de la recursión.
% Problema: Consume memoria de pila (stack) proporcional al tamaño de la entrada.

% Sumar números de N hasta 0.
suma_simple(0, 0).
suma_simple(N, Resultado) :-
    N > 0,
    N1 is N - 1,
    suma_simple(N1, R1),    % Llamada recursiva primero
    Resultado is N + R1.    % Cálculo después

% ------------------------------------------------------------------------------------------
% 2. RECURSIVIDAD DE COLA (TAIL RECURSION)
% ------------------------------------------------------------------------------------------
% El cálculo se hace "a la ida" y se pasa en un acumulador.
% La llamada recursiva es LO ÚLTIMO que ocurre. Prolog optimiza esto (memoria constante).

% Wrapper: Inicializa el acumulador
suma_tail(N, Resultado) :- suma_acc(N, 0, Resultado).

% Caso Base: El acumulador contiene la respuesta final.
suma_acc(0, Acumulador, Acumulador).

% Paso Recursivo:
suma_acc(N, Acumulador, Resultado) :-
    N > 0,
    NuevoAcumulador is Acumulador + N,  % Cálculo primero
    N1 is N - 1,
    suma_acc(N1, NuevoAcumulador, Resultado). % Llamada al final

% ------------------------------------------------------------------------------------------
% 3. PATRÓN DE ACUMULADOR EN LISTAS (REVERSE)
% ------------------------------------------------------------------------------------------
% Invertir una lista es el ejemplo clásico de uso de acumuladores.

% Versión ingenua (Lenta, O(N^2))
reverse_lento([], []).
reverse_lento([H|T], R) :-
    reverse_lento(T, RT),
    append(RT, [H], R). % Append es costoso aquí

% Versión con Acumulador (Rápida, O(N))
reverse_rapido(L, R) :- reverse_acc(L, [], R).

reverse_acc([], Acc, Acc).
reverse_acc([H|T], Acc, R) :-
    % Poner H al principio del acumulador invierte el orden naturalmente
    reverse_acc(T, [H|Acc], R). 

% ------------------------------------------------------------------------------------------
% 4. FIBONACCI (Doble Recursión vs Cola)
% ------------------------------------------------------------------------------------------

% Versión Exponencial (¡Muy lenta para N > 30!)
fib(0, 0).
fib(1, 1).
fib(N, R) :-
    N > 1,
    N1 is N - 1, N2 is N - 2,
    fib(N1, R1), fib(N2, R2),
    R is R1 + R2.

% Versión Lineal (Tail Recursive)
fib_rapido(N, R) :- fib_acc(N, 0, 1, R).

% A = Fibonacci anterior, B = Fibonacci actual
fib_acc(0, A, _, A).
fib_acc(N, A, B, R) :-
    N > 0,
    N1 is N - 1,
    Siguiente is A + B,
    fib_acc(N1, B, Siguiente, R). % Pasamos B como nuevo A, y Siguiente como nuevo B
