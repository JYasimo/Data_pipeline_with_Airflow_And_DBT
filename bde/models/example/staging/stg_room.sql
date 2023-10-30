-- stg_room.sql

-- This SQL script 'stg_room.sql' appears to be part of a data integration process, and it focuses on extracting data related to rooms from a 'room_snapshot' reference.

-- Configuration section: Set the unique key for this data to be 'LISTING_ID'.


{{
    config(
        unique_key='LISTING_ID'
    )
}}

-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'room_snapshot' reference.

with source  as (

    select * from {{ ref('room_snapshot') }}

),

-- Create another CTE named "current_record" to filter and select relevant columns from the data.

current_record as (
    select
        SCRAPED_DATE,                   -- Extract the scraped date
        LISTING_ID,                     -- Extract the listing ID
        ROOM_TYPE,                      -- Extract the room type
        dbt_valid_to,                   -- Extract 'dbt_valid_to'
        dbt_valid_from as last_updated_at  -- Extract 'dbt_valid_from' as 'last_updated_at'
    from source
    where dbt_valid_to IS NULL --when dbt_valid_to is equal to null it means data is still valid
)

-- Select and return specific columns from the "current_record" CTE.

select 
        last_updated_at,
        LISTING_ID,
        ROOM_TYPE,
        SCRAPED_DATE
        
from current_record







