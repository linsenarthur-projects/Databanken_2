TRUNCATE TABLE ABONNEMENTS;
TRUNCATE TABLE ADDRESS;
TRUNCATE TABLE DIFFICULTYS;
TRUNCATE TABLE EXERCISES;
TRUNCATE TABLE FITNESS;
TRUNCATE TABLE MACHINES;
TRUNCATE TABLE MEMBERS;
TRUNCATE TABLE MEMBERCHIPCARDS;
TRUNCATE TABLE MUSCLEGROUPS;
TRUNCATE TABLE TIMEOFPRACTICES;

-- Members
INSERT INTO MEMBERS (NAME, BIRTH_DATE, EMAIL, GENDER, BODYWEIGHT)
SELECT 'Arthur Linsen', '19/05/2003', 'arthur.linsen@gmail.com', 'M', 70
FROM DUAL
UNION ALL
SELECT 'Luna Lybaert', '31/03/2004', 'luna.lybaert@gmail.com', 'F', 58
FROM DUAL
UNION ALL
SELECT 'Senne David', '06/06/2003', 'senne.david@outlook.be', 'M', 68
FROM DUAL
UNION ALL
SELECT 'Robbe Verslype', '10/12/2003', 'robbe.verslype@yahoo.com', 'M', 74
FROM DUAL
UNION ALL
SELECT 'Mia Stevens', '10/07/2004', 'mia.stevens@outlook.be', 'F', 60
FROM DUAL;

-- Address
INSERT INTO ADDRESS (STREET, STREETNUMBER, POSTALCODE)
SELECT 'Belgiëlaan', 58, 2200
FROM DUAL
UNION ALL
SELECT 'Lierseweg', 317, 2200
FROM DUAL
UNION ALL
SELECT 'Eiermarkt', 21, 2000
FROM DUAL
UNION ALL
SELECT 'Stationstraat', 17, 9900
FROM DUAL
UNION ALL
SELECT 'Antwerpseweg', 79, 2440
FROM DUAL;

-- Fitness
INSERT INTO FITNESS (NAME, SURFACE, ADDRESS_ADDRESSID)
SELECT 'Basic Fit Herentals',
       80,
       (SELECT ADDRESSID FROM ADDRESS WHERE STREET = 'Belgiëlaan' AND STREETNUMBER = 58 AND POSTALCODE = 2200)
FROM DUAL
UNION ALL
SELECT 'KD Sports',
       140,
       (SELECT ADDRESSID FROM ADDRESS WHERE STREET = 'Lierseweg' AND STREETNUMBER = 317 AND POSTALCODE = 2200)
FROM DUAL
UNION ALL
SELECT 'Basic Fit Eiermarkt',
       180,
       (SELECT ADDRESSID FROM ADDRESS WHERE STREET = 'Eiermarkt' AND STREETNUMBER = 21 AND POSTALCODE = 2000)
FROM DUAL
UNION ALL
SELECT 'Basic Fit Eeklo',
       100,
       (SELECT ADDRESSID FROM ADDRESS WHERE STREET = 'Stationstraat' AND STREETNUMBER = 17 AND POSTALCODE = 9900)
FROM DUAL
UNION ALL
SELECT 'Basic Fit Geel',
       240,
       (SELECT ADDRESSID FROM ADDRESS WHERE STREET = 'Antwerpseweg' AND STREETNUMBER = 79 AND POSTALCODE = 2440)
FROM DUAL;


-- Abonnement
INSERT INTO ABONNEMENTS (NAME, DESCRIPTION)
SELECT 'Basic', 'a 1 year subscription to 1 gym'
FROM DUAL
UNION ALL
SELECT 'Premium', 'a 1 year subscription to 1 gym with personal training'
FROM DUAL
UNION ALL
SELECT '1-day pas', 'a 1 day pas to 1 gym'
FROM DUAL
UNION ALL
SELECT '1-week pas', 'a 1 week pas to 1 gym'
FROM DUAL
UNION ALL
SELECT '10 turns-card', 'a 10 turns-card to 1 gym'
FROM DUAL;

-- Memberschipcard
INSERT INTO MEMBERCHIPCARDS (STARTDATE, ENDDATE, FITNESS_FITNESSID, MEMBER_MEMBERID,
                            ABONNEMENT_ABONNEMENTID)
SELECT '01/01/2023',
       '31/12/2023',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Eeklo'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = 'Basic')
FROM DUAL
UNION ALL
SELECT '01/01/2023',
       '31/12/2023',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Eeklo'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = 'Basic')
FROM DUAL
UNION ALL
SELECT '07/10/2022',
       '07/09/2023',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Herentals'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'senne.david@outlook.be'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = '10 turns-card')
FROM DUAL
UNION ALL
SELECT '21/03/2022',
       '20/03/2023',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Eiermarkt'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'robbe.verslype@yahoo.com'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = '1-week pas')
FROM DUAL
UNION ALL
SELECT '01/01/2022',
       '31/12/2022',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'KD Sports'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = 'Basic')
FROM DUAL
UNION ALL
SELECT '01/01/2022',
       '31/12/2022',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'KD Sports'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = '1-day pas')
FROM DUAL
UNION ALL
SELECT '16/02/2023',
       '15/02/2024',
       (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Geel'),
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'mia.stevens@outlook.be'),
       (SELECT ABONNEMENTID FROM ABONNEMENTS WHERE NAME = 'Premium')
FROM DUAL;

-- Machine
INSERT INTO MACHINES (NAME, WEIGHT, PRICE, BRAND, FITNESS_FITNESSID)
SELECT 'Bench', 20, 249, 'Rogue', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Herentals')
FROM DUAL
UNION ALL
SELECT 'Squat rack', 100, 2399, 'Hammersmith', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Herentals')
FROM DUAL
UNION ALL
SELECT 'Deadlift platform', 20, 399, 'Rogue', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'KD Sports')
FROM DUAL
UNION ALL
SELECT 'Pull up station', 50, 249, 'Echelon', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Eiermarkt')
FROM DUAL
UNION ALL
SELECT 'Dips station', 50, 149, 'Titan', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'Basic Fit Eeklo')
FROM DUAL
UNION ALL
SELECT 'Smith machine', 160, 3299, 'Titan', (SELECT FITNESSID FROM FITNESS WHERE NAME = 'KD Sports')
FROM DUAL;

-- Difficulty
INSERT INTO DIFFICULTYS (NAME)
SELECT 'Easy'
FROM DUAL
UNION ALL
SELECT 'Intermediate'
FROM DUAL
UNION ALL
SELECT 'Hard'
FROM DUAL
UNION ALL
SELECT 'Very hard'
FROM DUAL
UNION ALL
SELECT 'Impossible'
FROM DUAL;

-- Musclegroup
INSERT INTO MUSCLEGROUPS (NAME)
SELECT 'Chest'
FROM DUAL
UNION ALL
SELECT 'Back'
FROM DUAL
UNION ALL
SELECT 'Triceps'
FROM DUAL
UNION ALL
SELECT 'Biceps'
FROM DUAL
UNION ALL
SELECT 'Schoulders'
FROM DUAL
UNION ALL
SELECT 'Legs'
FROM DUAL
UNION ALL
SELECT 'Abs'
FROM DUAL;

-- Exercise
INSERT INTO EXERCISES (NAME, MAXWEIGHT, INSTRUCTION, MACHINE_MACHINEID, DIFFICULTY_DIFFICULTYID, MUSCLEGROUP_MUCLSEGROUPID)
SELECT 'BB bench',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Bench'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Chest')
FROM DUAL
UNION ALL
SELECT 'DB bench',
       120,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Bench'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Intermediate'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Chest')
FROM DUAL
UNION ALL
SELECT 'Squat',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Squat rack'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Hard'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Legs')
FROM DUAL
UNION ALL
SELECT 'BB rows',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Squat rack'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Hard'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Back')
FROM DUAL
UNION ALL
SELECT 'Overheid press',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Squat rack'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Schoulders')
FROM DUAL
UNION ALL
SELECT 'Deadlift',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Deadlift platform'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Hard'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Back')
FROM DUAL
UNION ALL
SELECT 'Pull ups',
       100,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Pull up station'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Intermediate'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Back')
FROM DUAL
UNION ALL
SELECT 'Chin ups',
       100,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Pull up station'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Biceps')
FROM DUAL
UNION ALL
SELECT 'Dips',
       100,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Dips station'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Triceps')
FROM DUAL
UNION ALL
SELECT 'SM Bench',
       300,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Smith machine'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Chest')
FROM DUAL
UNION ALL
SELECT 'SM overheid press',
       300,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Smith machine'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Schoulders')
FROM DUAL
UNION ALL
SELECT 'Incline DB bench',
       120,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Bench'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Intermediate'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Chest')
FROM DUAL
UNION ALL
SELECT 'Lunges',
       1000,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Squat rack'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Hard'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Legs')
FROM DUAL
UNION ALL
SELECT 'Incline bicep curls',
       120,
       'Lorem ipsum dolor sit amet',
       (SELECT MACHINEID FROM MACHINES WHERE NAME = 'Bench'),
       (SELECT DIFFICULTYID FROM DIFFICULTYS WHERE NAME = 'Easy'),
       (SELECT MUCLSEGROUPID FROM MUSCLEGROUPS WHERE NAME = 'Biceps')
FROM DUAL;

-- TimeOfPractice
INSERT INTO TIMEOFPRACTICES (PRACTICEDATE, REPS, SETS, ADDEDWEIGHT, MEMBER_MEMBERID,
                            EXERCISE_EXERCISEID)
SELECT '01/03/2023',
       12,
       3,
       60,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'BB bench')
FROM DUAL
UNION ALL
SELECT '01/03/2023',
       14,
       3,
       56,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'DB bench')
FROM DUAL
UNION ALL
SELECT '01/03/2023',
       6,
       5,
       40,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Squat')
FROM DUAL
UNION ALL
SELECT '01/03/2023',
       16,
       2,
       60,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'BB rows')
FROM DUAL
UNION ALL
SELECT '06/03/2023',
       4,
       6,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Chin ups')
FROM DUAL
UNION ALL
SELECT '06/03/2023',
       10,
       4,
       50,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'senne.david@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Incline DB bench')
FROM DUAL
UNION ALL
SELECT '07/03/2023',
       12,
       5,
       32,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'senne.david@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Incline bicep curls')
FROM DUAL
UNION ALL
SELECT '09/03/2023',
       10,
       3,
       50,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'senne.david@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'SM overheid press')
FROM DUAL
UNION ALL
SELECT '10/03/2023',
       12,
       4,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'senne.david@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Dips')
FROM DUAL
UNION ALL
SELECT '10/03/2023',
       12,
       5,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'robbe.verslype@yahoo.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Pull ups')
FROM DUAL
UNION ALL
SELECT '11/03/2023',
       16,
       3,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'robbe.verslype@yahoo.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Dips')
FROM DUAL
UNION ALL
SELECT '11/03/2023',
       8,
       6,
       40,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'robbe.verslype@yahoo.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'BB bench')
FROM DUAL
UNION ALL
SELECT '12/03/2023',
       8,
       4,
       40,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'robbe.verslype@yahoo.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'SM overheid press')
FROM DUAL
UNION ALL
SELECT '12/03/2023',
       8,
       3,
       30,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'mia.stevens@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'DB bench')
FROM DUAL
UNION ALL
SELECT '12/03/2023',
       12,
       3,
       20,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'mia.stevens@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Lunges')
FROM DUAL
UNION ALL
SELECT '12/03/2023',
       10,
       3,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'mia.stevens@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Chin ups')
FROM DUAL
UNION ALL
SELECT '13/03/2023',
       6,
       4,
       10,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'mia.stevens@outlook.be'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Overheid press')
FROM DUAL
UNION ALL
SELECT '14/03/2023',
       6,
       5,
       0,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Pull ups')
FROM DUAL
UNION ALL
SELECT '14/03/2023',
       12,
       3,
       80,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'arthur.linsen@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Squat')
FROM DUAL
UNION ALL
SELECT '14/03/2023',
       16,
       3,
       60,
       (SELECT MEMBERID FROM MEMBERS WHERE EMAIL = 'luna.lybaert@gmail.com'),
       (SELECT EXERCISEID FROM EXERCISES WHERE NAME = 'Squat')
FROM DUAL;