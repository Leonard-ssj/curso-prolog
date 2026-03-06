# Hechos y Reglas: Modelando el Universo

En Prolog, programar no es escribir una secuencia de comandos; es **modelar un universo**. Tú defines qué es verdad en tu mundo, y luego haces preguntas sobre ese mundo.

Este módulo cubre la creación de la **Base de Conocimiento** (Knowledge Base o KB).

---

## 1. Hechos (Facts): Las Verdades Absolutas

Un hecho es la unidad más simple de información. Declara que una relación entre objetos es verdadera incondicionalmente.

**Sintaxis:** `predicado(arg1, arg2, ...).`

### Analogía: La Libreta del Detective
Imagina que eres un detective tomando notas sobre un caso. Escribes cosas que has verificado que son ciertas.

*   "Juan es alto." -> `alto(juan).`
*   "El cielo es azul." -> `color(cielo, azul).`
*   "Madrid es la capital de España." -> `capital(espana, madrid).`

### Detalles Importantes
1.  **Nombres de Predicados:** Deben empezar con minúscula (`padre`, `amigo`, `es_rico`).
2.  **Argumentos:** Son los objetos que participan en la relación.
3.  **Aridad:** Es el número de argumentos. `llueve` tiene aridad 0. `es_gato(tom)` tiene aridad 1. `padre(homero, bart)` tiene aridad 2.

### El Principio de Universo Cerrado
Esto es vital: **Prolog asume que sabe TODO.**
Si algo no está en tu base de conocimiento, para Prolog **es falso**.

Si tu base solo tiene:
`es_gato(tom).`

Y preguntas:
`?- es_gato(felix).`
Prolog dirá `false`. No porque sepa que Félix es un perro, sino porque **no sabe que es un gato**. Para Prolog, lo que no está escrito, no existe.

---

## 2. Reglas (Rules): Verdades Condicionales

Los hechos son aburridos por sí solos. La potencia real viene de las reglas. Una regla permite deducir nuevos hechos a partir de los existentes.

**Sintaxis:**
`Cabeza :- Cuerpo.`

*   **Cabeza:** Lo que queremos probar (la conclusión).
*   **:-** : El operador de implicación. Se lee "ES VERDAD SI..." (o "if" en inglés).
*   **Cuerpo:** Las condiciones que deben cumplirse.

### Analogía: El Manual de Instrucciones o Leyes
"Una persona puede conducir SI tiene más de 18 años Y tiene licencia."

En Prolog:
```prolog
puede_conducir(Persona) :- 
    edad(Persona, Edad), 
    Edad >= 18, 
    tiene_licencia(Persona).
```

### Operadores Lógicos
Dentro del cuerpo de la regla, conectamos condiciones:

1.  **La Coma (`,`) es AND (Y):**
    Todas las condiciones separadas por comas deben ser verdaderas para que la regla sea verdadera.
    `abuelo(X,Y) :- padre(X,Z), padre(Z,Y).`
    (X es padre de Z **Y** Z es padre de Y).

2.  **El Punto y Coma (`;`) es OR (O):**
    Basta con que una de las condiciones sea verdadera.
    `progenitor(X,Y) :- padre(X,Y) ; madre(X,Y).`
    (X es progenitor de Y SI es padre **O** es madre).

    *Nota de estilo:* Es mejor escribir dos reglas separadas en lugar de usar `;`, es más legible:
    ```prolog
    progenitor(X,Y) :- padre(X,Y).
    progenitor(X,Y) :- madre(X,Y).
    ```
    Prolog probará la primera. Si falla, probará la segunda (esto es el **OR** implícito).

---

## 3. Cláusulas de Horn

Prolog se basa en un subconjunto de la lógica llamado **Cláusulas de Horn**. Esto significa que las reglas solo pueden tener **una** conclusión (una cabeza).

*   ✅ Válido: "Si llueve y hace frío, entonces me quedo en casa."
    `quedo_casa :- llueve, hace_frio.`
*   ❌ Inválido: "Si es fin de semana, entonces voy al cine O voy al parque."
    No puedes escribir: `voy_cine ; voy_parque :- fin_de_semana.`

En Prolog, debes decidir la conclusión.

---

## 4. Ejemplo Paso a Paso: Sistema de Diagnóstico Médico (Simplificado)

Vamos a crear un mini sistema experto.

### Paso 1: Definir los síntomas (Hechos)
Supongamos que tenemos un paciente, Pedro.

```prolog
tiene_sintoma(pedro, fiebre).
tiene_sintoma(pedro, tos).
tiene_sintoma(pedro, cansancio).
```

### Paso 2: Definir las enfermedades (Reglas)
Definimos qué síntomas implican qué enfermedad.

```prolog
% Gripe: Fiebre, tos y cansancio.
enfermedad(X, gripe) :-
    tiene_sintoma(X, fiebre),
    tiene_sintoma(X, tos),
    tiene_sintoma(X, cansancio).

% Resfriado: Tos y cansancio, pero NO fiebre.
enfermedad(X, resfriado) :-
    tiene_sintoma(X, tos),
    tiene_sintoma(X, cansancio),
    \+ tiene_sintoma(X, fiebre).  % \+ es NOT
```

### Paso 3: Consultar
`?- enfermedad(pedro, QueTiene).`

Prolog intentará probar la regla `enfermedad(pedro, gripe)`.
1.  Busca `tiene_sintoma(pedro, fiebre)`. ✅ Sí.
2.  Busca `tiene_sintoma(pedro, tos)`. ✅ Sí.
3.  Busca `tiene_sintoma(pedro, cansancio)`. ✅ Sí.
4.  Conclusión: `QueTiene = gripe`.

Si probamos con `resfriado`, fallaría en `\+ tiene_sintoma(pedro, fiebre)` porque Pedro SÍ tiene fiebre.

---

## 5. Práctica: Diseña tu Familia

El ejercicio más clásico es el árbol genealógico. Te obliga a pensar en relaciones.

1.  **Hechos:** Define `hombre(x)`, `mujer(x)`, `padre(x,y)`, `madre(x,y)`.
2.  **Reglas Básicas:** `hijo`, `hija` (usan el género).
3.  **Reglas Compuestas:**
    *   `hermano(X, Y)`: Comparten padre Y madre Y `X \= Y` (no eres hermano de ti mismo).
    *   `tia(X, Y)`: Es hermana de uno de los padres.
    *   `primo(X, Y)`: Hijos de hermanos.

### Reto Mental
¿Cómo definirías `cuñado`?
Hay dos formas de ser cuñado:
1.  El esposo de mi hermana.
2.  El hermano de mi esposa.
¡Intenta escribir esas dos reglas!
