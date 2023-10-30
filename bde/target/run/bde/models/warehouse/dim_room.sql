
  
    

  create  table "postgres"."warehouse"."dim_room__dbt_tmp"
  
  
    as
  
  (
    -- dim_host table


WITH current_data AS (
    SELECT *

    FROM "postgres"."staging"."stg_room"
)

SELECT 
    CONCAT(CAST(listing_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_room,
        last_updated_at,
        ROOM_TYPE

FROM current_data
  );
  