-- self-join of a table is a regular join, but instead of joining two different tables, 
-- we join two copies of the same table, which we will call the “A” copy and the “B” copy:

# Step 1
-- Select all rows from camp assignment table A,
SELECT * FROM Camp_assignment A
    -- Join with camp assignment 
    JOIN Camp_assignment B 
    -- Combine both tables together using Site
    ON A.Site = B.Site;

# Step 2 
SELECT * FROM Camp_assignment A
    JOIN Camp_assignment B ON A.Site = B.Site
    -- Conditonal Statement
    AND A.Start <= B.End
    AND B.Start <= A.End;

# Step 3
SELECT * FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site
    WHERE A.Site = 'lkri'
    A.Observer < B.Observer;

SELECT * FROM Camp_assignment A
JOIN Camp_assignment B ON A.Site = B.Site
    AND A.Start <= B.End
    AND B.Start <= A.End
    AND A.Observer < B.Observer
WHERE A.Site = 'lkri';

# Step 4
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2
FROM Camp_assignment A
JOIN Camp_assignment B ON A.Site = B.Site
    AND A.Start <= B.End
    AND B.Start <= A.End
    AND A.Observer < B.Observer
WHERE A.Site = 'lkri'
ORDER BY A.Site;

-- BONUS
-- Check Personnel see which column could be joined
SELECT * FROM Personnel LIMIT 2;

---
SELECT A.Site, p1.Name AS Name_1, p2.Name AS Name_2
FROM Camp_assignment A
JOIN Camp_assignment B ON A.Site = B.Site
-- Conditions
    AND A.Start <= B.End
    AND B.Start <= A.End
    AND A.Observer < B.Observer
-- Add Personnel Table 2x's
JOIN Personnel as p1 ON A.Observer = p1.Abbreviation
JOIN Personnel as p2 ON B.Observer = p2.Abbreviation
    WHERE A.Site = 'lkri'
    ORDER BY A.Site;