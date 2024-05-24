DROP TABLE abonnements CASCADE CONSTRAINTS;
DROP TABLE address CASCADE CONSTRAINTS;
DROP TABLE difficultys CASCADE CONSTRAINTS;
DROP TABLE exercises CASCADE CONSTRAINTS;
DROP TABLE fitness CASCADE CONSTRAINTS;
DROP TABLE machines CASCADE CONSTRAINTS;
DROP TABLE members CASCADE CONSTRAINTS;
DROP TABLE memberchipcards CASCADE CONSTRAINTS;
DROP TABLE musclegroups CASCADE CONSTRAINTS;
DROP TABLE timeofpractices CASCADE CONSTRAINTS;
PURGE RECYCLEBIN;

CREATE TABLE abonnements
(
    abonnementid NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    name         VARCHAR2(30)  NOT NULL,
    description  VARCHAR2(150) NOT NULL
);

ALTER TABLE abonnements
    ADD CONSTRAINT abonnements_pk PRIMARY KEY (abonnementid);

CREATE TABLE address
(
    addressid    NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    street       VARCHAR2(30) NOT NULL,
    streetnumber NUMBER       NOT NULL,
    postalcode   NUMBER       NOT NULL
);

ALTER TABLE address
    ADD constraint postalcode
        check (
                    postalcode >= 1000
                AND postalcode <= 9999
            );

ALTER TABLE address
    ADD CONSTRAINT address_pk PRIMARY KEY (addressid);

CREATE TABLE difficultys
(
    difficultyid NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    name         VARCHAR2(30) NOT NULL
);

ALTER TABLE difficultys
    ADD CONSTRAINT difficultys_pk PRIMARY KEY (difficultyid);

CREATE TABLE exercises
(
    exerciseid                NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    name                      VARCHAR2(30)                                  NOT NULL,
    maxweight                 NUMBER                                        NOT NULL,
    instruction               VARCHAR2(200)                                 NOT NULL,
    machine_machineid         NUMBER                                        NOT NULL,
    difficulty_difficultyid   NUMBER                                        NOT NULL,
    musclegroup_muclsegroupid NUMBER                                        NOT NULL
);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_pk PRIMARY KEY (exerciseid);

CREATE TABLE fitness
(
    fitnessid         NUMBER GENERATED ALWAYS AS IDENTITY  NOT NULL,
    name              VARCHAR2(30)                                  NOT NULL,
    surface           NUMBER                                        NOT NULL,
    address_addressid NUMBER                                        NOT NULL
);

ALTER TABLE fitness
    ADD CONSTRAINT fitness_pk PRIMARY KEY (fitnessid);

CREATE TABLE machines
(
    machineid         NUMBER GENERATED ALWAYS AS IDENTITY  NOT NULL,
    name              VARCHAR2(30)                                  NOT NULL,
    weight            NUMBER,
    price             NUMBER                                        NOT NULL,
    brand             VARCHAR2(30),
    fitness_fitnessid NUMBER                                        NOT NULL
);

ALTER TABLE machines
    ADD CONSTRAINT machines_pk PRIMARY KEY (machineid);

CREATE TABLE members
(
    memberid   NUMBER GENERATED ALWAYS AS IDENTITY  NOT NULL,
    name       VARCHAR2(40)                                  NOT NULL,
    birth_date DATE                                          NOT NULL,
    email      VARCHAR2(30)                                  NOT NULL,
    gender     CHAR(1)                                       NOT NULL,
    bodyweight NUMBER                                        NOT NULL
);

ALTER TABLE members
    ADD constraint bodyweight
        check (bodyweight > 0);

ALTER TABLE members
    ADD constraint gender
        check (gender = 'M' OR gender = 'F');

ALTER TABLE members
    ADD CONSTRAINT members_pk PRIMARY KEY (memberid);

CREATE TABLE memberchipcards
(
    memberschipid           NUMBER GENERATED ALWAYS AS IDENTITY  NOT NULL,
    startdate               DATE   NOT NULL,
    enddate                 DATE   NOT NULL,
    fitness_fitnessid       NUMBER NOT NULL,
    member_memberid         NUMBER NOT NULL,
    abonnement_abonnementid NUMBER NOT NULL
);

ALTER TABLE memberchipcards
    ADD constraint startdate_enddate
        check (startdate < enddate);

ALTER TABLE memberchipcards
    ADD CONSTRAINT memberchipcards_pk PRIMARY KEY (memberschipid);

CREATE TABLE musclegroups
(
    muclsegroupid NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    name          VARCHAR2(30)                                  NOT NULL
);

ALTER TABLE musclegroups
    ADD CONSTRAINT musclegroups_pk PRIMARY KEY (muclsegroupid);

CREATE TABLE timeofpractices
(
    timeofpracticeid    NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    practicedate        DATE   NOT NULL,
    reps                NUMBER NOT NULL,
    sets                NUMBER NOT NULL,
    addedweight         NUMBER,
    member_memberid     NUMBER NOT NULL,
    exercise_exerciseid NUMBER NOT NULL
);

ALTER TABLE timeofpractices
    ADD CONSTRAINT execution_pk PRIMARY KEY (timeofpracticeid);

ALTER TABLE timeofpractices
    ADD CONSTRAINT execution_exercises_fk FOREIGN KEY (exercise_exerciseid)
        REFERENCES exercises (exerciseid);

ALTER TABLE timeofpractices
    ADD CONSTRAINT execution_members_fk FOREIGN KEY (member_memberid)
        REFERENCES members (memberid);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_difficultys_fk FOREIGN KEY (difficulty_difficultyid)
        REFERENCES difficultys (difficultyid);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_machines_fk FOREIGN KEY (machine_machineid)
        REFERENCES machines (machineid);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_musclegroups_fk FOREIGN KEY (musclegroup_muclsegroupid)
        REFERENCES musclegroups (muclsegroupid);

ALTER TABLE fitness
    ADD CONSTRAINT fitness_address_fk FOREIGN KEY (address_addressid)
        REFERENCES address (addressid);

ALTER TABLE machines
    ADD CONSTRAINT machines_fitness_fk FOREIGN KEY (fitness_fitnessid)
        REFERENCES fitness (fitnessid);

ALTER TABLE memberchipcards
    ADD CONSTRAINT memberchipcards_abonnements_fk FOREIGN KEY (abonnement_abonnementid)
        REFERENCES abonnements (abonnementid);

ALTER TABLE memberchipcards
    ADD CONSTRAINT memberchipcards_fitness_fk FOREIGN KEY (fitness_fitnessid)
        REFERENCES fitness (fitnessid);

ALTER TABLE memberchipcards
    ADD CONSTRAINT memberchipcards_members_fk FOREIGN KEY (member_memberid)
        REFERENCES members (memberid);

-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             0
-- ALTER TABLE                             26
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
-- ERRORS                                   0
-- WARNINGS                                 0
