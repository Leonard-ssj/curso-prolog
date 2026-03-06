% =======================================================
% SISTEMA DE GESTIÓN DE VUELOS Y RESERVAS (COMENTADO A DETALLE)
% =======================================================
% Este archivo implementa un sistema CRUD (Create, Read, Update, Delete)
% simulado en memoria usando listas dinámicas.
%
% CONCEPTOS CLAVE:
% 1. dynamic: Permite modificar hechos en tiempo de ejecución.
% 2. Listas paralelas: Usamos 4 listas separadas que deben mantenerse sincronizadas
%    por índice (el primer elemento de vuelos corresponde al primero de destinos, etc.)
% 3. Recursividad: Para recorrer las listas y generar reportes.
% =======================================================

% Declaramos que estos predicados van a cambiar.
% Inicialmente tienen aridad 1 porque guardarán UNA lista cada uno.
:- dynamic vuelos/1.
:- dynamic destinos/1.
:- dynamic asientos/1.
:- dynamic reservas/1.

% Inicialización: Hechos base con listas vacías.
% Esto es necesario para que la primera vez que llamemos a 'vuelos(L)', L sea [].
vuelos([]).
destinos([]).
asientos([]).
reservas([]).

% =======================================================
% 1. AGREGAR DATOS (CREATE)
% =======================================================

% Predicado para agregar un vuelo.
agregar_vuelo :-
    writeln('--- AGREGAR VUELO ---'),
    writeln('Ingrese codigo de vuelo (ej. am123, termina con punto):'),
    read(V), % Leemos el input del usuario en la variable V.
    
    % PASO CRITICO: Actualización de la lista
    vuelos(L),              % 1. Recuperamos la lista actual (ej. [v1, v2])
    retract(vuelos(L)),     % 2. La borramos de la memoria.
    append(L, [V], NL),     % 3. Creamos una NUEVA lista agregando V al final.
    assert(vuelos(NL)),     % 4. Guardamos la nueva lista.
    
    writeln('Vuelo agregado exitosamente.').

% (La lógica es idéntica para los otros campos, manteniendo la estructura paralela)
agregar_destino :-
    writeln('--- AGREGAR DESTINO ---'),
    writeln('Ingrese destino (ej. cancun, termina con punto):'),
    read(D),
    destinos(L), retract(destinos(L)),
    append(L, [D], NL), assert(destinos(NL)),
    writeln('Destino agregado.').

agregar_asientos :-
    writeln('--- AGREGAR ASIENTOS ---'),
    writeln('Ingrese cantidad de asientos (numero y punto):'),
    read(A),
    asientos(L), retract(asientos(L)),
    append(L, [A], NL), assert(asientos(NL)),
    writeln('Asientos agregados.').

registrar_reservas :-
    writeln('--- REGISTRAR RESERVAS ---'),
    writeln('Ingrese cantidad de reservas hechas (numero y punto):'),
    read(R),
    reservas(L), retract(reservas(L)),
    append(L, [R], NL), assert(reservas(NL)),
    writeln('Reservas registradas.').

% =======================================================
% 2. MOSTRAR LISTAS (READ)
% =======================================================
% Simplemente consultamos el hecho y lo imprimimos.

mostrar_todo :-
    writeln('--- ESTADO ACTUAL DEL SISTEMA ---'),
    vuelos(V), writeln('Vuelos:'), writeln(V),
    destinos(D), writeln('Destinos:'), writeln(D),
    asientos(A), writeln('Asientos disp.:'), writeln(A),
    reservas(R), writeln('Reservas hechas:'), writeln(R).

% =======================================================
% 3. VERIFICAR DISPONIBILIDAD (LÓGICA DE NEGOCIO)
% =======================================================
% Aquí aplicamos reglas para interpretar los datos.
% Recorremos la lista de asientos y damos un diagnóstico por cada uno.

verificar_disponibilidad :-
    writeln('--- ANALISIS DE DISPONIBILIDAD ---'),
    asientos(ListaAsientos),    % Obtenemos la lista [20, 4, 15...]
    analizar_asientos(ListaAsientos). % Llamamos al worker recursivo

% Caso Base: Si la lista está vacía, terminamos.
analizar_asientos([]).

% Caso Recursivo:
% [A|Resto] -> Descomponemos la lista. 'A' es el primero, 'Resto' los demás.
analizar_asientos([A|Resto]) :-
    clasificar(A, Estado), % Llamamos a una regla auxiliar para decidir el texto
    format('Asientos: ~w -> Estado: ~w~n', [A, Estado]),
    analizar_asientos(Resto). % RECURSIÓN: Repetimos con el resto de la lista.

% Reglas auxiliares (Condicionales lógicos)
% Prolog probará estas reglas en orden hasta que una sea verdadera.
clasificar(A, 'Disponible') :- A >= 20.
clasificar(A, 'Pocas plazas') :- A >= 5, A < 20.
clasificar(A, 'Casi lleno') :- A < 5.

% =======================================================
% 4. CALCULAR TOTAL (REDUCCIÓN)
% =======================================================
% Sumar todos los elementos de la lista de reservas.

calcular_total_reservas :-
    reservas(Lista),
    sumar_lista(Lista, Total), % Predicado recursivo que devuelve Total
    writeln('--- TOTAL GENERAL DE RESERVAS ---'),
    writeln(Total).

% Caso Base: La suma de nada es 0.
sumar_lista([], 0).

% Caso Recursivo:
% Total = Cabeza + SumaDelResto
sumar_lista([Cabeza|Cola], Total) :-
    sumar_lista(Cola, SubTotal), % 1. Primero calculamos la suma de la cola (baja hasta el final)
    Total is Cabeza + SubTotal.  % 2. Luego sumamos al "volver" de la recursión.

% =======================================================
% 5. REPORTE CONSOLIDADO (RECURSIÓN PARALELA)
% =======================================================
% El reto aquí es recorrer 4 listas al mismo tiempo.
% Asumimos que están sincronizadas (tienen el mismo tamaño).

generar_reporte :-
    writeln('--- REPORTE CONSOLIDADO ---'),
    % Obtenemos las 4 listas
    vuelos(V), destinos(D), asientos(A), reservas(R),
    imprimir_reporte(V, D, A, R).

% Caso Base: Todas las listas se vaciaron a la vez.
imprimir_reporte([], [], [], []).

% Caso Recursivo:
% Descomponemos las 4 listas simultáneamente.
% V|RV -> Cabeza Vuelo, Resto Vuelos
% D|RD -> Cabeza Destino, Resto Destinos...
imprimir_reporte([V|RV], [D|RD], [A|RA], [R|RR]) :-
    % Imprimimos la fila actual
    format('Vuelo: ~w | Destino: ~w | Asientos: ~w | Reservas: ~w~n', [V, D, A, R]),
    % Llamada recursiva con los RESTOS de todas las listas
    imprimir_reporte(RV, RD, RA, RR).

% =======================================================
% 6. BUSCAR VUELO (BÚSQUEDA)
% =======================================================

buscar_vuelo :-
    writeln('Ingrese codigo de vuelo a buscar:'),
    read(Busca),
    vuelos(V), destinos(D), asientos(A), reservas(R),
    buscar_en_listas(Busca, V, D, A, R).

% Caso 1: Lista vacía -> No encontrado
buscar_en_listas(_, [], [], [], []) :-
    writeln('Vuelo no encontrado.').

% Caso 2: ENCONTRADO (La cabeza coincide con Busca)
% Usamos [Busca|_] para decir "Si la cabeza es igual a lo que busco..."
% Capturamos los datos correspondientes en Dest, Asi, Res.
buscar_en_listas(Busca, [Busca|_], [Dest|_], [Asi|_], [Res|_]) :-
    writeln('--- VUELO ENCONTRADO ---'),
    format('Destino: ~w, Asientos: ~w, Reservas: ~w~n', [Dest, Asi, Res]).
    % Nota: Aquí NO llamamos a la recursión, porque ya lo encontramos y queremos parar.

% Caso 3: NO coincide -> Seguir buscando
buscar_en_listas(Busca, [_|RV], [_|RD], [_|RA], [_|RR]) :-
    buscar_en_listas(Busca, RV, RD, RA, RR).

% =======================================================
% MENÚ INTERACTIVO
% =======================================================
% Bucle infinito controlado por recursión.

iniciar :-
    writeln('SISTEMA DE AEROLINEA PROLOG'),
    menu.

menu :-
    nl, % Nueva linea
    writeln('1. Agregar Vuelo'),
    writeln('2. Agregar Destino'),
    writeln('3. Agregar Asientos Disponibles'),
    writeln('4. Registrar Reservas'),
    writeln('5. Mostrar Todo'),
    writeln('6. Verificar Disponibilidad'),
    writeln('7. Total de Reservas'),
    writeln('8. Reporte Consolidado'),
    writeln('9. Buscar Vuelo'),
    writeln('0. Salir'),
    write('Opcion: '),
    read(Op),
    ejecutar(Op).

% Despachador de opciones
ejecutar(1) :- agregar_vuelo, menu. % Llama a la acción y LUEGO vuelve al menú
ejecutar(2) :- agregar_destino, menu.
ejecutar(3) :- agregar_asientos, menu.
ejecutar(4) :- registrar_reservas, menu.
ejecutar(5) :- mostrar_todo, menu.
ejecutar(6) :- verificar_disponibilidad, menu.
ejecutar(7) :- calcular_total_reservas, menu.
ejecutar(8) :- generar_reporte, menu.
ejecutar(9) :- buscar_vuelo, menu.
ejecutar(0) :- writeln('Saliendo...'). % Caso Base del menú: NO llama a menu, así que termina.
ejecutar(_) :- writeln('Opcion invalida'), menu. % Catch-all para errores.
