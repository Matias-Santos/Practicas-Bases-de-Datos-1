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

--Ej 1.d
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
--Resolucion Ejercicio 1 2

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

INSERT INTO Tarea10000REP (id_tarea, nombre_tarea, min_horas, max_horas) VALUES ( 'MGR', 'Org Salud', 18000, 20000);
--Da error id_tarea no coincide con %rep%
INSERT INTO Tarea10000Hs (id_tarea, nombre_tarea, min_horas, max_horas) VALUES (  'REPA', 'Organiz Salud', 4000, 5500);
--Da error max_horas es menor que 10000
INSERT INTO Tarea10000REP (id_tarea, nombre_tarea, min_horas, max_horas) VALUES ( 'CC_REP', 'Organizacion Salud', 8000, 9000);
--Da error max_horas es menor que 10000 al tener definido el WCO en ambas se checkea en ambas
INSERT INTO Tarea10000Hs (id_tarea, nombre_tarea, min_horas, max_horas) VALUES (  'ROM', 'Org Salud', '10000', 12000)
--Da errror porque min horas es un numeric y quieren insertar un string


CREATE VIEW ENTREGAS_KP_3 AS
SELECT nro_entrega, RE.codigo_pelicula, cantidad, titulo
FROM renglon_entrega RE NATURAL JOIN pelicula P;

--A: La clave preseervada es la de Renglon_pelicula, al ser standar sql te dejaria actualizar.
--B:
create or replace function insert_ENTREGAS_KP_3() returns trigger as $$
    begin
        if not exists(select 1 from renglon_entrega re where re.nro_entrega = new.nro_entrega and re.codigo_pelicula = new.codigo_pelicula) then
            if not exists(select 1 from pelicula p where p.codigo_pelicula = new.codigo_pelicula) then
                insert into pelicula(codigo_pelicula, titulo) values(new.codigo_pelicula,new.titulo);
            end if;
            insert into renglon_entrega values(new.nro_entrega,new.codigo_pelicula,new.cantidad);
        else
            raise exception 'caca';
        end if;
        return new;
    end $$ language 'plpgsql';

create or replace function update_ENTREGAS_KP_3() returns trigger as $$
    begin

    end $$ language 'plpgsql';

create or replace function delete_ENTREGAS_KP_3() returns trigger as $$
    begin

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

alter table institucion
add column cantVoluntarios integer;

create or replace procedure actualizarCantInstitucion() as $$
    declare
        cantAux integer;
        idAux numeric(4);
        i integer;
        max integer;
    begin
        cantAux:=0;
        idAux:=0;
        i:=0;
        select count(id_institucion) into max
            from institucion;
        if (max is not null) then
            loop
                exit when (i>= max);
                    select id_institucion, count(nro_voluntario) into idAux, cantAux
                        from voluntario
                        group by id_institucion
                        order by id_institucion
                        offset i
                        limit 1;
                    raise warning 'cantAux: %, idAux: %, max:%', cantAux, idAux, max;
                    update institucion set cantVoluntarios = cantAux where (id_institucion = idAux);
                    cantAux:=0;
                    idAux:=0;
                    i:=i + 1;
                    raise warning 'i: % ', i;
            end loop;
        end if;
        update institucion set cantVoluntarios = cantAux where (cantVoluntarios is null);
    end; $$ language 'plpgsql';

call actualizarCantInstitucion();


select *
from institucion;

select *
    from voluntario;
select id_institucion, count(nro_voluntario)
    from voluntario
    group by id_institucion
    order by id_institucion;

select count(id_institucion)
            from institucion;