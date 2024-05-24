-- Query performance
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'FITNESS');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'MACHINES');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'EXERCISES');
END;

-- Tabel info voor partitionering
select segment_name,
       segment_type,
       sum(bytes / 1024 / 1024)            MB,
       (select COUNT(*) FROM EXERCISES) as table_count
from dba_segments
where segment_name = 'EXERCISES'
group by segment_name, segment_type;

-- Query
-- Ik wil een overzicht zien voor een bepaalde fitness van het gemiddelde maxgewicht per machine
SELECT f.NAME, m.NAME, AVG(e.MAXWEIGHT)
FROM FITNESS f
         JOIN MACHINES m on f.FITNESSID = m.FITNESS_FITNESSID
         JOIN EXERCISES e on m.MACHINEID = e.MACHINE_MACHINEID
WHERE m.MACHINEID = 756
-- WHERE m.NAME = 'Machine36'
GROUP BY f.NAME, m.NAME
ORDER BY m.NAME;

SELECT *
FROM USER_TAB_PARTITIONS;

DROP TABLE EXERCISES CASCADE CONSTRAINTS;
CREATE TABLE exercises
(
    exerciseid                NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL
        CONSTRAINT exercises_pk PRIMARY KEY,
    name                      VARCHAR2(30)                        NOT NULL,
    maxweight                 NUMBER                              NOT NULL,
    instruction               VARCHAR2(200)                       NOT NULL,
    machine_machineid         NUMBER                              NOT NULL,
    difficulty_difficultyid   NUMBER                              NOT NULL,
    musclegroup_muclsegroupid NUMBER                              NOT NULL
)
    PARTITION BY RANGE (machine_machineid)
(
    PARTITION machine_0001 VALUES LESS THAN (50),
    PARTITION machine_0002 VALUES LESS THAN (100),
    PARTITION machine_0003 VALUES LESS THAN (150),
    PARTITION machine_0004 VALUES LESS THAN (200),
    PARTITION machine_0005 VALUES LESS THAN (250),
    PARTITION machine_0006 VALUES LESS THAN (300),
    PARTITION machine_0007 VALUES LESS THAN (350),
    PARTITION machine_0008 VALUES LESS THAN (400),
    PARTITION machine_0009 VALUES LESS THAN (450),
    PARTITION machine_0010 VALUES LESS THAN (500),
    PARTITION machine_0011 VALUES LESS THAN (550),
    PARTITION machine_0012 VALUES LESS THAN (600),
    PARTITION machine_0013 VALUES LESS THAN (650),
    PARTITION machine_0014 VALUES LESS THAN (700),
    PARTITION machine_0015 VALUES LESS THAN (750),
    PARTITION machine_0016 VALUES LESS THAN (maxvalue)
);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_difficultys_fk FOREIGN KEY (difficulty_difficultyid)
        REFERENCES difficultys (difficultyid);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_machines_fk FOREIGN KEY (machine_machineid)
        REFERENCES machines (machineid);

ALTER TABLE exercises
    ADD CONSTRAINT exercises_musclegroups_fk FOREIGN KEY (musclegroup_muclsegroupid)
        REFERENCES musclegroups (muclsegroupid);