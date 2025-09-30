DROP TABLE COMUNA;
DROP TABLE ESTADO_CIVIL;
DROP TABLE GENERO;
DROP TABLE IDIOMA;
DROP TABLE REGION;
DROP TABLE TITULO;


CREATE TABLE REGION (
    id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
    nombre_region VARCHAR2(25) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);

CREATE TABLE GENERO (
    id_genero VARCHAR2(3),
    description_genero VARCHAR2(25) NOT NULL,
    CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);

CREATE TABLE ESTADO_CIVIL (
    cod_estado_civil VARCHAR2(2),
    descripcion VARCHAR2(25) NOT NULL,
    CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (cod_estado_civil)
);

CREATE TABLE TITULO (
    id_titulo VARCHAR2(3),
    description_titulo VARCHAR2(60) NOT NULL,
    CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);

CREATE TABLE IDIOMA (
    id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);

CREATE TABLE COMUNA (
    id_comuna NUMBER(5),
    comuna_nombre VARCHAR2(25) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna, cod_region),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region) REFERENCES REGION(id_region)
);

CREATE TABLE COMPANIA (
    id_empresa NUMBER(2),
    nombre_empresa VARCHAR2(25) NOT NULL,
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    renta_promedio NUMBER(10) NOT NULL,
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
    CONSTRAINT COMPANIA_UN_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region) 
    REFERENCES COMUNA(id_comuna, cod_region)
);

CREATE TABLE PERSONAL (
    rut_persona NUMBER(8) NOT NULL,
    dv_persona VARCHAR2(1) NOT NULL,
    primer_nombre VARCHAR2(25) NOT NULL,
    segundo_nombre VARCHAR2(25),
    primer_apellido VARCHAR2(25) NOT NULL,
    segundo_apellido VARCHAR2(25),
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR2(50),
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    sueldo NUMBER(8) NOT NULL,
    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    cod_genero VARCHAR2(3) NOT NULL,
    cod_estado_civil VARCHAR2(3) NOT NULL,
    cod_empresa NUMBER(2) NOT NULL,
    encargado_rut NUMBER(8),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
    CONSTRAINT PERSONAL_FK_COMPANIA FOREIGN KEY (cod_empresa) REFERENCES COMPANIA(id_empresa),
    CONSTRAINT PERSONAL_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region) 
        REFERENCES COMUNA(id_comuna, cod_region),
    CONSTRAINT PERSONAL_FK_ESTADO_CIVIL FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL(cod_estado_civil),
    CONSTRAINT PERSONAL_FK_GENERO FOREIGN KEY (cod_genero) REFERENCES GENERO(id_genero),
    CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (encargado_rut) REFERENCES PERSONAL(rut_persona)
);

CREATE TABLE DOMINIO (
    id_idioma NUMBER(3) NOT NULL,
    persona_rut NUMBER(8) NOT NULL,
    nivel VARCHAR2(25) NOT NULL,
    CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
    CONSTRAINT DOMINIO_FK_IDIOMA FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma),
    CONSTRAINT DOMINIO_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona)
);

CREATE TABLE TITULACION (
    cod_titulo VARCHAR2(3) NOT NULL,
    persona_rut NUMBER(8) NOT NULL,
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
    CONSTRAINT TITULACION_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona),
    CONSTRAINT TITULACION_FK_TITULO FOREIGN KEY (cod_titulo) REFERENCES TITULO(id_titulo)
);

-- Restricción para email único
ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_UN_EMAIL UNIQUE (email);

-- Restricción para dígito verificador válido
ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_CK_DV CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- Restricción para sueldo mínimo
ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_CK_SUELDO CHECK (sueldo >= 450000);

-- Secuencia para COMUNA
CREATE SEQUENCE seq_comuna_id 
START WITH 1101 
INCREMENT BY 6;

-- Secuencia para COMPANIA
CREATE SEQUENCE seq_compania_id 
START WITH 10 
INCREMENT BY 5;

-- Poblar REGION (usa IDENTITY)
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

-- Poblar IDIOMA (usa IDENTITY)
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

-- Poblar COMUNA (usa SEQUENCE)
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Arica', 7);

INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Santiago', 9);

INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Temuco', 11);

-- Poblar COMPANIA (usa SEQUENCE)
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '10 CC y ROJAS', 'Amapolas', 586, 1857800, 0.5, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, 15 , SENTIV', 'Los Alamos', 3498, 897800, 0.025, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '20 Praxia LTDA', 'Las Camelias', 11098, 2157800, 0.055, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '25 TIC spa', 'FLORES S.A.', 4357, 857800, NULL, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '30 SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757800, 0.015, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '35 FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589800, 0.015, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '40 J.A. HOFFMAN', 'LATINA D.32', 509, 1857800, 0.025, 1113, 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '45 CAGLIART D.', 'ALAMEDA', 206, 1857800, NULL, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '50 Rojas HMDS LTDA', 'SUCRE', 106, 957800, 0.005, 1113, 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (seq_compania_id.NEXTVAL, '55 FRIENDS P. S.A', 'SUECIA', 506, 857800, 0.015, 1113, 11);

SELECT 
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección Completa",
    renta_promedio AS "Renta Promedio",
    renta_promedio * (1 + NVL(pct_aumento, 0)) AS "Renta con Aumento"
FROM COMPANIA
ORDER BY "Renta Promedio" DESC, "Nombre Empresa" ASC;


SELECT 
    id_empresa AS "ID Empresa",
    nombre_empresa AS "Nombre Empresa",
    renta_promedio AS "Renta Promedio Actual",
    NVL(pct_aumento, 0) + 0.15 AS "Porcentaje Aumentado",
    renta_promedio * (1 + NVL(pct_aumento, 0) + 0.15) AS "Renta Promedio Incrementada"
FROM COMPANIA
ORDER BY "Renta Promedio Actual" ASC, "Nombre Empresa" DESC;

SELECT * FROM REGION;

SELECT * FROM COMUNA;

DELETE FROM COMPANIA;
DELETE FROM COMUNA;
DELETE FROM REGION;

DROP SEQUENCE seq_comuna_id;
DROP SEQUENCE seq_compania_id;

-- Secuencia para COMUNA
CREATE SEQUENCE seq_comuna_id 
START WITH 1101 
INCREMENT BY 6;

-- Secuencia para COMPANIA
CREATE SEQUENCE seq_compania_id 
START WITH 10 
INCREMENT BY 5;

--POBLAR REGION 
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');


INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Arica', 13);

INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Santiago', 15);

INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
VALUES (seq_comuna_id.NEXTVAL, 'Temuco', 17);

--POBLAR COMUNA 
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (1101, 'Arica', 13);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (1107, 'Santiago', 15);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (1113, 'Temuco', 17);

--Poblar COMPANIA
INSERT INTO COMPANIA VALUES (10, '10 CCYROJAS', 'Amapolas', 586, 1857800, 0.5, 1101, 13);
INSERT INTO COMPANIA VALUES (15, '15 SENTIV', 'Los Alamos', 3498, 897800, 0.025, 1101, 13);
INSERT INTO COMPANIA VALUES (20, '20 Praxia LTDA', 'Las Camelias', 11098, 2157800, 0.055, 1107, 15);

INSERT INTO COMPANIA VALUES (25, '25 TIC spa', 'FLORES S.A.', 4357, 857800, NULL, 1107, 15);
INSERT INTO COMPANIA VALUES (30, '30 SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757800, 0.015, 1101, 13);
INSERT INTO COMPANIA VALUES (35, '35 FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589800, 0.015, 1107, 15);
INSERT INTO COMPANIA VALUES (40, '40 J.A. HOFFMAN', 'LATINA D.32', 509, 1857800, 0.025, 1113, 17);
INSERT INTO COMPANIA VALUES (45, '45 CAGLIART D.', 'ALAMEDA', 206, 1857800, NULL, 1107, 15);
INSERT INTO COMPANIA VALUES (50, '50 Rojas HMDS LTDA', 'SUCRE', 106, 957800, 0.005, 1113, 17);
INSERT INTO COMPANIA VALUES (55, '55 FRIENDS P. S.A', 'SUECIA', 506, 857800, 0.015, 1113, 17);

-- INFORME 1
SELECT 
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección Completa",
    renta_promedio AS "Renta Promedio",
    renta_promedio * (1 + NVL(pct_aumento, 0)) AS "Renta con Aumento"
FROM COMPANIA
ORDER BY "Renta Promedio" DESC, "Nombre Empresa" ASC;


-- INFORME 2  
SELECT 
    id_empresa AS "ID Empresa",
    nombre_empresa AS "Nombre Empresa",
    renta_promedio AS "Renta Promedio Actual",
    NVL(pct_aumento, 0) + 0.15 AS "Porcentaje Aumentado",
    renta_promedio * (1 + NVL(pct_aumento, 0) + 0.15) AS "Renta Promedio Incrementada"
FROM COMPANIA
ORDER BY "Renta Promedio Actual" ASC, "Nombre Empresa" DESC;

















