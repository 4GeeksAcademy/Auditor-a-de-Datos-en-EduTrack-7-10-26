# Informe de análisis — EduTrack

Nota: los resultados de las consultas de lectura (1, 2, 4, 5, 9, 10, 11 y 12) corresponden a la tabla ya corregida (cuentas de prueba borradas e inscripción 18 añadida, 16 filas). La consulta 3 se muestra con los datos originales, antes del UPDATE.

## Inscripciones en 'Intro to Python'

Resultado: 4

- Emily Watson (emily.watson@student.edutrack.com): 85 %
- Klaus Weber (klaus.weber@student.edutrack.com): 92 %
- Marco Rossi (marco.rossi@student.edutrack.com): 88 %
- Priya Sharma (priya.sharma@student.edutrack.com): 55 %

## Posibles abandonos (completion_percentage < 10)

Resultado: 5

- id 5, Lucia Fernandes, Web Design Basics: 5 %
- id 6, Lucia Fernandes, Digital Marketing 101: 3 %
- id 18, Lucia Fernandes, Advanced Python: 0 %
- id 10, Yuki Nakamura, UI/UX Fundamentals: 0 %
- id 11, Pierre Dubois, UI/UX Fundamentals: 0 %

## Inscripciones con instructor NULL (antes del UPDATE)

Resultado: 2

- id 10, Yuki Nakamura, UI/UX Fundamentals
- id 11, Pierre Dubois, UI/UX Fundamentals

## UPDATE de instructores vacíos

Resultado: 2 filas actualizadas (ids 10 y 11, UI/UX Fundamentals). Ambas quedan con instructor `Pending assignment`.

## Top 5 con mayor progreso que no han aprobado

Resultado:

- id 2, Emily Watson, Web Design Basics: 60 %
- id 15, Priya Sharma, Intro to Python: 55 %
- id 9, Yuki Nakamura, Data Analysis with SQL: 45 %
- id 17, Emily Watson, Advanced Python: 40 %
- id 16, Pierre Dubois, Data Analysis with SQL: 20 %

## Inscripciones del último año (enrollment_date DESC)

Resultado con CURRENT_DATE (8 oct 2026): 0 filas. La última inscripción es del 2025-04-01.

Resultado tomando como referencia la última fecha de la tabla: 13 filas

- 18 (2025-04-01), 17 (2025-03-05), 16 (2025-02-20), 15 (2025-01-10), 12 (2024-12-01), 11 (2024-11-05), 10 (2024-10-11), 9 (2024-09-03), 8 (2024-08-09), 6 (2024-07-01), 5 (2024-06-20), 4 (2024-05-01), 2 (2024-04-15)

## Cuentas de prueba eliminadas (@test.com)

Resultado: 2 filas eliminadas

- id 13, James Miller, Intro to Python
- id 14, Alex Chen, Web Design Basics

Filas: 17 → 15. Ingresos: 839.83 → 749.85.

## INSERT de la inscripción faltante

Resultado: 1 fila añadida (id 18, Lucia Fernandes, Advanced Python, 2025-04-01, 0 %, 69.99, Carlos Vega)

Filas: 15 → 16. Ingresos: 749.85 → 819.84.

## Inscripciones por categoría

Resultado:

- Programming: 7
- Design: 4
- Data: 3
- Marketing: 2

## Promedio de completado por curso (de menor a mayor)

Resultado:

- UI/UX Fundamentals: 0.0
- Web Design Basics: 32.5
- Digital Marketing 101: 36.5
- Advanced Python: 45.0
- Data Analysis with SQL: 47.7
- Intro to Python: 80.0

## Cursos con más de 3 inscripciones

Resultado:

- Intro to Python: 4

## Ingresos totales por categoría (de mayor a menor)

Resultado:

- Programming: 409.93
- Data: 179.97
- Design: 169.96
- Marketing: 59.98
