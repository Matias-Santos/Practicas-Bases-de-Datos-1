SELECT apellido || ', ' || nombre, id_tarea, id_institucion
FROM voluntario
ORDER BY 1;

SELECT nro_voluntario, id_tarea, id_institucion
FROM historico
ORDER BY 1;

SELECT apellido, nombre, e_mail
FROM voluntario
WHERE horas_aportadas > 1000
ORDER BY apellido;

SELECT apellido, telefono
FROM voluntario
WHERE id_institucion = 20 OR id_institucion = 50
ORDER BY apellido, nombre;

SELECT apellido || ', ' ||  nombre AS "Apellido y Nombre", e_mail AS "Direccion de mail"
FROM voluntario
WHERE telefono LIKE '011%';

SELECT apellido, nombre, nro_voluntario
FROM voluntario
WHERE porcentaje IS NULL OR porcentaje = 0
ORDER BY apellido;