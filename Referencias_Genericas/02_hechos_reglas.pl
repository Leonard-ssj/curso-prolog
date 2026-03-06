% ==========================================================================================
% REFERENCIA COMPLETA: HECHOS Y REGLAS (BASE DE CONOCIMIENTO)
% ==========================================================================================
% Este archivo muestra cómo modelar relaciones lógicas y construir sistemas expertos simples.
%
% ÍNDICE:
% 1. Definición de Hechos (La verdad del universo)
% 2. Definición de Reglas (Lógica condicional)
% 3. Operadores Lógicos (AND, OR, NOT)
% 4. Caso de Estudio: Sistema de Parentesco
% 5. Caso de Estudio: Sistema de Diagnóstico
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. HECHOS (FACTS)
% ------------------------------------------------------------------------------------------
% Sintaxis: predicado(argumento1, argumento2).
% Importante: Los nombres de predicados deben ser descriptivos.

% Base de datos de personas
hombre(homero).
hombre(bart).
hombre(abraham).
hombre(ned).

mujer(marge).
mujer(lisa).
mujer(maggie).
mujer(mona).

% Relaciones directas
padre(abraham, homero).
padre(homero, bart).
padre(homero, lisa).
padre(homero, maggie).
padre(ned, rod).
padre(ned, todd).

madre(mona, homero).
madre(marge, bart).
madre(marge, lisa).
madre(marge, maggie).

% ------------------------------------------------------------------------------------------
% 2. REGLAS (RULES) Y 3. OPERADORES LÓGICOS
% ------------------------------------------------------------------------------------------
% Sintaxis: Cabeza :- Cuerpo.
% , (coma) = AND
% ; (punto y coma) = OR (Aunque se prefiere usar múltiples reglas)
% \+ = NOT (Negación por fallo)

% Regla Simple: Hijo (Genérico)
es_hijo(Hijo, Padre) :- padre(Padre, Hijo).
es_hijo(Hijo, Madre) :- madre(Madre, Hijo).

% Regla con AND (,): Abuelo
% X es abuelo de Y si X es padre de Z Y Z es padre de Y
abuelo(Abuelo, Nieto) :-
    padre(Abuelo, Papa),
    padre(Papa, Nieto).

% Regla con OR implícito (Múltiples cláusulas):
% Una persona es progenitor si es padre O es madre.
progenitor(X, Y) :- padre(X, Y).
progenitor(X, Y) :- madre(X, Y).

% Regla Compuesta: Hermano
% Dos personas son hermanos si comparten el mismo padre Y la misma madre
% Y además no son la misma persona.
hermano(X, Y) :-
    padre(P, X), padre(P, Y),
    madre(M, X), madre(M, Y),
    X \= Y. % Operador de desigualdad

% Regla con NOT (\+): Hijo Único
% X es hijo único si es hijo de P y NO existe otro Y que sea hermano de X.
hijo_unico(X) :-
    padre(P, X),
    \+ (padre(P, Y), Y \= X).

% ------------------------------------------------------------------------------------------
% 4. CASO DE ESTUDIO: REGLAS RECURSIVAS DE PARENTESCO
% ------------------------------------------------------------------------------------------
% Ancestro: Relación transitiva.
% Caso Base: Un padre es un ancestro.
ancestro(X, Y) :- progenitor(X, Y).
% Caso Recursivo: El ancestro de mi padre es mi ancestro.
ancestro(X, Y) :- 
    progenitor(X, Z),
    ancestro(Z, Y).

% ------------------------------------------------------------------------------------------
% 5. CASO DE ESTUDIO: SISTEMA DE DIAGNÓSTICO (PLANTILLA GENÉRICA)
% ------------------------------------------------------------------------------------------
% Plantilla para sistemas expertos basados en reglas.

% Hechos: Síntomas del paciente actual
tiene_sintoma(paciente1, fiebre).
tiene_sintoma(paciente1, tos).
tiene_sintoma(paciente2, dolor_cabeza).

% Reglas: Enfermedades
diagnostico(Paciente, gripe) :-
    tiene_sintoma(Paciente, fiebre),
    tiene_sintoma(Paciente, tos).

diagnostico(Paciente, migraña) :-
    tiene_sintoma(Paciente, dolor_cabeza),
    \+ tiene_sintoma(Paciente, fiebre).

diagnostico(Paciente, desconocido) :-
    \+ diagnostico(Paciente, gripe),
    \+ diagnostico(Paciente, migraña).

% ------------------------------------------------------------------------------------------
% CONSULTAS DE EJEMPLO
% ------------------------------------------------------------------------------------------
% ?- hermano(bart, lisa).        -> true.
% ?- hermano(bart, bart).        -> false.
% ?- ancestro(abraham, bart).    -> true.
% ?- diagnostico(paciente1, E).  -> E = gripe.
