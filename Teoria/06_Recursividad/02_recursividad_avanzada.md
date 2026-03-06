# Recursividad Avanzada y Depuración

## 1. Recursividad de Cola (Tail Recursion)
Cuando Prolog hace una llamada recursiva, guarda información en la pila (stack) para saber a dónde volver. Si la lista es muy grande, la memoria se llena (Stack Overflow).

La **Recursividad de Cola** ocurre cuando la llamada recursiva es *lo último* que hace la regla. Prolog optimiza esto y no gasta memoria extra.

**Ejemplo: Suma (Normal vs Tail)**

*Normal (Gasta memoria):*
```prolog
suma([], 0).
suma([H|T], R) :- 
    suma(T, R1),   % Llamada recursiva (NO es lo último, falta sumar)
    R is H + R1.   % Operación pendiente
```

*Tail Recursive (Con Acumulador):*
```prolog
suma_tail(Lista, R) :- suma_acc(Lista, 0, R).

suma_acc([], Acc, Acc). % Cuando terminamos, el acumulador es el resultado.
suma_acc([H|T], Acc, R) :-
    NuevoAcc is Acc + H,      % Calculamos primero
    suma_acc(T, NuevoAcc, R). % Llamada recursiva (ES lo último)
```

## 2. Depuración (Debugging)
Errores comunes y cómo verlos.

### A. Ciclos Infinitos
Si tu programa se queda pensando y no responde, probablemente olvidaste el **Caso Base** o el caso base nunca se cumple.
*   Usa `Ctrl+C` y luego `a` (abort) para detenerlo.
*   Usa `trace.` para ver dónde se cicla.

### B. Singleton Variables
`Warning: Singleton variables: [X]`
Significa que usaste `X` una sola vez.
*   ¿Escribiste mal el nombre? (`Resultado` vs `Resultad`).
*   ¿No necesitas la variable? Cámbiala por `_`.

---

## 3. Ejemplo Completo: Invertir Lista (Reverse)

Vamos a hacer `reverse` usando un acumulador (eficiente).

```prolog
% Predicado principal
invertir(Lista, Invertida) :-
    invertir_acc(Lista, [], Invertida).

% Caso Base: Ya no queda nada en la lista original.
% El acumulador tiene la lista completa al revés.
invertir_acc([], Acumulador, Acumulador).

% Caso Recursivo:
% 1. Tomo la cabeza (H).
% 2. La pongo AL PRINCIPIO del acumulador ([H|Acc]).
%    (Esto es lo que invierte el orden: lo primero que entra queda al final).
invertir_acc([H|T], Acc, Resultado) :-
    invertir_acc(T, [H|Acc], Resultado).
```

**Traza mental:** `invertir([1,2], R)`
1. `invertir_acc([1,2], [], R)`
2. Tomo 1. NuevoAcc = `[1]`. Llamo `invertir_acc([2], [1], R)`.
3. Tomo 2. NuevoAcc = `[2, 1]`. Llamo `invertir_acc([], [2, 1], R)`.
4. Lista vacía. `R = [2, 1]`. ¡Listo!
