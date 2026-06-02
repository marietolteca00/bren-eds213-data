# Install libraries
-- INSTALL spatial;
LOAD spatial;
-- INSTALL httpfs;
LOAD httpfs;

# Location of Interest
-- Location: Oxnard, CA — Lat: 34.1975, Long: -119.1771


-- Parquet data for Ventura County and subset only a few columns (URL);
SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84 
FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet')
-- State and County
-- Ventura County, CA (STATEFP='06', COUNTYFP='111')
WHERE STATEFP = '06' AND COUNTYFP = '111';


-- Load in FIPS State County CSV (URL)
SELECT STATEFP, State_name, COUNTYFP, County_name FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv');

-- Store into a table/view - Walkablility_CA
CREATE OR REPLACE VIEW Walkability_CA AS
  SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84
  FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet', hive_partitioning=true)
  -- Ventra County, CA
  WHERE STATEFP = '06' AND COUNTYFP = '111';

-- Store into a table/view - FIPS
CREATE OR REPLACE TABLE Fips AS
  SELECT STATEFP, State_name, COUNTYFP, County_name
  FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv', hive_partitioning=true)
  -- Ventra County, CA
  WHERE STATEFP = '06' AND COUNTYFP = '111';

-- Join Tables
CREATE OR REPLACE VIEW Walkind_ca AS
  SELECT w.GEOID10, w.STATEFP, w.COUNTYFP, w.TRACTCE, w.BLKGRPCE,w.CBSA, w.CBSA_Name, w.TotPop, w.NatWalkInd, w.geom_wgs84, 
  f.State_name, f.County_name
  
  FROM Walkability_ca w
  LEFT JOIN Fips f ON w.STATEFP = f.STATEFP AND w.COUNTYFP = f.COUNTYFP;

-- Walkability Index at Location (Oxnard, CA)
SELECT GEOID10, TRACTCE, BLKGRPCE, NatWalkInd, County_name
FROM Walkind_ca
-- Insert Coords
WHERE ST_Within(ST_Point(-119.1771, 34.1975), geom_wgs84);
-- Result : NatWalkInd = 10.3 

-- Average Walkability Index at Oxnard Census Tract Level
-- Adding round to control sigfigs
SELECT TRACTCE, COUNT(*) AS Block_count, Round(AVG(NatWalkInd)) AS Walkind_tract_avg
FROM Walkind_ca
WHERE STATEFP = '06' AND COUNTYFP = '111' AND TRACTCE = '009100'
GROUP BY TRACTCE;
-- Result: Walkind_tract_avg = 13.0 after rounding

-- Average Walkability Indext at Ventura County Level
SELECT COUNTYFP, County_name, COUNT(*) AS Block_count, Round(AVG(NatWalkInd)) AS Walkind_county_avg
FROM Walkind_ca
GROUP BY COUNTYFP, County_name;
-- Result: Walkind_tract_avg = 12.0 after rounding & Block Count = 430

-- Discuss Results
-- My block group in Oxnard scored 10.3, below both the tract average (13.0) and Ventura County average (12.0), making it the least 
-- walkable of the three. Considering the documentation was last updated in 2021, Oxnard has a lot of unpaved roads (mostly dirt roads, at least the area I live in)
-- With infrastructure being increase in the area, lots of roads have improved and now have sidewalks in a lot of areas that previously did not.
-- Ventura County as a whole has a lot of cities, most are walkable besides some areas, however there has been a lot of beautification project
-- occuring and increasing more bike paths and walking paths. To help reduce the car congestions we are now experiencing 


-- Export CSV
COPY (
  SELECT w.*,
    AVG(w.NatWalkInd) OVER (PARTITION BY w.TRACTCE) AS Walkind_tract_avg,
    AVG(w.NatWalkInd) OVER () AS Walkind_county_avg
  FROM Walkind_ca w
  WHERE w.TRACTCE = '009100'
) TO 'ventura_walkability.csv' (HEADER, DELIMITER ',');

-- The geometry column is not preserved in CSV because CSV is plain text and has no spatial type support.
-- Formats like Parquet would retain the geometry column with its spatial type intact.