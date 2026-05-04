
.table

PART 1:

SELECT Site_name, MAX(Area) FROM Site;

SELECT ANY_VALUE(Site_name), MAX(Area) FROM Site;

SELECT Site_name, AVG(Area) FROM Site;

SELECT ANY_VALUE(Site_name), COUNT(*) FROM Site;

-- The reason we are getting an error is because we have more than one value in Site_name. 
-- When adding the 'Max(Area)' the computer does not know which value to get and spits out 
-- an error to use Any_value(). When any_value(Site_name) is added, it provides the computer to choose any value 
-- and get the max(area) from that dataframe, which may not be matched correctly. 
-- The main problem of this is to collapse Max(area) into a single row.

PART 2:
-- Find the site name and area of the site having the largest area. Do so by ordering 
-- the rows in a particularly convenient order, and using LIMIT to select just the first row. Your result should look like:
SELECT Site_name, Area From Site ORDER BY Area DESC LIMIT 1;

PART 3:
-- Do the same, but use a nested query. First, create a query that finds the maximum area. 
-- Then, create a query that selects the site name and area of the site whose area equals 
-- the maximum. Your overall query will look something like:

SELECT Site_name, Area FROM Site WHERE Area = (SELECT MAX(Area) FROM Site); -- Inside nested does not need 'Site_name' or 'WHERE'
