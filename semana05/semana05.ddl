-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-09-15 22:31:49 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE AFP 
    ( 
     codigo VARCHAR2 (10)  NOT NULL , 
     nombre VARCHAR2 (80)  NOT NULL 
    ) 
    LOGGING 
;

ALTER TABLE AFP 
    ADD CONSTRAINT AFP_PK PRIMARY KEY ( codigo ) ;

CREATE TABLE ATENCION_MEDICA 
    ( 
     id              NUMBER (12)  NOT NULL , 
     fecha_hora      TIMESTAMP  NOT NULL , 
     tipo            VARCHAR2 (12)  NOT NULL , 
     modalidad       VARCHAR2 (12)  NOT NULL , 
     diagnostico     VARCHAR2 (500)  NOT NULL , 
     PACIENTE_rut    VARCHAR2 (15)  NOT NULL , 
     MEDICO_rut      VARCHAR2 (15)  NOT NULL , 
     ESPECIALIDAD_id NUMBER (4)  NOT NULL 
    ) 
    LOGGING 
;
CREATE INDEX IX_ATEN_PAC ON ATENCION_MEDICA 
    ( 
     PACIENTE_rut ASC 
    ) 
;
CREATE INDEX IX_ATEN_MED ON ATENCION_MEDICA 
    ( 
     MEDICO_rut ASC 
    ) 
;
CREATE INDEX IX_ATEN_ESP ON ATENCION_MEDICA 
    ( 
     ESPECIALIDAD_id ASC 
    ) 
;

ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT CHK_ATEN_MOD 
    CHECK (modalidad IN ('presencial','virtual'))
;


ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT CHK_ATEN_TIPO 
    CHECK (tipo IN ('general','urgencia','preventiva'))
;
ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT ATENCION_PK PRIMARY KEY ( id ) ;

CREATE TABLE COMUNA 
    ( 
     id        NUMBER (6)  NOT NULL , 
     nombre    VARCHAR2 (80)  NOT NULL , 
     REGION_id NUMBER (4)  NOT NULL 
    ) 
    LOGGING 
;
CREATE INDEX IX_COMUNA_REGION ON COMUNA 
    ( 
     REGION_id ASC 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id ) ;

CREATE TABLE ESPECIALIDAD 
    ( 
     id     NUMBER (4)  NOT NULL , 
     nombre VARCHAR2 (80)  NOT NULL 
    ) 
    LOGGING 
;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY ( id ) ;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT ESPECIALIDAD_nombre_UN UNIQUE ( nombre ) ;

CREATE TABLE EXAMEN 
    ( 
     codigo                  VARCHAR2 (12)  NOT NULL , 
     nombre                  VARCHAR2 (100)  NOT NULL , 
     tipo_muestra            VARCHAR2 (60)  NOT NULL , 
     condiciones_preparacion VARCHAR2 (200) 
    ) 
    LOGGING 
;

ALTER TABLE EXAMEN 
    ADD CONSTRAINT EXAMEN_PK PRIMARY KEY ( codigo ) ;

CREATE TABLE MEDICO 
    ( 
     rut             VARCHAR2 (15)  NOT NULL , 
     nombre          VARCHAR2 (150)  NOT NULL , 
     fecha_ingreso   DATE  NOT NULL , 
     UNIDAD_id       NUMBER (3)  NOT NULL , 
     ESPECIALIDAD_id NUMBER (4)  NOT NULL , 
     MEDICO_rut      VARCHAR2 (15) , 
     AFP_codigo      VARCHAR2 (10)  NOT NULL , 
     SALUD_codigo    VARCHAR2 (10)  NOT NULL 
    ) 
    LOGGING 
;
CREATE INDEX IX_MED_UNIDAD ON MEDICO 
    ( 
     UNIDAD_id ASC 
    ) 
;
CREATE INDEX IX_MED_ESPEC ON MEDICO 
    ( 
     ESPECIALIDAD_id ASC 
    ) 
;
CREATE INDEX IX_MED_SUP ON MEDICO 
    ( 
     MEDICO_rut ASC 
    ) 
;
CREATE INDEX IX_MED_AFP ON MEDICO 
    ( 
     AFP_codigo ASC 
    ) 
;
CREATE INDEX IX_MED_SALUD ON MEDICO 
    ( 
     SALUD_codigo ASC 
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT CHK_SUP_NO_SELF 
    CHECK (supervisor_rut IS NULL OR supervisor_rut <> rut)
;
ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_PK PRIMARY KEY ( rut ) ;

CREATE TABLE PACIENTE 
    ( 
     rut          VARCHAR2 (15)  NOT NULL , 
     nombre       VARCHAR2 (150)  NOT NULL , 
     sexo         CHAR (1)  NOT NULL , 
     fecha_nac    DATE  NOT NULL , 
     direccion    VARCHAR2 (150)  NOT NULL , 
     COMUNA_id    NUMBER (6)  NOT NULL , 
     tipo_usuario VARCHAR2 (12)  NOT NULL , 
     email        VARCHAR2 (150) , 
     telefono     VARCHAR2 (20) 
    ) 
    LOGGING 
;
CREATE INDEX IX_PAC_COMUNA ON PACIENTE 
    ( 
     COMUNA_id ASC 
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CHK_PAC_SEXO 
    CHECK (sexo IN ('M','F','O'))
;


ALTER TABLE PACIENTE 
    ADD CONSTRAINT CHK_PAC_TIPO 
    CHECK (tipo_usuario IN ('estudiante','funcionario','externo'))
;
ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_PK PRIMARY KEY ( rut ) ;

CREATE TABLE PAGO_ATENCION 
    ( 
     id          NUMBER (12)  NOT NULL , 
     ATENCION_id NUMBER (12)  NOT NULL , 
     monto       NUMBER (10)  NOT NULL , 
     tipo_pago   VARCHAR2 (12)  NOT NULL , 
     fecha_pago  DATE  NOT NULL 
    ) 
    LOGGING 
;
CREATE INDEX IX_PAGO_ATEN ON PAGO_ATENCION 
    ( 
     ATENCION_id ASC 
    ) 
;

ALTER TABLE PAGO_ATENCION 
    ADD CONSTRAINT CHK_MONTO_POS 
    CHECK (monto >= 0)
;


ALTER TABLE PAGO_ATENCION 
    ADD CONSTRAINT CHK_TIPO_PAGO 
    CHECK (tipo_pago IN ('efectivo','tarjeta','convenio'))
;
ALTER TABLE PAGO_ATENCION 
    ADD CONSTRAINT PAGO_PK PRIMARY KEY ( id ) ;

ALTER TABLE PAGO_ATENCION 
    ADD CONSTRAINT PAGO_atencion_id_UN UNIQUE ( ATENCION_id ) 
    USING INDEX IX_PAGO_ATEN ;

CREATE TABLE REGION 
    ( 
     id     NUMBER (4)  NOT NULL , 
     nombre VARCHAR2 (80)  NOT NULL 
    ) 
    LOGGING 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id ) ;

CREATE TABLE RESULTADO_EXAMEN 
    ( 
     SOLICITUD_EXAMEN_id NUMBER (12)  NOT NULL , 
     fecha_resultado     DATE , 
     valores             VARCHAR2 (500) , 
     informe             VARCHAR2 (1000) 
    ) 
    LOGGING 
;

ALTER TABLE RESULTADO_EXAMEN 
    ADD CONSTRAINT RESULTADO_EXAMEN_PK PRIMARY KEY ( SOLICITUD_EXAMEN_id ) ;

CREATE TABLE SALUD 
    ( 
     codigo VARCHAR2 (10)  NOT NULL , 
     nombre VARCHAR2 (80)  NOT NULL , 
     tipo   VARCHAR2 (10)  NOT NULL 
    ) 
    LOGGING 
;

ALTER TABLE SALUD 
    ADD CONSTRAINT CHK_SALUD_TIPO 
    CHECK (tipo IN ('FONASA','ISAPRE'))
;
ALTER TABLE SALUD 
    ADD CONSTRAINT SALUD_PK PRIMARY KEY ( codigo ) ;

CREATE TABLE SOLICITUD_EXAMEN 
    ( 
     id              NUMBER (12)  NOT NULL , 
     ATENCION_id     NUMBER (12)  NOT NULL , 
     EXAMEN_codigo   VARCHAR2 (12)  NOT NULL , 
     fecha_solicitud DATE  NOT NULL 
    ) 
    LOGGING 
;
CREATE INDEX IX_SOL_ATEN ON SOLICITUD_EXAMEN 
    ( 
     ATENCION_id ASC 
    ) 
;
CREATE INDEX IX_SOL_EXAM ON SOLICITUD_EXAMEN 
    ( 
     EXAMEN_codigo ASC 
    ) 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOLICITUD_EXAMEN_PK PRIMARY KEY ( id ) ;

CREATE TABLE UNIDAD 
    ( 
     id     NUMBER (3)  NOT NULL , 
     nombre VARCHAR2 (60)  NOT NULL 
    ) 
    LOGGING 
;

ALTER TABLE UNIDAD 
    ADD CONSTRAINT UNIDAD_PK PRIMARY KEY ( id ) ;

ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT ATENCION_ESPECIALIDAD_FK FOREIGN KEY 
    ( 
     ESPECIALIDAD_id
    ) 
    REFERENCES ESPECIALIDAD 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT ATENCION_MEDICO_FK FOREIGN KEY 
    ( 
     MEDICO_rut
    ) 
    REFERENCES MEDICO 
    ( 
     rut
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE ATENCION_MEDICA 
    ADD CONSTRAINT ATENCION_PACIENTE_FK FOREIGN KEY 
    ( 
     PACIENTE_rut
    ) 
    REFERENCES PACIENTE 
    ( 
     rut
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     REGION_id
    ) 
    REFERENCES REGION 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_AFP_FK FOREIGN KEY 
    ( 
     AFP_codigo
    ) 
    REFERENCES AFP 
    ( 
     codigo
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_ESPECIALIDAD_FK FOREIGN KEY 
    ( 
     ESPECIALIDAD_id
    ) 
    REFERENCES ESPECIALIDAD 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_MEDICO_FK FOREIGN KEY 
    ( 
     MEDICO_rut
    ) 
    REFERENCES MEDICO 
    ( 
     rut
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_SALUD_FK FOREIGN KEY 
    ( 
     SALUD_codigo
    ) 
    REFERENCES SALUD 
    ( 
     codigo
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_UNIDAD_FK FOREIGN KEY 
    ( 
     UNIDAD_id
    ) 
    REFERENCES UNIDAD 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id
    ) 
    REFERENCES COMUNA 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE PAGO_ATENCION 
    ADD CONSTRAINT PAGO_ATENCION_FK FOREIGN KEY 
    ( 
     ATENCION_id
    ) 
    REFERENCES ATENCION_MEDICA 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE RESULTADO_EXAMEN 
    ADD CONSTRAINT RESULTADO_EXAMEN_SOLICITUD_EXAMEN_FK FOREIGN KEY 
    ( 
     SOLICITUD_EXAMEN_id
    ) 
    REFERENCES SOLICITUD_EXAMEN 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOLICITUD_EXAMEN_ATENCION_FK FOREIGN KEY 
    ( 
     ATENCION_id
    ) 
    REFERENCES ATENCION_MEDICA 
    ( 
     id
    ) 
    NOT DEFERRABLE 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOLICITUD_EXAMEN_EXAMEN_FK FOREIGN KEY 
    ( 
     EXAMEN_codigo
    ) 
    REFERENCES EXAMEN 
    ( 
     codigo
    ) 
    NOT DEFERRABLE 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                            13
-- ALTER TABLE                             37
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   1
-- WARNINGS                                 0
