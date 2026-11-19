
        -- **************************************************** C A L C U L A T I O N  _  V I E W ****************************************************************
-- A Calculation View is a Resuable virtual data model in SAP HANA that COMBINES data from multiple tables, performs TRANSFORMATION and provides meaningful RESULTS..

SET SCHEMA VIEW_SCHEMA;
DROP TABLE SALES
CREATE COLUMN TABLE CUSTOMER ( CUSTOMER_ID INT PRIMARY KEY, CUSTOMER_NAME VARCHAR(50), CITY VARCHAR(50) );
INSERT INTO CUSTOMER VALUES (101, 'Om', 'Pune');
INSERT INTO CUSTOMER VALUES (102, 'Rahul', 'Mumbai');
INSERT INTO CUSTOMER VALUES (103, 'Priya', 'Lonavala');

CREATE COLUMN TABLE SALES ( SALE_ID INT PRIMARY KEY, CUSTOMER_ID INT, SALES_AMOUNT DECIMAL(10,2), SALE_DATE DATE );
INSERT INTO SALES VALUES (1, 101, 5000, '2025-01-10');
INSERT INTO SALES VALUES (2, 102, 3000, '2025-01-11');
INSERT INTO SALES VALUES (3, 101, 2000, '2025-01-12');
INSERT INTO SALES VALUES (4, 103, 4000, '2025-01-13');
INSERT INTO SALES VALUES (5, 102, 1000, '2025-01-14');

SELECT * FROM SALES
SELECT * FROM CUSTOMER

-- A company wants to analyse how much revenue each customer has generated. It stores customer details in one table and sales transactions in another.
SELECT C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY, SUM(S.SALES_AMOUNT) AS TOTAL_SALES
FROM CUSTOMER C INNER JOIN SALES S
    ON C.CUSTOMER_ID = S.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY;

-- The company wants to display only eemployes whose total salary exceeds ₹5,000.
CREATE VIEW HIGH_VALUE_CUSTOMERS AS
SELECT C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY, SUM(S.SALES_AMOUNT) AS TOTAL_SALES
FROM CUSTOMER C
INNER JOIN SALES S
    ON C.CUSTOMER_ID = S.CUSTOMER_ID
GROUP BY
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.CITY
HAVING SUM(S.SALES_AMOUNT) > 5000;

SELECT * FROM HIGH_VALUE_CUSTOMERS;








/*
Nodes are individual components in a Graphical Calculation View that perform specific operations on data.
The important nodes aare mentioned below:

A Projection Node is used in a Graphical Calculation View to select required columns from a table, apply filters, and perform certain calculations.
A Join Node is used to combine data from multiple sources based on a common column. It supports different join types such as Inner, Left Outer, Right Outer and Full Outer Join.
An Aggregation Node is used to group data and perform aggregate calculations such as SUM, COUNT, AVG, MIN and MAX.
A Union Node combines records from multiple data sources into one result set. (Stacks records from different datasets) JOIN combines columns horizontally, UNION combines rows vertically.
A Rank Node is used to rank records based on selected measures or attributes. RANK FUNCTIONS ------> ROW_NUMBER(), RANK(), DENSE_RANK()
The Semantics Node defines how the output of a Calculation View is presented. In simple words, it defines the meaning and structure of the final output.
Measures are numerical values used for calculations and analytical operations. SALES_AMOUNT is a measure because it represents a numerical business value that can be aggregated.
Attributes are descriptive fields used to categorize, filter, or analyze measures. We can use CITY as an attribute to analyze sales by location.

A Restricted Measure is a measure calculated under a specific filter condition. It allows us to analyze selected portions of data without changing the underlying dataset.


*/