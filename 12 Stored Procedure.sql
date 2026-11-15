-----------------------------------------------------=-=-=-=-=-=-=-> S T O R E D _ P R O C E D U R E 
-- In SAP HANA, we can modify an existing stored procedure/Function using CREATE OR REPLACE PROCEDURE instead of dropping and recreating it manually.
SELECT * FROM TABLES WHERE SCHEMA_NAME = 'PRACTICE_33'

CREATE PROCEDURE FIRST_PRO()
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER                            -- A SECURITY MODE that controls whose privileges are used when a procedure or function executes.
-- DEFAULT SCHEMA PRACTICE_33                   -- Every time we dont need to mention the SCHEMA_NAME before declaring table
-- READS SQL DATA                               -- Declares that the procedure only reads data.
AS                                              -- Starts the procedure definition. 
BEGIN
    SELECT * FROM "T4H" . "Books";
END;

DROP PROCEDURE FIRST_PRO

CALL FIRST_PRO()

--------------------------------------------------------------------PARAMETER MODES---------------------------------------------------------------------------
CREATE PROCEDURE FILTER_BOOKS (IN CAT VARCHAR(1), OUT RESULT TABLE (BOOK_ID VARCHAR(4), CATEGORY VARCHAR (15), MRP DECIMAL(10,2)))
    LANGUAGE SQLSCRIPT
    SQL SECURITY INVOKER
    --DEFAULT SCHEMA <default_schema_name> 
    READS SQL DATA AS
BEGIN
    DECLARE X VARCHAR(15);
    IF :CAT = 'p' THEN X := 'pdf';
    ELSEIF :CAT = 'e' THEN X := 'e-book';
    else X := 'Printed';
    END IF;
    
    RESULT = SELECT BOOK_ID, CATEGORY, MRP FROM "T4H" . "Books" WHERE CATEGORY = X;
END;

DROP PROCEDURE FILTER_BOOKS

CALL FILTER_BOOKS ('p', ?)

----------------------------------------TABLE VARIABLE --> It is a temporary table-like structure used in SQLScript to store intermediate query results. It can hold multiple rows and columns.
CREATE PROCEDURE DEMO_TABLE_VAR()
LANGUAGE SQLSCRIPT
AS
BEGIN
    -- Step 1: Create an empty table variable
    DECLARE X TABLE( BOOK_ID VARCHAR(4), CATEGORY VARCHAR(15), MRP DECIMAL(10,2));      -- Creates an empty table variable.

    -- Step 2: Store query result in X
    X = SELECT BOOK_ID, CATEGORY, MRP FROM "T4H"."Books"                                -- Stores query results in X.
        WHERE CATEGORY = 'pdf';

    -- Step 3: Display data from X
    SELECT * FROM :X;
END;

CALL DEMO_TABLE_VAR();

------------------------------------TABLE TYPE - A Table Type is a Blueprint of a table's structure (columns and data types).
-- It is mainly used to avoid repeatedly declaring the same table structure in stored procedures or functions. Create it once and reuse it as an IN or OUT parameter whenever required.
-- For example, suppose I have multiple stored procedures that return book details containing BOOK_ID, CATEGORY and MRP. 
-- Instead of defining these columns repeatedly in every procedure, I can create a Table Type called BOOK_TYPE once and reuse it

CREATE TYPE BOOK_TYPE AS TABLE (BOOK_ID VARCHAR(4), CATEGORY VARCHAR(15), MRP DECIMAL(10,2));
DROP TYPE BOOK_TYPE

CREATE PROCEDURE GET_PDF_BOOKS ( OUT RESULTS BOOK_TYPE)----- See Type is used here.
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
READS SQL DATA
AS
BEGIN
    RESULTS = SELECT BOOK_ID, CATEGORY, MRP FROM "T4H"."Books" WHERE CATEGORY = 'pdf';
END;

CALL GET_PDF_BOOKS(?);
DROP PROCEDURE GET_PDF_BOOKS
--  SAP HANA does not support CALL PROCEDURE WITH OVERVIEW. Ex------> CALL GET_PDF_BOOKS(?) WITH OVERVIEW;
