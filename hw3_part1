-- Create table
CREATE temp TABLE mytable(val REAL);

-- Inserting #'s in rows
INSERT INTO mytable VALUES (10), (20), (30), (NULL);

-- Run value
SELECT AVG(val) FROM mytable; 
-- value returned is 20, NULL did not get counted, it was ignored
-- The way it was calculated was by 
SELECT 10+20+30;
SELECT 60/3;
-- This exludes the NULL getting counted as 0 and if it was counted it would've been 
-- 4 in the denominator instead of 3 for the values total

-- PART 2
-- Which query is correct
SELECT SUM(val)/COUNT(*) FROM mytable; -- Not correct
-- This is not correct because it is counting the NULL as an extra value in the denominator
-- causing this to be 60/4 = 15. This counts the row of NULL.

SELECT SUM(val)/COUNT(val) FROM mytable; -- Correct
-- This provides the same output as it did in part 1. It is not counting the NULL value 
-- row. This helps since we don't have information on what NULL means in this case