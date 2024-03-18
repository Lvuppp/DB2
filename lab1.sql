
DECLARE
    v_count NUMBER := 10000;
BEGIN
    FOR i IN 1..v_count LOOP
            INSERT INTO mytable (id, val)
            VALUES (DBMS_RANDOM.VALUE(-1000, 1000), DBMS_RANDOM.VALUE(-1000, 1000));
        END LOOP;
    COMMIT;
END;
/

CREATE OR REPLACE FUNCTION checkEvenOddCount RETURN VARCHAR2 IS
    v_even NUMBER := 0;
    v_odd NUMBER := 0;
BEGIN
    SELECT COUNT(CASE WHEN MOD(val, 2) = 0 THEN 1 END),
           COUNT(CASE WHEN MOD(val, 2) != 0 THEN 1 END)
    INTO v_even, v_odd
    FROM MyTable;

    IF v_even > v_odd THEN
        RETURN 'TRUE';
    ELSIF v_even < v_odd THEN
        RETURN 'FALSE';
    ELSE
        RETURN 'EQUAL';
    END IF;
END checkEvenOddCount;
/

select checkEvenOddCount() from dual;

CREATE OR REPLACE FUNCTION generateInsertStatement(p_id NUMBER) RETURN VARCHAR2 IS
    v_id NUMBER := p_id;
BEGIN
    RETURN 'INSERT INTO MyTable (id, val) VALUES (' || v_id || ', ''' || DBMS_RANDOM.VALUE(-1000,1000) || ''');';
END generateInsertStatement;
/

select generateInsertStatement(12) from dual;

CREATE OR REPLACE PROCEDURE insertRecord(p_id NUMBER, p_val NUMBER) AS
BEGIN
    INSERT INTO MyTable (id, val)
    VALUES (p_id, p_val);
    COMMIT;
END insertRecord;
/

BEGIN
    insertRecord(12234, 3423423);
END;
/

CREATE OR REPLACE PROCEDURE updateRecord(p_id NUMBER, p_val NUMBER) AS
BEGIN
    UPDATE MyTable
    SET id = p_id,
        val = p_val
    WHERE id = p_id;
    COMMIT;
END updateRecord;


-- select insertRecord(12234,2) from dual;

CREATE OR REPLACE PROCEDURE deleteRecord(
    p_id NUMBER
) AS
BEGIN
    DELETE FROM MyTable
    WHERE id = p_id;
    COMMIT;
END deleteRecord;


-- select deleteRecord(12234) from dual;

select calculateTotalSalary(2000, 70) from DUAL;

CREATE OR REPLACE FUNCTION calculateTotalSalary(p_monthly_salary NUMBER, p_annual_bonus_percent NUMBER)
    RETURN NUMBER IS
    v_annual_bonus_factor NUMBER;
BEGIN
    IF p_annual_bonus_percent IS NULL OR p_annual_bonus_percent < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid bonus percent');
    END IF;

    v_annual_bonus_factor := 1 + p_annual_bonus_percent / 100;
    RETURN (v_annual_bonus_factor * 12 * p_monthly_salary);
END calculateTotalSalary;
/
select calculateTotalSalary(2000, 70) from DUAL;


CREATE OR REPLACE FUNCTION func (p_id IN NUMBER, p_val IN NUMBER) RETURN VARCHAR2 IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM MYTABLE WHERE id = p_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'exist ');
    END IF;
        RETURN 'INSERT INTO MYTABLE (id, val) VALUES (' || p_id || ',' || p_val ||')';
END func;
/

DECLARE
v_sql_statement VARCHAR2(1000);
BEGIN
    v_sql_statement := func(13495880,1000);
    EXECUTE IMMEDIATE v_sql_statement;
END;
/