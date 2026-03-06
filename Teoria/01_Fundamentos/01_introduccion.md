# Introducción a la Programación Lógica y Prolog

## 1. ¿Qué es Prolog? Una Nueva Forma de Pensar

Prolog (**PRO**gramming in **LOG**ic) no es solo otro lenguaje de programación; es una forma completamente diferente de ver la computación. Nacido en la Universidad de Aix-Marseille (Francia) en 1972, creado por Alain Colmerauer y Philippe Roussel, Prolog se basa en la lógica formal de primer orden.

Mientras que aprender Java después de C++ es como cambiar de un coche manual a uno automático, aprender Prolog viniendo de Java es como intentar pilotar un helicóptero. Los controles son diferentes, las reglas de la física parecen cambiar, y lo que antes era obvio (como un bucle `for`) aquí no existe.

### La Analogía del Restaurante
Para entender la diferencia entre **Imperativo** (Python, C, Java) y **Declarativo** (Prolog, SQL), imaginemos un restaurante:

#### El Enfoque Imperativo (El Cocinero)
En un lenguaje imperativo, tú eres el Jefe de Cocina. Tienes que detallar cada paso exacto para obtener el resultado.
*   "Toma una sartén."
*   "Pon aceite."
*   "Enciende el fuego al 60%."
*   "Espera 2 minutos."
*   "Rompe el huevo."
*   "Si la cáscara cae, sácala."

Si olvidas un paso o lo pones en el orden incorrecto, la comida sale mal. Tú controlas el **CÓMO**.

#### El Enfoque Declarativo (El Cliente)
En Prolog, tú eres el Cliente. Tú no cocinas; tú pides lo que quieres y defines las reglas de lo que es aceptable.
*   "Quiero un huevo frito."
*   "Regla: Un huevo frito debe estar cocido pero con la yema líquida."
*   "Hecho: Hay huevos en la nevera."
*   "Hecho: Hay gas en la estufa."

El camarero (el motor de Prolog) se encarga de ir a la cocina, verificar si hay ingredientes, seguir las reglas de la física y traerte el huevo. Tú no le dijiste cómo encender la estufa; tú definiste el **QUÉ**.

---

## 2. El Paradigma Lógico

La ecuación fundamental de la programación lógica, propuesta por Robert Kowalski, es:

> **Algoritmo = Lógica + Control**

*   **Lógica:** Es lo que tú escribes. Especificas el conocimiento y las relaciones.
*   **Control:** Es lo que hace Prolog. Es la estrategia para resolver las consultas (búsqueda en profundidad, backtracking, unificación).

En C o Java, tú escribes tanto la Lógica como el Control. En Prolog, intentamos escribir solo la Lógica y dejar que la máquina se encargue del Control (aunque a veces tenemos que darle pistas para que sea eficiente).

### ¿Por qué aprender esto?
1.  **Inteligencia Artificial:** Es nativo para sistemas expertos, procesamiento de lenguaje natural y razonamiento automatizado.
2.  **Abstracción:** Te enseña a pensar en el problema, no en la implementación.
3.  **Recursividad:** Te convertirás en un maestro de la recursividad, una habilidad transferible a cualquier otro lenguaje.

---

## 3. Instalación y Entorno: SWI-Prolog

Para este curso, utilizamos **SWI-Prolog**, que es la implementación más robusta, gratuita y ampliamente usada en la industria y la academia.

### Verificación del Entorno
Antes de empezar, asegúrate de que tu computadora reconoce Prolog.
1.  Abre tu terminal (PowerShell o CMD).
2.  Escribe `swipl` y presiona Enter.
3.  Deberías ver algo como:
    ```text
    Welcome to SWI-Prolog (threaded, 64 bits, version 9.0.4)
    SWI-Prolog comes with ABSOLUTELY NO WARRANTY...
    ?-
    ```
4.  Ese `?-` es el **Prompt**. Significa que Prolog está esperando tus órdenes.
5.  Para salir, escribe `halt.` (¡No olvides el punto final!) y presiona Enter.

**Nota:** Si sale un error de "comando no reconocido", necesitas agregar la ruta `bin` de SWI-Prolog a tu variable de entorno PATH (generalmente `C:\Program Files\swipl\bin`).

---

## 4. Tu Primer Programa: "Hola Mundo" Lógico

En otros lenguajes, el "Hola Mundo" imprime texto en pantalla. En Prolog, definimos una relación.

### Paso 1: Crear la Base de Conocimiento
Crea un archivo llamado `hola.pl` (la extensión .pl es estándar para Prolog).

```prolog
% Esto es un comentario.
% Definimos un HECHO:
% "El mensaje de saludo es 'hola mundo'".

mensaje_de_saludo('Hola Mundo, bienvenidos a Prolog').

% Definimos una REGLA (opcional para este ejemplo):
% Alguien saluda si existe un mensaje de saludo.
saludar(X) :- mensaje_de_saludo(X).
```

### Paso 2: Cargar el Programa (Consultar)
Abre la terminal en la carpeta donde guardaste el archivo y ejecuta Prolog:

```powershell
swipl hola.pl
```
O si ya estás dentro de Prolog:
```prolog
?- ['hola.pl'].
```
*(El `true.` indica que se cargó sin errores).*

### Paso 3: Hacer Consultas (Queries)
Ahora interrogamos al sistema.

**Consulta 1: Verificación**
"¿Es 'Hola Mundo...' el mensaje de saludo?"
```prolog
?- mensaje_de_saludo('Hola Mundo, bienvenidos a Prolog').
true.
```

**Consulta 2: Búsqueda (Variable)**
"¿Cuál es el mensaje de saludo? (Dímelo en la variable X)"
```prolog
?- mensaje_de_saludo(X).
X = 'Hola Mundo, bienvenidos a Prolog'.
```

**Consulta 3: Falsedad**
"¿Es 'Adios' el mensaje de saludo?"
```prolog
?- mensaje_de_saludo('Adios').
false.
```
Esto ilustra el **Principio de Universo Cerrado**: Si Prolog no sabe que es verdad, asume que es falso.

---

## 5. La Sintaxis: Reglas de Oro

Para no frustrarte, memoriza estas 4 reglas sintácticas:

1.  **Minúsculas para Átomos:** `juan`, `gato`, `x`. Si escribes `Juan`, Prolog cree que es una variable.
2.  **Mayúsculas para Variables:** `Juan`, `X`, `Resultado`. Son huecos para llenar.
3.  **Punto al final:** Cada instrucción (hecho, regla o consulta) DEBE terminar con un punto `.`. Es como el `;` de Java.
4.  **Comentarios:**
    *   `%` para comentarios de una línea.
    *   `/* ... */` para bloques de comentarios.

### Errores Comunes
*   Escribir `?- saludo(Juan).` esperando que `Juan` sea el nombre de una persona. Prolog pensará que `Juan` es una variable y tratará de buscarle un valor. Lo correcto es `saludo(juan).` o `saludo('Juan').`.
*   Olvidar el punto final. Prolog se quedará esperando con un prompt `|` asi:
    ```prolog
    ?- saludo(X)
    |
    ```
    Si te pasa esto, pon un punto `.` y Enter.

---

## 6. Resumen del Flujo de Trabajo

1.  **Escribir:** Usas un editor de texto (VS Code) para crear tu archivo `.pl`. Aquí defines tu "Universo".
2.  **Cargar:** Abres Prolog y cargas tu archivo. El motor "lee" y memoriza tu universo.
3.  **Consultar:** Haces preguntas al motor. Prolog busca respuestas basándose ÚNICAMENTE en lo que escribiste en el paso 1.
4.  **Refinar:** Si la respuesta no es la esperada, editas el archivo `.pl`, guardas y vuelves a cargar (`make.` es un comando útil para recargar archivos modificados).

¡Bienvenido al mundo de la lógica! En el siguiente módulo veremos cómo las "Variables" aquí no son lo que parecen.
