
  
    

  create  table "postgres"."raw"."Raw_nsw_lga_code__dbt_tmp"
  
  
    as
  
  (
    -- Raw_property.sql


-- The SQL query to extract data from the source table
SELECT  *

FROM "postgres"."raw"."nsw_lga_code"
  );
  