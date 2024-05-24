CREATE OR REPLACE PACKAGE BODY PKG_fitness
AS
    gn_fitness_counter NUMBER := 0; -- 5 => basislijnen met m4
    gn_members_counter NUMBER := 0; -- 5
    gn_membershipcards_counter NUMBER := 0; -- 7

    TYPE type_bulk_fitness IS TABLE OF FITNESS%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE type_bulk_machines IS TABLE OF MACHINES%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE type_bulk_exercises IS TABLE OF EXERCISES%ROWTYPE INDEX BY PLS_INTEGER;

    ----------------------
    -- LOOKUP FUNCTIONS --
    ----------------------
    FUNCTION lookup_address(
        p_address_street ADDRESS.STREET%TYPE,
        p_address_streetnumber ADDRESS.STREETNUMBER%TYPE,
        p_address_postalcode ADDRESS.POSTALCODE%TYPE
    )
        RETURN NUMERIC
        IS
        v_addressid NUMERIC;
    BEGIN
        SELECT ADDRESSID
        INTO v_addressid
        FROM ADDRESS
        WHERE STREET = p_address_street
          AND STREETNUMBER = p_address_streetnumber
          AND POSTALCODE = p_address_postalcode;

        RETURN v_addressid;
    END lookup_address;

    FUNCTION lookup_abonnement(
        p_abonnement_name ABONNEMENTS.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_abonnementid NUMERIC;
    BEGIN
        SELECT ABONNEMENTID
        INTO v_abonnementid
        FROM ABONNEMENTS
        WHERE NAME = p_abonnement_name;

        RETURN v_abonnementid;
    END lookup_abonnement;

    FUNCTION lookup_machine(
        p_machine_name MACHINES.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_machineid NUMERIC;
    BEGIN
        SELECT MACHINEID
        INTO v_machineid
        FROM MACHINES
        WHERE NAME = p_machine_name;

        RETURN v_machineid;
    END lookup_machine;

    FUNCTION lookup_difficulty(
        p_difficulty_name DIFFICULTYS.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_difficultyid NUMERIC;
    BEGIN
        SELECT DIFFICULTYID
        INTO v_difficultyid
        FROM DIFFICULTYS
        WHERE NAME = p_difficulty_name;

        RETURN v_difficultyid;
    END lookup_difficulty;

    FUNCTION lookup_musclegroup(
        p_musclegroup_name MUSCLEGROUPS.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_musclegroupid NUMERIC;
    BEGIN
        SELECT MUCLSEGROUPID
        INTO v_musclegroupid
        FROM MUSCLEGROUPS
        WHERE NAME = p_musclegroup_name;

        RETURN v_musclegroupid;
    END lookup_musclegroup;

    FUNCTION lookup_member(
        p_member_email MEMBERS.EMAIL%TYPE
    )
        RETURN NUMERIC
        IS
        v_memberid NUMERIC;
    BEGIN
        SELECT MEMBERID
        INTO v_memberid
        FROM MEMBERS
        WHERE EMAIL = p_member_email;

        RETURN v_memberid;
    END lookup_member;

    FUNCTION lookup_fitness(
        p_fitness_name FITNESS.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_fitnessid NUMERIC;
    BEGIN
        SELECT FITNESSID
        INTO v_fitnessid
        FROM FITNESS
        WHERE NAME = p_fitness_name;

        RETURN v_fitnessid;
    END lookup_fitness;

    FUNCTION lookup_max_fitnessid
        RETURN NUMERIC
        IS
        v_fitnessid NUMERIC;
    BEGIN
        SELECT MAX(FITNESSID)
        INTO v_fitnessid
        FROM FITNESS;

        RETURN v_fitnessid;
    END lookup_max_fitnessid;

    FUNCTION lookup_exercise(
        p_exercise_name EXERCISES.NAME%TYPE
    )
        RETURN NUMERIC
        IS
        v_exerciseid NUMERIC;
    BEGIN
        SELECT EXERCISEID
        INTO v_exerciseid
        FROM EXERCISES
        WHERE NAME = p_exercise_name;

        RETURN v_exerciseid;
    END lookup_exercise;

    FUNCTION lookup_max_machineid
        RETURN NUMERIC
        IS
        v_machineid NUMERIC;
    BEGIN
        SELECT MAX(MACHINEID)
        INTO v_machineid
        FROM MACHINES;

        RETURN v_machineid;
    END lookup_max_machineid;

    FUNCTION lookup_total_exercise
        RETURN NUMERIC
        IS
        v_tot_exercises NUMERIC;
    BEGIN
        SELECT COUNT(*)
        INTO v_tot_exercises
        FROM EXERCISES;

        RETURN v_tot_exercises;
    END lookup_total_exercise;

    FUNCTION lookup_total_machine
        RETURN NUMERIC
        IS
        v_tot_machines NUMERIC;
    BEGIN
        SELECT COUNT(*)
        INTO v_tot_machines
        FROM MACHINES;

        RETURN v_tot_machines;
    END lookup_total_machine;

    FUNCTION timestamp_diff(a timestamp, b timestamp)
        RETURN number
        IS
    BEGIN
        RETURN EXTRACT(day from (a - b)) * 24 * 60 * 60 +
               EXTRACT(hour from (a - b)) * 60 * 60 +
               EXTRACT(minute from (a - b)) * 60 +
               EXTRACT(second from (a - b));
    END;
    ----------------------

    ----------------------
    -- RANDOM FUNCTIONS --
    ----------------------
    FUNCTION give_random_number(
        v_start_range NUMERIC,
        v_end_range NUMERIC
    )
        RETURN NUMERIC
    AS
    BEGIN
        return TRUNC(DBMS_RANDOM.VALUE(v_start_range, v_end_range));
    END give_random_number;

    FUNCTION give_random_date(
        v_start_date DATE,
        v_end_date DATE
    )
        RETURN DATE
    AS
        v_range    NUMERIC;
        v_datepick NUMERIC;
    BEGIN
        v_range := v_end_date - v_start_date;
        v_datepick := give_random_number(0, v_range);
        return v_start_date + v_datepick;
    END give_random_date;

    FUNCTION give_random_brand
        return VARCHAR2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        t_brand string_array;
        N       PLS_INTEGER;
    BEGIN
        t_brand(1) := 'Rogue';
        t_brand(2) := 'Hammersmith';
        t_brand(3) := 'Echelon';
        t_brand(4) := 'Titon';
        t_brand(5) := 'Nautilus';
        t_brand(6) := 'Tunturi';
        t_brand(7) := 'Matrix';
        t_brand(8) := 'Cybex';
        t_brand(9) := 'Stairmaster';
        t_brand(10) := 'Life Fitness';

        N := t_brand.COUNT;
        RETURN t_brand(DBMS_RANDOM.VALUE(1, N));
    END give_random_brand;

    FUNCTION give_random_gender
        return varchar2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(1) INDEX BY PLS_INTEGER;
        t_gender string_array;
        N        PLS_INTEGER;
    BEGIN
        t_gender(1) := 'M';
        t_gender(2) := 'F';

        N := t_gender.COUNT;
        RETURN t_gender(DBMS_RANDOM.VALUE(1, N));
    END give_random_gender;

    FUNCTION give_random_abonnement
        return varchar2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        t_abonnement string_array;
        N            PLS_INTEGER;
    BEGIN
        t_abonnement(1) := 'Basic';
        t_abonnement(2) := 'Premium';
        t_abonnement(3) := '1-day pas';
        t_abonnement(4) := '1-week pas';
        t_abonnement(5) := '10 turns-card';

        N := t_abonnement.COUNT;
        RETURN t_abonnement(DBMS_RANDOM.VALUE(1, N));
    END give_random_abonnement;

    FUNCTION give_random_email
        return varchar2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        t_email string_array;
        N       PLS_INTEGER;
    BEGIN
        t_email(1) := '@gmail.com';
        t_email(2) := '@outlook.be';
        t_email(3) := '@yahoo.com';
        t_email(4) := '@skynet.be';
        t_email(5) := '@hotmail.com';

        N := t_email.COUNT;
        RETURN t_email(DBMS_RANDOM.VALUE(1, N));
    END give_random_email;

    FUNCTION give_random_difficulty
        return varchar2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        t_difficulty string_array;
        N            PLS_INTEGER;
    BEGIN
        t_difficulty(1) := 'Easy';
        t_difficulty(2) := 'Intermediate';
        t_difficulty(3) := 'Hard';
        t_difficulty(4) := 'Very hard';
        t_difficulty(5) := 'Impossible';

        N := t_difficulty.COUNT;
        RETURN t_difficulty(DBMS_RANDOM.VALUE(1, N));
    END give_random_difficulty;

    FUNCTION give_random_musclegroup
        return varchar2
    AS
        TYPE string_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        t_musclegroup string_array;
        N             PLS_INTEGER;
    BEGIN
        t_musclegroup(1) := 'Chest';
        t_musclegroup(2) := 'Back';
        t_musclegroup(3) := 'Triceps';
        t_musclegroup(4) := 'Biceps';
        t_musclegroup(5) := 'Schoulders';
        t_musclegroup(6) := 'Legs';
        t_musclegroup(7) := 'Abs';

        N := t_musclegroup.COUNT;
        RETURN t_musclegroup(DBMS_RANDOM.VALUE(1, N));
    END give_random_musclegroup;
    ----------------------

    --------------------------
    -- ADD SINGLE ROW IN DB --
    --------------------------
    PROCEDURE add_abonnement(
        p_abonnement_name ABONNEMENTS.NAME%TYPE,
        p_abonnement_description ABONNEMENTS.DESCRIPTION%TYPE
    )
    AS
    BEGIN
        INSERT INTO ABONNEMENTS(NAME, DESCRIPTION) VALUES (p_abonnement_name, p_abonnement_description);
    END add_abonnement;

    PROCEDURE add_address(
        p_address_street ADDRESS.STREET%TYPE,
        p_address_streetnumber ADDRESS.STREETNUMBER%TYPE,
        p_address_postalcode ADDRESS.POSTALCODE%TYPE
    )
    AS
    BEGIN
        INSERT INTO ADDRESS(STREET, STREETNUMBER, POSTALCODE)
        VALUES (p_address_street, p_address_streetnumber, p_address_postalcode);
    END add_address;

    PROCEDURE add_difficulty(
        p_difficulty_name DIFFICULTYS.NAME%TYPE
    )
    AS
    BEGIN
        INSERT INTO DIFFICULTYS(NAME)
        VALUES (p_difficulty_name);
    END add_difficulty;

    PROCEDURE add_exercise(
        p_exercise_name EXERCISES.NAME%TYPE,
        p_exercise_maxweight EXERCISES.MAXWEIGHT%TYPE,
        p_exercise_instruction EXERCISES.INSTRUCTION%TYPE,
        p_machine_name MACHINES.NAME%TYPE,
        p_difficulty_name DIFFICULTYS.NAME%TYPE,
        p_musclegroup_name MUSCLEGROUPS.NAME%TYPE
    )
    AS
        v_machine_id     NUMERIC;
        v_difficulty_id  NUMERIC;
        v_muslcegroup_id NUMERIC;
    BEGIN
        v_machine_id := lookup_machine(p_machine_name);
        v_difficulty_id := lookup_difficulty(p_difficulty_name);
        v_muslcegroup_id := lookup_musclegroup(p_musclegroup_name);
        INSERT INTO EXERCISES(NAME, MAXWEIGHT, INSTRUCTION, MACHINE_MACHINEID, DIFFICULTY_DIFFICULTYID,
                              MUSCLEGROUP_MUCLSEGROUPID)
        VALUES (p_exercise_name, p_exercise_maxweight, p_exercise_instruction, v_machine_id, v_difficulty_id,
                v_muslcegroup_id);
    END add_exercise;

    PROCEDURE add_fitness(
        p_fitness_name FITNESS.NAME%TYPE,
        p_fitness_surface FITNESS.SURFACE%TYPE,
        p_address_street ADDRESS.STREET%TYPE,
        p_address_streetnumber ADDRESS.STREETNUMBER%TYPE,
        p_address_postalcode ADDRESS.POSTALCODE%TYPE
    )
    AS
        v_address_id NUMERIC;
    BEGIN
        v_address_id := lookup_address(p_address_street, p_address_streetnumber, p_address_postalcode);
        INSERT INTO FITNESS(NAME, SURFACE, ADDRESS_ADDRESSID)
        VALUES (p_fitness_name, p_fitness_surface, v_address_id);
    END add_fitness;

    PROCEDURE add_machine(
        p_machine_name MACHINES.NAME%TYPE,
        p_machine_weight MACHINES.WEIGHT%TYPE,
        p_machine_price MACHINES.PRICE%TYPE,
        p_machine_brand MACHINES.BRAND%TYPE,
        p_fitness_name FITNESS.NAME%TYPE
    )
    AS
        v_fitness_id NUMERIC;
    BEGIN
        v_fitness_id := lookup_fitness(p_fitness_name);
        INSERT INTO MACHINES(NAME, WEIGHT, PRICE, BRAND, FITNESS_FITNESSID)
        VALUES (p_machine_name, p_machine_weight, p_machine_price, p_machine_brand, v_fitness_id);
    END add_machine;

    PROCEDURE add_member(
        p_member_name MEMBERS.NAME%TYPE,
        p_member_birthdate MEMBERS.BIRTH_DATE%TYPE,
        p_member_email MEMBERS.EMAIL%TYPE,
        p_member_gender MEMBERS.GENDER%TYPE,
        p_member_bodyweight MEMBERS.BODYWEIGHT%TYPE
    )
    AS
    BEGIN
        INSERT INTO MEMBERS(NAME, BIRTH_DATE, EMAIL, GENDER, BODYWEIGHT)
        VALUES (p_member_name, p_member_birthdate, p_member_email, p_member_gender, p_member_bodyweight);
    END add_member;

    PROCEDURE add_membershipcard(
        p_membershipcard_startdate MEMBERCHIPCARDS.STARTDATE%TYPE,
        p_membershipcard_enddate MEMBERCHIPCARDS.ENDDATE%TYPE,
        p_fitness_name FITNESS.NAME%TYPE,
        p_member_email MEMBERS.EMAIL%TYPE,
        p_abonnement_name ABONNEMENTS.NAME%TYPE
    )
    AS
        v_fitness_id    NUMERIC;
        v_member_id     NUMERIC;
        v_abonnement_id NUMERIC;
    BEGIN
        v_fitness_id := lookup_fitness(p_fitness_name);
        v_member_id := lookup_member(p_member_email);
        v_abonnement_id := lookup_abonnement(p_abonnement_name);
        INSERT INTO MEMBERCHIPCARDS(STARTDATE, ENDDATE, FITNESS_FITNESSID, MEMBER_MEMBERID, ABONNEMENT_ABONNEMENTID)
        VALUES (p_membershipcard_startdate, p_membershipcard_enddate, v_fitness_id,
                v_member_id,
                v_abonnement_id);
    END add_membershipcard;

    PROCEDURE add_musclegroup(
        p_musclegroup_name MUSCLEGROUPS.NAME%TYPE
    )
    AS
    BEGIN
        INSERT INTO MUSCLEGROUPS(NAME)
        VALUES (p_musclegroup_name);
    END add_musclegroup;

    PROCEDURE add_timeofpractice(
        p_timeofpractice_practicedate TIMEOFPRACTICES.PRACTICEDATE%TYPE,
        p_timeofpractice_reps TIMEOFPRACTICES.REPS%TYPE,
        p_timeofpractice_sets TIMEOFPRACTICES.SETS%TYPE,
        p_timeofpractice_addedweight TIMEOFPRACTICES.ADDEDWEIGHT%TYPE,
        p_member_email MEMBERS.EMAIL%TYPE,
        p_exercise_name EXERCISES.NAME%TYPE
    )
    AS
        v_member_id   NUMERIC;
        v_exercise_id NUMERIC;
    BEGIN
        v_member_id := lookup_member(p_member_email);
        v_exercise_id := lookup_exercise(p_exercise_name);
        INSERT INTO TIMEOFPRACTICES(PRACTICEDATE, REPS, SETS, ADDEDWEIGHT, MEMBER_MEMBERID, EXERCISE_EXERCISEID)
        VALUES (p_timeofpractice_practicedate, p_timeofpractice_reps, p_timeofpractice_sets,
                p_timeofpractice_addedweight, v_member_id, v_exercise_id);
    END add_timeofpractice;
    --------------------------

    ------------------------------------
    -- ADD MULTIPLE RANDOM ROWS IN DB --
    ------------------------------------
    PROCEDURE generate_random_fitness(v_amount NUMERIC)
        IS
        v_name       VARCHAR2(100);
        v_surface    NUMERIC;
        v_address_id NUMERIC;
    BEGIN
        FOR teller IN 1..v_amount
            LOOP
                gn_fitness_counter := gn_fitness_counter + 1;
                v_name := 'Fitness' || gn_fitness_counter;
                v_surface := give_random_number(20, 300);
                v_address_id := give_random_number(1, 6);

                INSERT INTO FITNESS (NAME, SURFACE, ADDRESS_ADDRESSID)
                VALUES (v_name, v_surface, v_address_id);
            END LOOP;
    END generate_random_fitness;

    PROCEDURE generate_random_member(v_amount NUMERIC)
        IS
        v_name  VARCHAR2(100);
        v_email VARCHAR2(200);
    BEGIN
        FOR teller IN 1..v_amount
            LOOP
                gn_members_counter := gn_members_counter + 1;
                v_name := 'Member' || gn_members_counter;
                v_email := v_name || '@gmail.com';
                add_member(
                        v_name,
                        give_random_date(to_date('01011950', 'DDMMYYYY'), to_date('31122007', 'DDMMYYYY')),
                        v_email,
                        give_random_gender(),
                        give_random_number(50, 150)
                    );
            END LOOP;
    END generate_random_member;

    PROCEDURE generate_random_membershipcard(v_amount NUMERIC)
        IS
        v_start_date DATE;
    BEGIN
        FOR teller IN 1..v_amount
            LOOP
                gn_membershipcards_counter := gn_membershipcards_counter + 1;
                v_start_date := give_random_date(to_date('01012022', 'DDMMYYYY'), sysdate - 10);
                add_membershipcard(
                        v_start_date,
                        v_start_date + give_random_number(1, 100),
                        'Fitness' || give_random_number(1, 20),
                        'Member' || give_random_number(1, 20) || '@gmail.com',
                        give_random_abonnement()
                    );
            END LOOP;
    END generate_random_membershipcard;

    PROCEDURE generate_random_machine(v_amount NUMERIC)
        IS
        v_fitness_counter  NUMBER := 0;
        v_machines_counter NUMBER := 0;
        v_max_fitnessid    NUMBER := lookup_max_fitnessid();
        v_name             VARCHAR2(100);
        v_weight           NUMBER;
        v_price            NUMBER;
        v_brand            VARCHAR2(100);
        v_fitness_id       NUMERIC;
    BEGIN
        LOOP
            v_fitness_counter := v_fitness_counter + 1;
            FOR teller IN 1..v_amount
                LOOP
                    v_machines_counter := v_machines_counter + 1;

                    v_name := 'Machine' || v_machines_counter;
                    v_weight := give_random_number(20, 250);
                    v_price := give_random_number(100, 2500);
                    v_brand := give_random_brand();
                    v_fitness_id := v_fitness_counter;

                    INSERT INTO MACHINES (NAME, WEIGHT, PRICE, BRAND, FITNESS_FITNESSID)
                    VALUES (v_name, v_weight, v_price, v_brand, v_fitness_id);
                END LOOP;
            EXIT WHEN v_fitness_counter >= v_max_fitnessid;
        END LOOP;
    END generate_random_machine;

    PROCEDURE generate_random_exercise(v_amount NUMERIC)
        IS
        TYPE t_machine IS TABLE OF machines.MACHINEID%TYPE;
        t_id                t_machine;
        v_exercises_counter NUMBER := 0;
        v_max_machineid     NUMBER := lookup_max_machineid();
        v_name              VARCHAR2(100);
        v_maxweight         NUMBER;
        v_instruction       VARCHAR2(100);
        v_machineid         NUMERIC;
        v_difficultyid      VARCHAR2(100);
        v_musclegroupid     VARCHAR2(100);

    BEGIN
        SELECT MACHINEID BULK COLLECT INTO t_id FROM MACHINES;
        FOR i IN 1..v_max_machineid
            LOOP
                FOR teller IN 1..v_amount
                    LOOP
                        v_exercises_counter := v_exercises_counter + 1;
                        v_name := 'Exercise' || v_exercises_counter;
                        v_maxweight := give_random_number(1, 1000);
                        v_instruction := 'Lorem ipsum dolor sit amet';
                        v_machineid := i;
                        v_difficultyid := give_random_number(1, 6);
                        v_musclegroupid := give_random_number(1, 8);

                        INSERT INTO EXERCISES (NAME, MAXWEIGHT, INSTRUCTION, MACHINE_MACHINEID, DIFFICULTY_DIFFICULTYID,
                                               MUSCLEGROUP_MUCLSEGROUPID)
                        VALUES (v_name, v_maxweight, v_instruction, v_machineid, v_difficultyid, v_musclegroupid);
                    END LOOP;
            END LOOP;
    END generate_random_exercise;

    PROCEDURE generate_2_levels(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC
    )
        IS
    BEGIN
        generate_random_fitness(v_amount_f);
        generate_random_machine(v_amount_m);
        generate_random_exercise(v_amount_e);
    END generate_2_levels;
    ------------------------------------

    -----------------------------
    -- ADD RANDOM ROWS IN BULK --
    -----------------------------
    PROCEDURE add_fitness_bulk(p_fitness IN type_bulk_fitness)
    AS
    BEGIN
        FORALL i IN INDICES OF p_fitness
            INSERT INTO FITNESS(NAME, SURFACE, ADDRESS_ADDRESSID)
            VALUES (p_fitness(i).NAME, p_fitness(i).SURFACE, p_fitness(i).ADDRESS_ADDRESSID);
    END add_fitness_bulk;

    PROCEDURE add_machine_bulk(p_machines IN type_bulk_machines)
    AS
    BEGIN
        FORALL i IN INDICES OF p_machines
            INSERT INTO MACHINES(NAME, WEIGHT, PRICE, BRAND, FITNESS_FITNESSID)
            VALUES (p_machines(i).NAME, p_machines(i).WEIGHT, p_machines(i).PRICE, p_machines(i).BRAND,
                    p_machines(i).FITNESS_FITNESSID);
    END add_machine_bulk;

    PROCEDURE add_exercise_bulk(p_exercises IN type_bulk_exercises)
    AS
    BEGIN
        FORALL i IN INDICES OF p_exercises
            INSERT INTO EXERCISES(NAME, MAXWEIGHT, INSTRUCTION, MACHINE_MACHINEID, DIFFICULTY_DIFFICULTYID,
                                  MUSCLEGROUP_MUCLSEGROUPID)
            VALUES (p_exercises(i).NAME, p_exercises(i).MAXWEIGHT, p_exercises(i).INSTRUCTION,
                    p_exercises(i).MACHINE_MACHINEID, p_exercises(i).DIFFICULTY_DIFFICULTYID,
                    p_exercises(i).MUSCLEGROUP_MUCLSEGROUPID);
    END add_exercise_bulk;

    PROCEDURE generate_random_fitness_bulk(v_amount NUMERIC)
        IS
        v_fitness    type_bulk_fitness;
        v_amount_gen NUMBER := 1;
    BEGIN
        LOOP
            v_fitness(v_amount_gen).NAME := 'Fitness' || v_amount_gen;
            v_fitness(v_amount_gen).SURFACE := give_random_number(20, 300);
            v_fitness(v_amount_gen).ADDRESS_ADDRESSID := give_random_number(1, 6);

            v_amount_gen := v_amount_gen + 1;
            EXIT WHEN v_amount_gen > v_amount;
        END LOOP;
        add_fitness_bulk(v_fitness);
    END generate_random_fitness_bulk;

    PROCEDURE generate_random_machine_bulk(v_amount NUMERIC)
        IS
        TYPE type_fitness_id IS TABLE OF fitness.FITNESSID%TYPE INDEX BY PLS_INTEGER;
        t_fitness_id    type_fitness_id;
        v_machines      type_bulk_machines;
        v_amount_gen    NUMBER := 1;
        v_max_fitnessid NUMBER := lookup_max_fitnessid();
    BEGIN
--         SELECT MACHINEID BULK COLLECT INTO t_fitness_id FROM MACHINES;
--         FOR i IN 1..v_max_fitnessid
--             LOOP
                LOOP
                    v_machines(v_amount_gen).NAME := 'Machine' || v_amount_gen;
                    v_machines(v_amount_gen).WEIGHT := give_random_number(20, 250);
                    v_machines(v_amount_gen).PRICE := give_random_number(100, 2500);
                    v_machines(v_amount_gen).BRAND := give_random_brand();
                    v_machines(v_amount_gen).FITNESS_FITNESSID := give_random_number(1, v_max_fitnessid);

                    v_amount_gen := v_amount_gen + 1;
                    EXIT WHEN v_amount_gen > v_amount;
                END LOOP;
                add_machine_bulk(v_machines);
--             END LOOP;
    END generate_random_machine_bulk;

    PROCEDURE
        generate_random_exercise_bulk(v_amount NUMERIC)
        IS
        TYPE type_machine_id IS TABLE OF machines.MACHINEID%TYPE INDEX BY PLS_INTEGER;
        t_machine_id    type_machine_id;
        v_exercises     type_bulk_exercises;
        v_amount_gen    NUMBER := 1;
        v_max_machineid NUMBER := lookup_max_machineid();
    BEGIN
        --         SELECT MACHINEID BULK COLLECT INTO t_machine_id FROM MACHINES;
--         FOR i IN 1..v_max_machineid
--             LOOP
        LOOP
            v_exercises(v_amount_gen).NAME := 'Exercise' || v_amount_gen;
            v_exercises(v_amount_gen).MAXWEIGHT := give_random_number(1, 1000);
            v_exercises(v_amount_gen).INSTRUCTION := 'Lorem ipsum dolor sit amet';
            v_exercises(v_amount_gen).MACHINE_MACHINEID := give_random_number(1, v_max_machineid);
            v_exercises(v_amount_gen).DIFFICULTY_DIFFICULTYID := give_random_number(1, 6);
            v_exercises(v_amount_gen).MUSCLEGROUP_MUCLSEGROUPID := give_random_number(1, 8);

            v_amount_gen := v_amount_gen + 1;
            EXIT WHEN v_amount_gen > v_amount;

        END LOOP;
        add_exercise_bulk(v_exercises);
--             END LOOP;
    END generate_random_exercise_bulk;

    PROCEDURE
        generate_2_levels_bulk(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC
    )
        IS
        v_teller       NUMBER := 0;
        v_tot_amount_m NUMBER := v_amount_f * v_amount_m;
    BEGIN
        generate_random_fitness_bulk(v_amount_f);
        LOOP
            generate_random_machine_bulk(v_amount_m);
            v_teller := v_teller + 1;
            EXIT WHEN v_teller = v_amount_f;
        END LOOP;
        v_teller := 0;
        LOOP
            generate_random_exercise_bulk(v_amount_e);
            v_teller := v_teller + 1;
            EXIT WHEN v_teller = v_tot_amount_m;
        END LOOP;
    END generate_2_levels_bulk;
    -----------------------------

    ---------------------------
    -- Additional PROCEDURES --
    ---------------------------
    PROCEDURE
        generate_necessary_data
        IS
    BEGIN
        ADD_ABONNEMENT('Basic', 'a 1 year subscription to 1 gym');
        ADD_ABONNEMENT('Premium', 'a 1 year subscription to 1 gym with personal training');
        ADD_ABONNEMENT('1-day pas', 'a 1 day pas to 1 gym');
        ADD_ABONNEMENT('1-week pas', 'a 1 week pas to 1 gym');
        ADD_ABONNEMENT('10 turns-card', 'a 10 turns-card to 1 gym');

        ADD_ADDRESS('Belgiëlaan', 58, 2200);
        ADD_ADDRESS('Lierseweg', 317, 2200);
        ADD_ADDRESS('Eiermarkt', 21, 2000);
        ADD_ADDRESS('Stationstraat', 17, 9900);
        ADD_ADDRESS('Antwerpseweg', 79, 2440);

        ADD_DIFFICULTY('Easy');
        ADD_DIFFICULTY('Intermediate');
        ADD_DIFFICULTY('Hard');
        ADD_DIFFICULTY('Very hard');
        ADD_DIFFICULTY('Impossible');

        ADD_MUSCLEGROUP('Chest');
        ADD_MUSCLEGROUP('Back');
        ADD_MUSCLEGROUP('Triceps');
        ADD_MUSCLEGROUP('Biceps');
        ADD_MUSCLEGROUP('Schoulders');
        ADD_MUSCLEGROUP('Legs');
        ADD_MUSCLEGROUP('Abs');
    END;
    ---------------------------

    -----------------------
    -- PUBLIC PROCEDURES --
    -----------------------
    PROCEDURE
        empty_tables
        IS
        v_col       NUMBER;
        v_id_column VARCHAR2(40);
    BEGIN
        FOR fk IN (SELECT * FROM user_constraints WHERE constraint_type = 'R')
            LOOP
                EXECUTE IMMEDIATE 'ALTER TABLE ' || fk.owner || '.' || fk.table_name || ' DISABLE CONSTRAINT ' ||
                                  fk.constraint_name;
            END LOOP;

        FOR tab IN (SELECT table_name FROM user_tables)
            LOOP
                SELECT COLUMN_NAME, COUNT(*)
                INTO v_id_column, v_col
                FROM all_tab_cols
                WHERE table_name = tab.table_name
                  AND identity_column = 'YES'
                GROUP BY COLUMN_NAME;

                IF v_col > 0 THEN
                    EXECUTE IMMEDIATE ('ALTER TABLE ' || tab.TABLE_NAME || ' MODIFY(' || v_id_column ||
                                       ' GENERATED ALWAYS AS IDENTITY(START WITH 1))');
                END IF;

                --DBMS_OUTPUT.PUT_LINE('Deleting table ' || tab.TABLE_NAME);
                EXECUTE IMMEDIATE ('TRUNCATE TABLE ' || tab.TABLE_NAME || ' CASCADE');
            END LOOP;

        FOR fk IN (SELECT * FROM user_constraints WHERE constraint_type = 'R')
            LOOP
                EXECUTE IMMEDIATE 'ALTER TABLE ' || fk.owner || '.' || fk.table_name || ' ENABLE CONSTRAINT ' ||
                                  fk.constraint_name;
            END LOOP;
    END empty_tables;

    PROCEDURE
        fill_tables
        IS
    BEGIN
        ADD_ABONNEMENT('Basic', 'a 1 year subscription to 1 gym');
        ADD_ABONNEMENT('Premium', 'a 1 year subscription to 1 gym with personal training');
        ADD_ABONNEMENT('1-day pas', 'a 1 day pas to 1 gym');
        ADD_ABONNEMENT('1-week pas', 'a 1 week pas to 1 gym');
        ADD_ABONNEMENT('10 turns-card', 'a 10 turns-card to 1 gym');

        ADD_ADDRESS('Belgiëlaan', 58, 2200);
        ADD_ADDRESS('Lierseweg', 317, 2200);
        ADD_ADDRESS('Eiermarkt', 21, 2000);
        ADD_ADDRESS('Stationstraat', 17, 9900);
        ADD_ADDRESS('Antwerpseweg', 79, 2440);

        ADD_DIFFICULTY('Easy');
        ADD_DIFFICULTY('Intermediate');
        ADD_DIFFICULTY('Hard');
        ADD_DIFFICULTY('Very hard');
        ADD_DIFFICULTY('Impossible');

        ADD_MUSCLEGROUP('Chest');
        ADD_MUSCLEGROUP('Back');
        ADD_MUSCLEGROUP('Triceps');
        ADD_MUSCLEGROUP('Biceps');
        ADD_MUSCLEGROUP('Schoulders');
        ADD_MUSCLEGROUP('Legs');
        ADD_MUSCLEGROUP('Abs');

        ADD_MEMBER('Arthur Linsen', '19/05/2003', 'arthur.linsen@gmail.com', 'M', 70);
        ADD_MEMBER('Luna Lybaert', '31/03/2004', 'luna.lybaert@gmail.com', 'F', 58);
        ADD_MEMBER('Senne David', '06/06/2003', 'senne.david@outlook.be', 'M', 68);
        ADD_MEMBER('Robbe Verslype', '10/12/2003', 'robbe.verslype@yahoo.com', 'M', 74);
        ADD_MEMBER('Mia Stevens', '10/07/2004', 'mia.stevens@outlook.be', 'F', 60);

        ADD_FITNESS('Basic Fit Herentals', 80, 'Belgiëlaan', 58, 2200);
        ADD_FITNESS('KD Sports', 140, 'Lierseweg', 317, 2200);
        ADD_FITNESS('Basic Fit Eiermarkt', 180, 'Eiermarkt', 21, 2000);
        ADD_FITNESS('Basic Fit Eeklo', 100, 'Stationstraat', 17, 9900);
        ADD_FITNESS('Basic Fit Geel', 240, 'Antwerpseweg', 79, 2440);

        ADD_MEMBERSHIPCARD('01/01/2023', '31/12/2023', 'Basic Fit Eeklo', 'arthur.linsen@gmail.com', 'Basic');
        ADD_MEMBERSHIPCARD('01/01/2023', '31/12/2023', 'Basic Fit Eeklo', 'luna.lybaert@gmail.com', 'Basic');
        ADD_MEMBERSHIPCARD('07/10/2022', '07/09/2023', 'Basic Fit Herentals', 'senne.david@outlook.be',
                           '10 turns-card');
        ADD_MEMBERSHIPCARD('21/03/2022', '20/03/2023', 'Basic Fit Eiermarkt', 'robbe.verslype@yahoo.com',
                           '1-week pas');
        ADD_MEMBERSHIPCARD('01/01/2022', '31/12/2022', 'KD Sports', 'arthur.linsen@gmail.com', 'Basic');
        ADD_MEMBERSHIPCARD('01/01/2022', '31/12/2022', 'KD Sports', 'luna.lybaert@gmail.com', 'Basic');
        ADD_MEMBERSHIPCARD('16/02/2023', '15/02/2024', 'Basic Fit Geel', 'mia.stevens@outlook.be', 'Premium');

        ADD_MACHINE('Bench', 20, 249, 'Rogue', 'Basic Fit Herentals');
        ADD_MACHINE('Squat rack', 100, 2399, 'Hammersmith', 'Basic Fit Herentals');
        ADD_MACHINE('Deadlift platform', 20, 399, 'Rogue', 'KD Sports');
        ADD_MACHINE('Pull up station', 50, 249, 'Echelon', 'Basic Fit Eiermarkt');
        ADD_MACHINE('Dips station', 50, 149, 'Titan', 'Basic Fit Eeklo');
        ADD_MACHINE('Smith machine', 160, 3299, 'Titan', 'KD Sports');

        ADD_EXERCISE('BB bench', 1000, 'Lorem ipsum dolor sit amet', 'Bench', 'Easy', 'Chest');
        ADD_EXERCISE('DB bench', 120, 'Lorem ipsum dolor sit amet', 'Bench', 'Intermediate', 'Chest');
        ADD_EXERCISE('Squat', 1000, 'Lorem ipsum dolor sit amet', 'Squat rack', 'Hard', 'Legs');
        ADD_EXERCISE('BB rows', 1000, 'Lorem ipsum dolor sit amet', 'Squat rack', 'Hard', 'Back');
        ADD_EXERCISE('Overheid press', 1000, 'Lorem ipsum dolor sit amet', 'Squat rack', 'Easy', 'Schoulders');
        ADD_EXERCISE('Deadlift', 1000, 'Lorem ipsum dolor sit amet', 'Deadlift platform', 'Hard', 'Back');
        ADD_EXERCISE('Pull ups', 100, 'Lorem ipsum dolor sit amet', 'Pull up station', 'Intermediate', 'Back');
        ADD_EXERCISE('Chin ups', 100, 'Lorem ipsum dolor sit amet', 'Pull up station', 'Easy', 'Biceps');
        ADD_EXERCISE('Dips', 100, 'Lorem ipsum dolor sit amet', 'Dips station', 'Easy', 'Triceps');
        ADD_EXERCISE('SM Bench', 300, 'Lorem ipsum dolor sit amet', 'Smith machine', 'Easy', 'Chest');
        ADD_EXERCISE('SM overheid press', 300, 'Lorem ipsum dolor sit amet', 'Smith machine', 'Easy', 'Schoulders');
        ADD_EXERCISE('Incline DB bench', 120, 'Lorem ipsum dolor sit amet', 'Bench', 'Intermediate', 'Chest');
        ADD_EXERCISE('Lunges', 1000, 'Lorem ipsum dolor sit amet', 'Squat rack', 'Hard', 'Legs');
        ADD_EXERCISE('Incline bicep curls', 120, 'Lorem ipsum dolor sit amet', 'Bench', 'Easy', 'Biceps');

        ADD_TIMEOFPRACTICE('01/03/2023', 12, 3, 60, 'arthur.linsen@gmail.com', 'BB bench');
        ADD_TIMEOFPRACTICE('01/03/2023', 14, 3, 56, 'arthur.linsen@gmail.com', 'DB bench');
        ADD_TIMEOFPRACTICE('01/03/2023', 6, 5, 40, 'luna.lybaert@gmail.com', 'Squat');
        ADD_TIMEOFPRACTICE('01/03/2023', 16, 2, 60, 'luna.lybaert@gmail.com', 'BB rows');
        ADD_TIMEOFPRACTICE('06/03/2023', 4, 6, 0, 'luna.lybaert@gmail.com', 'Chin ups');
        ADD_TIMEOFPRACTICE('06/03/2023', 10, 4, 50, 'senne.david@outlook.be', 'Incline DB bench');
        ADD_TIMEOFPRACTICE('07/03/2023', 12, 5, 32, 'senne.david@outlook.be', 'Incline bicep curls');
        ADD_TIMEOFPRACTICE('09/03/2023', 10, 3, 50, 'senne.david@outlook.be', 'SM overheid press');
        ADD_TIMEOFPRACTICE('10/03/2023', 12, 4, 0, 'senne.david@outlook.be', 'Dips');
        ADD_TIMEOFPRACTICE('10/03/2023', 12, 5, 0, 'robbe.verslype@yahoo.com', 'Pull ups');
        ADD_TIMEOFPRACTICE('11/03/2023', 16, 3, 0, 'robbe.verslype@yahoo.com', 'Dips');
        ADD_TIMEOFPRACTICE('11/03/2023', 8, 6, 40, 'robbe.verslype@yahoo.com', 'BB bench');
        ADD_TIMEOFPRACTICE('12/03/2023', 8, 4, 40, 'robbe.verslype@yahoo.com', 'SM overheid press');
        ADD_TIMEOFPRACTICE('12/03/2023', 8, 3, 30, 'mia.stevens@outlook.be', 'DB bench');
        ADD_TIMEOFPRACTICE('12/03/2023', 12, 3, 20, 'mia.stevens@outlook.be', 'Lunges');
        ADD_TIMEOFPRACTICE('12/03/2023', 10, 3, 0, 'mia.stevens@outlook.be', 'Chin ups');
        ADD_TIMEOFPRACTICE('13/03/2023', 6, 4, 10, 'mia.stevens@outlook.be', 'Overheid press');
        ADD_TIMEOFPRACTICE('14/03/2023', 6, 5, 0, 'arthur.linsen@gmail.com', 'Pull ups');
        ADD_TIMEOFPRACTICE('14/03/2023', 12, 3, 80, 'arthur.linsen@gmail.com', 'Squat');
        ADD_TIMEOFPRACTICE('14/03/2023', 16, 3, 60, 'luna.lybaert@gmail.com', 'Squat');
    END fill_tables;

    PROCEDURE
        bewijs_milestone_5
        IS
        start_time
                 timestamp;
        end_time timestamp;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('1 - random nummer teruggeven binnen een bereik');
        DBMS_OUTPUT.PUT_LINE('give_random_number (2, 22) --> ' || give_random_number(2, 22));
        DBMS_OUTPUT.PUT_LINE('2 - random datum teruggeven ...');
        DBMS_OUTPUT.PUT_LINE('give_random_date(to_date(''01012022'', ''DDMMYYYY''), sysdate) --> ' ||
                             give_random_date(to_date('01012022', 'DDMMYYYY'), sysdate));
        DBMS_OUTPUT.PUT_LINE('3 - random tekst string uit een lijst');
        DBMS_OUTPUT.PUT_LINE('give_random_brand --> ' || give_random_brand);
        generate_necessary_data();
        start_time := systimestamp;
        DBMS_OUTPUT.PUT_LINE('4 - Starting Many-to-many generation: generate_many_to_many(20,20,50)');
        DBMS_OUTPUT.PUT_LINE('4.1 - generate_random_fitness(20)');
        generate_random_fitness(20);
        DBMS_OUTPUT.PUT_LINE('4.2 - generate_random_member(20)');
        generate_random_member(20);
        DBMS_OUTPUT.PUT_LINE('4.3 - generate_random_membershipcard(50)');
        generate_random_membershipcard(50);
        end_time := systimestamp;
        DBMS_OUTPUT.PUT_LINE('The duration of generate_many_to_many was: ' ||
                             extract(second from end_time - start_time) ||
                             ' ms');
        start_time := systimestamp;
        DBMS_OUTPUT.PUT_LINE('generate_2_levels(p_machines => 40, p_exercises => 50)');
        generate_2_levels(20, 40, 50);
        DBMS_OUTPUT.PUT_LINE('We already have 20 finesses in our database --> skip fitness');
        DBMS_OUTPUT.PUT_LINE('generate_random_machine(40) generated ' || lookup_total_machine() || ' rows');
        DBMS_OUTPUT.PUT_LINE('generate_random_exercise(50) generated ' || lookup_total_exercise() || ' rows');
        end_time := systimestamp;
        DBMS_OUTPUT.PUT_LINE('The duration of generate_2_levels was: ' ||
                             extract(second from end_time - start_time) ||
                             ' ms');
    END bewijs_milestone_5;

    PROCEDURE
        printreport_2_levels(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC
    )
        IS
        e_neg_value EXCEPTION;

        CURSOR
            cur_fitness IS
            SELECT f.FITNESSID, f.NAME, AVG(e.MAXWEIGHT) AS "Average Maxweight"
            FROM FITNESS f
                     JOIN MACHINES m on m.FITNESS_FITNESSID = f.FITNESSID
                     JOIN EXERCISES e on e.MACHINE_MACHINEID = m.MACHINEID
            GROUP BY f.FITNESSID, f.NAME;
        CURSOR
            cur_machines(p_fitnessid FITNESS.FITNESSID%TYPE) IS
            SELECT m.MACHINEID, m.NAME, AVG(e.MAXWEIGHT) AS "Average Maxweight"
            FROM MACHINES m
                     JOIN EXERCISES e on m.MACHINEID = e.MACHINE_MACHINEID
            WHERE m.FITNESS_FITNESSID = p_fitnessid
            GROUP BY m.MACHINEID, m.NAME;
        CURSOR
            cur_exercises(p_machinesid MACHINES.MACHINEID%TYPE) IS
            SELECT e.EXERCISEID, e.NAME, e.MAXWEIGHT
            FROM EXERCISES e
            WHERE e.MACHINE_MACHINEID = p_machinesid;
    BEGIN
        IF v_amount_f < 0 OR v_amount_m < 0 OR v_amount_e < 0
        THEN
            RAISE e_neg_value;
        END IF;

        FOR fitness IN cur_fitness
            LOOP
                DBMS_OUTPUT.PUT_LINE('fitness_id    | fitness_name      | Average maxweight');
                DBMS_OUTPUT.PUT_LINE('========================================================');
                DBMS_OUTPUT.PUT_LINE(RPAD(fitness.FITNESSID, 13) || ' | ' || RPAD(fitness.NAME, 17) || ' | ' ||
                                     RPAD(fitness."Average Maxweight", 15));
                FOR machine IN cur_machines(fitness.FITNESSID)
                    LOOP
                        DBMS_OUTPUT.PUT_LINE('   machine_id  | machine_name  | Average maxweight');
                        DBMS_OUTPUT.PUT_LINE('   -----------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(machine.MACHINEID, 11) || ' | ' ||
                                             RPAD(machine.NAME, 13) ||
                                             ' | ' || RPAD(machine."Average Maxweight", 5));
                        DBMS_OUTPUT.PUT_LINE('    exercise_id | exercise_name | maxweight');
                        FOR exercise IN cur_exercises(machine.MACHINEID)
                            LOOP
                                DBMS_OUTPUT.PUT_LINE('    ' || RPAD(exercise.EXERCISEID, 11) || ' | ' ||
                                                     RPAD(exercise.NAME, 13) || ' | ' ||
                                                     RPAD(exercise.MAXWEIGHT, 5));
                                EXIT WHEN cur_exercises%ROWCOUNT >= v_amount_e;
                            END LOOP;
                        EXIT WHEN cur_machines%ROWCOUNT >= v_amount_m;
                        DBMS_OUTPUT.PUT_LINE(' ');
                    END LOOP;
                DBMS_OUTPUT.PUT_LINE(' ');
                EXIT WHEN cur_fitness%ROWCOUNT >= v_amount_f;
            END LOOP;
    EXCEPTION
        WHEN e_neg_value
            THEN
                DBMS_OUTPUT.PUT_LINE('Every parameter must be greater than 0, no negatieve number of rows can be printed');
    END printreport_2_levels;

    PROCEDURE
        Comparison_single_bulk_m7(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC,
        v_bulk BOOLEAN
    )
        IS
        start_time
                 timestamp;
        end_time timestamp;
    BEGIN
        IF v_bulk = true
        THEN
            empty_tables();
            generate_necessary_data();

            start_time := systimestamp;
            generate_2_levels_bulk(v_amount_f, v_amount_m, v_amount_e);
            end_time := systimestamp;
            DBMS_OUTPUT.PUT_LINE('generate_2_levels_bulk(' || v_amount_f || ', ' || v_amount_m || ', ' || v_amount_e ||
                                 ')');
            DBMS_OUTPUT.PUT_LINE('generate_random_machine(' || v_amount_m || ') generated ' || lookup_total_machine() ||
                                 ' rows');
            DBMS_OUTPUT.PUT_LINE('generate_random_exercise(' || v_amount_e || ') generated ' ||
                                 lookup_total_exercise() || ' rows');
            DBMS_OUTPUT.PUT_LINE('The duration of generate_2_levels_bulk was: ' ||
                                 timestamp_diff(end_time, start_time) ||
                                 ' ms');
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE(' ');
        ELSE
            empty_tables();
            generate_necessary_data();

            start_time := systimestamp;
            generate_2_levels(v_amount_f, v_amount_m, v_amount_e);
            end_time := systimestamp;
            DBMS_OUTPUT.PUT_LINE('COMPARISON SINGLE BULK Comparison_single_bulk_m7(' || v_amount_f || ', ' ||
                                 v_amount_m ||
                                 ', ' || v_amount_e || ')');
            DBMS_OUTPUT.PUT_LINE('generate_2_levels(' || v_amount_f || ', ' || v_amount_m || ', ' || v_amount_e || ')');
            DBMS_OUTPUT.PUT_LINE('generate_random_machine(' || v_amount_m || ') generated ' || lookup_total_machine() ||
                                 ' rows');
            DBMS_OUTPUT.PUT_LINE('generate_random_exercise( ' || v_amount_e || ') generated ' ||
                                 lookup_total_exercise() || ' rows');
            DBMS_OUTPUT.PUT_LINE('The duration of generate_2_levels was: ' || timestamp_diff(end_time, start_time) ||
                                 ' ms');
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END;
    -----------------------
END PKG_fitness;