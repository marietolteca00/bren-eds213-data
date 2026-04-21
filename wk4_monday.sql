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
-- USING TOY.DUCKDB

Let's a join condition, where can be *any* expression!
-- Defaults join by INNER JOIN

SELECT * FROM A JOIN B ON acol1 < bcol1;

This is whats referred to as an INNER JOIN
SELECT * FROM A INNER JOIN B ON acol1 < bcol1;

Outer Join: We are adding rows from one table that never got matched.

SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1;

Left Join:

SELECT * FROM A LEFT JOIN B ON acol1 < bcol1;

Just for completness (this is more way rare that you would want to do this):

SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

Now, joining on a foreign key relationship is way more common
-- is the difference between schema and table -  that schema all constraints, more sql language
-- still able to identify which is primary key bc its underlined
.schema
.table

SELECT * FROM House;
SELECT * FROM Student;

Typical thing to do:

SELECT * FROM Student S JOIN HOUSE H ON S.House_ID = H.House_ID;

Can be done without aliases:
SELECT * FROM Student JOIM House ON Student.House_ID = House.House_ID

One nice benefit of joining on a column that has the same name (i.e., House_ID here)
is you can use `USING` clause

SELECT * FROM Student JOIN House USING (House_ID);

Meanwhile, back in the bird database:

SELECT COUNT(*) FROM Bird_eggs;

For better viewing:
.mode line

SELECT * FROM Bird_eggs LIMIT 1;

SELECT * FROM Bird_eggs JOIN Bird_nests USING (Nest_ID) LIMIT 1;

SELECT COUNT (*) FROM Bird_eggs JOIN Bird_nests USING (Nest_ID);

-- Switch back into regular viewing mode
.mode duckbox

Important Point !!! Ordering is assuredly lost doing a JOIN. So dont say this:
Odering Should always and only be the very last thing

SELECT * FROM
    -- NESTED QUERY
    (SELECT * FROM Bird_eggs Order BY Width)
    JOIN Bird_nests
    USING (Nest_ID);

Gotcha with DuckDB... its not as smart as other databases

SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

Some databases allow you to say:

SELECT Nest_ID, Species COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

workaround:

SELECT Nest_ID, ANY_VALUE(Species), COUNT (*)
    FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
    GROUP BY Nest_ID;

SELECT Nest_ID, Species, COUNT (*)
    FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
    GROUP BY Nest_ID, Species;


SELECT Nest_ID, Species, Egg_num, Width FROM
    Bird_eggs JOIN Bird_nests USING (Nest_ID)
    ORDER BY Nest_ID, Egg_num
    LIMIT 10;


Can two species inhabit the same nest?

ANY_VALUE literally returns any value
SELECT Nest_ID, ANY_VALUE(Width)
    FROM Bird_eggs
    GROUP BY Nest_ID;

Needs To Go over still
- 
- Set operations