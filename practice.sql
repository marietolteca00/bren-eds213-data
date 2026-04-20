SELECT DISTINCT Year FROM Bird_nests;

SELECT  Code FROM Species;

SELECT COUNT(*) Code FROM Species;

-- Selecting the first five rows from the table Bird_eggs
SELECT * FROM Bird_eggs LIMIT 5;

--- Explore the all the values in the Site column
SELECT Site FROM Bird_eggs;

-- Let's view the unique/ distinct values in site now
SELECT DISTINCT Site FROM Bird_eggs;

-- lets select the width by order: Greatest to smallest
SELECT Width FROM Bird_eggs ORDER BY Width;

-- Count the rows in width
SELECT COUNT (*) Width FROM Bird_eggs;
-- Total number of rows
SELECT COUNT (*) FROM Bird_eggs;

-- Number of Distinct Widths
SELECT COUNT (DISTINCT Width) FROM Bird_eggs;

-- Minimum Width
SELECT MIN(Width) FROM Bird_eggs;

-- Avg Width
SELECT AVG(Width) FROM Bird_eggs;

-- Max Width
SELECT MAX(Width) FROM Bird_eggs;


