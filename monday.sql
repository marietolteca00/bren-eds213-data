# To verify that we have the 'right' database open, look what tables are in the database:
.table

# for help
.help
.help mode

# To .exit to exit, or Ctrl-D

# In SQL, comments are delimited with --

--.table -- lists tables

--.schema --.list the whole schema
.schema

--Getting help on SQL look at the 'railroad' diagrams in SQLite
-- checkout https://sqlite.org/lang.html


- Our first query
-- The '*' means all columns; all rows are implied because we didn't specify a WHERE clause
SELECT * FROM Species;


-- A couple gotchas
-- 1. Don't foget the closing semicolon (;), DuckDB will wait for it forever
-- 2. Watch for missing lcosing quotes


-- To see just a few rows:
SELECT * FROM Species LIMIT 5;
-- Can also "page" through the rows
SELECT * FROM Species LIMIT 5 OFFSET 5;

-- Of course, we can select which columns we want
SELECT Code, Scientific_name FROM Species;

-- Another handy query to explore data:
SELECT Species FROM Bird_nests;

SELECT DISTINCT Species FROM Bird_nests;

-- Can also get distinct pairs or tuples that occur
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- can ask that the results be ordered

SELECT Scientific_name FROM Species;
SELECT Scientific_name FROM Species ORDER BY Scientific_name;

SELECT * FROM Species;

-- The default ordering (which is undefined) can be subtle
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests LIMIT 3;

-- ^^ I think this is surprising !!

-- Let's try again, but ask that the results be ordered
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species LIMIT 3;


-- In class Challenege: 
-- Select distinct locations from the Site table; are they ordered? If not, order them
-- Run tables to look at all tables
.tables
-- Use The SITE Table from main database!
-- Grab Location and Order by Locations
SELECT DISTINCT Location FROM Site ORDER BY Location;
