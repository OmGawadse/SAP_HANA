-- Schema is a CONTAINER inside a database that organizes database objects, such as tables, views, and stored procedures.

SELECT * FROM SCHEMAS;

DROP USER New_User;

CREATE USER New_User PASSWORD Ghatakom2003;  -- created a database user. remember we have not created a new Schema

SELECT USER_NAME FROM SYS.USERS
WHERE USER_NAME = 'NEW_USER';

GRANT CREATE SCHEMA TO New_User;      -- For New Users; It Grants privileges to perform database operations.

CREATE SCHEMA Practice_33; -- SCHEMA NAME

CREATE TABLE Practice_33_work(
    CUSTOMER_ID INTEGER PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(100),
    CITY VARCHAR(50)
);

SELECT * FROM Practice_33_work


-- easy Way to Copy data from any Table ----> Like
CREATE TABLE COPY_Instructor LIKE INSTRUCTOR WITH DATA
SELECT * FROM COPY_Instructor
DROP TABLE COPY_Instructor

-- If we want Specific values from the Table:
CREATE TABLE Specific_Values AS (SELECT ID, NAME FROM INSTRUCTOR WHERE ID = '2');
SELECT * FROM Specific_Values


-- ****************************************** Creation of Tables Advance. ******************************


SELECT * FROM TABLES WHERE SCHEMA_NAME = 'T4H'              -- Checks In schema How many Tables 

CREATE COLUMN TABLE PRACTICE_33.Sampletable (
    ID INTEGER,
    NAME VARCHAR(50)
);

SELECT * FROM PRACTICE_33.Sampletable LIMIT 5

INSERT INTO PRACTICE_33.Sampletable VALUES(1, 'A');
INSERT INTO PRACTICE_33.Sampletable VALUES(2, 'B');
INSERT INTO PRACTICE_33.Sampletable VALUES(3, 'C');
INSERT INTO PRACTICE_33.Sampletable VALUES(4, 'D');
INSERT INTO PRACTICE_33.Sampletable VALUES(5, 'E');
INSERT INTO PRACTICE_33.Sampletable VALUES(6, 'F');
INSERT INTO PRACTICE_33.Sampletable VALUES(7, Null); 

ALTER TABLE PRACTICE_33.Sampletable
ADD CONSTRAINT xyz PRIMARY KEY(ID);    ------------------------- No Duplicate/ Null values are allowed.      
SELECT * FROM PRACTICE_33.Sampletable

INSERT INTO PRACTICE_33.Sampletable VALUES(Null, 'om');  ------- Only Unique's Allowed, So shows ERROR

CREATE TABLE SALES(
    Order_no INT,   -------------------------------------------- For Unique --> DUPLICATES are NOT Allowed, But NULL is Allowed.
    Product VARCHAR(50),
    QTY INT NOT NULL DEFAULT 1, -------------------------------- the QTY is Compulsory, & by default it can be set to 1.
    Order_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (Order_no, Product)    ------------------------- Composite Primary Key - When we Buy Multiple Products from same User or order NO. 
);
SELECT * FROM SALES

INSERT INTO SALES (Order_no, Product, QTY) VALUES(1, 'A', 8);
INSERT INTO SALES (Order_no, Product) VALUES(1, 'G');    ------------------------- By Default the QTY will give 1
INSERT INTO SALES (Order_no, Product, QTY) VALUES(1, 'B', 10); ------------------- This will Work cause either of the 2 can be repeated but not Both 

INSERT INTO SALES VALUES(1, 'A', NULL);  ----------------------------------------- This will Show Error... Cause Both entity is repeating & QTY cannot be Null

DROP TABLE SALES

SELECT * FROM TABLES WHERE SCHEMA_NAME = 'PRACTICE_33'
