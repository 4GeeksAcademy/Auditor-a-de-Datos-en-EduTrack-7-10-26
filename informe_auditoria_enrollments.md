# Auditoría de la tabla `enrollments` — EduTrack, Q3

**Preparado para:** Responsable de Operaciones y equipo de EduTrack
**Fecha:** 8 de octubre de 2026
**Alcance:** solo la tabla `enrollments`. Las tablas `students` y `courses` no se han modificado.

---

## 1. Resumen ejecutivo

- La tabla pasó de **17 a 16 inscripciones** tras la limpieza. Los ingresos registrados pasaron de **839.83 a 819.84**.
- Se eliminaron **2 inscripciones de cuentas de prueba** (`@test.com`), se añadió **1 inscripción confirmada por correo** que faltaba y se corrigieron **2 registros sin instructor**.
- **Design es la categoría con peor rendimiento**: 16.3 % de completado medio y ningún estudiante aprobado. El curso **UI/UX Fundamentals** tiene un 0 % en sus dos inscripciones y es justo el que no tiene instructor asignado.
- **Programming** genera la mitad de los ingresos (50.0 %) y tiene el mejor completado (65.0 %).
- **No hay ninguna inscripción nueva desde el 1 de abril de 2025.** Conviene confirmar si es falta de actividad real o de registro.

---

## 2. Cambios realizados en la base de datos

| Cambio | Registros | Detalle | Filas / efecto |
|---|---|---|---|
| Eliminar cuentas de prueba | ids 13 y 14 | James Miller (Intro to Python) y Alex Chen (Web Design Basics), ambos `@test.com`. Se comprobó con un SELECT antes de borrar. | 2 filas eliminadas, −89.98 |
| Añadir inscripción faltante | id 18 | Lucia Fernandes en Advanced Python, 1 abr 2025, 0 % de progreso, 69.99 pagados, instructor Carlos Vega. Datos tomados del brief. | 1 fila añadida, +69.99 |
| Corregir instructor vacío | ids 10 y 11 | Yuki Nakamura y Pierre Dubois, curso UI/UX Fundamentals. Valor asignado: `Pending assignment`, según lo indicado en el proyecto. | 2 filas actualizadas |

**Comprobaciones tras cada paso:**

| Momento | Filas | Ingresos |
|---|---|---|
| Estado inicial | 17 | 839.83 |
| Tras eliminar cuentas de prueba | 15 | 749.85 |
| Tras añadir la inscripción 18 | 16 | 819.84 |

Los ingresos finales cuadran con la suma de las cuatro categorías (sección 4).

---

## 3. Estudiantes con progreso muy bajo

Se usó el criterio de **menos del 10 % de completado**, que es el que define el proyecto para marcar posibles abandonos.

| id | Estudiante | Curso | Completado |
|---|---|---|---|
| 5 | Lucia Fernandes | Web Design Basics | 5 % |
| 6 | Lucia Fernandes | Digital Marketing 101 | 3 % |
| 18 | Lucia Fernandes | Advanced Python | 0 % |
| 10 | Yuki Nakamura | UI/UX Fundamentals | 0 % |
| 11 | Pierre Dubois | UI/UX Fundamentals | 0 % |

**Lectura:**
- **Lucia Fernandes** concentra 3 de los 5 casos. Es el perfil con más riesgo de abandono.
- La inscripción **18** tiene un 0 % porque se acaba de registrar. No debe contarse como abandono confirmado hasta que pase un tiempo razonable.
- Los dos casos de **UI/UX Fundamentals** coinciden con el curso sin instructor asignado. Es una hipótesis razonable, pero los datos no permiten confirmarla.

**Estudiantes con más avance que aún no han aprobado** (los más fáciles de recuperar):

| Estudiante | Curso | Completado |
|---|---|---|
| Emily Watson | Web Design Basics | 60 % |
| Priya Sharma | Intro to Python | 55 % |
| Yuki Nakamura | Data Analysis with SQL | 45 % |
| Emily Watson | Advanced Python | 40 % |
| Pierre Dubois | Data Analysis with SQL | 20 % |

---

## 4. Cifras por categoría

Datos tras la limpieza (16 inscripciones). "Ingresos" es la suma de `monthly_fee_paid`, es decir, una cuota mensual por inscripción.

| Categoría | Inscripciones | Ingresos cobrados | % de ingresos | Completado medio | Aprobados |
|---|---|---|---|---|---|
| Programming | 7 | 409.93 | 50.0 % | 65.0 % | 4 |
| Data | 3 | 179.97 | 22.0 % | 47.7 % | 1 |
| Design | 4 | 169.96 | 20.7 % | **16.3 %** | **0** |
| Marketing | 2 | 59.98 | 7.3 % | 36.5 % | 1 |
| **Total** | **16** | **819.84** | 100 % | | **6** |

### Categorías con peor rendimiento

1. **Design (16.3 %, 0 aprobados).** Es la peor con diferencia. Dos de sus cuatro inscripciones (UI/UX Fundamentals) están a 0 %. Aun sin ese curso, Web Design Basics solo llega al 32.5 %.
2. **Marketing (36.5 %).** Solo hay 2 inscripciones: una con 3 % y otra con 70 %, por lo que el promedio es poco representativo.
3. **Data (47.7 %).** Un aprobado de tres.

### Por curso

| Curso | Inscripciones | Completado medio |
|---|---|---|
| UI/UX Fundamentals | 2 | 0.0 % |
| Web Design Basics | 2 | 32.5 % |
| Digital Marketing 101 | 2 | 36.5 % |
| Advanced Python | 3 | 45.0 % |
| Data Analysis with SQL | 3 | 47.7 % |
| Intro to Python | 4 | 80.0 % |

- **Intro to Python** es el único curso con más de 3 inscripciones y el de mejor completado.
- El 45 % de **Advanced Python** incluye la inscripción 18, recién añadida con 0 %. Sin ella, el promedio sería 67.5 %.

---

## 5. Otros hallazgos de calidad de datos

1. **Sin actividad desde abril de 2025.** La última inscripción es del 1 de abril de 2025 y no hay ninguna en los últimos 12 meses desde hoy. Con la última fecha de la tabla como referencia, hay 13 inscripciones entre abril de 2024 y abril de 2025.
2. **El curso UI/UX Fundamentals no tiene instructor ni en `enrollments` ni en `courses`.** El valor `Pending assignment` es provisional. Hay que asignar el instructor real y actualizar ambos sitios.
3. **Las cuentas de prueba siguen en `students`** (ids 8 y 9). Solo se eliminaron sus inscripciones, porque esa tabla no se podía modificar en esta fase.
4. **Estudiantes y cursos sin inscripciones:** Hans Schneider (estudiante 10) y el curso Email Campaigns (curso 7) no tienen ninguna inscripción.
5. **Los aprobados son coherentes.** Todos los estudiantes con `passed = true` tienen un 70 % o más, y ninguno de los que no aprobaron supera el 60 %. Parece haber un umbral de aprobado entre 61 % y 70 %, que conviene documentar.
6. **Datos duplicados entre tablas.** `enrollments` repite nombre, email, título del curso, categoría e instructor, que ya existen en `students` y `courses`. Eso explica cómo pudieron llegar registros sin instructor. Es recomendable normalizar en una fase futura.
7. **Secuencia de ids.** Como los datos se cargaron con ids explícitos, se ajustó la secuencia automática para que las altas nuevas no choquen con los ids existentes.

---

## 6. Recomendaciones

1. Asignar el instructor de UI/UX Fundamentals y sustituir `Pending assignment`.
2. Contactar a los estudiantes con menos del 10 % (sección 3), empezando por Lucia Fernandes, y a los 5 con más avance sin aprobar.
3. Revisar la categoría Design: contenido, instructor y acompañamiento.
4. Confirmar por qué no hay inscripciones desde abril de 2025 y si hay datos sin importar.
5. Limpiar las cuentas de prueba de `students` en la siguiente fase.
6. Antes de importar lotes de partners, validar que traigan el campo instructor.

---

## 7. Anexo

Todas las consultas utilizadas están en `analysis.sql`, y el script de carga original en `edutrack.sql`.
