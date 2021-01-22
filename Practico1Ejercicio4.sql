CREATE TABLE equipo (
    nro_equipo integer not null,
    descripcion varchar(50) not null,
    CONSTRAINT PK_equipo primary key (nro_equipo)
);

CREATE TABLE grabacion (
    nro_grabacion integer not null,
    casa_discografica varchar(50) not null,
    fecha_grabacion date not null,
    tipo char(1) not null,
    CONSTRAINT PK_grabacion primary key (nro_grabacion)
);

CREATE TABLE grabacion_no_propia (
    FK_nro_grabacion integer not null,
    duracion integer,
    CONSTRAINT PK_grabacion_no_propia primary key (FK_nro_grabacion)
);

CREATE TABLE grabacion_comercial (
    FK_nro_grabacion integer not null,
    FK_nro_equipo integer not null,
    CONSTRAINT PK_grabacion_comercial primary key (FK_nro_grabacion, FK_nro_equipo)
);

ALTER TABLE grabacion_no_propia
 ADD CONSTRAINT FK_grabacion_no_propia_grabacion foreign key (FK_nro_grabacion)
REFERENCES grabacion(nro_grabacion);

ALTER TABLE grabacion_comercial
 ADD CONSTRAINT FK_grabacion_comercial_grabacion foreign key (FK_nro_grabacion)
REFERENCES grabacion(nro_grabacion);

ALTER TABLE grabacion_comercial
 ADD CONSTRAINT FK_grabacion_comercial_equipo foreign key (FK_nro_equipo)
REFERENCES equipo(nro_equipo);
