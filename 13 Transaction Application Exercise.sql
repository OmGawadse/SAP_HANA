-- Build a reusable SQLScript procedure that manages account transactions, updates transaction records, and calculates the available balance.

CREATE COLUMN TABLE TRANSACTIONS (TRX_ID INT, TRX_DATE TIMESTAMP, ACCOUNT INT, AMOUNT DECIMAL(10,2), ACTION VARCHAR(1));
DROP TABLE TRANSACTIONS

INSERT INTO TRANSACTIONS VALUES (1000, NOW(), 1, 100, 'D');
INSERT INTO TRANSACTIONS VALUES (1001, NOW(), 2, 100, 'D');

CREATE OR REPLACE PROCEDURE TRANSACTIONS_APP (IN ACCOUNT INT, IN AMOUNT DECIMAL(10,2), IN ACTION VARCHAR(1), OUT MSG1 NVARCHAR(100), OUT MSG2 NVARCHAR(100))
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
--READS SQL DATA
AS
BEGIN
DECLARE TRX INT DEFAULT 1;
DECLARE BALANCE DECIMAL(10,2) DEFAULT 1.0;

IF :ACTION = 'D' THEN
SELECT (MAX(TRX_ID)+1) INTO TRX FROM TRANSACTIONS;                              -- Fetches the Highest Trx-id and adds +1 for the one we will be using.
INSERT INTO TRANSACTIONS VALUES (:TRX, NOW(), :ACCOUNT, :AMOUNT, :ACTION);      -- Everytime New Transaction happens, i need to increment my Transaction Number

MSG1 := 'Transaction successful and '|| :AMOUNT || ' is Deposited into your account';

SELECT SUM(AMOUNT) INTO BALANCE FROM TRANSACTIONS WHERE ACCOUNT = :ACCOUNT;

MSG2 := 'Your available balance is: ' || :BALANCE;

ELSEIF :ACTION =  'W' THEN

SELECT SUM(AMOUNT) INTO BALANCE FROM TRANSACTIONS;
    IF :BALANCE >= AMOUNT THEN
    SELECT (MAX(TRX_ID)+1) INTO TRX FROM TRANSACTIONS WHERE ACCOUNT = :ACCOUNT;                              -- Fetches the Highest Trx-id and adds +1 for the one we will be using.
    AMOUNT := :AMOUNT * (-1);------------- or down  -:AMOUNT
    INSERT INTO TRANSACTIONS VALUES (:TRX, NOW(), :ACCOUNT, :AMOUNT, :ACTION);      -- Everytime New Transaction happens, i need to increment my Transaction Number

    MSG1 := 'Transaction successful and '|| :AMOUNT || ' is Deducted from your account';

    SELECT SUM(AMOUNT) INTO BALANCE FROM TRANSACTIONS WHERE ACCOUNT = :ACCOUNT ;
    MSG2 := 'Your available balance is: ' || :BALANCE;

    ELSE
    MSG1 := 'Insufficiant Funds';
    MSG2 := 'Try gain after Some Time';
    END IF;
ELSE
MSG1 := 'Insufficiant Funds';
MSG2 := 'Try gain after Some Time';
END IF;
END;

CALL TRANSACTIONS_APP(1, 300, 'D', ?, ?);
CALL TRANSACTIONS_APP(1, 70, 'W', ?, ?);

SELECT * FROM TRANSACTIONS;
