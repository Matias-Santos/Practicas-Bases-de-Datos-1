SELECT d.*
FROM internacional i JOIN distribuidor d ON
i.id_distribuidor = d.id_distribuidor
WHERE d.telefono IS NULL;

SELECT id_departamento, nombre
FROM departamento
WHERE jefe_departamento IS NULL OR jefe_departamento=0
ORDER BY id_departamento;