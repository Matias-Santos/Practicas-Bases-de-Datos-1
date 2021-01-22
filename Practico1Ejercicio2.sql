CREATE TABLE alumno (
    LU integer[5] not null,
    nombre varchar(40) not null,
    provincia varchar(30) not null,
    CONSTRAINT PK_alumno primary key (LU)
);
CREATE TABLE inscripto (
    FK_cod char(4),
    FK_LU integer[5],
    CONSTRAINT PK_inscripto primary key (FK_cod, FK_LU)
);
CREATE TABLE curso (
    cod char(4) not null,
    descripcion varchar(40) not null,
    tipo char(1) not null,
    FK_cod char(4),
    FK_LU integer[5],
    CONSTRAINT PK_curso primary key (cod)
);
ALTER TABLE inscripto
ADD CONSTRAINT FK_inscripto_alumno foreign key(FK_LU)
REFERENCES alumno(LU);

ALTER TABLE inscripto
ADD CONSTRAINT FK_inscripto_curso foreign key(FK_cod)
REFERENCES curso(cod);

ALTER TABLE curso
ADD CONSTRAINT FK_curso_inscripto foreign key(FK_cod,FK_LU)
REFERENCES inscripto(FK_cod,FK_LU);