
  
    

  create  table "postgres"."raw_public"."host_raw__dbt_tmp"
  
  
    as
  
  (
    -- model_name.sql


-- Your raw SQL query to extract data from the source table
SELECT  SCRAPED_DATE,HOST_ID,HOST_NAME,HOST_SINCE,HOST_IS_SUPERHOST,HOST_NEIGHBOURHOOD,LISTING_NEIGHBOURHOOD

FROM "postgres"."raw"."listing"
  );
  