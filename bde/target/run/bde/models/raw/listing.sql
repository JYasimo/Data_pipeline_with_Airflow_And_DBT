
  
    

  create  table "postgres"."raw_raw"."listing__dbt_tmp"
  
  
    as
  
  (
    -- model_name.sql


-- Your raw SQL query to extract data from the source table
SELECT PROPERTY_TYPE , ROOM_TYPE , SCRAPED_DATE
FROM "postgres"."raw"."listing";
  );
  