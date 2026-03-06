# Variables y Unificación: El Corazón de Prolog

Si vienes de Java, C o Python, lo primero que debes hacer es **olvidar** lo que sabes sobre variables.

En la programación imperativa:
*   Una variable es una **caja en la memoria**.
*   `x = 5` significa "ve a la caja llamada x y mete el número 5".
*   Más tarde, `x = 10` significa "saca el 5 y mete un 10". **(Destructivo)**

En Prolog (Programación Lógica):
*   Una variable es una **incógnita en una ecuación**.
*   `X = 5` significa "Para que esto sea verdad, X debe ser 5".
*   Más tarde, decir `X = 10` es imposible si X ya es 5. Sería una contradicción (5 no es igual a 10). **(Inmutable dentro de su ámbito)**

---

## 1. Analogía: El Formulario o El Sudoku

Imagina que estás llenando un formulario oficial o resolviendo un Sudoku.

*   Una **Variable no instanciada** (libre) es una casilla en blanco. Puedes escribir cualquier cosa en ella (siempre que respete las reglas).
*   Una **Variable instanciada** (ligada) es una casilla que ya tiene un número escrito con tinta permanente. Ya no puedes cambiarlo.
*   La **Unificación** es el proceso de verificar si lo que quieres escribir en la casilla es válido.

Si tienes la casilla `[ _ ]` y dices "quiero que sea un 5", la unificación tiene éxito y la casilla se convierte en `[ 5 ]`.
Si luego dices "quiero que esa misma casilla sea un 7", la unificación falla porque `[ 5 ]` no es `[ 7 ]`.

---

## 2. Tipos de Variables en Prolog

### A. Variables Nombradas
Empiezan con una **Letra Mayúscula** o un guion bajo seguido de letras `_Nombre`.
*   Ejemplos: `X`, `Resultado`, `Persona`, `_G123`.
*   **Alcance (Scope):** Solo existen dentro de la regla donde se definen. La `X` de la regla `abuelo` no tiene NADA que ver con la `X` de la regla `tio`.

### B. La Variable Anónima (`_`)
Es un guion bajo solitario.
*   **Significado:** "Hay algo aquí, pero no me importa qué es".
*   **Magia:** Cada `_` es una variable **diferente** y única.

Ejemplo:
`pareja(_, _).`
Esto significa "Una pareja son dos cosas cualesquiera". Pueden ser `pareja(juan, maria)` o `pareja(a, b)`. No obligamos a que sean iguales.

Si escribiéramos:
`pareja(X, X).`
Estaríamos forzando a que los dos elementos sean **el mismo**. `pareja(juan, juan)` funcionaría, pero `pareja(juan, maria)` fallaría.

---

## 3. El Algoritmo de Unificación

La unificación es el mecanismo que usa Prolog para resolver las preguntas. Se denota con el operador `=`.
¡Cuidado! `=` NO es asignación. Es "Intenta hacer que sean iguales".

Cuando Prolog encuentra `A = B`, sigue estos pasos:

1.  **¿Son ambos átomos (constantes)?**
    *   `juan = juan` -> ✅ Éxito.
    *   `juan = pepe` -> ❌ Fallo.

2.  **¿Es uno de ellos una variable libre?**
    *   `X = juan` -> ✅ Éxito. La variable `X` se "instancia" (se ata) al valor `juan`. A partir de ahora, `X` es `juan`.
    *   `juan = Y` -> ✅ Éxito. `Y` pasa a valer `juan`.

3.  **¿Son ambos variables libres?**
    *   `X = Y` -> ✅ Éxito. Se "correferencian". Si en el futuro `X` toma un valor, `Y` tomará automáticamente el mismo valor. Son alias de la misma casilla.

4.  **¿Son estructuras complejas?**
    *   Deben tener el mismo nombre (functor) y la misma cantidad de argumentos.
    *   Prolog intenta unificar argumento por argumento.
    *   `fecha(D, M, 2023) = fecha(10, enero, A)`
        *   Unifica `D` con `10` -> `D=10`.
        *   Unifica `M` con `enero` -> `M=enero`.
        *   Unifica `2023` con `A` -> `A=2023`.
        *   Resultado: ✅ Éxito con esas asignaciones.

### Ejemplos de Trampas

**Caso 1: Conflicto**
```prolog
?- X = 5, X = 10.
false.
```
*Explicación:* Primero `X` se hace 5. Luego intentamos verificar si `5 = 10`. Como es falso, todo falla.

**Caso 2: Estructura Anidada**
```prolog
?- triangulo(punto(0,0), punto(2,2), punto(4,0)) = triangulo(A, B, C).
A = punto(0,0),
B = punto(2,2),
C = punto(4,0).
```
*Explicación:* Prolog desmonta la estructura y asigna las partes correspondientes.

---

## 4. Ejercicio Mental: El Detective

Imagina que eres un detective y tienes pistas parciales.

Hechos:
`lugar_crimen(cocina).`
`arma(candelabro).`

Regla:
`culpable(X) :- estaba_en(X, Lugar), lugar_crimen(Lugar), tiene(X, Objeto), arma(Objeto).`

Cuando ejecutas `culpable(Sospechoso)`, Prolog empieza con todas las variables vacías.

1.  `estaba_en(X, Lugar)`: Busca en la base de datos. Encuentra `estaba_en(mayordomo, cocina)`.
    *   Unifica `X` = `mayordomo`.
    *   Unifica `Lugar` = `cocina`.
2.  `lugar_crimen(Lugar)`: Ahora verifica `lugar_crimen(cocina)`.
    *   Busca en los hechos. ¿Es verdad? Sí. Continúa.
3.  `tiene(X, Objeto)`: Como `X` ya es `mayordomo`, busca `tiene(mayordomo, Objeto)`.
    *   Encuentra `tiene(mayordomo, candelabro)`.
    *   Unifica `Objeto` = `candelabro`.
4.  `arma(Objeto)`: Verifica `arma(candelabro)`.
    *   ¿Es verdad? Sí.
5.  **Conclusión:** Todas las unificaciones tuvieron éxito. El culpable es el mayordomo.

Si en el paso 2, el `Lugar` hubiera sido `jardin` y el `lugar_crimen` fuera `cocina`, la unificación `jardin = cocina` fallaría. Prolog haría **Backtracking** (retrocedería) al paso 1 para buscar otra persona en otro lugar.

---

## 5. Singleton Variables (Ese molesto Warning)

Cuando compilas, a veces ves:
`Warning: Singleton variables: [X]`

Esto significa: "Declaraste una variable X pero solo la usaste una vez".
En lógica, una variable sirve para **conectar** dos cosas. Si solo aparece una vez, no conecta nada.

**Ejemplo Malo:**
`hijo(X, Y) :- padre(Y, Z).`
Aquí `X` aparece solo una vez. La regla dice "X es hijo de Y si Y es padre de Z". ¿Quién es X? No hay relación entre X y el resto. Y `Z` también es singleton.

**Corrección:**
Probablemente querías decir:
`hijo(X, Y) :- padre(Y, X).`
Ahora `X` aparece dos veces (en la cabeza y en el cuerpo). Está conectada.

Si *realmente* no te importa la variable (por ejemplo, quieres saber si alguien es padre, sin importar de quién), usa `_`:
`es_padre(Y) :- padre(Y, _).`
Aquí decimos: "Y es padre si es padre de *alguien*". El warning desaparecerá.
