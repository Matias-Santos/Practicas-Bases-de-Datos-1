--Resolucion Ejercicio 1 1

--Creacion de las tablas
create table proveedor
(
    id_prov varchar(10) not null,
    nombre  varchar(30),
    rubro   varchar(15),
    ciudad  varchar(30),
    constraint pk_proveedor primary key (id_prov)
);

create table articulo
(
    id_arti     varchar(10)   not null,
    descripcion varchar(30),
    precio      decimal(8, 2),
    peso        decimal(5, 2) not null,
    ciudad      varchar(30),
    constraint pk_articulo primary key (id_arti)
);

create table envio
(
    id_prov varchar(10) not null,
    id_arti varchar(10) not null,
    cantidad integer,
    constraint pk_envio primary key (id_prov,id_arti)
);

alter table envio add constraint fk_proveedor_envio
foreign key (id_prov) references proveedor;


alter table envio add constraint fk_articulo_envio
foreign key (id_arti) references articulo;

-- Ej 1 a
create view Envios500 as
    select *
    from envio
    where (cantidad >= 500)
    with cascaded check option;

--Ej 1 b
create view Envios999 as
    select *
    from Envios500
    with local check option;

--Ej 1 c
create view RubrosTandil as
    select distinct rubro
    from proveedor
    where ciudad like 'Tandil';

--Ej D
create view EnviosProv as
    select id_prov, sum(cantidad)
    from envio
    group by id_prov;

--Ejercicio 1) punto: 2
-- La tabla del ejercicio 1c no es actualizable porque posee distinct y luego la del d tampoco es actualizable porque posee funciones de agrupamiento.

--Ejercicio 1 3
create view RubrosTandil as
    select distinct rubro
    from proveedor
    where ciudad like 'Tandil'
    with cascaded check option;

--Si se agrega con cascaded: El insert o update de los datos en el atributo ciudad debera coincidir con Tandil. Y ademas debera de checkear para
--abajo en cascada
--Si se agrega con Local: El insert o update de los datos en el atributo ciudad debera coincidir con Tandil.

insert into proveedor values ('aa','Santos','Carpintero','Ayacucho');
insert into proveedor values ('ab','Juampi','Carpintero','Tandil');
insert into proveedor values ('ac','Musu','Carpintero','Tandil');
insert into articulo values ('11','silla',1600,2,'Ayacucho');
insert into articulo values ('12','mesa',1600,2,'Ayacucho');
insert into articulo values ('13','mesada',1600,2,'Ayacucho');
insert into envio values ('aa','11',499);
insert into envio values ('aa','12',1000);
insert into envio values ('ab','11',1000);
insert into envio values ('ab','12',1000);

select * from Envios500;
select * from Envios999;
select * from RubrosTandil;
select * from EnviosProv;

------------------------------------------------------------------------------------------------------------------------
--Resolucion Ejercicio 2

CREATE OR REPLACE VIEW Tarea10000Hs
AS  SELECT T.*
FROM Tarea T
WHERE max_horas > 10000
WITH LOCAL CHECK OPTION;

CREATE OR REPLACE VIEW Tarea10000REP
AS  SELECT R.*
FROM Tarea10000Hs R
WHERE id_tarea LIKE '%REP%'
WITH LOCAL CHECK OPTION;

set search_path = unc_248943;

INSERT INTO Tarea10000REP (id_tarea, nombre_tarea, min_horas, max_horas) VALUES ( 'MGR', 'Org Salud', 18000, 20000);
--Da error id_tarea no coincide con %rep%
INSERT INTO Tarea10000Hs (id_tarea, nombre_tarea, min_horas, max_horas) VALUES (  'REPA', 'Organiz Salud', 4000, 5500);
--Da error max_horas es menor que 10000
INSERT INTO Tarea10000REP (id_tarea, nombre_tarea, min_horas, max_horas) VALUES ( 'CC_REP', 'Organizacion Salud', 8000, 9000);
--Da error max_horas es menor que 10000 al tener definido el WCO en ambas se checkea en ambas
INSERT INTO Tarea10000Hs (id_tarea, nombre_tarea, min_horas, max_horas) VALUES (  'ROM', 'Org Salud', '10000', 12000);
--Da errror porque min horas es un numeric y quieren insertar un string (por lo visto lo acept nose que carajos)

------------------------------------------------------------------------------------------------------------------------
--Resolucion Ejercicio 3

-- 1) A)
drop view if exists EMPLEADO_DIST_20;
create or replace view EMPLEADO_DIST_20 as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (id_distribuidor  = 20);

-- 1) B) Es actualizable ya que posee toda su clave primaria,no presenta atributos derivados, ni funciones de agregacion, ni especificaciones de distinc
-- 1) C) Es actualizable por todo lo otro y ademas no hace un join.

-- 2) A)

drop view if exists EMPLEADO_DIST_2000;
create or replace view EMPLEADO_DIST_2000 as
    select id_empleado,nombre,apellido
    from empleado
    where (sueldo >= 2000);

-- 2) B) Es actualizable ya que posee toda su clave primaria,no presenta atributos derivados, ni funciones de agregacion, ni especificaciones de distinc
-- 2) C) Es actualizable por todo lo otro y ademas no hace un join.

-- 3) A)
drop view if exists EMPLEADO_DIST_20_70;
create or replace view EMPLEADO_DIST_20_70  as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (extract(year from fecha_nacimiento) between 1970 and 1979);

-- 3) B) Es actualizable ya que posee toda su clave primaria,no presenta atributos derivados, ni funciones de agregacion, ni especificaciones de distinc
-- 3) C) Es actualizable por todo lo otro y ademas no hace un join.

-- 4) A)
drop view if exists PELICULAS_ENTREGADAS;
create or replace view PELICULAS_ENTREGADAS  as
    select p.codigo_pelicula, sum(re.cantidad)
    from pelicula p join renglon_entrega re on p.codigo_pelicula = re.codigo_pelicula
    group by p.codigo_pelicula;

-- 4) B) No es actualizable ya que posee funciones de agregacion.
-- 4) C) No es actualizable ya que posee funciones de agregacion y ademas hace un join.

-- 5) A)
drop view if exists DISTRIB_NAC ;
create or replace view DISTRIB_NAC as
    select n.id_distribuidor,n.nro_inscripcion,n.encargado
    from nacional n
    where (n.id_distribuidor in (select i.id_distribuidor
                                from internacional i
                                where i.codigo_pais like 'AR'));

create or replace view DISTRIB_NAC as
    select n.id_distribuidor,n.nro_inscripcion,n.encargado
    from nacional n
    where (exists (select 1
                        from internacional i
                        where n.id_distribuidor = i.id_distribuidor and i.codigo_pais = 'AR'));


-- 5) B) Es actualizable ya que posee toda su clave primaria,no presenta atributos derivados, ni funciones de agregacion, ni especificaciones de distinc
-- 5) C) Es actualizable por todo lo otro y ademas no hace un join.

-- 6) A)
drop view if exists DISTRIB_NAC_MAS2EMP;
create or replace view DISTRIB_NAC_MAS2EMP as
    select d.*
    from DISTRIB_NAC d
    where (exists (select 1
                    from empleado e
                    where (e.id_distribuidor= d.id_distribuidor)
                    group by e.id_distribuidor
                    having count(id_empleado) >= 2));

-- 6) B) Es actualizable ya que posee toda su clave primaria,no presenta atributos derivados, ni funciones de agregacion, ni especificaciones de distinc
-- 6) C) Es actualizable por todo lo otro y ademas no hace un join.

------------------------------------------------------------------------------------------------------------------------
--Resolucion Ejercicio 4

--Caso 1 para EMPLEADO_DIST_2000 :
create or replace view EMPLEADO_DIST_2000 as
    select id_empleado,nombre,apellido
    from empleado
    where (sueldo >= 2000)
    with local check option;

--Si esta definido como local checkearia el where y terminaria aca.

create or replace view EMPLEADO_DIST_2000 as
    select id_empleado,nombre,apellido
    from empleado
    where (sueldo >= 2000)
    with cascaded check option;

--Si esta definido como cascaded checkearia el where y terminaria aca ya que no esta definida sobre una vista.

--Caso 1 para EMPLEADO_DIST_20 y EMPLEADO_DIST_20_70:
create or replace view EMPLEADO_DIST_20 as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (id_distribuidor  = 20)
    with local check option;

create or replace view EMPLEADO_DIST_20_70  as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from EMPLEADO_DIST_20
    where (extract(year from fecha_nacimiento) between 1970 and 1979)
    with local check option;

--Como las dos tienen definido wco checkearia las dos

--Caso 2 para EMPLEADO_DIST_20 y EMPLEADO_DIST_20_70:
create or replace view EMPLEADO_DIST_20 as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (id_distribuidor  = 20)
    with cascaded check option;

create or replace view EMPLEADO_DIST_20_70  as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (extract(year from fecha_nacimiento) between 1970 and 1979)
    with cascaded check option;

--Como las dos tienen definido wco checkearia las dos

--Caso 3 para EMPLEADO_DIST_20 y EMPLEADO_DIST_20_70::
create or replace view EMPLEADO_DIST_20 as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (id_distribuidor  = 20)
    with local check option;

create or replace view EMPLEADO_DIST_20_70  as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (extract(year from fecha_nacimiento) between 1970 and 1979)
    with cascaded check option;

--Como las dos tienen definido wco checkearia las dos

--Caso 4 para EMPLEADO_DIST_20 y EMPLEADO_DIST_20_70::
create or replace view EMPLEADO_DIST_20 as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (id_distribuidor  = 20)
    with cascaded check option;

create or replace view EMPLEADO_DIST_20_70  as
    select id_empleado, nombre, apellido,sueldo,fecha_nacimiento
    from empleado
    where (extract(year from fecha_nacimiento) between 1970 and 1979)
    with  local check option;

--Como las dos tienen definido wco checkearia las dos


------------------------------------------------------------------------------------------------------------------------
--Resolucion Ejercicio 5

--1
CREATE or replace VIEW CIUDAD_KP_2 AS
SELECT C.id_ciudad, C.nombre_ciudad, C.id_pais, P.nombre_pais
FROM ciudad C NATURAL JOIN pais P;

--A: La clave preservada seria id_ciudad , al ser standar sql te dejaria actualizar solo los atributos de ciudad id_ciudad,nombre ciudad , id pais
-- y de pais solo te deja el nombre.

--B:

create or replace function insert_ciudad_kp_2_view() returns trigger as $$
    begin
        if not exists(select 1 from ciudad where id_ciudad= new.id_ciudad) then
            insert into ciudad values(new.id_ciudad,new.nombre_ciudad,new.id_pais);
        else
            if not exists(select 1 from ciudad where id_ciudad= new.id_ciudad and nombre_ciudad= new.nombre_ciudad) then
                update ciudad set nombre_ciudad=new.nombre_ciudad where id_ciudad= new.id_ciudad;
            end if;
            if not exists(select 1 from ciudad where id_ciudad= new.id_ciudad and id_pais= new.id_pais) then
                    update ciudad set id_pais=new.id_pais where id_ciudad= new.id_ciudad;
            end if;
        end if;
        if not exists(select 1 from pais where id_pais= new.id_pais) then
            insert into pais values (new.id_pais,new.nombre_pais);
        else
            if not exists(select 1 from pais where id_pais= new.id_pais and nombre_pais=new.nombre_pais) then
                update pais set nombre_pais= new.nombre_pais where id_pais=new.id_pais;
            end if;
        end if;
        return new;
    end $$ language 'plpgsql';

drop trigger if exists tr_is_ciud_kp_2_view on CIUDAD_KP_2;
create or replace function delete_ciudad_kp_2_view() returns trigger as $$
    begin
        delete from ciudad where id_ciudad= old.id_ciudad;
        return old;
    end $$ language 'plpgsql';

drop trigger if exists tr_is_ciud_kp_2_view on CIUDAD_KP_2;
create trigger tr_is_ciud_kp_2_view
    instead of insert or update id_pais,nombre_ciudad
    on CIUDAD_KP_2
    for each row
    execute function insert_ciudad_kp_2_view();

drop trigger if exists tr_del_ciud_kp_2_view on CIUDAD_KP_2;
create trigger tr_del_ciud_kp_2_view
    instead of delete
    on CIUDAD_KP_2
    for each row
    execute function delete_ciudad_kp_2_view();

--2
CREATE VIEW ENTREGAS_KP_3 AS
SELECT nro_entrega, RE.codigo_pelicula, cantidad, titulo
FROM renglon_entrega RE NATURAL JOIN pelicula P;

--A: La clave preseervada es la de Renglon_pelicula, al ser standar sql te dejaria actualizar.
--B:
create or replace function insert_ENTREGAS_KP_3() returns trigger as $$
    begin
        if exists(select 1 from renglon_entrega re where re.nro_entrega = new.nro_entrega and re.codigo_pelicula = new.codigo_pelicula)
            and exists(select 1 from pelicula p where p.codigo_pelicula = new.codigo_pelicula)then
                raise exception 'ya estan insertados';
        else
            if not exists(select 1 from renglon_entrega re where re.nro_entrega = new.nro_entrega and re.codigo_pelicula = new.codigo_pelicula) then
                insert into renglon_entrega values(new.nro_entrega,new.codigo_pelicula,new.cantidad);
            end if;
            if not exists(select 1 from pelicula p where p.codigo_pelicula = new.codigo_pelicula)  then
                insert into pelicula(codigo_pelicula, titulo) values(new.codigo_pelicula,new.titulo);
            end if;
        end if;
        return new;
    end $$ language 'plpgsql';

create or replace function update_ENTREGAS_KP_3() returns trigger as $$
    begin
        if exists(select 1 from renglon_entrega re where re.nro_entrega = new.nro_entrega and re.codigo_pelicula = new.codigo_pelicula and re.cantidad=new.cantidad) and
        exists(select 1 from pelicula p where p.codigo_pelicula = new.codigo_pelicula and p.titulo =new.titulo) then
                raise exception 'nada nuevo que updatear perro';
        else
            if exists(select 1 from renglon_entrega re where re.nro_entrega = new.nro_entrega and re.codigo_pelicula = new.codigo_pelicula and re.cantidad<>new.cantidad) then
                update renglon_entrega set cantidad= new.cantidad where nro_entrega = new.nro_entrega and codigo_pelicula = new.codigo_pelicula;
            end if;
            if exists(select 1 from pelicula p where p.codigo_pelicula = new.codigo_pelicula and p.titulo <>new.titulo) then
                update pelicula set titulo=new.titulo where codigo_pelicula = new.codigo_pelicula;
            end if;
        end if;
        return new;
    end $$ language 'plpgsql';


create or replace function delete_ENTREGAS_KP_3() returns trigger as $$
    begin
        delete from renglon_entrega where nro_entrega = new.nro_entrega and codigo_pelicula = new.codigo_pelicula;
    end $$ language 'plpgsql';

create trigger tr_insert_ENTREGAS_KP_3
    instead of insert
    on ENTREGAS_KP_3
    for each row
        execute function insert_ENTREGAS_KP_3();

create trigger tr_delete_ENTREGAS_KP_3
    instead of delete
    on ENTREGAS_KP_3
    for each row
        execute function delete_ENTREGAS_KP_3();

create trigger tr_update_ENTREGAS_KP_3
    instead of update of titulo,cantidad
    on ENTREGAS_KP_3
    for each row
        execute function update_ENTREGAS_KP_3();

------------------------------------------------------------------------------------------------------------------------
--Resolucion Ejercicio 6

create or replace view vistaVoluntariosTarea as
    select v.nro_voluntario,v.nombre,v.apellido,v.horas_aportadas, t.id_tarea,t.min_horas, t.max_horas,t.nombre_tarea
    from voluntario v join tarea t on t.id_tarea = v.id_tarea;

create or replace view US_cant_tareas as
   select  i.*, count(h.id_tarea)
   from institucion i
   join direccion d on d.id_direccion = i.id_direccion
   join historico h on i.id_institucion = h.id_institucion
   where d.id_pais ='US'
   group by i.id_institucion;

create or replace view instituciones_cant_voluntario as
   select i.id_institucion, i.nombre_institucion, count(v.nro_voluntario)
   from institucion i
   join voluntario v on i.id_institucion = v.id_institucion
   group by i.id_institucion;

create or replace view vistaVoluntariosTarea as
    select v.nro_voluntario,v.nombre,v.apellido,v.horas_aportadas, t.id_tarea,t.min_horas, t.max_horas,t.nombre_tarea
    from voluntario v join tarea t on t.id_tarea = v.id_tarea;

create or replace function ins_vistaVoluntariosTarea() returns trigger as $$
    begin
        if not exists(select 1 from vistaVoluntariosTarea where nombre_tarea = new.nombre_tarea) then
            insert into voluntario (nombre, apellido,nro_voluntario, horas_aportadas) values (new.nro_voluntario,new.nombre,new.apellido,new.horas_aportadas);
        else
            update voluntario set nombre = new.nombre where nro_voluntario = new.nro_voluntario;
            update voluntario set apellido = new.apellido where nro_voluntario = new.nro_voluntario;
            update voluntario set horas_aportadas = new.horas_aportadas  where nro_voluntario = new.nro_voluntario;
        end if;
        return new;
    end $$ language 'plpgsql';

create or replace function upd_vistaVoluntariosTarea() returns trigger as $$
    begin
        if exists(select 1
            from voluntario
            where nro_voluntario = new.nro_voluntario)
        then
            update voluntario set nombre = new.nombre where nro_voluntario = new.nro_voluntario;
            update voluntario set apellido = new.apellido where nro_voluntario = new.nro_voluntario;
            update voluntario set horas_aportadas = new.horas_aportadas  where nro_voluntario = new.nro_voluntario;
        end if;
        return new;
    end $$ language 'plpgsql';

create or replace function del_vistaVoluntariosTarea() returns trigger as $$
    begin
        delete from voluntario where nro_voluntario = old.nro_voluntario;
        return old;
    end $$ language 'plpgsql';

create trigger tr_ins_vistaVoluntariosTarea
    instead of insert
    on vistaVoluntariosTarea
    for each row
        execute function upd_vistaVoluntariosTarea()

create trigger tr_upd_vistaVoluntariosTarea
    instead of delete
    on vistaVoluntariosTarea
    for each row
        execute function del_vistaVoluntariosTarea()

create trigger tr_del_vistaVoluntariosTarea
    instead of update
    on vistaVoluntariosTarea
    for each row
        execute function upd_vistaVoluntariosTarea();




