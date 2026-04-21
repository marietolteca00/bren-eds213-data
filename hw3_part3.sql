.tables
-- Create Table
CREATE TEMP TABLE Averages AS
    -- select nest id, get average and call it avg_volume
    SELECT Nest_ID, AVG((3.14/6)* Width^2 * Length) AS Avg_volume
        -- Use bird_eggs datatable
        FROM Bird_eggs
        -- Group by Nest_Id
        GROUP BY Nest_ID;

-- View Table- Two columns
SELECT * FROM Averages;

-- Join Species, with max avg_volume using Nest_id
SELECT Species, MAX(Avg_volume)
    FROM Bird_nests JOIN Averages USING (Nest_ID)
    GROUP BY Species;

-- Joining Scientific name
SELECT Species, MAX(Avg_volume)
    FROM Bird_nests JOIN Averages USING (Nest_ID) JOIN Species ON Species.Code = Bird_nests.Species
    GROUP BY Species;

-- Fixing join
SELECT Scientific_name, MAX(Avg_volume)
    FROM Bird_nests JOIN Averages USING (Nest_ID) JOIN Species ON Species.Code = Bird_nests.Species
    GROUP BY Scientific_name
    ORDER BY MAX(Avg_volume) DESC;