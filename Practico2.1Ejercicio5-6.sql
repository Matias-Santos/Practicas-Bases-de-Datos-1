SELECT v.id_institucion, COUNT(*)
FROM voluntario v
GROUP BY v.id_institucion;

SELECT  MAX(v.fecha_nacimiento) AS "Mas joven",
        MIN(v.fecha_nacimiento) AS "Mas viejo"
FROM voluntario v;

SELECT h.nro_voluntario, COUNT(h.id_tarea) as "Cantidad de cambios"
FROM historico h
GROUP BY h.nro_voluntario
HAVING COUNT(h.id_tarea) > 0
ORDER BY h.nro_voluntario;

SELECT  MAX(v.horas_aportadas) AS "Menor cantidad de horas",
        MIN(v.horas_aportadas) AS "Mayor cantidad de horas",
        AVG(v.horas_aportadas) AS "Cantidad de horas promedio"
FROM voluntario v
WHERE (AGE(v.fecha_nacimiento) > '25 years')

SELECT i.id_direccion
FROM institucion i
ORDER BY i.id_institucion
LIMIT 10;

SELECT *
FROM tarea t
WHERE (t.nombre_tarea LIKE 'O%') OR (t.nombre_tarea LIKE 'A%') OR (t.nombre_tarea LIKE 'C%')
OFFSET 10
LIMIT 5;