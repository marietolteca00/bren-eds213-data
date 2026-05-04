## Recap: views
Link to learn more SQL - https://sqlite.org/lang.html

- A view is kind of virtual table
- Stored in the database
- Execute everytime its referenced
- In effect, a view is a kind of shortcut
- Its similar to a function in a programming language

-- A view gets re-executed
Example:
Suppose we want to look at bird nest, but we always would rather see scientific names,
not species codes

CREATE VIEW Nest_view AS
    -- Selecting columns
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer
    -- From this table join it with this table
    FROM Bird_nests JOIN species
    -- To join use species and code
    ON Species = Code;

SELECT * FROM Bird_nests LIMIT 1;

Lets use our view for a more substantial purpose: Counting eggs, 
but we would like to see the nest_ID and the scientific name for each nest

-- Count the nuumer of rows
SELECT Nest_ID, ANY_VALUE(Scientific_name), COUNT(*) AS Num_eggs
    -- combining tables
    FROM Nest_view JOIN Bird_eggs
    -- use this column
    USING (Nest_ID)
    -- group by
    GROUP BY Nest_ID;

WITHOUT ANY_VALUE -- will spit out an error
SELECT Nest_ID, Scientific_name, COUNT(*) AS Num_eggs
    -- combining tables
    FROM Nest_view JOIN Bird_eggs
    -- use this column
    USING (Nest_ID)
    -- group by
    GROUP BY Nest_ID;
 
 
 View compared to TEMP TABLES:
 - Temp table is more like a vairable in a programming language
 - As the name suggest, "Temp" table only last for the session

 Another option! USE A WITH CLAUSE
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID;

-- Ex: take previous table, use it input to another query:

WITH x AS(
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    -- combining tables
    FROM Nest_view JOIN Bird_eggs
    -- use this column
    USING (Nest_ID)
    -- group by
    GROUP BY Nest_ID
) SELECT Scientific_name, AVG(Num_eggs) AS Avg_num_eggs FROM x
  GROUP BY Scientific_name;

- The variable ("x" in this case) only last for the statement; its really
    a kind of Abbreviation

SELECT * FROM x;

## SET OPERATIONS

- Recall that tables are **sets** of rows, not ordered lists
- We can do set operations on tables
- UNION, INTERSECT, EXCEPT (set difference) -- Give me everything in A that is not in B
- One note: These are set operations, so duplicates are eliminated in UNIONs
- But, if you do want to preserve all rows, UNION all

Example of a UNION: Lets go bakc to last weeks quiz
We want a table of bird nests and egg counts, but we also want entries
for nest that have no eggs (they should have a count of 0)

SELECT Nest_ID, COUNT(Egg_num) AS Num_eggs
    FROM Bird_nests LEFT JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID;

Lets try solving the same problem, but using UNION

SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_eggs
    GROUP BY Nest_ID

## UNION
-- simply aggregation on Num_eggs
SELECT Nest_ID, 0 AS Num_eggs
    -- From this table
    FROM Bird_nests
    -- nested query - give me all the unique nest id's that do no appear in Nest_ID
    WHERE Nest_ID NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs);

# JOINED CONDITIONS
- Join conditions on a Foreign key, two ways
- ... ON Species = Code
-- if the same column
- ... ON Bird_nests.Nest_ID = Bird_eggs.Nest_ID
- but just more compact to say ... USING (Nest_ID)
- you can get away with *not* prefixing columns if theyre unambiguous 
- but if the names are ambiguous, you need to prefix them

NOTE on UNIONS: SQL will UNION any two tables that have the same number 
of columns and compatible datatypes

Example of when you might want to use EXCEPT:
Question: Which species do we *not* have data for?

Way #1:
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

Way #2:
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    -- Condition
    WHERE Species IS NULL;

Way #3: Give me all the code except the ones that appear in bird nest table
SELECT Code FROM Species
    EXCEPT
    SELECT DISTINCT Species FROM Bird_nests;

## Enough with SELECT ! DATA MANAGEMENT Statements

- INSERT Statements

SELECT * FROM Personnel;

INSERT INTO Personnel VALUES ('gjanee', 'Greg Janée');

SELECT * FROM Personnel;

-- Good Practice For safer code: name the columns
INSERT INTO Personnel (Abbreviation, Name) VALUES ('jbrun', 'Julien Brun');

- Also, when you insert a row in a table, you dont necessarily
have to specify all the values; anything not specified will either
be filled with NULL or a default values
- So thats another reason for spelling out the column names

- Datebases typically have some kind of load function to laod data in bulk

# Updates and deletes

SELECT * FROM Bird_nests LIMIT 10;
UPDATE Bird_nests SET floatAge = 6.5, ageMethod = 'float'
    WHERE Nest_ID = '14HPE1';
SELECT * FROM Bird_nests LIMIT 10;

DELETE is very similar

-- DELETE FROM Bird_nests WHERE ...;

The above two commands (UPDATE, DELETE) Are just incredibly dangerous

The weird/ terrible behavior: if no WHERE clause, they operate on **all** rows in the table
- Will delete all files, if not specified

UPDATE Bird_nests SET floatAge = NULL;

SELECT * FROM Bird_nests;

.exit

-- Do the following on the terminal
git restore database.duckdb

duckdb database.duckdb

- What is a strategy to not make this terrible mistake?
One Idea:
First do a SELECT to confirm the rows you want to operate on, then edit The 
statement to do an UPDATE
SELECT * FROM Bird_nests WHERE Nest_ID = '98nome7';

Another idea:
Use a fake table name, then change to the real name
UPDATE Bird_nestsxxxx SET... WHERE...;


- But in general, won't be a possibility, databases not typically
  under git control, usually stored on a server somewhere

- Strategies to avoid catastrophes
-- Just subconsciouly be careful, like holding a kitchen knife
-- Do SELECT first, then replace SELECT with DELETE <- allows inspection
   of what's about to be deleted
-- Put comment in front: -- DELETE FROM ..., then remove comment
-- Tweak table name, put x in front, then remove

