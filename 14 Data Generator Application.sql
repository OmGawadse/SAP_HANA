-- RAND() is a SQL function that generates a random decimal number between 0 and 1.
SET SCHEMA T4H;
select * from tables where SCHEMA_NAME = 'T4H'

DROP TABLE PRODUCT;
DROP TABLE REGION;
DROP TABLE SALES;

CREATE COLUMN TABLE PRODUCT (PRODUCT_ID INTEGER, PRODUCT_NAME VARCHAR(100), PRIMARY KEY (PRODUCT_ID) );

INSERT INTO PRODUCT VALUES (1, 'MicroSD card');
INSERT INTO PRODUCT VALUES (2, 'Bluetooth speaker');
INSERT INTO PRODUCT VALUES (3, 'Smart TV');
INSERT INTO PRODUCT VALUES (4, 'Laptop');
INSERT INTO PRODUCT VALUES (5, 'Mobile');
INSERT INTO PRODUCT VALUES (6, 'Projector');
INSERT INTO PRODUCT VALUES (7, 'Mini PC');
INSERT INTO PRODUCT VALUES (8, 'Fitness tracker');
INSERT INTO PRODUCT VALUES (9, 'Camera');

CREATE COLUMN TABLE REGION( REGION_ID INTEGER, REGION_NAME VARCHAR(20), DIVISION VARCHAR(30), PRIMARY KEY (REGION_ID));

INSERT INTO REGION VALUES (1, 'Americas', 'North-America');
INSERT INTO REGION VALUES (2, 'Americas', 'South-America');
INSERT INTO REGION VALUES (3, 'Asia', 'India');
INSERT INTO REGION VALUES (4, 'Asia', 'Japan');
INSERT INTO REGION VALUES (5, 'Asia', 'China');
INSERT INTO REGION VALUES (6, 'Europe', 'Germany');
INSERT INTO REGION VALUES (7, 'Europe', 'UK');
INSERT INTO REGION VALUES (8, 'Africa', 'Egypt');
INSERT INTO REGION VALUES (9, 'Australia', 'Sidney');

CREATE COLUMN TABLE SALES ( SO_ID INT, TRX_DATE DATE, REGION_ID INTEGER, PRODUCT_ID INTEGER, SALES_AMOUNT DOUBLE, PRIMARY KEY (SO_ID) );        -- Sales Order ID

-- Requirement of procedure
-- Insert records into sales table based on value of input parameter
-- Hint: use RAND() function
-- SO_ID: is an incremental value
-- TRX_DATE: use DATE functions and RAND() function.
-- Rest of the fields, you can use RAND() function.

CREATE PROCEDURE DATA_G_APP (IN REC INT)
LANGUAGE SQLSCRIPT 
SQL SECURITY INVOKER As

BEGIN

DECLARE CNT INT := 0; -- Counter helps in Incrementing the Values.
-- -- Check whether SALES table contains records. If records exist, delete them before generating new records
IF NOT IS_EMPTY(SALES) THEN
DELETE FROM SALES;
END IF;

WHILE CNT < :REC DO 
    INSERT INTO SALES       --  Insert randomly generated sales data into SALES table
    SELECT :CNT+1000,
    ADD_DAYS(TO_DATE('2025-07-01', 'YYYY-MM-DD'), RAND() * 730),                   -- TRX_DATE: Generate a random date within 730 days from 01-07-2025
    FLOOR(RAND() * 9) + 1,      -------------------------------------------------- -- REGION_ID: Generate a random integer between 1 and 9
    FLOOR(RAND() * 9) + 1,      -------------------------------------------------- -- PRODUCT_ID: Generate a random integer between 1 and 9
    ROUND(RAND() * 1000, 0)     -------------------------------------------------- -- SALES_AMOUNT: Generate a random sales amount between 0 and 1000

    FROM DUMMY;
    CNT := CNT +1;
END WHILE;
END;

CALL DATA_G_APP(10);

SELECT * FROM SALES;









