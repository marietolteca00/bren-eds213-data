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

