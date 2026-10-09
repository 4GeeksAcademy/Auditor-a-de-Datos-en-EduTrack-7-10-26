-- 1. Inscripciones en 'Intro to Python'
SELECT student_name,student_email,completion_percentage
FROM enrollments
WHERE course_title = 'Intro to Python';

-- 2. Posibles abandonos (completado menor que 10)
SELECT id, student_name,course_title, completion_percentage
FROM enrollments
WHERE completion_percentage < 10;

-- 3. Inscripciones sin instructor
SELECT id, student_name, course_title,instructor
FROM enrollments
WHERE instructor IS NULL;

-- 4. Top 5 con mayor completado sin aprobar
SELECT id, student_name, course_title, completion_percentage
FROM enrollments
WHERE passed = false
ORDER BY completion_percentage DESC
LIMIT 5;

-- 5. Inscripciones del último año
SELECT id, student_name, course_title, enrollment_date
FROM enrollments
WHERE enrollment_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY enrollment_date DESC;

-- 6. Añadir la inscripción que faltaba
INSERT INTO enrollments (id, student_id, student_name, student_email, course_id, course_title, category, enrollment_date, completion_percentage, passed, monthly_fee_paid, instructor)
VALUES (18, 3, 'Lucia Fernandes', 'lucia.fernandes@student.edutrack.com', 5, 'Advanced Python', 'Programming', '2025-04-01', 0, false, 69.99, 'Carlos Vega');

-- 7. Asignar 'Pending assignment' a los instructores vacíos
UPDATE enrollments
SET instructor = 'Pending assignment'
WHERE instructor IS NULL;

-- 8a. Ver las cuentas de prueba
SELECT id, student_name, student_email, course_title
FROM enrollments
WHERE student_email LIKE '%@test.com';

-- 8b. Borrar las cuentas de prueba
DELETE FROM enrollments
WHERE student_email LIKE '%@test.com';

-- 9. Inscripciones por categoría
SELECT category, COUNT(*)
FROM enrollments
GROUP BY category;

-- 10. Promedio de completado por curso
SELECT course_title, AVG(completion_percentage)
FROM enrollments
GROUP BY course_title
ORDER BY AVG(completion_percentage) ASC;

-- 11. Cursos con más de 3 inscripciones
SELECT course_title, COUNT(*)
FROM enrollments
GROUP BY course_title
HAVING COUNT(*) > 3;

-- 12. Ingresos totales por categoría
SELECT category, SUM(monthly_fee_paid)
FROM enrollments
GROUP BY category
ORDER BY SUM(monthly_fee_paid) DESC;
