% ==========================================================================================
% REFERENCIA COMPLETA: CONTROL DE FLUJO E INTERACCIÓN
% ==========================================================================================
% Prolog es declarativo, pero a veces necesitamos controlar CÓMO se ejecuta.
% Este archivo cubre condicionales, cortes, entrada/salida y menús interactivos.
%
% ÍNDICE:
% 1. Condicionales (If-Then-Else)
% 2. El Corte (Cut !)
% 3. Entrada y Salida (I/O)
% 4. Plantilla de Menú Recursivo
% 5. Bucles "Failure-Driven" (Para imprimir reportes)
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. CONDICIONALES (IF-THEN-ELSE)
% ------------------------------------------------------------------------------------------
% Sintaxis: ( Condicion -> Verdad ; Falso )
% IMPORTANTE: Los paréntesis son obligatorios para agrupar el bloque.

% Ejemplo: Calificador de edad
clasificar_edad(Edad, Tipo) :-
    ( Edad < 12 ->
        Tipo = nino
    ; Edad < 18 ->  % Else-If anidado
        Tipo = adolescente
    ; Edad < 65 ->  % Else-If anidado
        Tipo = adulto
    ;               % Else final
        Tipo = mayor
    ).

% Prueba:
% ?- clasificar_edad(10, T). -> T = nino.
% ?- clasificar_edad(20, T). -> T = adulto.

% ------------------------------------------------------------------------------------------
% 2. EL CORTE (CUT !)
% ------------------------------------------------------------------------------------------
% El símbolo ! detiene el backtracking. Dice "Si llegaste aquí, no busques más alternativas".

% Ejemplo: Máximo de dos números (Optimizado con corte)
max(X, Y, X) :- X >= Y, !. % Si X >= Y, el resultado es X. ¡Y NO BUSQUES MÁS!
max(_, Y, Y).              % Si falló la anterior, el resultado es Y.

% Sin el corte, Prolog intentaría la segunda regla incluso si la primera fue cierta
% (aunque fallaría la condición implícita, es ineficiente).

% ------------------------------------------------------------------------------------------
% 3. ENTRADA Y SALIDA (I/O)
% ------------------------------------------------------------------------------------------

saludo_interactivo :-
    writeln('--- PROGRAMA DE SALUDO ---'),
    write('Cual es tu nombre? (escribe entre comillas simples y punto al final): '),
    read(Nombre),  % Lee un término Prolog. Ej: 'Juan'.
    format('Hola, ~w! Bienvenido.~n', [Nombre]).

% ------------------------------------------------------------------------------------------
% 4. PLANTILLA DE MENÚ RECURSIVO
% ------------------------------------------------------------------------------------------
% Patrón estándar para mantener un programa en ejecución.

iniciar_menu :-
    writeln('Iniciando sistema...'),
    menu_principal.

menu_principal :-
    nl,
    writeln('=== MENU PRINCIPAL ==='),
    writeln('1. Opcion Uno (Imprimir fecha)'),
    writeln('2. Opcion Dos (Calcular cuadrado)'),
    writeln('0. Salir'),
    write('Seleccione opcion: '),
    read(Opcion),
    procesar_opcion(Opcion).

% Caso de Salida (Base de la recursión):
% NO llama a menu_principal de nuevo, rompiendo el bucle.
procesar_opcion(0) :-
    writeln('Saliendo del sistema. Adios!').

% Opciones Activas (Llaman a menu_principal al final):
procesar_opcion(1) :-
    get_time(T), stamp_date_time(T, Fecha, local),
    format('Fecha y hora: ~w~n', [Fecha]),
    menu_principal. % Recursión

procesar_opcion(2) :-
    write('Ingrese numero: '), read(N),
    R is N * N,
    format('El cuadrado es: ~w~n', [R]),
    menu_principal. % Recursión

% Manejo de Error (Catch-all):
procesar_opcion(_) :-
    writeln('ERROR: Opcion no valida.'),
    menu_principal. % Recursión para dar otra oportunidad

% ------------------------------------------------------------------------------------------
% 5. BUCLES IMPULSADOS POR FALLO (FAILURE-DRIVEN LOOPS)
% ------------------------------------------------------------------------------------------
% Útil para "imprimir todos" los elementos de la base de conocimiento sin usar listas.

% Datos de prueba
producto(pan).
producto(leche).
producto(huevos).

listar_productos :-
    writeln('--- LISTA DE PRODUCTOS ---'),
    producto(P),    % Encuentra un producto
    writeln(P),     % Lo imprime
    fail.           % Falla forzosamente para provocar backtracking y buscar el siguiente
listar_productos.   % Cláusula final vacía para que el predicado termine con true.
