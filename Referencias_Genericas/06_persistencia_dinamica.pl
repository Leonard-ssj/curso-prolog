% ==========================================================================================
% REFERENCIA COMPLETA: PERSISTENCIA DINÁMICA
% ==========================================================================================
% Prolog permite modificar su propia base de conocimiento en tiempo de ejecución.
% Esto es fundamental para aplicaciones con "estado" (inventarios, juegos, sesiones).
%
% ÍNDICE:
% 1. Configuración (dynamic)
% 2. Operaciones CRUD (Create, Read, Update, Delete)
% 3. Persistencia en Archivos (Guardar/Cargar)
% 4. Plantilla de Gestor de Inventario
% ==========================================================================================

% ------------------------------------------------------------------------------------------
% 1. CONFIGURACIÓN
% ------------------------------------------------------------------------------------------
% Debemos declarar qué predicados serán dinámicos. Si no, Prolog lanza error al intentar modificarlos.

:- dynamic item/2.   % item(Nombre, Cantidad)
:- dynamic config/1. % config(Clave, Valor)

% Estado inicial (opcional)
item(pocion, 10).
item(espada, 1).

% ------------------------------------------------------------------------------------------
% 2. OPERACIONES CRUD EN MEMORIA
% ------------------------------------------------------------------------------------------

% CREATE (Agregar)
agregar_item(Nombre, Cantidad) :-
    % assertz agrega al final. asserta agrega al principio.
    assertz(item(Nombre, Cantidad)),
    writeln('Item agregado.').

% READ (Consultar)
ver_inventario :-
    writeln('--- INVENTARIO ---'),
    item(N, C),
    format('Item: ~w, Cantidad: ~w~n', [N, C]),
    fail. % Truco para imprimir todos
ver_inventario.

% UPDATE (Modificar = Retract + Assert)
% No existe "modificar". Hay que borrar el viejo y poner el nuevo.
actualizar_cantidad(Nombre, NuevaCantidad) :-
    item(Nombre, _), % Verificar que existe
    retract(item(Nombre, _)), % Borrar el viejo
    assertz(item(Nombre, NuevaCantidad)), % Insertar el nuevo
    writeln('Actualizado.').

% DELETE (Eliminar)
borrar_item(Nombre) :-
    retract(item(Nombre, _)),
    writeln('Eliminado.').

% DELETE ALL (Limpiar todo)
limpiar_todo :-
    retractall(item(_, _)),
    writeln('Inventario vacio.').

% ------------------------------------------------------------------------------------------
% 3. PERSISTENCIA EN ARCHIVOS
% ------------------------------------------------------------------------------------------
% Guardar el estado de la memoria en un archivo .pl para recuperarlo luego.

guardar_datos(Archivo) :-
    tell(Archivo),      % 1. Redirigir salida al archivo
    listing(item),      % 2. Escribir todos los predicados 'item'
    told,               % 3. Cerrar archivo
    writeln('Datos guardados exitosamente.').

cargar_datos(Archivo) :-
    consult(Archivo),   % Leer el archivo como código Prolog
    writeln('Datos cargados en memoria.').

% ------------------------------------------------------------------------------------------
% 4. EJEMPLO COMPLETO: CONTADOR DE VISITAS
% ------------------------------------------------------------------------------------------

:- dynamic contador/1.
contador(0). % Inicialmente 0

incrementar_contador :-
    contador(C),
    retract(contador(C)),
    C1 is C + 1,
    assertz(contador(C1)),
    format('Contador incrementado. Nuevo valor: ~w~n', [C1]).

reset_contador :-
    retractall(contador(_)),
    assertz(contador(0)),
    writeln('Contador reiniciado a 0.').
