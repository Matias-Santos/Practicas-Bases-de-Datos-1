--Practico 4 Parte B

-- 1A
create table his_entrega(
    nro_reg numeric(10,0) not null,
    fecha date not null,
    operacion varchar(20),
    usuario varchar(100)
    );

create or replace function fn_act_his_entrega() returns trigger as $$
    begin
        INSERT INTO his_entrega VALUES(new.nro_registro,new.fecha_entrega,tg_op,current_user);
        if (tg_op = 'DELETE') then
            return old;
        else
            return new;
        end if;
    end $$ language 'plpgsql';

create trigger tr_act_his_entrega_entrega
    after insert or update or delete
    on entrega
        for each row
            execute function fn_act_his_entrega();

create trigger tr_act_his_entrega_renglon
    after insert or update or delete
    on renglon_entrega
        for each row
            execute function fn_act_his_entrega();

--Ej 1C
DELETE FROM ENTREGA  WHERE id_video = 3582 ;
select *
from his_entrega;

------------------------------------------------------------------------------------------------------------------------

-- Ejercicio 2

create or replace function fn_act_hist() returns trigger as $$
    begin
        if (old.id_tarea != new.id_tarea) then
            update historico set id_tarea= new.id_tarea where nro_voluntario = new.nro_voluntario;
        else
            if (old.id_institucion != new.id_institucion) then
                update historico set id_institucion= new.id_institucion where nro_voluntario = new.nro_voluntario;
            end if;
            else
                if (old.id_institucion != new.id_institucion) and (old.id_tarea != new.id_tarea) then
                    update historico set id_tarea,id_institucion= new.id_tarea,new.id_institucion where nro_voluntario = new.nro_voluntario;
                end if;
        end if;
        return new;
    end $$ language 'plpgsql';

create trigger tr_act_hist
    before update id_tarea,id_institucion
    on voluntario
    for each row
        execute function fn_act_hist();

------------------------------------------------------------------------------------------------------------------------

-- Ejercicio 3

/*
Dado el esquema de Voluntarios, agregar un atributo a la tabla Institución llamado cant_voluntarios del tipo de dato que considere
más adecuado e implemente lo siguiente.
 A) De la sentencia de alteración de la tabla Institución que agregue dicho atributo.
 B) De la sentencia que dado el estado actual de la base de datos, inicialice todas las filas en forma masiva con el valor correcto.
 C) Implemente el o los triggers adecuados para mantener este atributo actualizado.
*/

-- A) De la sentencia de alteración de la tabla Institución que agregue dicho atributo.
alter table institucion
add column cant_voluntarios integer;


-- B) De la sentencia que dado el estado actual de la base de datos, inicialice todas las filas en forma masiva con el valor correcto.
create or replace procedure cargaMasivaCant_vol() as $$

    declare
        j integer;
        tam integer;
        auxCant integer;
        auxIdInst numeric(4);

    begin
        j:=0;
        tam:= 0;


        select count(i.id_institucion) into tam
        from institucion i  ;

        loop
            exit when (j > tam);
            auxIdInst:= 0;
            auxCant:= 0;
            select v.id_institucion,count(v.nro_voluntario) into auxIdInst ,auxCant
            from institucion i join voluntario v on i.id_institucion = v.id_institucion
            group by v.id_institucion
            offset j
            limit 1;
            raise warning 'auxID : % auxCant : % tam: % j : % ',auxIdInst,auxCant, tam,j;
            update institucion set cant_voluntarios= auxCant where id_institucion = auxIdInst;
            j:= j + 1;
        end loop;

    end $$ language 'plpgsql';

call cargaMasivaCant_vol();

-- C) Implemente el o los triggers adecuados para mantener este atributo actualizado.

create or replace function ins_Vol_Mod_Cant() returns trigger as $$
    declare
        nuevaCantVol integer;
    begin
        select count(v.nro_voluntario) into nuevaCantVol
        from voluntario v
        where v.id_institucion= new.id_institucion
        group by v.id_institucion;

        update institucion set cant_voluntarios= nuevaCantVol where id_institucion = new.id_institucion;
    end $$ language 'plpgsql';

create or replace function upd_EnVolIdIns_Mod_Cant() returns trigger as $$
    declare
        nuevaCantVol integer;
    begin

        loop

        end loop;
        select count(v.nro_voluntario) into nuevaCantVol
        from voluntario v
        where v.id_institucion= new.id_institucion
        group by v.id_institucion;

        update institucion set cant_voluntarios= nuevaCantVol where id_institucion = new.id_institucion;
    end $$ language 'plpgsql';

create view VISTA_2 as
    select g.*, coalese(gc.caracteristica,ge.perfil)
    from GRUPO g
    left join GR_COMUN gc on gc.nro_grupo = g.nro_grupo
    left join GR_EXCLUSIVO ge on ge.nro_grupo = g.nro_grupo;