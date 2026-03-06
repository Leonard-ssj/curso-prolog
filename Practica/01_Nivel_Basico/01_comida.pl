% ==========================================
% EJERCICIOS NIVEL BÁSICO: HECHOS Y CONSULTAS
% ==========================================
% Objetivo: Definir una base de conocimiento sobre "Comida y Bebida"
% y realizar consultas simples.

% 1. Define hechos para 'comida(X)' (ej. pizza, hamburguesa, ensalada).
comida(pizza).
comida(hamburguesa).
comida(ensalada).
comida(pasta).
comida(tacos).

% 2. Define hechos para 'bebida(X)' (ej. agua, refresco, vino).
bebida(agua).
bebida(refresco).
bebida(vino).
bebida(cerveza).

% 3. Define hechos 'caloria(X, Cantidad)' para cada comida.
caloria(pizza, 800).
caloria(hamburguesa, 600).
caloria(ensalada, 200).
caloria(pasta, 500).
caloria(tacos, 400).

% 4. Escribe una regla 'comida_sana(X)' que sea verdad si 
%    X es comida Y sus calorías son menores a 450.
comida_sana(X) :-
    comida(X),
    caloria(X, C),
    C < 450.

% 5. Escribe una regla 'combo(C, B)' que sugiera una comida y una bebida.
%    Si la comida es sana, la bebida debe ser agua.
%    Si la comida NO es sana, la bebida puede ser cualquiera.

combo(C, B) :-
    comida_sana(C),
    B = agua.

combo(C, B) :-
    comida(C),
    \+ comida_sana(C), % \+ significa NOT
    bebida(B).

% --- INSTRUCCIONES PARA PROBAR ---
% 1. Carga este archivo.
% 2. Pregunta: ?- comida_sana(X).
% 3. Pregunta: ?- combo(tacos, B).
% 4. Pregunta: ?- combo(pizza, B).
