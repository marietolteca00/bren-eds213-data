First Review Item: Tri-value logic
Expressions can have a value (if Boolean, TRUE or FALSE), but they can also be NULL
In Selecting rows, NULL doesn't cut it, NULL doesn't count as TRUE


SELECT COUNT (*) FROM Bird_nests
    WHERE floatAge < 7 OR floatAge >= 7;

-- Counts Null values
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge IS NULL;

Review item: Relational Algebra
- Everything is a table! 
- Every operation returns a table!
Even a simple COUNT(*) returns a table

SELECT COUNT (*) FROM Bird_nests;

We looked at one example of nesting SELECTs

SELECT Scientific_name
    FROM Species
    WHERE Code NOT IN  (SELECT DISTINCT Species FROM Bird_nests) ORDER BY Scientific_name;

Lets pretend that SQL didn't have a HAVING clause. Could we somehow get the same functionality?
Let's go back to the exapmle where we used a HAVING clause

SELECT Location, Max(Area) AS Max_area
    -- FROM Site
    FROM Site
    -- Only selecting CANADA locations
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    -- Setting threshold
    HAVING Max_area > 200;

As a reminder, the Site table:
SELECT * FROM Site LIMIT 5;



-- Let's try without the HAVING Clause
-- Process Data on the fly- To not create a table every single time
SELECT * FROM 
    (SELECT Location, Max(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location)
   WHERE Max_area > 200;


REVIEW AND CONTINUING DISCUSSING OF JOINS

What is a join? Conceptually, the database performs a "Cartesian Product" 
of the tables, then matches up rows based on some kind of join condition


In some databases, to do a Cartensian product you would just do a JOIN without a condition, e.g.,
SELECT * FROM A JOIN B;

**BUT** in Duckdb, you have to say:
SELECT * FROM A CROSS JOIN B;
SELECT * FROM A;
SELECT * FROM B;

Here's what the Cartesian product looks like:
SELECT * FROM A CROSS JOIN B;

Let's a join condition, where can be *any* expression!

SELECT * FROM A JOIN B ON acol1 < bcol1;

This