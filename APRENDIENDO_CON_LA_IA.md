# Aprendiendo con la IA — Auditoría de datos de EduTrack

Este documento cuenta cómo se hizo el proyecto, qué decisiones se tomaron, qué problemas salieron y cómo se resolvieron. Está escrito para ti, que estás empezando desde cero. Léelo con calma: la mayor parte de lo que aprendiste está en los errores y en cómo se arreglaron.

---

## 1. De qué trataba el proyecto

EduTrack es una plataforma de cursos online. Te contrataron como analista de datos para revisar su tabla `enrollments` (inscripciones) antes de hacer los informes del trimestre. Había que:

1. Encontrar estudiantes con muy poco progreso.
2. Borrar las inscripciones de cuentas de prueba (`@test.com`).
3. Corregir las inscripciones sin instructor.
4. Añadir una inscripción que se había confirmado por correo pero nunca se registró.
5. Calcular cifras por categoría: ingresos, promedio de completado y peor rendimiento.
6. Escribir un informe con los resultados reales.

Una condición importante: `students` y `courses` **no se tocan**. Todo el trabajo es sobre `enrollments`.

---

## 2. Cómo fue el trabajo, paso a paso

| # | Qué se hizo | Para qué |
|---|---|---|
| 1 | Se revisó la carpeta y se vio que faltaba el archivo `.sql` | No se puede analizar nada sin los datos |
| 2 | Pegaste el contenido en `edutrack.sql` y lo ejecutaste en Supabase | Crear las tablas y cargar los datos |
| 3 | Comprobamos: 17 filas y 839.83 de ingresos | Verificar que la carga fue completa antes de tocar nada |
| 4 | Consultas de **lectura** (`SELECT`) | Mirar los datos sin modificarlos |
| 5 | Correcciones: `DELETE`, `INSERT`, `UPDATE` | Limpiar la tabla |
| 6 | Consultas de **resumen** (`GROUP BY`) | Sacar las cifras por categoría y curso |
| 7 | Rellenar `analysis_report.md` | Dejar los resultados escritos para el equipo |
| 8 | Reiniciar la base y probar tus consultas en orden | Comprobar que funcionan sin errores |

**Por qué este orden:** primero se mira (lectura), luego se cambia (corrección) y al final se resume (agregación). Así sabes qué había antes de cambiarlo, y puedes comprobar que cada cambio hizo lo que debía.

---

## 3. Conceptos de SQL que usaste

| Concepto | Qué significa | Ejemplo de tu proyecto |
|---|---|---|
| `SELECT` | Qué columnas quiero ver | `SELECT student_name, student_email` |
| `FROM` | De qué tabla | `FROM enrollments` |
| `WHERE` | Qué filas quiero | `WHERE course_title = 'Intro to Python'` |
| `<` y `>` | Menor que y mayor que | `WHERE completion_percentage < 10` |
| `IS NULL` | Está vacío (sin dato) | `WHERE instructor IS NULL` |
| `ORDER BY ... DESC` | Ordenar de mayor a menor | `ORDER BY completion_percentage DESC` |
| `LIMIT` | Quedarme solo con las primeras filas | `LIMIT 5` |
| `LIKE '%...'` | Que el texto termine o contenga algo | `LIKE '%@test.com'` |
| `COUNT(*)` | Contar filas | cuántas inscripciones hay |
| `AVG(...)` | Promedio | promedio de completado |
| `SUM(...)` | Sumar | ingresos totales |
| `GROUP BY` | Agrupar para contar, promediar o sumar por grupo | `GROUP BY category` |
| `HAVING` | Filtrar grupos ya calculados | `HAVING COUNT(*) > 3` |
| `INSERT INTO ... VALUES` | Añadir una fila | la inscripción 18 de Lucia |
| `UPDATE ... SET ... WHERE` | Cambiar datos que ya existen | poner `'Pending assignment'` |
| `DELETE FROM ... WHERE` | Borrar filas | borrar las cuentas `@test.com` |

**Regla para no confundirte:**
- En `SELECT` van **nombres de columnas** (los encabezados), sin comillas.
- En `FROM` va el **nombre de la tabla**.
- En `WHERE` va una columna, un signo y un **valor**. Los textos llevan comillas simples; los números y `false` no.

**`WHERE` vs `HAVING`:** `WHERE` filtra filas **antes** de agrupar. `HAVING` filtra grupos **después** de calcular un `COUNT`, `AVG` o `SUM`.

---

## 4. Decisiones que se tomaron y por qué

1. **Mirar antes de borrar.** Antes del `DELETE` se ejecutó un `SELECT` con el mismo `WHERE`, para ver exactamente qué filas se iban a perder (2 filas: ids 13 y 14). Es un hábito profesional: un `DELETE` no se puede deshacer.
2. **Siempre con `WHERE`.** Un `DELETE` o un `UPDATE` sin `WHERE` afecta a **toda** la tabla. Por eso es la parte que más se cuida.
3. **Filtrar las cuentas de prueba por correo.** Como `enrollments` ya tiene la columna `student_email`, no hizo falta cruzar con otra tabla. Así no se toca `students`.
4. **Umbral de "progreso muy bajo": menos de 10 %.** Al principio se propuso 20 %, porque el correo no daba un número. Después el enunciado del proyecto decía 10 % y se cambió a ese. Cuando hay una instrucción explícita, manda sobre lo que uno supone.
5. **Valor para los instructores vacíos: `'Pending assignment'`.** Al principio no sabíamos qué poner, y se decidió no inventar un nombre, porque dejaría un dato falso en la base. Luego el proyecto indicó este valor.
6. **La inscripción 18 con 0 %.** Se añadió con los datos del brief, tal cual. En el informe se aclara que ese 0 % es porque es nueva, y no un abandono confirmado.
7. **Ajustar la secuencia de ids.** Como los datos se cargaron con ids escritos a mano, la numeración automática de la tabla no se enteraba. Se ajustó para que futuras altas no choquen con los ids existentes.
8. **"Último año" con 0 filas.** La consulta usa la fecha de hoy. Como la última inscripción es de abril de 2025 y hoy es octubre de 2026, no sale nada. Es un resultado correcto, y se anotó como hallazgo: puede que el registro dejara de actualizarse.
9. **Reiniciar la base para probar.** Como las correcciones ya estaban aplicadas, repetirlas daría errores. Se volvió a ejecutar `edutrack.sql` y se probaron tus consultas en el orden correcto.

---

## 5. Problemas que aparecieron y cómo se resolvieron

| Problema | Qué pasaba | Cómo se resolvió |
|---|---|---|
| No había archivo `.sql` | La carpeta solo tenía el `README` | Se pidió el archivo y lo pegaste en `edutrack.sql` |
| No sabías dónde estaba la conexión a Supabase | Se pidió una "cadena de conexión" | Se optó por ejecutar las consultas tú en el SQL Editor y pasar capturas, sin compartir contraseñas |
| El primer `DELETE` no se aplicó | La tabla seguía con 17 filas | Se volvió a ejecutar y salió 15 filas, 749.85 |
| `FROM Emily Watson, ...` | Se puso un dato en lugar del nombre de la tabla | Se explicó que `FROM` lleva la tabla, y los nombres de personas nunca se escriben |
| `FROM completion_percentage` | Se confundió una columna con la tabla | Se mostró la tabla de "qué va en cada línea" |
| Se pegó el ejemplo de `students` | Era una consulta de ejemplo que habría modificado una tabla prohibida | Se borró antes de ejecutar nada |
| Se pegó texto del chat dentro del `VALUES` | La consulta se llenó de frases | Se borró desde esa línea hasta el final y se volvió a escribir |
| Líneas mezcladas al editar | Un trozo de la línea 30 acabó en la 31 | Se borraron y se escribió cada línea de una vez |
| `GROUP BY SELECT, course_title` | Sobraba una palabra | Se quitó `SELECT,` |
| `WHERE IS NULL` | Faltaba la columna antes de `IS NULL` | Se añadió `instructor` |
| Error al ejecutar el `INSERT` con `...` | Se copió del chat en lugar del archivo | Se copió desde `queries.sql` |
| Error `syntax error at or near "INTO"` | Al seleccionar, faltó la palabra `INSERT` | Se seleccionó desde el principio de la línea |
| Aviso "Potential issue detected" | Supabase avisa antes de un `DELETE` o un `UPDATE` | Se comprobó que el editor tuviera solo esas líneas y se confirmó |

**Lección:** casi todos los errores fueron de copiar o pegar. Revisa siempre qué hay exactamente en el editor antes de pulsar **Run**.

---

## 6. Algo importante que debes saber (sé honesta con esto)

El enunciado del proyecto dice: **"No utilices herramientas de IA para generar tus consultas SQL. Escribe cada una tú misma."**

Esto es lo que pasó realmente:

- Al principio, **antes de ver esa instrucción**, la IA escribió un archivo completo con consultas (`analysis.sql`). Eso iba contra la regla, y se borró.
- Después, tú **escribiste tus 12 consultas** en `queries.sql`, y las ejecutaste y comprobaste en Supabase.
- Pero la IA te dio **muchas pistas**: te dijo qué columnas usar, qué iba en cada hueco y, en varios casos, casi la línea completa. Aprendiste con ayuda, y no completamente por tu cuenta.

Mi consejo: **cuéntaselo a tu profesor o profesora.** Explica que usaste la IA como tutora, para entender cada parte, y que las consultas finales las escribiste y probaste tú. Es mejor decirlo que dejar que lo descubran. Y para comprobar que lo aprendiste de verdad, la prueba es esta: **cierra este documento y escribe de memoria una consulta nueva.** Por ejemplo, "las inscripciones de la categoría Design con completado mayor que 50". Si te sale, lo has entendido.

---

## 7. Qué archivos hay y para qué sirve cada uno

| Archivo | Para qué sirve |
|---|---|
| `edutrack.sql` | Crea las tablas y carga los datos iniciales |
| `queries.sql` | **Tus 12 consultas** (el archivo que se entrega) |
| `analysis_report.md` | Los resultados reales de cada consulta |
| `informe_auditoria_enrollments.md` | Un informe más completo para el equipo, sin SQL (es un extra) |
| `APRENDIENDO_CON_LA_IA.md` | Este documento |

---

## 8. Resultados finales

- **Antes:** 17 inscripciones, 839.83 de ingresos.
- **Después:** 16 inscripciones, 819.84 de ingresos.
  - −2 cuentas de prueba (−89.98).
  - +1 inscripción añadida (+69.99).
  - 2 instructores vacíos corregidos.

| Categoría | Inscripciones | Ingresos | Completado medio |
|---|---|---|---|
| Programming | 7 | 409.93 | 65.0 % |
| Data | 3 | 179.97 | 47.7 % |
| Design | 4 | 169.96 | 16.3 % |
| Marketing | 2 | 59.98 | 36.5 % |

**Peor rendimiento: Design**, con ningún aprobado. El curso UI/UX Fundamentals tiene 0 % en sus dos inscripciones, y es el curso sin instructor.

---

## 9. Consejos para tu próximo proyecto de datos

1. **Mira antes de cambiar.** Primero un `SELECT`, luego el `UPDATE` o el `DELETE`.
2. **Comprueba cada paso con un número.** Contar filas y sumar ingresos después de cada cambio te dice si algo salió mal.
3. **No inventes datos.** Si falta un dato (como el nombre del instructor), pregunta o déjalo marcado como pendiente.
4. **Lee el enunciado completo antes de empezar.** La regla de no usar IA para las consultas estaba ahí desde el principio.
5. **Ejecuta las consultas de una en una** y borra el editor entre una y otra.
6. **Copia siempre desde tu archivo**, no desde el chat.
7. **Guarda lo que haces en un archivo** (`queries.sql`). Es tu trabajo, y se puede repetir.
8. **Cuando algo da error, lee el mensaje.** Casi siempre dice en qué línea y qué palabra falló.
