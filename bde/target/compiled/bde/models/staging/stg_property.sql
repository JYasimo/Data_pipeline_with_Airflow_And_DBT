-- This SQL script appears to define a materialized view configuration and extracts data from a 'property_snapshot' reference.

-- Configuration section: Specifies that this SQL script defines a materialized view.


-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'property_snapshot' reference.

WITH source AS (
    SELECT * FROM "postgres"."raw"."property_snapshot"
),
-- Create another CTE named "current_data" to filter and transform the data.
current_data AS ( 
    SELECT
        SCRAPED_DATE,                   -- Extract the scraped date
        LISTING_ID,                     -- Extract the listing ID
        PROPERTY_TYPE,                  -- Extract the property type
        UPPER(LISTING_NEIGHBOURHOOD) AS LISTING_NEIGHBOURHOOD,  -- Convert the neighborhood name to uppercase
        dbt_valid_to,                   -- Extract 'dbt_valid_to'
        dbt_valid_from as last_updated_at  -- Extract 'dbt_valid_from' as 'last_updated_at'
    FROM source
    WHERE dbt_valid_to IS NULL --current data
)
-- Select and return specific columns from the "current_data" CTE.
SELECT
    SCRAPED_DATE,
    LISTING_ID,
    PROPERTY_TYPE,
    last_updated_at,
    LISTING_NEIGHBOURHOOD
FROM current_data