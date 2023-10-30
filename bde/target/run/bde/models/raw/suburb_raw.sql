
  
    

  create  table "postgres"."raw_raw"."suburb_raw__dbt_tmp"
  
  
    as
  
  (
    
-- Your raw SQL query to extract data from the source table
SELECT *
FROM nsw_lga_suburb;
  );
  