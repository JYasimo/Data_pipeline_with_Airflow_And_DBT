
  create view "postgres"."staging"."stg_room__dbt_tmp"
    
    
  as (
    -- stg_room.sql



with

source  as (

    select * from "postgres"."raw"."room_snapshot"

),

current_record as (
    select
        SCRAPED_DATE,
        LISTING_ID,
        ROOM_TYPE,
        dbt_valid_to,
        dbt_valid_from as last_updated_at
    from source
    where dbt_valid_to IS NULL --when dbt_valid_to is equal to null it means data is still valid
)
select 
        last_updated_at,
        LISTING_ID,
        ROOM_TYPE,
        SCRAPED_DATE
        
from current_record
  );