# Manejo de Memoria: Persistencia y Dinamismo

Hasta ahora, todo lo que hemos visto es **estático**. Escribes el código, lo cargas, y no cambia. Si dices que `juan` es padre de `pepe`, lo será para siempre durante la ejecución.

Pero, ¿y si quieres hacer un programa que aprenda? ¿O un sistema de inventario donde el stock baja? ¿O el sistema de vuelos donde se reservan asientos?

Necesitamos una **Base de Datos Dinámica**.

---

## 1. El Concepto de Estado en un Mundo Sin Variables Mutables

En Java, si quieres cambiar el saldo de una cuenta, haces `saldo = saldo - 100`.
En Prolog, las variables NO cambian. `Saldo` es 500 y siempre será 500 en esa regla.

Para simular cambio de estado, tenemos dos opciones:
1.  **Recursividad con Argumentos:** Pasar el nuevo estado a la siguiente llamada recursiva (como vimos en Tail Recursion). Esto es limpio y funcional.
2.  **Base de Datos Dinámica:** Modificar literalmente los hechos del programa en tiempo de ejecución. Esto es "sucio" (efecto secundario) pero muy útil para simular una base de datos global.

---

## 2. La Directiva `dynamic`

Para poder modificar un predicado, primero debes pedir permiso a Prolog. Si no, te dará un error de permiso denegado (Prolog protege su código por defecto).

```prolog
% Aviso: "Voy a agregar y borrar hechos de tipo 'stock' con 2 argumentos"
:- dynamic stock/2.
```

---

## 3. Las Herramientas de Cirugía: `assert` y `retract`

### A. `assertz(Hecho)` - Agregar al final
Escribe un nuevo hecho en la memoria.
*   `assertz(stock(manzanas, 10)).`
    Ahora Prolog sabe que hay 10 manzanas.

### B. `asserta(Hecho)` - Agregar al principio
Igual, pero lo pone al inicio de la lista de hechos. Útil si quieres que ese hecho se encuentre primero.

### C. `retract(Hecho)` - Eliminar
Busca en la memoria un hecho que coincida (unifique) y lo borra.
*   `retract(stock(manzanas, 10)).` -> Borra exactamente ese.
*   `retract(stock(manzanas, _)).` -> Borra cualquier stock de manzanas, sin importar la cantidad.
*   **Nota:** Solo borra EL PRIMERO que encuentra. Si hay duplicados, necesitas llamar a retract varias veces (o usar `retractall`).

### D. `retractall(Hecho)` - Eliminar Todo
Borra todos los hechos que coincidan.
*   `retractall(stock(_, _)).` -> ¡Borra todo el inventario! Peligroso pero útil para reiniciar.

---

## 4. Patrón de Actualización (Update)

Como no existe "modificar", actualizar un dato es un proceso de tres pasos:
1.  **Leer** el valor actual.
2.  **Borrar** el hecho viejo.
3.  **Escribir** el hecho nuevo.

### Ejemplo: Vender un producto

```prolog
:- dynamic stock/2.

% Estado inicial
stock(tv, 5).

vender(Producto) :-
    % 1. Verificar si hay stock y capturar la cantidad actual (C)
    stock(Producto, C),
    C > 0,
    
    % 2. Calcular la nueva cantidad
    NuevaC is C - 1,
    
    % 3. Transacción atómica (Borrar viejo, Poner nuevo)
    retract(stock(Producto, C)),
    assertz(stock(Producto, NuevaC)),
    
    writeln('Venta realizada.').
```

**¿Qué pasa si falla en medio?**
Si `retract` funciona pero luego el programa falla antes de `assertz`, ¡perdiste el dato! El producto desaparece del universo. Por eso hay que ser cuidadoso con el orden lógico.

---

## 5. Persistencia (Guardar en disco)

Todo lo que haces con `assert` vive en la memoria RAM. Si cierras Prolog (`halt.`), tus cambios se esfuman.
Para guardarlos, necesitamos escribir en un archivo.

### Escribir (`tell`, `listing`, `told`)

```prolog
guardar_bd :-
    tell('mi_base_datos.pl'),  % 1. Redirige la salida a un archivo
    listing(stock),            % 2. Imprime todos los hechos 'stock' en formato código
    told,                      % 3. Cierra el archivo y restaura la salida a pantalla
    writeln('Datos guardados.').
```

### Leer (`consult`)
Para recuperar los datos, simplemente cargamos el archivo como cualquier script de Prolog.
```prolog
cargar_bd :-
    ['mi_base_datos.pl'],
    writeln('Datos cargados.').
```

---

## 6. Ejemplo: Sistema de Notas de Alumnos

```prolog
:- dynamic nota/2. % nota(Alumno, Calificacion)

registrar_nota(Alumno, N) :-
    % Si ya tiene nota, la actualizamos
    ( nota(Alumno, _) ->
        retract(nota(Alumno, _)),
        assertz(nota(Alumno, N)),
        writeln('Nota actualizada.')
    ; 
    % Si no, la creamos
        assertz(nota(Alumno, N)),
        writeln('Nota registrada.')
    ).

promedio_curso(P) :-
    findall(N, nota(_, N), ListaNotas), % Recolectar todas las notas en una lista
    sumar_lista(ListaNotas, Suma),      % (Asumiendo que tienes un predicado sumar)
    length(ListaNotas, Cantidad),
    Cantidad > 0,
    P is Suma / Cantidad.
```
Este ejemplo combina `dynamic`, `condicionales`, `findall` y aritmética. Es el núcleo de cualquier aplicación de gestión en Prolog.
