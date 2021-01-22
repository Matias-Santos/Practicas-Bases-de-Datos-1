--1.1
SELECT DISTINCT v.nro_voluntario, v.nombre, v.apellido, COUNT(h.id_tarea) as "Cantidad de cambios"
FROM voluntario v INNER JOIN historico h on v.nro_voluntario = h.nro_voluntario
GROUP BY v.nro_voluntario
HAVING COUNT(h.id_tarea) > 0;

--1.2
SELECT v.nombre, v.apellido, v.e_mail, v.telefono, h.id_tarea, h.fecha_fin
FROM voluntario v
JOIN historico h on v.nro_voluntario = h.nro_voluntario
WHERE TO_DATE('24/07/1998', 'DD/MM/YYYY') > h.fecha_fin AND '5000' > (SELECT t.max_horas - t.min_horas
    FROM tarea t
    WHERE t.id_tarea = h.id_tarea);

--1.3
SELECT i.id_institucion, i.nombre_institucion, i.id_direccion
FROM institucion i
WHERE i.id_institucion IN (SELECT v.id_institucion
    FROM voluntario v
    WHERE v.horas_aportadas <= (SELECT t.max_horas
        FROM tarea t
        WHERE v.id_tarea = t.id_tarea));

--1.4
SELECT p.nombre_pais
FROM pais p
WHERE p.id_pais NOT IN (
    SELECT DISTINCT d.id_pais
    FROM historico h INNER JOIN institucion i on i.id_institucion = h.id_institucion
    INNER JOIN direccion d on d.id_direccion = i.id_direccion
    )
ORDER BY p.nombre_pais;

--1.5
SELECT t.nombre_tarea
FROM tarea t
WHERE t.id_tarea NOT IN (
    SELECT DISTINCT v.id_tarea
    FROM voluntario v
)
ORDER BY t.nombre_tarea;

--1.6
SELECT t.id_tarea, t.nombre_tarea, t.max_horas
FROM tarea t
WHERE t.id_tarea IN (
    SELECT v.id_tarea
    FROM voluntario v
    WHERE v.nro_voluntario IN (
        SELECT v1.nro_voluntario
        FROM voluntario v1 INNER JOIN institucion i on v1.id_institucion = i.id_institucion
        INNER JOIN direccion d on d.id_direccion = i.id_direccion
        WHERE(upper(d.ciudad) LIKE 'MUNICH' )
        )
    GROUP BY v.id_tarea
    HAVING COUNT(id_tarea) = 1
    );

--1.7
SELECT d.calle, d.ciudad, d.provincia
FROM direccion d INNER JOIN institucion i ON d.id_direccion = i.id_direccion
INNER JOIN historico h ON i.id_institucion = h.id_institucion
WHERE (i.id_director IS NOT NULL) AND ((h.id_tarea,i.id_institucion) NOT IN (SELECT v.id_tarea,i2.id_institucion
                                                    FROM institucion i2 JOIN voluntario v ON (i2.id_institucion = v.id_institucion)));