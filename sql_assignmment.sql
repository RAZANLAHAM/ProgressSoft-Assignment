CREATE TABLE university (
    ID NUMBER,
    Name VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_uni
    PRIMARY KEY (ID)
);

CREATE TABLE MyDepartment (
    Dept_ID NUMBER,
    Name VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_department
    PRIMARY KEY (Dept_ID)
);

CREATE TABLE Gender (
    Gender_ID NUMBER,
    Name VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_gender
    PRIMARY KEY (Gender_ID)
);
CREATE TABLE MyEmployee (
    ID_Number NUMBER,
    LAST_NAME VARCHAR2(20) NOT NULL,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    HIRE_DATE DATE,
    USERID NUMBER,
    SALARY NUMBER,
    DEPT_ID NUMBER,
    Gender_ID NUMBER,
    University_ID NUMBER,
    EMP_IMAGE BLOB,

    CONSTRAINT pk_emp
    PRIMARY KEY (ID_Number),

    CONSTRAINT chk_salary
    CHECK (SALARY >= 0),

    CONSTRAINT fk_emp_dep
    FOREIGN KEY (DEPT_ID)
    REFERENCES MyDepartment (Dept_ID),

    CONSTRAINT fk_emp_gender
    FOREIGN KEY (Gender_ID)
    REFERENCES Gender (Gender_ID),

    CONSTRAINT fk_emp_uni
    FOREIGN KEY (University_ID)
    REFERENCES University (ID)
);
ALTER TABLE MyEmployee
ADD Manager_ID NUMBER;

ALTER TABLE MyEmployee
ADD CONSTRAINT fk_emp_manager
FOREIGN KEY (Manager_ID)
REFERENCES MyEmployee (ID_Number);
SELECT
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    D.NAME AS DEPARTMENT_NAME,
    M.FIRST_NAME AS MANAGER_NAME,
    G.NAME AS GENDER,
    U.NAME AS UNIVERSITY

FROM MyEmployee E, MyDepartment D, Gender G, University U, MyEmployee M

WHERE E.DEPT_ID = D.DEPT_ID
AND E.Gender_ID = G.Gender_ID
AND E.University_ID = U.ID
AND E.Manager_ID = M.ID_Number;
INSERT INTO MyDepartment (Dept_ID, Name)
VALUES (10, 'IT');

INSERT INTO Gender (Gender_ID, Name)
VALUES (1, 'Female');

INSERT INTO University (ID, Name)
VALUES (1, 'Yarmouk');

INSERT INTO MyEmployee
(ID_Number, FIRST_NAME, LAST_NAME, SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES
(1, 'Ahmad', 'Ali', 1000, 10, 1, 1);

INSERT INTO MyEmployee
(ID_Number, FIRST_NAME, LAST_NAME, SALARY, DEPT_ID, Gender_ID, University_ID, Manager_ID)
VALUES
(2, 'Sara', 'Omar', 800, 10, 1, 1, 1);

COMMIT;
ALTER TABLE MyEmployee
ADD JOB_TITLE VARCHAR2(50);
SELECT
    JOB_TITLE,
    SUM(SALARY) AS TOTAL_SALARY

FROM MyEmployee

WHERE JOB_TITLE NOT LIKE 'SALE%'

GROUP BY JOB_TITLE

HAVING SUM(SALARY) > 2500;
--Q4
SELECT empno, ename,
salary * 12 AS "ANNUAL SALARY"
FROM emp;
CREATE OR REPLACE FUNCTION F_HR_QUERY
RETURN SYS_REFCURSOR
IS
    RESULT SYS_REFCURSOR;

BEGIN

    OPEN RESULT FOR
    SELECT FIRST_NAME, HIRE_DATE
    FROM MyEmployee
    WHERE HIRE_DATE > (
        SELECT HIRE_DATE
        FROM MyEmployee
        WHERE FIRST_NAME = 'SCOTT'
    );

    RETURN RESULT;

END;
/
INSERT INTO MyEmployee
(ID_Number, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES
(3, 'SCOTT', 'KING', TO_DATE('09/09/1987','DD/MM/YYYY'));

UPDATE MyEmployee
SET HIRE_DATE = TO_DATE('10/10/1980','DD/MM/YYYY')
WHERE ID_Number = 1;

INSERT INTO MyEmployee
(ID_Number, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES
(4, 'Rami', 'Khaled', TO_DATE('24/05/1986','DD/MM/YYYY'));

COMMIT;
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM MyEmployee;
DECLARE
    RESULT SYS_REFCURSOR;
    F_NAME MyEmployee.FIRST_NAME%TYPE;
    H_DATE MyEmployee.HIRE_DATE%TYPE;

BEGIN

    RESULT := F_HR_QUERY;

    LOOP
        FETCH RESULT INTO F_NAME, H_DATE;

        EXIT WHEN RESULT%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(F_NAME || ' ' || H_DATE);

    END LOOP;

    CLOSE RESULT;

END;
/
CREATE TABLE MyEmployee_update AS
SELECT *
FROM MyEmployee
WHERE 1 = 0;
CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE
IS
BEGIN
    INSERT INTO MyEmployee_update
    SELECT *
    FROM MyEmployee;

    COMMIT;
END;
/
SELECT * FROM MyEmployee_update;
BEGIN
    P_COPY_EMPLOYEE;
END;
/
SELECT COUNT(*) FROM MyEmployee_update;