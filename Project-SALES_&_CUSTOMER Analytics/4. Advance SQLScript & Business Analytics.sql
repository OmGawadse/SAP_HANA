-- TASK 1: VERIFY DISCOUNT CALCULATION FUNCTION
-- Check whether the function correctly calculates the discounted unit price.

CREATE FUNCTION CALCULATE_NET_PRICE ( IN P_UNIT_PRICE DECIMAL(10,2), IN P_DISCOUNT DECIMAL (5,2) )
RETURNS NET_PRICE DECIMAL(12,2)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS 
BEGIN
    NET_PRICE = ROUND(:P_UNIT_PRICE * (1 - COALESCE(:P_DISCOUNT,0) / 100), 2);
END;

SELECT CALCULATE_NET_PRICE(1000, 15) FROM DUMMY;   -- 850.00
SELECT CALCULATE_NET_PRICE(1000, NULL) FROM DUMMY; -- 1000.00

-- TESTING - Check whether the function matches the expected discounted unit price for every sales item.
SELECT COUNT(*) AS INCORRECT_CALCULATIONS
FROM SALES_ITEMS
WHERE CALCULATE_NET_PRICE(UNIT_PRICE, DISCOUNT_PERCENT) <> ROUND( UNIT_PRICE * (1 - COALESCE(DISCOUNT_PERCENT, 0) / 100), 2); -- !=


-- ********************************************************************************************************************************************
-- TASK 2: CREATE CUSTOMER SALES TABLE FUNCTION ------> Retrieve sales transactions for a specific customer.
-- Retrieve a specific customer's sales transactions and calculate their net revenue.

CREATE FUNCTION GET_CUSTOMER_SALES ( IN P_CUSTOMER_ID INT )
RETURNS TABLE ( SALES_ID INT, PURCHASE_DATE DATE, PRODUCT_ID INT, QUANTITY INT, NET_REVENUE DECIMAL(18,2) )         -- Table Function
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN
    RETURN                  -- RETURN sends the query result back as a table.
        SELECT S.SALES_ID, S.PURCHASE_DATE, SI.PRODUCT_ID, SI.QUANTITY,
        CAST( SI.QUANTITY * CALCULATE_NET_PRICE( SI.UNIT_PRICE, SI.DISCOUNT_PERCENT) AS DECIMAL(18,2) ) AS NET_REVENUE  -- converts a value from one data type to another.

        FROM SALES S INNER JOIN SALES_ITEMS SI ON S.SALES_ID = SI.SALES_ID
        WHERE S.CUSTOMER_ID = :P_CUSTOMER_ID;
END;

-- TESTING:
SELECT * FROM GET_CUSTOMER_SALES(101)
ORDER BY PURCHASE_DATE;

-- TESTING: Check that every sale returned by the table function belongs to customer 101.
SELECT COUNT(*) AS INCORRECT_CUSTOMER_RECORDS
FROM GET_CUSTOMER_SALES(101) T INNER JOIN SALES S
    ON T.SALES_ID = S.SALES_ID
WHERE S.CUSTOMER_ID <> 101;     -- !=


-- ********************************************************************************************************************************************
-- TASK 3: CUSTOMER PURCHASE HISTORY PROCEDURE ---- > Summarize a customer's purchase activity using our existing sales table function.
     
CREATE PROCEDURE GET_CUSTOMER_PURCHASE_HISTORY ( IN P_CUSTOMER_ID INT )
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN
    SELECT :P_CUSTOMER_ID AS CUSTOMER_ID, COUNT(DISTINCT SALES_ID) AS TOTAL_ORDERS,     -- Counts unique orders.
        COALESCE(SUM(QUANTITY), 0) AS TOTAL_UNITS_PURCHASED,
        COALESCE(SUM(NET_REVENUE), 0) AS TOTAL_SPENT
    FROM GET_CUSTOMER_SALES(:P_CUSTOMER_ID);
END;

CALL GET_CUSTOMER_PURCHASE_HISTORY(101);


-- ********************************************************************************************************************************************
-- TASK 4: PRODUCT PERFORMANCE BY CATEGORY
-- Analyze product sales and discounted revenue for a selected category.

CREATE PROCEDURE GET_PRODUCT_PERFORMANCE_BY_CATEGORY ( IN P_CATEGORY_ID INT )
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN

    SELECT P.PRODUCT_ID, P.PRODUCT_NAME,
        COALESCE(SUM(SI.QUANTITY), 0) AS TOTAL_UNITS_SOLD,      -- calculates units sold.
        COALESCE( SUM( SI.QUANTITY * CALCULATE_NET_PRICE( SI.UNIT_PRICE, SI.DISCOUNT_PERCENT )), 0) AS TOTAL_REVENUE

    FROM PRODUCT P LEFT JOIN SALES_ITEMS SI     -- includes products even if they haven't been sold.(LEFT JOIN ka yahi kam hota haiii)
        ON P.PRODUCT_ID = SI.PRODUCT_ID
    WHERE P.CATEGORY_ID = :P_CATEGORY_ID

    GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
    ORDER BY TOTAL_REVENUE DESC;
    -- ORDER BY PRODUCT_ID;
END;

CALL GET_PRODUCT_PERFORMANCE_BY_CATEGORY(1);

-- TEST 2: VERIFY ELECTRONICS SALES QUANTITY
-- Check the total quantity sold for Electronics products directly against the source tables.

SELECT SUM(SI.QUANTITY) AS VERIFIED_UNITS_SOLD
FROM SALES_ITEMS SI INNER JOIN  PRODUCT P
    ON P.PRODUCT_ID = SI.PRODUCT_ID
WHERE P.CATEGORY_ID = 1;


-- DAY 4 - TASK 5: CUSTOMER SPENDING CLASSIFICATION
-- Classify a customer based on total spending using SQLScript conditional logic.

CREATE PROCEDURE CLASSIFY_CUSTOMER_SPENDING ( IN P_CUSTOMER_ID INT )
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN

    DECLARE V_TOTAL_SPENT DECIMAL(18,2);
    DECLARE V_CUSTOMER_CLASS NVARCHAR(30);

    SELECT COALESCE(SUM(NET_REVENUE), 0)
    INTO V_TOTAL_SPENT              -- stores the calculated revenue in our local variable
    FROM GET_CUSTOMER_SALES(:P_CUSTOMER_ID);

    IF :V_TOTAL_SPENT >= 50000 THEN
        V_CUSTOMER_CLASS = 'HIGH VALUE';

    ELSEIF :V_TOTAL_SPENT >= 20000 THEN
        V_CUSTOMER_CLASS = 'MEDIUM VALUE';

    ELSE
        V_CUSTOMER_CLASS = 'LOW VALUE';
    END IF;

    SELECT
        :P_CUSTOMER_ID AS CUSTOMER_ID,
        :V_TOTAL_SPENT AS TOTAL_SPENT,
        :V_CUSTOMER_CLASS AS CUSTOMER_CLASS
    FROM DUMMY;
END;

CALL CLASSIFY_CUSTOMER_SPENDING(110);

-- TEST: Independently calculate customer spending and verify the classification rules using actual sales data.

WITH CUSTOMER_SPENDING AS (         --- Common Table Expression (CTE) ------> temporary named result that we can use in main SELECT query.
    SELECT S.CUSTOMER_ID, ROUND(SUM( SI.QUANTITY * CALCULATE_NET_PRICE( SI.UNIT_PRICE, SI.DISCOUNT_PERCENT )), 2) AS TOTAL_SPENT
    FROM SALES S INNER JOIN SALES_ITEMS SI
        ON S.SALES_ID = SI.SALES_ID
    GROUP BY S.CUSTOMER_ID
)
SELECT CUSTOMER_ID, TOTAL_SPENT,
    CASE
        WHEN TOTAL_SPENT >= 50000 THEN 'HIGH VALUE'
        WHEN TOTAL_SPENT >= 20000 THEN 'MEDIUM VALUE'
        ELSE 'LOW VALUE'
    END AS CUSTOMER_CLASS
FROM CUSTOMER_SPENDING
WHERE CUSTOMER_ID = 110;







