% ==========================================================================================
% SISTEMA DE VUELOS Y RESERVAS (VERSIÓN COMPLETA)
% ==========================================================================================
% Práctica solicitada: Gestión de aerolínea con 4 listas paralelas.
% Incluye: Altas, Bajas, Consultas, Reportes y Cálculos.
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. CONFIGURACIÓN DE BASE DE DATOS DINÁMICA
% ------------------------------------------------------------------------------------------
% Definimos las 4 listas que almacenarán la información.
% Usamos listas paralelas: el índice N de 'vuelos' corresponde al índice N de 'destinos', etc.

:- dynamic vuelos/1.
:- dynamic destinos/1.
:- dynamic asientos/1.
:- dynamic reservas/1.

% Inicialización (Listas vacías al principio)
vuelos([]).
destinos([]).
asientos([]).
reservas([]).

% ------------------------------------------------------------------------------------------
% 2. MÓDULO DE ALTAS (AGREGAR INFORMACIÓN)
% ------------------------------------------------------------------------------------------

% ==========================================================================================
% UTILIDADES DE ENTRADA (INPUT HELPERS)
% ==========================================================================================
% Estas reglas permiten leer texto y numeros sin necesidad de comillas ni puntos finales.

leer_texto(Texto) :-
    read_line_to_string(user_input, String),
    atom_string(Texto, String).

leer_numero(Numero) :-
    read_line_to_string(user_input, String),
    (   number_string(Numero, String)
    ->  true
    ;   writeln('>> ERROR: Debe ingresar un numero valido.'), fail
    ).

% ------------------------------------------------------------------------------------------
% 2. MÓDULO DE ALTAS (AGREGAR INFORMACIÓN)
% ------------------------------------------------------------------------------------------

% Opción 1: Agregar Vuelo
agregar_vuelo :-
    writeln('--- 1. AGREGAR VUELO ---'),
    write('Ingrese codigo de vuelo (Ej: AM-01): '),
    leer_texto(V),
    ( V \= '' ->
        vuelos(L), retract(vuelos(L)),
        append(L, [V], NL), assertz(vuelos(NL)),
        writeln('Vuelo registrado.'),
        verificar_sincronizacion
    ;
        writeln('>> Cancelado: Codigo vacio.')
    ).

% Opción 2: Agregar Destino
agregar_destino :-
    writeln('--- 2. AGREGAR DESTINO ---'),
    write('Ingrese destino (Ej: Nueva York): '), 
    leer_texto(D),
    destinos(L), retract(destinos(L)),
    append(L, [D], NL), assertz(destinos(NL)),
    writeln('Destino registrado.'),
    verificar_sincronizacion.

% Opción 3: Agregar Asientos
agregar_asientos :-
    writeln('--- 3. AGREGAR ASIENTOS ---'),
    write('Ingrese cantidad de asientos (Ej: 50): '), 
    leer_numero(A),
    asientos(L), retract(asientos(L)),
    append(L, [A], NL), assertz(asientos(NL)),
    writeln('Asientos registrados.'),
    verificar_sincronizacion.

% Opción 4: Registrar Reservas
registrar_reservas :-
    writeln('--- 4. REGISTRAR RESERVAS ---'),
    write('Ingrese reservas realizadas (Ej: 10): '), 
    leer_numero(R),
    reservas(L), retract(reservas(L)),
    append(L, [R], NL), assertz(reservas(NL)),
    writeln('Reservas registradas.'),
    verificar_sincronizacion.

% Helper para guiar al usuario
verificar_sincronizacion :-
    vuelos(V), length(V, NV),
    destinos(D), length(D, ND),
    asientos(A), length(A, NA),
    reservas(R), length(R, NR),
    ( (NV =:= ND, ND =:= NA, NA =:= NR) ->
        writeln('>> ESTADO: Sistema sincronizado. Todo correcto.')
    ;
        writeln('>> ALERTA: Las listas estan desincronizadas.'),
        format('   Vuelos: ~w, Destinos: ~w, Asientos: ~w, Reservas: ~w~n', [NV, ND, NA, NR]),
        writeln('   Por favor, complete los datos faltantes usando las otras opciones.')
    ).

% ------------------------------------------------------------------------------------------
% 3. MÓDULO DE CONSULTAS Y REPORTES
% ------------------------------------------------------------------------------------------

% Opción 5: Mostrar todas las listas
mostrar_listas :-
    writeln('--- 5. LISTAS ACTUALES ---'),
    vuelos(V), write('Vuelos: '), writeln(V),
    destinos(D), write('Destinos: '), writeln(D),
    asientos(A), write('Asientos: '), writeln(A),
    reservas(R), write('Reservas: '), writeln(R).

% Opción 6: Verificar disponibilidad
% Recorre la lista de asientos y clasifica según la cantidad.
verificar_disponibilidad :-
    writeln('--- 6. DISPONIBILIDAD POR VUELO ---'),
    vuelos(V), asientos(A), % Necesitamos los vuelos para saber de cuál hablamos
    recorrer_disponibilidad(V, A).

recorrer_disponibilidad([], []).
recorrer_disponibilidad([V|RestoV], [A|RestoA]) :-
    clasificar_asientos(A, Estado),
    format('Vuelo ~w: ~w (~w asientos)~n', [V, Estado, A]),
    recorrer_disponibilidad(RestoV, RestoA).

% Reglas de clasificación
clasificar_asientos(A, 'Disponible') :- A >= 20.
clasificar_asientos(A, 'Pocas plazas') :- A >= 5, A < 20.
clasificar_asientos(A, 'Casi lleno') :- A < 5.

% Opción 7: Calcular total de reservas
calcular_total :-
    writeln('--- 7. TOTAL DE RESERVAS ---'),
    reservas(R),
    sumar_lista(R, Total),
    format('Total de pasajeros reservados: ~w~n', [Total]).

% Predicado auxiliar para sumar (Recursividad)
sumar_lista([], 0).
sumar_lista([H|T], Total) :-
    sumar_lista(T, SubTotal),
    Total is H + SubTotal.

% Opción 8: Reporte Consolidado
% Combina las 4 listas línea por línea.
reporte_consolidado :-
    writeln('--- 8. REPORTE CONSOLIDADO ---'),
    vuelos(V), destinos(D), asientos(A), reservas(R),
    writeln('VUELO | DESTINO | ASIENTOS | RESERVAS'),
    imprimir_reporte(V, D, A, R).

imprimir_reporte([], [], [], []).
imprimir_reporte([V|RV], [D|RD], [A|RA], [R|RR]) :-
    format('~w | ~w | ~w | ~w~n', [V, D, A, R]),
    imprimir_reporte(RV, RD, RA, RR).

% Opción 10: Buscar Vuelo
buscar_vuelo :-
    writeln('--- 10. BUSCAR VUELO ---'),
    write('Ingrese codigo a buscar: '), 
    leer_texto(Busca),
    vuelos(V), destinos(D), asientos(A), reservas(R),
    buscar_recursivo(Busca, V, D, A, R).

buscar_recursivo(_, [], [], [], []) :- writeln('Vuelo no encontrado.').
buscar_recursivo(Busca, [Busca|_], [D|_], [A|_], [R|_]) :-
    writeln('--- DATOS ENCONTRADOS ---'),
    format('Destino: ~w~nAsientos: ~w~nReservas: ~w~n', [D, A, R]).
buscar_recursivo(Busca, [_|RV], [_|RD], [_|RA], [_|RR]) :-
    buscar_recursivo(Busca, RV, RD, RA, RR).

% ------------------------------------------------------------------------------------------
% 4. MÓDULO DE BAJAS (ELIMINAR)
% ------------------------------------------------------------------------------------------

% Opción 11: Eliminar Vuelo
% Requiere eliminar el elemento de las 4 listas para mantener la sincronización.
eliminar_vuelo :-
    writeln('--- 11. ELIMINAR VUELO ---'),
    write('Codigo a eliminar: '), 
    leer_texto(Codigo),
    
    % Obtener datos actuales
    vuelos(V), destinos(D), asientos(A), reservas(R),
    
    % Verificar si existe antes de intentar borrar
    ( member(Codigo, V) ->
        % Llamar al predicado recursivo que borra en las 4 listas
        borrar_sincronizado(Codigo, V, D, A, R, NV, ND, NA, NR),
        
        % Actualizar la base de datos
        retract(vuelos(V)), assertz(vuelos(NV)),
        retract(destinos(D)), assertz(destinos(ND)),
        retract(asientos(A)), assertz(asientos(NA)),
        retract(reservas(R)), assertz(reservas(NR)),
        
        writeln('Vuelo eliminado y listas actualizadas.')
    ;
        writeln('Error: El vuelo no existe.')
    ).

% Predicado recursivo para borrar en paralelo
% Caso Base: Listas vacías -> Regresan vacías
borrar_sincronizado(_, [], [], [], [], [], [], [], []).

% Caso 1: Encontramos el vuelo (Cabeza coincide) -> Saltamos este elemento
borrar_sincronizado(X, [X|TV], [_|TD], [_|TA], [_|TR], TV, TD, TA, TR) :-
    !. % Corte para no buscar más (borra solo la primera ocurrencia)

% Caso 2: No coincide -> Conservamos las cabezas y seguimos buscando en la cola
borrar_sincronizado(X, [HV|TV], [HD|TD], [HA|TA], [HR|TR], [HV|NTV], [HD|NTD], [HA|NTA], [HR|NTR]) :-
    borrar_sincronizado(X, TV, TD, TA, TR, NTV, NTD, NTA, NTR).

% ------------------------------------------------------------------------------------------
% 5. MENÚ INTERACTIVO
% ------------------------------------------------------------------------------------------

iniciar :-
    writeln('SISTEMA DE GESTION DE AEROLINEA'),
    menu.

menu :-
    nl,
    writeln('===================================='),
    writeln('1. Agregar vuelo'),
    writeln('2. Agregar destino'),
    writeln('3. Agregar asientos disponibles'),
    writeln('4. Registrar reservas realizadas'),
    writeln('5. Mostrar todas las listas'),
    writeln('6. Verificar disponibilidad'),
    writeln('7. Calcular total de reservas'),
    writeln('8. Reporte consolidado'),
    writeln('10. Buscar vuelo'),
    writeln('11. Eliminar vuelo'),
    writeln('0. Salir'),
    writeln('===================================='),
    write('Seleccione una opcion: '),
    leer_numero(Opcion),
    ejecutar(Opcion).

ejecutar(1) :- agregar_vuelo, menu.
ejecutar(2) :- agregar_destino, menu.
ejecutar(3) :- agregar_asientos, menu.
ejecutar(4) :- registrar_reservas, menu.
ejecutar(5) :- mostrar_listas, menu.
ejecutar(6) :- verificar_disponibilidad, menu.
ejecutar(7) :- calcular_total, menu.
ejecutar(8) :- reporte_consolidado, menu.
ejecutar(10) :- buscar_vuelo, menu.
ejecutar(11) :- eliminar_vuelo, menu.
ejecutar(0) :- writeln('Saliendo del sistema...').
ejecutar(_) :- writeln('Opcion no valida, intente de nuevo.'), menu.
