
  
    

  create  table "postgres"."raw"."Raw_G01__dbt_tmp"
  
  
    as
  
  (
    -- Raw_property.sql


-- The SQL query to extract data from the source table
SELECT  *

FROM "postgres"."raw"."census_g01_nsw_lga_2016"
  );
  