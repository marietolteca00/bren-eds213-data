

-- Look at rows in both tables A and B
SELECT * FROM A;

SELECT * FROM B;

-- SELF-JOINs
-- Join tables- CARTESIAN PRODUCT
SELECT * FROM A CROSS JOIN B;

-- SELECT always select columns from the ouput compputed after the FROM
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B);

-- Difference between COUNT(*)== number of rows & Count(column) == NON-NULL
-- in that column, or groups
-- I want acol1 and any value in 'acol2' to count each row
SELECT acol1, ANY_VALUE(acol2), COUNT(*)
    -- FROM the cross join
    FROM (SELECT * FROM A CROSS JOIN B)
    -- Group by acol1
    GROUP BY acol1;
-- this will provide counts for each value in col2


-- Another Example
-- Including bcol3, will only count streusel and frosting and Ignore NULL
SELECT acol1, ANY_VALUE(acol2), COUNT(bcol3)
    -- FROM the cross join
    FROM (SELECT * FROM A CROSS JOIN B)
    -- Group by acol1
    GROUP BY acol1;


-- USING a condition

-- Do the join when acol1 is less than bcol1
SELECT * FROM A JOIN B on acol1 < bcol1;

-- INNER OR OUTER JOINS
SELECT * FROM Student;

SELECT * FROM House;

-- INNER Join = DEFAULT
SELECt * FROM Student AS S JOIN House AS H ON S.House_ID = H.House_ID;
-- SAMETHING- More Compact: Requires the same column names!
SELECT * FROM Student JOIN House USING (House_ID);


-- OUTER JOINS
SELECT * FROM Student FULL JOIN House USING (House_ID); -- We have no student with a house

-- LEFT JOIN
SELECT * FROM Student LEFT JOIN House USING (House_ID);

-- RIGHT JOIN
SELECT * FROM Student RIGHT JOIN House USING (House_ID);

-- CROSS JOIN - 7 columns AND 12 ROWS
-- Student table = 4 columns and 4 rows
-- House table = 3 columns and 3 rows
SELECT * FROM Student CROSS JOIN House;


-- Add a table into our database
-- Creating Table

CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

-- View table -  SHOCKER NO DATA
SELECT * FROM Snow_cover;

-- ADD DATA
COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");

-- View newly imported data
SELECt * FROM Snow_cover LIMIT 5;

-- CREATE A TEMPORARY TABLE; Could be used to Create a backup table
CREATE TEMP TABLE Camp_assignment_copy AS
   SELECT * FROM Camp_assignment; 

-- View columns
.table

-- View rows from copy table only first 5 rows
SELECT * FROM Camp_assignment_copy LIMIT 5;

-- View rows in personnel limit 5
SELECT * FROM Personnel LIMIT 5;

-- Look at which observer 
SELECT Year, Site, Name
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

-- Format syntax-- I got different tables
SELECT Year, Site, Name
   FROM Camp_assignment_copy AS C JOIN Personnel AS P ON C.Observer = P.Abbreviation;



CREATE VIEW Camp_personnel_v AS
   SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

.table
.schema

-- DANGER ZONE IN NOTES
-- Identify for one site, make sure we can see all bylo sites
SELECT * FROM Camp_assignment_copy WHERE Site == 'bylo';

-- View the rows in temp table
SELECT * FROM Camp_personnel_v LIMIT 10;

-- Delete bylo sites from copy
DELETE FROM Camp_assignment_copy WHERE Site == 'bylo';


.table