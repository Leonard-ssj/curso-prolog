% ==========================================
% EJEMPLO: GESTIÓN DE INVENTARIO (INTENSIVO)
% ==========================================
% Este código consolida:
% 1. Base de datos dinámica (assert/retract)
% 2. Listas
% 3. Menús recursivos
% 4. Condicionales (If-Then-Else)
% 5. Variables anónimas (_)
% ==========================================

% --- CONFIGURACIÓN DINÁMICA ---
% Definimos que 'inventario/1' puede cambiar en tiempo de ejecución.
:- dynamic inventario/1.

% Estado inicial: El inventario empieza como una lista vacía.
inventario([]).

% --- LÓGICA DE NEGOCIO ---

% Agregar un producto al inventario
agregar_producto :-
    writeln('Ingrese el nombre del producto (entre comillas simples si tiene espacios, termina con punto):'),
    read(Nombre),
    writeln('Ingrese la cantidad (numero y punto):'),
    read(Cantidad),
    
    % Recuperamos la lista actual
    inventario(ListaActual),
    
    % Verificamos si ya existe (usando member)
    ( member([Nombre, _], ListaActual) ->
        writeln('¡Error! El producto ya existe.')
    ;   % ELSE: No existe, procedemos a actualizar
        % 1. Quitamos el hecho viejo
        retract(inventario(ListaActual)),
        % 2. Creamos la nueva lista agregando el par [Nombre, Cantidad]
        append(ListaActual, [[Nombre, Cantidad]], NuevaLista),
        % 3. Insertamos el hecho nuevo
        assert(inventario(NuevaLista)),
        writeln('Producto agregado exitosamente.')
    ).

% Mostrar todo el inventario
mostrar_inventario :-
    inventario(Lista),
    ( Lista == [] ->
        writeln('El inventario esta vacio.')
    ;
        writeln('--- LISTADO DE PRODUCTOS ---'),
        imprimir_lista(Lista)
    ).

% Predicado auxiliar recursivo para imprimir
imprimir_lista([]). % Caso base: lista vacía, no hace nada
imprimir_lista([[Nombre, Cantidad] | Resto]) :-
    format('Producto: ~w | Stock: ~w~n', [Nombre, Cantidad]),
    imprimir_lista(Resto). % Llamada recursiva con la cola

% Buscar un producto específico
buscar_producto :-
    writeln('Nombre a buscar:'),
    read(Nombre),
    inventario(Lista),
    
    % Usamos member para buscar el patrón [Nombre, Cantidad]
    % Note el uso de Variable Anónima (_) en member si solo quisiéramos checar existencia,
    % pero aquí necesitamos 'Cant' para mostrarla, así que usamos variable nombrada.
    ( member([Nombre, Cant], Lista) ->
        format('ENCONTRADO: Hay ~w unidades de ~w.~n', [Cant, Nombre]),
        verificar_stock(Cant) % Llamamos a una regla condicional extra
    ;
        writeln('Producto no encontrado.')
    ).

% Ejemplo de condicionales anidados
verificar_stock(Cant) :-
    ( Cant =< 0 ->
        writeln('ALERTA: Sin stock.')
    ; Cant < 5 ->
        writeln('ADVERTENCIA: Stock bajo.')
    ;
        writeln('Estado: Stock saludable.')
    ).

% --- MENÚ DE USUARIO ---

iniciar :-
    writeln('Bienvenido al Sistema de Inventario'),
    menu.

menu :-
    nl, % Nueva linea
    writeln('=== MENU PRINCIPAL ==='),
    writeln('1. Agregar Producto'),
    writeln('2. Ver Inventario'),
    writeln('3. Buscar Producto'),
    writeln('0. Salir'),
    write('Seleccione una opcion: '),
    read(Opcion),
    ejecutar_opcion(Opcion).

% Despachador de opciones
ejecutar_opcion(1) :- agregar_producto, menu.
ejecutar_opcion(2) :- mostrar_inventario, menu.
ejecutar_opcion(3) :- buscar_producto, menu.

% Caso de salida (NO llama a menu)
ejecutar_opcion(0) :- 
    writeln('Guardando datos... (simulado)'),
    writeln('Saliendo del sistema. Hasta luego!').

% Manejo de opción inválida (Variable anónima _ atrapa cualquier otro valor)
ejecutar_opcion(_) :-
    writeln('Opcion no reconocida. Intente de nuevo.'),
    menu.
