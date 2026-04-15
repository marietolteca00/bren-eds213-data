.table

# recap from Monday
# keyword are ALL CAPS, we did queries such as
SELECT DISTINCT Location
    FROM Site
    ORDER BY Location
    Limit 3;


-- FILTERING
-- LOOKS JUST LIKE IN R OR PYTHON
SELECT * FROM Site WHERE Area < 200;
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60;

-- older-styles operators
SELECT * FROM Site WHERE Code != 'iglo';
SELECT * FROM Site WHERE Code <> 'iglo'; -- older style
-- expression: The usual operators, plus lots functions like regular expression (regex)

## Expressions
-- 2.47 is a conversion factor for area
SELECT Site_name, Area * 2.47 FROM Site;
-- very handy to give a name to columns
SELECT Site_name, Area * 2.47 Area_acres FROM Site;

-- string concatentation
-- old-style operator: | |
SELECT Site_name || ',' || Location AS Full_name FROM Site;
-- there are probably other operators, let's see
SELECT Site_name + Location FROM Site;

-- BTW, you have another fancy calculator!
SELECT 2+2;

-- adding "AS ..." needs to come right after the thing you want to name
SELECT Site_name AS some_other_name FROM Site LIMIT 1;

## AGGREGATION & GROUPING

-- How many rows are in this table?
-- The '*'  MEANS: Just count the rows
SELECT COUNT (*) FROM Bird_nests;

-- We can also ask, how non-NULL values are there?
SELECT COUNT(*) FROM Species;

-- How many rows have scientific names
SELECT COUNT(Scientific_name) FROM Species;

-- Very handy to count number of distinct things
-- Just an idiom, it doesn't make much sense
SELECT COUNT(*) FROM Site;

-- Number of Distinct Locations
SELECT COUNT(DISTINCT Location) FROM Site; 

-- Number of non-NULL Locations
SELECT COUNT(Location) FROM Site; 

-- REMINDER from Monday:
SELECT DISTINCT Location FROM Site;

-- The usual aggregation functions
SELECT AVG(Area) FROM Site;
SELECT MIN(Area) FROM Site;

-- This won't work, but suppose we want to list 7 locations
-- that occur in the Site table, along with the average areas
SELECT Location, AVG(Area) FROM Site; --- THIS WON'T WORK B/C it doesn't know which output to give you location or area

-- Enter Grouping
-- Grab each location and output the average area
SELECT Location, AVG(AREA) FROM Site GROUP BY Location;

-- Similar to Counting
SELECT Location, COUNT(*) FROM Site GROUP BY Location;
-- For Comparison
-- Site %>% group_by(Location) %>% summarize(count=n())

-- We can Site have WHERE Clauses!
-- starting with the site table, count the rows and groupby location
SELECT Location, COUNT(*)
    FROM Site
    WHERE Location LIKE '%Canada' -- old style pattern-matching, NOT a full regular expression (regex), just wildcard (%)
    GROUP BY Location;

-- The order of the clauses reflect the order of the processing
-- But, what if you want to do some filtering on your groups, i.e., *after* you've done the grouping?
SELECT Location, MAX(Area) AS MAX_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200
    ORDER BY Max_area DESC;

## RELATIONAL ALGEBRA
-- EVERYTHING is a TABLE
-- Every query, every statement actually, returns a table
SELECT COUNT(*) FROM Site;

-- you can save tables, you can nest queries
SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM SITE );

-- you can nest queries
SELECT DISTINCT Species FROM Bird_nests;
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);


## NULL processing
-- NULL is infectious
-- In a table, NULL means NO DATA, the absence of a value
-- In an expression, NULL means unknown
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = 'float';
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod != 'float'; -- Different b/c it is a NULL value

-- This won't work, but you will try it by accident anyway
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = NULL;

-- The only way to do it
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NOT NULL;
-- so-called "tri-value" logic

-- JOINS
-- 90% of the time, we'll join tables based on a foreign key relationship
SELECT * FROM Camp_assignment;
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 10;

-- Join is a very general operation, can be applied to any tables, with any expression joining them
-- fundamentally, joins always start from Cartesian product of tables
-- CROSS JOIN = Cartesian Product
SELECT * FROM Site CROSS JOIN Species;
SELECT COUNT(*) FROM Site; -- ROWS 16
SELECT COUNT(*) FROM Species; -- ROWS 99
SELECT 99*16;

-- *any* condition can be expression, we have complete freedom here

-- But when there *is* a foreign key relationship, then
-- what happens?
-- The Table with the foreign key - The result is the same as the table with the foreign key, but augmented with additional columns
SELECT * FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code
    LIMIT 5;

SELECT COUNT(*) FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code;


-- Table Aliases
-- Sometimes, if column names are ambiguous where they're coming from, 
-- need to qualify them
SELECT * FROM Bird_nests JOIN Species
    ON Bird_nests.Species = Species.Code;

-- same, using a table alias
SELECT * FROM Bird_nests AS BN JOIN Species AS S
    ON BN.Species = S.Code;

-- even more compact, leave out the "AS"