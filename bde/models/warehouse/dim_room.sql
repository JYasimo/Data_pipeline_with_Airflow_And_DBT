
-- dim_host table
{{
    config(
        materialized = 'table',
        unique_key = 'surrogate_key_room'
    )
}}

WITH current_data AS (
    SELECT *

    FROM {{ ref('stg_room') }}
)

SELECT 
    CONCAT(CAST(listing_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_room,
        last_updated_at,
        ROOM_TYPE

FROM current_data




