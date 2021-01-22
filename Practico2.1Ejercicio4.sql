SELECT apellido, nombre, id_tarea, to_char(fecha_nacimiento, 'YYYY-MM-DD') as "Fecha Nacimiento"
FROM voluntario
WHERE EXTRACT(month from fecha_nacimiento) = 5;

SELECT AGE(fecha_nacimiento) AS "Edad", nombre || ', ' || apellido AS "Nombre y Apellido"
FROM voluntario
ORDER BY AGE(fecha_nacimiento);

SELECT *
FROM voluntario
WHERE fecha_nacimiento BETWEEN TO_DATE('1960/01/01', 'YYYY/MM/DD') AND TO_DATE('1960/12/31', 'YYYY/MM/DD')
ORDER BY nro_voluntario;