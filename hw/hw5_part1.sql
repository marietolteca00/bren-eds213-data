-- Step 1 add Nest_big into a table
CREATE TABLE Nests_big AS SELECT * FROM 'nests_big.csv';

-- Loading Eggs_big
CREATE TABLE Eggs_big AS SELECT * FROM 'eggs_big.csv';


DESCRIBE Nests_big;
DESCRIBE Eggs_big;
DESCRIBE Species;

SELECT * FROM Species Limit 5;

SELECT * FROM Nests_big Limit 5;

SELECT * FROM Eggs_big Limit 5;

-- Step 2 - Relational Join
SELECT Scientific_name FROM Species WHERE Scientific_name = 'Calidris alpina'; -- make sure it exist

-- 2912 rows and 10 columns
SELECT * FROM Eggs_big
    JOIN nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    WHERE Scientific_name = 'Calidris alpina';

-- Step 3
-- Add formula after first column and then use AS to name the column
SELECT Site, ((3.14 / 6) * (Width)^2 * (Length)) AS Volume FROM Eggs_big
    JOIN nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    WHERE Scientific_name = 'Calidris alpina';

-- Step 4 
DESCRIBE Site;

-- View Table
SELECT * FROM Site;

SELECT Site.Longitude, ((3.14 / 6) * (Width)^2 * (Length)) AS Volume FROM Eggs_big
    JOIN nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    JOIN Site ON Nests_big.Site = Site.Code
    WHERE Scientific_name = 'Calidris alpina';

-- Step 5
SELECT MIN(Longitude) FROM Site; -- -164.9 (Neg)
SELECT MAX(Longitude) FROM Site; -- 170.6 (Pos)

-- Step 6
-- Create View Table
CREATE VIEW egg_longitude AS
SELECT CASE WHEN Longitude > 0 THEN Longitude - (360) ELSE Longitude END AS Longitude, 
((3.14 / 6) * (Width)^2 * (Length)) AS Volume FROM Eggs_big
    JOIN nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    JOIN Site ON Nests_big.Site = Site.Code
    WHERE Scientific_name = 'Calidris alpina';

-- Step 7
-- SELECT regr_slope(dependent_y, independent_x) AS slope
-- FROM your_table;
SELECT regr_slope(Volume, Longitude) AS slope, corr(Volume, Longitude) AS PCC FROM egg_longitude;

