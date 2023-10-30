
  
    

  create  table "postgres"."raw"."Raw_G02__dbt_tmp"
  
  
    as
  
  (
    -- Raw_property.sql


-- The SQL query to extract data from the source table
SELECT  *

FROM "postgres"."raw"."census_g02_nsw_lga_2016"
  );
  