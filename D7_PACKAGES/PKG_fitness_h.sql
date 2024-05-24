CREATE OR REPLACE PACKAGE PKG_fitness
AS
    PROCEDURE empty_tables;
    PROCEDURE fill_tables;
    PROCEDURE bewijs_milestone_5;
    PROCEDURE printreport_2_levels(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC
    );
    PROCEDURE Comparison_single_bulk_m7(
        v_amount_f NUMERIC,
        v_amount_m NUMERIC,
        v_amount_e NUMERIC,
        v_bulk BOOLEAN
    );
END PKG_fitness;