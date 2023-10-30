
  
    

  create  table "postgres"."raw"."Raw_room__dbt_tmp"
  
  
    as
  
  (
    -- Raw_room.sql


-- the SQL query to extract data from the source table
SELECT  SCRAPED_DATE,LISTING_ID,ROOM_TYPE

FROM "postgres"."raw"."listing"
  );
  