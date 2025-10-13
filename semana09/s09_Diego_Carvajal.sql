-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-10-12 21:03:14 CLST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE ASIGNACION_TURNO 
    ( 
     fecha           DATE  NOT NULL , 
     rol_desempenado VARCHAR2 (30) , 
     id_empleado     NUMBER (5)  NOT NULL , 
     numero_maquina  NUMBER (5)  NOT NULL , 
     id_planta       NUMBER (10)  NOT NULL , 
     id_turno        VARCHAR2 (5)  NOT NULL 
    ) 
;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT ASIGNACION_TURNO_PK PRIMARY KEY ( fecha, id_empleado ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna     NUMBER (4)  NOT NULL , 
     nombre_comuna VARCHAR2 (255)  NOT NULL , 
     id_region     NUMBER (10)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna ) ;

CREATE TABLE EMPLEADO 
    ( 
     id_empleado        NUMBER (5)  NOT NULL , 
     rut                VARCHAR2 (12)  NOT NULL , 
     nombres            VARCHAR2 (255)  NOT NULL , 
     apellidos          VARCHAR2 (255)  NOT NULL , 
     fecha_contratacion DATE  NOT NULL , 
     sueldo_base        NUMBER (10)  NOT NULL , 
     estado             CHAR (1) DEFAULT 'S'  NOT NULL , 
     afp                VARCHAR2 (50)  NOT NULL , 
     sistema_salud      VARCHAR2 (50)  NOT NULL , 
     PLANTA_id_planta   NUMBER (10)  NOT NULL , 
     jefe_directo_id    NUMBER (5) 
    ) 
;

ALTER TABLE EMPLEADO 
    ADD 
    CHECK (estado IN ('N', 'S')) 
;
CREATE UNIQUE INDEX EMPLEADO__IDX ON EMPLEADO 
    ( 
     jefe_directo_id ASC 
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY ( id_empleado ) ;

CREATE TABLE JEFE_TURNO 
    ( 
     id_empleado             NUMBER (5)  NOT NULL , 
     area_responsabilidad    VARCHAR2 (50)  NOT NULL , 
     max_operarios_coordinar NUMBER (3) 
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT JEFE_TURNO_PK PRIMARY KEY ( id_empleado ) ;

CREATE TABLE MAQUINA 
    ( 
     numero_maquina  NUMBER (5)  NOT NULL , 
     nombre_maquina  VARCHAR2 (100)  NOT NULL , 
     estado_activo   CHAR (1) DEFAULT 'S' , 
     id_tipo_maquina NUMBER (3)  NOT NULL , 
     id_planta       NUMBER (10)  NOT NULL 
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT CHECK_ESTADO_MAQUINA 
    CHECK (estado_activo IN ('N', 'S')) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQUINA_PK PRIMARY KEY ( numero_maquina, id_planta ) ;

CREATE TABLE OPERARIO 
    ( 
     id_empleado          NUMBER (5)  NOT NULL , 
     categoria_proceso    VARCHAR2 (20)  NOT NULL , 
     certificacion        VARCHAR2 (100) , 
     horas_estandar_turno NUMBER (2) DEFAULT 8  NOT NULL 
    ) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT OPERARIO_PK PRIMARY KEY ( id_empleado ) ;

CREATE TABLE ORDEN_MANTENCION 
    ( 
     id_orden_mantencion NUMBER (8)  NOT NULL , 
     fecha_programada    DATE  NOT NULL , 
     fecha_ejecucion     DATE , 
     descripcion_trabajo VARCHAR2 (255)  NOT NULL , 
     numero_maquina      NUMBER (5)  NOT NULL , 
     id_planta           NUMBER (10)  NOT NULL , 
     id_empleado         NUMBER (5)  NOT NULL 
    ) 
;

ALTER TABLE ORDEN_MANTENCION 
    ADD CONSTRAINT ORDEN_MANTENCION_PK PRIMARY KEY ( id_orden_mantencion ) ;

CREATE TABLE PLANTA 
    ( 
     id_planta        NUMBER (10)  NOT NULL , 
     nombre_de_planta VARCHAR2 (255)  NOT NULL , 
     dirreccion       VARCHAR2 (255)  NOT NULL , 
     id_comuna        NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT PLANTA_PK PRIMARY KEY ( id_planta ) ;

CREATE TABLE REGION 
    ( 
     id_region     NUMBER (10)  NOT NULL , 
     nombre_region VARCHAR2 (255)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE TECNICO_MANTENCION 
    ( 
     id_empleado               NUMBER (5)  NOT NULL , 
     especialidad              VARCHAR2 (30)  NOT NULL , 
     nivel_certificacion       VARCHAR2 (50) , 
     tiempo_respuesta_estandar NUMBER (3) 
    ) 
;

ALTER TABLE TECNICO_MANTENCION 
    ADD CONSTRAINT TECNICO_MANTENCION_PK PRIMARY KEY ( id_empleado ) ;

CREATE TABLE TIPO_MAQUINA 
    ( 
     id_tipo_maquina NUMBER (3)  NOT NULL , 
     nombre_tipo     VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_MAQUINA 
    ADD CONSTRAINT TIPO_MAQUINA_PK PRIMARY KEY ( id_tipo_maquina ) ;

CREATE TABLE TURNO 
    ( 
     id_turno     VARCHAR2 (5)  NOT NULL , 
     nombre_turno VARCHAR2 (20)  NOT NULL , 
     hora_inicio  CHAR (5)  NOT NULL , 
     hora_fin     CHAR (5)  NOT NULL 
    ) 
;

ALTER TABLE TURNO 
    ADD CONSTRAINT TURNO_PK PRIMARY KEY ( id_turno ) ;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT ASIGNACION_TURNO_EMPLEADO_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT ASIGNACION_TURNO_MAQUINA_FK FOREIGN KEY 
    ( 
     numero_maquina,
     id_planta
    ) 
    REFERENCES MAQUINA 
    ( 
     numero_maquina,
     id_planta
    ) 
;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT ASIGNACION_TURNO_TURNO_FK FOREIGN KEY 
    ( 
     id_turno
    ) 
    REFERENCES TURNO 
    ( 
     id_turno
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_EMPLEADO_FK FOREIGN KEY 
    ( 
     jefe_directo_id
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_PLANTA_FK FOREIGN KEY 
    ( 
     PLANTA_id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT JEFE_TURNO_EMPLEADO_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQUINA_PLANTA_FK FOREIGN KEY 
    ( 
     id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQUINA_TIPO_MAQUINA_FK FOREIGN KEY 
    ( 
     id_tipo_maquina
    ) 
    REFERENCES TIPO_MAQUINA 
    ( 
     id_tipo_maquina
    ) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT OPERARIO_EMPLEADO_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE ORDEN_MANTENCION 
    ADD CONSTRAINT ORDEN_MANT_MAQUINA_FK FOREIGN KEY 
    ( 
     numero_maquina,
     id_planta
    ) 
    REFERENCES MAQUINA 
    ( 
     numero_maquina,
     id_planta
    ) 
;

ALTER TABLE ORDEN_MANTENCION 
    ADD CONSTRAINT ORDEN_MANT_TECNICO_MANT_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES TECNICO_MANTENCION 
    ( 
     id_empleado
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT PLANTA_COMUNA_FK FOREIGN KEY 
    ( 
     id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE TECNICO_MANTENCION 
    ADD CONSTRAINT TECNICO_MANTENCION_EMPLEADO_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

-- =============================================================================

-- 1. CREACIÓN DE LA SECUENCIA PARA LA TABLA REGION
-- Requisito: El id_region debe iniciar en 21.
CREATE SEQUENCE region_seq
    START WITH 21
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Se modifica la tabla para que la columna id_region use la secuencia
-- como su valor por defecto al insertar nuevas filas.
ALTER TABLE REGION MODIFY id_region DEFAULT region_seq.NEXTVAL;


-- 2. CREACIÓN DE SECUENCIA Y TRIGGER PARA LA TABLA COMUNA
-- Requisito: La PK debe ser autoincremental, iniciar en 1050 e incrementar de 5 en 5.
-- Como la tabla ya fue creada, se usa el método de Secuencia + Trigger.
CREATE SEQUENCE comuna_seq
    START WITH 1050
    INCREMENT BY 5
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER comuna_before_insert
BEFORE INSERT ON COMUNA
FOR EACH ROW
BEGIN
    :new.id_comuna := comuna_seq.NEXTVAL;
END;
/


-- 3. AÑADIR LAS RESTRICCIONES DE CLAVE ÚNICA (UNIQUE)
-- Requisito: Los nombres no deben repetirse en estas tablas de catálogo.
ALTER TABLE REGION ADD CONSTRAINT REGION_NOMBRE_UK UNIQUE (nombre_region);
ALTER TABLE TIPO_MAQUINA ADD CONSTRAINT TIPO_MAQUINA_NOMBRE_UK UNIQUE (nombre_tipo);
ALTER TABLE TURNO ADD CONSTRAINT TURNO_NOMBRE_UK UNIQUE (nombre_turno);

-- Requisito adicional para asegurar la unicidad del RUT del empleado.
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_RUT_UK UNIQUE (rut);


-- 4. AÑADIR LAS RESTRICCIONES DE VALIDACIÓN (CHECK)
-- Se cambia el nombre de la columna "estado" a "estado_activo" para consistencia.
-- NOTA: Ejecuta esta línea solo si en tu script base la columna se llama "estado".
ALTER TABLE EMPLEADO RENAME COLUMN estado TO estado_activo;

-- Requisito: Validar que el estado del empleado solo sea 'S' o 'N'.
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_ESTADO_CK CHECK (estado_activo IN ('S', 'N'));

-- Requisito: Validar el formato de hora HH:MM para la tabla TURNO.
ALTER TABLE TURNO ADD CONSTRAINT TURNO_HORA_INICIO_CK
    CHECK (SUBSTR(hora_inicio, 3, 1) = ':' AND TO_NUMBER(SUBSTR(hora_inicio, 1, 2)) BETWEEN 0 AND 23 AND TO_NUMBER(SUBSTR(hora_inicio, 4, 2)) BETWEEN 0 AND 59);

ALTER TABLE TURNO ADD CONSTRAINT TURNO_HORA_FIN_CK
    CHECK (SUBSTR(hora_fin, 3, 1) = ':' AND TO_NUMBER(SUBSTR(hora_fin, 1, 2)) BETWEEN 0 AND 23 AND TO_NUMBER(SUBSTR(hora_fin, 4, 2)) BETWEEN 0 AND 59);

-- Requisito: Validar que la fecha de ejecución en una orden de mantención
-- sea igual or posterior a la fecha programada.
ALTER TABLE ORDEN_MANTENCION ADD CONSTRAINT ORDEN_FECHAS_CK
    CHECK (fecha_ejecucion IS NULL OR fecha_ejecucion >= fecha_programada);

-- =============================================================================

-- =============================================================================
-- Script 3: Poblamiento de Datos para Cristalería Andina S.A.
-- =============================================================================

-- Poblando la tabla REGION
INSERT INTO REGION (nombre_region) VALUES ('Región de Valparaíso');
INSERT INTO REGION (nombre_region) VALUES ('Región Metropolitana');

-- Poblando la tabla COMUNA
INSERT INTO COMUNA (nombre_comuna, id_region) VALUES ('Quilpué', 21);
INSERT INTO COMUNA (nombre_comuna, id_region) VALUES ('Maipú', 22);

-- Poblando la tabla PLANTA
INSERT INTO PLANTA (id_planta, nombre_de_planta, dirreccion, id_comuna) VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);
INSERT INTO PLANTA (id_planta, nombre_de_planta, dirreccion, id_comuna) VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);

-- Poblando la tabla TURNO
INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES ('M0715', 'Mañana', '07:00', '15:00');
INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES ('N2307', 'Noche', '23:00', '07:00');
INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_fin) VALUES ('T1523', 'Tarde', '15:00', '23:00');

COMMIT;

-- FIN DEL SCRIPT DE POBLAMIENTO
-- =============================================================================
-- INFORME 1: Turnos nocturnos
-- =============================================================================
SELECT
    id_turno || ' - ' || nombre_turno AS "TURNO",
    hora_inicio AS "ENTRADA",
    hora_fin AS "SALIDA"
FROM
    TURNO
WHERE
    hora_inicio > '20:00'
ORDER BY
    hora_inicio DESC;

-- =============================================================================
-- INFORME 2: Turnos diurnos
-- =============================================================================
SELECT
    nombre_turno || ' (' || id_turno || ')' AS "TURNO",
    hora_inicio AS "ENTRADA",
    hora_fin AS "SALIDA"
FROM
    TURNO
WHERE
    hora_inicio BETWEEN '06:00' AND '14:59'
ORDER BY
    hora_inicio ASC;

