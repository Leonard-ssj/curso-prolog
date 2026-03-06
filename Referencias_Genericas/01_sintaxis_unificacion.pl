% ==========================================================================================
% REFERENCIA COMPLETA: SINTAXIS BÁSICA Y UNIFICACIÓN
% ==========================================================================================
% Este archivo sirve como plantilla y guía para entender los bloques fundamentales de Prolog.
%
% ÍNDICE:
% 1. Átomos y Constantes
% 2. Variables (Nombradas, Anónimas, Singleton)
% 3. Estructuras Complejas (Functors)
% 4. Operadores de Unificación (=, is, =:=)
% 5. Escenarios de Prueba
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. ÁTOMOS Y CONSTANTES
% ------------------------------------------------------------------------------------------
% Los átomos son identificadores fijos. Representan objetos concretos.

% Sintaxis estándar (minúscula inicial):
objeto_simple(gato).
objeto_simple(juan).
objeto_simple(x).

% Sintaxis con comillas simples (para caracteres especiales o mayúsculas):
objeto_especial('San Francisco').
objeto_especial('Juan Perez').
objeto_especial('123-Calle-Falsa').

% Números (Enteros y Flotantes):
numero(42).
numero(3.14159).
numero(-10).

% ------------------------------------------------------------------------------------------
% 2. VARIABLES
% ------------------------------------------------------------------------------------------
% Las variables son marcadores de posición para valores desconocidos.
% Comienzan con MAYÚSCULA o GUION BAJO (_).

% A. Variables Nombradas: Se usan para pasar valores o conectar condiciones.
% Regla: "X es hijo de Y si Y es padre de X".
% Aquí X e Y son variables que deben unificarse con valores consistentes.
es_hijo(X, Y) :- padre(Y, X).

% B. Variable Anónima (_): "No me importa este valor".
% Regla: "Alguien es padre si tiene un hijo (cualquiera)".
% No nos importa quién es el hijo, solo que exista.
es_padre(Persona) :- padre(Persona, _).

% C. Variables Singleton (Advertencia común):
% Ocurre cuando usas una variable nombrada una sola vez en una regla.
% Ejemplo Incorrecto (genera warning):
% hermano(X, Y) :- padre(P, X).  % Y no se usa, P no se usa.
% Corrección: Usar _ si no importan, o conectarlas si sí importan.

% ------------------------------------------------------------------------------------------
% 3. ESTRUCTURAS (FUNCTORS)
% ------------------------------------------------------------------------------------------
% Permiten agrupar datos relacionados.
% Sintaxis: nombre_functor(arg1, arg2, ...).

% Ejemplo: Fechas
fecha_nacimiento(juan, fecha(12, enero, 1990)).
fecha_nacimiento(maria, fecha(25, diciembre, 1995)).

% Ejemplo: Figuras Geométricas
figura(triangulo(punto(0,0), punto(2,2), punto(4,0))).
figura(circulo(centro(5,5), radio(3))).

% ------------------------------------------------------------------------------------------
% 4. OPERADORES DE UNIFICACIÓN Y COMPARACIÓN
% ------------------------------------------------------------------------------------------

prueba_unificacion :-
    writeln('--- PRUEBAS DE UNIFICACION ---'),
    
    % A. Unificación (=): Intenta hacer que ambos lados sean idénticos.
    ( juan = juan -> writeln('1. Atomos iguales: SI') ; writeln('1. Atomos iguales: NO') ),
    ( juan = pedro -> writeln('2. Atomos distintos: SI') ; writeln('2. Atomos distintos: NO') ),
    
    % Variable libre se unifica con valor
    ( X = casa, writeln(X) -> writeln('3. Asignacion X=casa: SI') ; writeln('3. NO') ),
    
    % Estructuras
    ( fecha(D, M, A) = fecha(1, ene, 2023) -> 
        format('4. Desestructuracion: Dia=~w, Mes=~w, Anio=~w~n', [D, M, A]) 
    ; writeln('4. Fallo estructura') ),

    % B. Evaluación Aritmética (is): Calcula el resultado matemático.
    ( R is 2 + 2 -> format('5. Aritmetica: 2+2=~w~n', [R]) ; writeln('5. Fallo is') ),
    % OJO: X = 2 + 2 unifica X con la ESTRUCTURA "2+2", no con 4.
    
    % C. Comparación Aritmética (=:=): Compara valores numéricos.
    ( 4 =:= 2 + 2 -> writeln('6. Comparacion numerica: SI') ; writeln('6. NO') ),
    ( 4 =\= 5 -> writeln('7. Desigualdad numerica: SI') ; writeln('7. NO') ).

% ------------------------------------------------------------------------------------------
% 5. PLANTILLA GENÉRICA DE CONSULTA
% ------------------------------------------------------------------------------------------
% Copia y adapta esto para probar tus propios predicados.

ejecutar_pruebas :-
    writeln('Iniciando bateria de pruebas...'),
    prueba_unificacion,
    writeln('Pruebas finalizadas.').

% Para ejecutar: 
% ?- ejecutar_pruebas.
