/*                  E X C E P T I O N _ H A N D L I N G 
Exception handling is a mechanism used to handle errors that occur while executing the code.
SAP HANA SQLScript mainly provides two types of handlers:
1. EXIT HANDLER	Handles the error and exits the current block
When an exception occurs:
1. The handler catches the error.
2. Executes the handler statements.
3. Exits the current BEGIN...END block.

2. CONTINUE HANDLER	Handles the error and continues execution after the statement that caused the error
When an exception occurs:
1. The handler catches the error.
2. Executes the handler statements.
3. Continues execution after the statement that caused the error.
*/
-- colon (:) indicates that we're referencing an input paramete

CREATE FUNCTION XYZ(PRICE DECIMAL(10,2), DISCOUNT DECIMAL(5,2))
RETURNS RESULT DECIMAL(10,5)
LANGUAGE SQLScript
SQL SECURITY INVOKER AS
BEGIN
RESULT := :PRICE - (:PRICE * :DISCOUNT / 100);
END;

DROP FUNCTION XYZ /*CASCADE*/;

SELECT *, XYZ("MRP", -10) AS FINAL_PRICE FROM "PRACTICE_33"."SAMPLETABLE2"              -- if we pass even negative value it gives incorrect Result. Hence we use EH.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION "PRACTICE_33"."XYZ1"(IP1 DECIMAL(10,2), IP2 DECIMAL(5,2))
RETURNS FINAL_AMOUNT DECIMAL(10,2)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN
    DECLARE INVALID_DISCOUNT CONDITION FOR SQL_ERROR_CODE 10001;                    -- Always greater than 10001. bcoz previous are all predefined SQL Exception

    IF :IP2 <= 0 OR :IP2 > 100 THEN
        SIGNAL INVALID_DISCOUNT
        SET MESSAGE_TEXT = 'Discount must be greater than 0 and not exceed 100';
    ELSE
        FINAL_AMOUNT := :IP1 - (:IP1 * (:IP2 / 100));
    END IF;

END;

SELECT *, "PRACTICE_33"."XYZ1"("MRP", -10) AS "FINAL_AMOUNT" FROM "PRACTICE_33"."SAMPLETABLE2";

DROP FUNCTION XYZ1
/*
DECLARE CONDITION statement : Define custom exceptions.
After declaring the condition, we use the SIGNAL statement to raise that exception whenever a particular condition is met. 
We can also use MESSAGE_TEXT to provide a meaningful, custom error message explaining why the exception occurred.

-------------------------------------------------------------------------------------------------------------E X E R C I S E - WHILE LOOP
-- Create a scalar function to generate factorial values
-- Provide One input parameter to choose the factorial value dynamically
-- 5 = 1 * 2 * 3 * 4 * 5
*/
CREATE FUNCTION "PRACTICE_33"."FACTORIAL"(I INT)        -- 4
RETURNS F DOUBLE
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN

    DECLARE X INT := 2;         -- x = 4
    F := 1;

    WHILE :X <= :I DO           -- 2 < 4                            3 < 4                       4 <= 4
        F := :F * :X;           -- 1 * 2 = f = 2                    2 * 3 = f = 6               6 * 4 = f = 24 -----> Final
        X := :X + 1;            -- x = 3                            x = 4                       x = 5 xxxxxxxxxx
    END WHILE;

END;        -- 

SELECT "PRACTICE_33"."FACTORIAL"(5) FROM DUMMY;

