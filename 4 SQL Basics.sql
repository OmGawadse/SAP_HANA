SELECT DISTINCT MRP, AUTHOR
FROM "T4H"."Books"
ORDER BY MRP, AUTHOR;   ---------------------------- Prioritize which is written first

 --************************************************* OPERATORS ----> = >, <, >=, <=, =, !=, BETWEEN, IS NULL............
SELECT 'Everything ', * FROM "T4H"."Books"
WHERE CATEGORY = 'pdf';  --------------------------- Filter Statement --> single quote is used to finding string for numbers we can directly write it

SELECT * FROM "T4H"."Books"
WHERE MRP BETWEEN 50 AND 200;

SELECT * FROM "T4H"."Books"
WHERE AUTHOR IS NULL; ------------------------------ IS NOT NULL

SELECT * FROM "T4H"."Books"
WHERE NOT AUTHOR = 'A01';  ------------------------- SKIPS the A01 Value    -- WE can also use NOT EQUAL TO like WHERE AUTHOR <> 'A01';

-- list of pdf Books under 100
SELECT * FROM "T4H"."Books"
WHERE CATEGORY = 'pdf' AND MRP < 100;    

-- list of pdf Books & e-books
SELECT * FROM "T4H"."Books"
WHERE CATEGORY = 'pdf' OR CATEGORY = 'e-book';

-- list of pdf Books & e-books which are above 100
SELECT * FROM "T4H"."Books"
WHERE CATEGORY = 'pdf' OR CATEGORY = 'e-book' AND MRP > 100;  -- but here AND is executing 1st here & then OR. bcoz of priority. 
                                                               -- so OR after AND for CATEGORY = 'pdf' wiLL print all pdf not even caring about price.

SELECT * FROM "T4H"."Books"
WHERE (CATEGORY = 'pdf' OR CATEGORY = 'e-book') AND MRP > 100;

-- IN Operator: Allows you to specify multiple values in a WHERE clause, It acts like a shorthand for writing multiple OR conditions.
SELECT * FROM "T4H"."Books"
WHERE Book_id IN ('B02', 'B04', 'B07'); ------------------------ For Skipping values ---------> WHERE Book_id NOT IN ('B02', 'B04', 'B07');

-- LIKE operator = search for a specified pattern. Something starting from letter C
SELECT * FROM "T4H"."Location"
WHERE CITY LIKE 'N%';  ----------------------------------------- Case Sensitive .
-- for more wording '%R%d%';    means starting from r and contain d anywhere.
-- For ignoring null values simply '%';

SELECT MRP, MRP*0.2 AS ACTUAL_DISCOUNT, MRP*0.8 AS ACTUAL_PRICE_AFTER_DISCOUNT FROM "T4H"."Books"  -- Run & you will Understand

-- Next CASE topic ----> very similar to if else statement. ------------- CASE - WHEN - THEN - ELSE - END
/*
CASE input_expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE else_result
END */

SELECT BOOK_ID, MRP,
CASE 
WHEN MRP < 100 THEN 'LOW'
WHEN MRP > 200 AND MRP < 3000 THEN 'HIGH'
ELSE 'MID'
END  AS GG
FROM "T4H" . "Books";

-- if ISBN is empty or blank then simply show that the book is not present
SELECT BOOK_ID, ISBN,
CASE 
WHEN ISBN IS NOT NULL THEN ISBN
ELSE 'NAAAHHHHHHHHHH BOOK Not present'
END AS NEW_ISBN
FROM "T4H" . "Books";

-- dealing with specific column here Category LIKE TRANSPOSING OF ROWS INTO MULTIPLE COLUMN
SELECT BOOK_ID,
(CASE WHEN CATEGORY = 'pdf' THEN 'X' ELSE '' END) AS "PDF",
(CASE WHEN CATEGORY = 'e-book' THEN 'X' ELSE '' END) AS "E_BOOK",
(CASE WHEN CATEGORY = 'printed' THEN 'X' ELSE '' END) AS "PRINTED"
FROM "T4H" . "Books";
