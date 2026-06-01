# Install libraries
-- INSTALL spatial;
LOAD spatial;
-- INSTALL httpfs;
LOAD httpfs;

-- Parquet data for Santa Barbara County and subset only a few columns (URL);
SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84 
FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet')
-- State and County
WHERE STATEFP = '06' AND COUNTYFP = '111';

-- Load in FIPS State County CSV (URL)
SELECT STATEFP, COUNTYFP FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv');

-- Store into a table/view - Walkablility_CA
CREATE OR REPLACE VIEW Walkability_CA AS (
  SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom
  FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet', hive_partitioning=true)
  -- Ventra County, CA
  WHERE STATEFP = '06' AND COUNTYFP = '111'
  );

-- Store into a table/view - FIPS
CREATE OR REPLACE VIEW fips AS (
  SELECT STATEFP, COUNTYFP
  FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv', hive_partitioning=true)
  -- Ventra County, CA
  WHERE STATEFP = '06' AND COUNTYFP = '111'
  );
