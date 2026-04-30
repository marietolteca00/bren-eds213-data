-- that an observer, who worked at the “nome” site between 1998 and 2008 inclusive, 
-- had been floating eggs in salt water and not freshwater.

-- The colleague says that this incorrect technique was used on exactly 36 nests, 
-- but before you can ask who the observer was, the phone is disconnected

-- start with all rows
SELECT * FROM Bird_nests
    -- Specify Site
    WHERE Site = 'nome'
    -- Year Selection
    AND Year BETWEEN 1998 AND 2008
    -- Set float from ageMethod
    AND ageMethod = float;

-- Add in observer, count all rows and output should be called num_floated_nests
SELECT Observer, COUNT(*) AS Num_floated_nests
    FROM Bird_nests
    WHERE Site = 'nome'
    AND Year BETWEEN 1998 AND 2008
    AND ageMethod = 'float'
    -- add group by observer
    GROUP BY Observer;

-- Check column that match tables to combine
SELECT Abbreviation, Name FROM Personnel LIMIT 2;
SELECT Observer FROM Bird_nests LIMIT 2;


-- Join with personnel table
SELECT Personnel.Name, COUNT(*) AS Num_floated_nests
    FROM Bird_nests
    JOIN Personnel 
    ON Bird_nests.Observer = Personnel.Abbreviation
    WHERE Site = 'nome'
    AND Year BETWEEN 1998 AND 2008
    AND ageMethod = 'float'
    GROUP BY Observer
    HAVING Num_floated_nests = 36;
