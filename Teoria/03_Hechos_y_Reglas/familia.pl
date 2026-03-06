% =============================================
% BASE DE CONOCIMIENTO: FAMILIA SIMPSON
% =============================================
% Este archivo sirve para practicar consultas básicas,
% unificación y reglas simples.
% =============================================

% --- HECHOS (Datos) ---

% Relaciones de Padre
padre(abraham, homero).
padre(clancy, marge).
padre(homero, bart).
padre(homero, lisa).
padre(homero, maggie).

% Relaciones de Madre
madre(mona, homero).
madre(jacqueline, marge).
madre(marge, bart).
madre(marge, lisa).
madre(marge, maggie).

% Géneros (útil para reglas como 'abuela' vs 'abuelo')
hombre(abraham).
hombre(clancy).
hombre(homero).
hombre(bart).

mujer(mona).
mujer(jacqueline).
mujer(marge).
mujer(lisa).
mujer(maggie).

% --- REGLAS (Lógica) ---

% Abuelo: El padre de mi padre O el padre de mi madre.
abuelo(Abuelo, Nieto) :-
    padre(Abuelo, Progenitor),
    (padre(Progenitor, Nieto) ; madre(Progenitor, Nieto)).

% Abuela: La madre de mi padre O la madre de mi madre.
abuela(Abuela, Nieto) :-
    madre(Abuela, Progenitor),
    (padre(Progenitor, Nieto) ; madre(Progenitor, Nieto)).

% Hermano/Hermana (simplificado: comparte al menos un progenitor)
% Nota: X \= Y asegura que alguien no sea hermano de sí mismo.
hermano_de(X, Y) :-
    padre(P, X), padre(P, Y),
    X \= Y.

% Tío: Hermano del padre o de la madre
tio(Tio, Sobrino) :-
    hermano_de(Tio, Progenitor),
    (padre(Progenitor, Sobrino) ; madre(Progenitor, Sobrino)).

% Ancestro (Recursividad Básica)
% Caso Base: Un padre es un ancestro.
ancestro(X, Y) :- padre(X, Y).
ancestro(X, Y) :- madre(X, Y).

% Caso Recursivo: El ancestro de mi padre es mi ancestro.
ancestro(X, Y) :- 
    (padre(Z, Y) ; madre(Z, Y)),
    ancestro(X, Z).
