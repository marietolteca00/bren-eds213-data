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
