-- Using a Code NOT IN (subquery) clause.
SELECT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;
    
-- Outer Join with WHERE
SELECT Code FROM Site
    LEFT JOIN Bird_eggs ON Code = Site
    -- Condition
    WHERE Site IS NULL 
    ORDER BY Code;