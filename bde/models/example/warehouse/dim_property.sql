
-- dim_property table
{{
    config(
        materialized = 'table',
        unique_key = 'surrogate_key_property'
    )
}}

WITH current_data AS (
    SELECT *

    FROM {{ ref('stg_property') }}
)

SELECT 
    CONCAT(CAST(listing_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_property,
    LISTING_ID,
    PROPERTY_TYPE,
    last_updated_at,
    LISTING_NEIGHBOURHOOD

FROM current_data
