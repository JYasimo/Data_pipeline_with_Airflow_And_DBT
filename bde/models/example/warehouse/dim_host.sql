

-- dim_host table
{{
    config(
        materialized = 'table',
        unique_key = 'surrogate_key_host'
    )
}}

WITH current_data AS (
    SELECT *

    FROM {{ ref('stg_host') }}
)

SELECT 
    CONCAT(CAST(host_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_host,
    host_id,
    scraped_date,
    last_updated_at,
    host_name, 
    host_since_date, 
    host_is_superhost, 
    host_neighbourhood

FROM current_data
