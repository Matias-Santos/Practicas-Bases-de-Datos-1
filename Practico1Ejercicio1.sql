CREATE TABLE articulo (
    id_articulo integer[4] not null,
    titulo varchar(120) not null,
    autor varchar(25) not null,
    fecha_pub date,
    CONSTRAINT PK_articulo primary key(id_articulo),
    CONSTRAINT SK_articulo unique(titulo)
);
CREATE TABLE palabra (
    cod_p integer[4] not null,
    idioma char(2) not null,
    descripcion varchar(25) not null,
    CONSTRAINT PK_palabra primary key(cod_p,idioma)
);
CREATE TABLE contiene (
    id_articulo integer[4] not null,
    cod_p integer[4],
    idioma char(2),
    CONSTRAINT PK_contiene primary key(id_articulo,cod_p,idioma)
);
ALTER TABLE contiene
ADD CONSTRAINT FK_contiene_articulo foreign key(id_articulo)
REFERENCES articulo(id_articulo);

ALTER TABLE contiene
ADD CONSTRAINT FK_contiene_palabra foreign key(cod_p, idioma)
REFERENCES palabra(cod_p, idioma);