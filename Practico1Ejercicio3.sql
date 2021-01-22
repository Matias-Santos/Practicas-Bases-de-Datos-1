CREATE TABLE producto (
    cod_prod integer[7] not null,
    descripcion varchar(40) not null,
    tipo char(10) not null,
    CONSTRAINT PK_producto primary key (cod_prod)
);

CREATE TABLE proveedor (
    cod_prov integer not null,
    razon_social varchar(40) not null,
    calle varchar(60) not null,
    altura integer[5] not null,
    piso_depto varchar(10) not null,
    ciudad varchar(30) not null,
    fecha_nac date,
    CONSTRAINT PK_proveedor primary key (cod_prov)
);

CREATE TABLE sucursal (
    cod_suc char(6) not null,
    nombre varchar(40) not null,
    localidad varchar(30) not null,
    CONSTRAINT PK_sucursal primary key (cod_suc)
)

CREATE TABLE provee (
    FK_cod_prod integer[7] not null,
    FK_cod_prov integer not null,
    FK_cod_suc char(6),
    CONSTRAINT PK_provee primary key (FK_cod_prod, FK_cod_prov)
);

ALTER TABLE provee
 ADD CONSTRAINT FK_provee_producto foreign key(FK_cod_prod)
REFERENCES producto(cod_prod);

ALTER TABLE provee
 ADD CONSTRAINT FK_provee_proveedor foreign key(FK_cod_prov)
REFERENCES proveedor(cod_prov);

ALTER TABLE provee
 ADD CONSTRAINT FK_provee_sucursal foreign key(FK_cod_suc)
REFERENCES sucursal(cod_suc);
