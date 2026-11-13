SELECT * FROM TABLES WHERE SCHEMA_NAME = 'PRACTICE_33';
SELECT * FROM "PRACTICE_33". "RegionData";
-- SELECT * FROM RegionData;-----------------  Shows Error cause we cannot Directly Select which is not present in schema

-- Make sure the Schema Selected is Practice_33.
SELECT Region_id FROM "RegionData";

INSERT INTO "RegionData" VALUES (10, 'ASIA','CHINA');

-- ALTER: DDL (Data Definition Language) command used to modify the structure of an existing database object, such as a table. ADD, DROP, ALTER & Add constraints

SELECT * FROM SampleTable;
ALTER TABLE SampleTable ADD (CITY VARCHAR(15) NOT NULL DEFAULT 'UNKNOWN');          -- You simply Cannot define NOT NULL.
ALTER TABLE SampleTable DROP PRIMARY KEY;                                           -- Drops Primary Key.
ALTER TABLE SampleTable ADD PRIMARY KEY (ID);                                       -- Adds Primary Key
                                                
ALTER TABLE SampleTable ALTER (CITY NVARCHAR(50));                                  -- Change the Datatype of any Column.
ALTER TABLE SampleTable COLUMN                                                      -- Change Column Store T to Row Store Table & Vice Versa.
RENAME COLUMN SAMPLETABLE.CITY TO CITYS                                             -- Rename Column Name. can be done for table name as well.
ALTER TABLE SampleTable DROP (CITY);                                                -- Drops Column from Table

-- VIEW - A view is a virtual database object that presents data from one or more tables.
-- SELECT DBADMIN Schema

SELECT * FROM INSTRUCTOR                -- ID
SELECT * FROM COURSE                    -- INSTRUCTOR
-- Instead of USing JOIN we can use VIEW.

CREATE VIEW PRACTICEview AS             -- i can exclusively give name to table like ALIAS "CREATE VIEW PRACTICEview(IDXYZ, AMOUNT) AS"  
SELECT I.ID, C.PRICE FROM INSTRUCTOR I  -- & offcouse we can give it in sel;ect statement as well using ALIAS
JOIN COURSE C ON I.ID = C.INSTRUCTOR

SELECT * FROM PRACTICEview;
DROP VIEW PRACTICEview;
