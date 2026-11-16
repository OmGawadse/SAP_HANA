        -- **************************************************** V I E W ***********************************************************************
-- A View is a virtual table created based on an SQL query. It generally does not store data separately but retrieves data from underlying tables. 
-- Views are used for reusability & simplifying complex queries.
-- A Simple View is created using a single table and usually involves basic operations like SELECT and WHERE.
-- A Complex View is created using more advanced SQL operations, such as JOIN, GROUP BY and aggregate functions.

CREATE SCHEMA VIEW_SCHEMA;
SET SCHEMA VIEW_SCHEMA;

CREATE COLUMN TABLE EMPLOYEE (EMP_ID INT PRIMARY KEY, EMP_NAME VARCHAR(50), DEPT_ID INT, SALARY DECIMAL(10,2) );    -- Employee Table
CREATE COLUMN TABLE DEPARTMENT ( DEPT_ID INT PRIMARY KEY, DEPT_NAME VARCHAR(50) );                                  -- Department Table

INSERT INTO DEPARTMENT VALUES (10, 'IT');
INSERT INTO DEPARTMENT VALUES (20, 'HR');
INSERT INTO DEPARTMENT VALUES (30, 'FINANCE');
INSERT INTO DEPARTMENT VALUES (40, 'SALES');
 
INSERT INTO EMPLOYEE VALUES (101, 'Om', 10, 35000);
INSERT INTO EMPLOYEE VALUES (102, 'Rahul', 20, 28000);
INSERT INTO EMPLOYEE VALUES (103, 'Amit', 10, 45000);
INSERT INTO EMPLOYEE VALUES (104, 'Priya', 30, 50000);
INSERT INTO EMPLOYEE VALUES (105, 'Sneha', 40, 32000);
INSERT INTO EMPLOYEE VALUES (106, 'Karan', 10, 55000);

SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;

-- -- -- -- -- -- -- -- -- -- - - -- - - -- -  - -- - -- - -- - - - -- - - - --- -- -- --- -- - -- - --- -- --- -- -- - -- - - ---- -- - - 
SET SCHEMA VIEW_SCHEMA

CREATE VIEW EMPLOYEE_SIMPLE_VIEW AS         -- SIMPLE VIEW
SELECT EMP_NAME, SALARY FROM EMPLOYEE;
SELECT * FROM EMPLOYEE_SIMPLE_VIEW

CREATE VIEW EMPLOYEE_COMPLEX_VIEW AS        -- COMPLEX VIEW
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_NAME, E.SALARY
FROM EMPLOYEE E INNER JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID
WHERE D.DEPT_NAME = 'IT';
SELECT * FROM EMPLOYEE_COMPLEX_VIEW;

DROP VIEW "EMPLOYEE_COMPLEX_VIEW"

-- Management wants to know the total salary expenditure of each department.

CREATE VIEW DEPARTMENT_SALARY_VIEW AS
SELECT D.DEPT_NAME, COUNT(E.EMP_ID) AS TOTAL_EMPLOYEES, SUM(E.SALARY) AS TOTAL_SALARY, AVG(E.SALARY) AS AVG_SALARY
FROM DEPARTMENT D
INNER JOIN EMPLOYEE E 
ON D.DEPT_ID = E.DEPT_ID
GROUP BY D.DEPT_NAME;

SELECT * FROM DEPARTMENT_SALARY_VIEW;

-- Suppose Om gets a salary increment from ₹35,000 to ₹40,000.

UPDATE EMPLOYEE
SET SALARY = 40000
WHERE EMP_NAME = 'Om';      -- CHANGE IN THE ACTUAL/ORIGINAL DATA TABLE WILL AFFECT THE VIEW.

SELECT * FROM EMPLOYEE_SIMPLE_VIEW;
SELECT * FROM EMPLOYEE_COMPLEX_VIEW;
SELECT * FROM DEPARTMENT_SALARY_VIEW;
        
