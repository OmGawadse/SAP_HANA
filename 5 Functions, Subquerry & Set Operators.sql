--******************************************** F U N C T I O N S *************************************
-- LTRIM or RTRIM -----> remove Spaces Before & After words. TRIM ------> Does Both
-- LOWER & UPPER --------> Convert text from upper to lower or Vice Versa.
-- LEFT OR RIGHT --------> Shows Specific values from either left or right side.
-- Substring ---------> Can you skip value between specific range. mostly used in getting middle part. very similar to LEFT OR RIGHT

SELECT "e-Mail", LTRIM("e-Mail"), UPPER("COUNTRY")
FROM "T4H" . "Location";

SELECT Street, RIGHT(street, 2)
FROM "T4H" . "Location";

SELECT Street, SUBSTR(Street, 2, 5)
FROM "T4H" . "Location";

-- Function used here is :- year, month, Current_date, years_between, DAYS_BETWEEN & next_day. 
-- Calculate the age of the author: function used is years_between
-- SO if i want to know what is the year at 18th birthday wwe use --->  add_years(BIRTHDAY, 18)

SELECT BIRTHDAY, year(birthday) AS Year_Of_Birthday, Current_date,
month(birthday),
years_between (BIRTHDAY, Current_date) AS AGE,
next_day(Current_date) AS NEXT_DATE, add_years(BIRTHDAY, 18) AS sPECIFIC_yEAR
FROM "T4H" . "Author";

--************************************* AGGREGATE FUNCTIONS *****************************************

SELECT * FROM "T4H"."Books";
SELECT SUM(MRP), MIN(MRP), MAX(MRP), AVG(MRP) FROM "T4H"."Books";
SELECT COUNT(CATEGORY) FROM "T4H"."Books";      -- COUNT = Ignores NULL Values & Simply Counts.
SELECT COUNT(*) FROM "T4H"."Books" WHERE CATEGORY = 'pdf';

-- IMPORTANT :- When we are using aggregate functions together with a normal column, The normal column must be included in GROUP BY.'
-- WHERE is executed BEFORE data is Grouped & Having Clause is executed AFTER data is Grouped. 
-- Also we cannot use Aggrate Function with 'Where' Clause like ----> WHERE COUNT(*) > 1 instead we use -----> HAVING clause .
-- we can use Where Clause for unGrouped Data.
SELECT CATEGORY AS cATeGoRy_, COUNT(*)      -- Use Allias Once not needed in Group BY
FROM "T4H"."Books"
GROUP BY CATEGORY
HAVING COUNT(*) > 1;


-- **************************************** SUBQUERY **************************************************

-- Author Name where Category = pdf
SELECT * FROM "T4H"."Books";
SELECT * FROM "T4H"."Author";

SELECT NAME FROM "T4H"."Author" WHERE AUTHOR_ID in ('A03', 'A05', 'A06', 'A02', 'A08');
-- The Above Query becomes Quiet BIGGGGGGGGGGG........ so we can use SubQuery.
-- ****************************************** SUBQUERY → useful when you need a query inside another query.**********************************
SELECT NAME FROM "T4H"."Author" WHERE AUTHOR_ID in (SELECT AUTHOR FROM "T4H"."Books" WHERE CATEGORY = 'pdf');

-- How many category values are there.
SELECT CATEGORY, COUNT(*) FROM "T4H"."Books" 
GROUP BY CATEGORY
HAVING COUNT(*) > 1;

-- I would like to know author name and their books count or how many categories of books does each author have?
SELECT NAME, (SELECT COUNT(*) FROM "T4H"."Books" 
WHERE "T4H"."Books".AUTHOR = "T4H"."Author".AUTHOR_ID) AS COUNT_OF_CATEGORY
FROM "T4H"."Author";
-- Here the outer query simply returns the name from author table. An inner query fetches the count & maps to author from the author table
-- Subqueries are not useful when we are dealing with large amount of data because the inner query will run for N times & And so will the outer query.



-- *********************************************************** UNION, INTERSECT & EXCEPT **********************************************************
/* UNION → Everything, duplicates removed
- UNION ALL → Everything, duplicates included
- INTERSECT → Common between both
- EXCEPT → Give me what is in A, but not in B. */


SELECT * FROM STUDENT
SELECT * FROM COURSE
SELECT * FROM INSTRUCTOR

SELECT NAME, ID FROM STUDENT --WHERE COURSE IS NOT NULL
UNION 
SELECT NAME, ID FROM INSTRUCTOR -- THE UNION WILL WORK FOR SAME DATA TYPE
ORDER BY DESC
UNION
SELECT NAME, ID FROM COURSE -- FOR ID data type if different so it will throw error

SELECT NAME, ID FROM STUDENT
INTERSECT
SELECT NAME, ID FROM INSTRUCTOR

SELECT NAME, ID FROM STUDENT
EXCEPT
SELECT NAME, ID FROM INSTRUCTOR


