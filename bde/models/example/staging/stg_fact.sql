--stg_fact
-- Configuration section: Specifies that this SQL script defines a materialized view.
{{
    config(
        materialized='view'
    )
}}

-- Define a Common Table Expression (CTE) called "source" by selecting data from a source table named 'listing'.

WITH source AS (
    SELECT * FROM {{ source('raw', 'listing') }}
), -- Create another CTE named "filter_data" to transform and filter data from the "source" CTE.
filter_data AS (  
    SELECT 
        SCRAPED_DATE,                  -- Extract the scraped date
        LISTING_ID,                   -- Extract the listing ID
        HOST_ID,                      -- Extract the host ID
        PRICE,                        -- Extract the price
        AVAILABILITY_30,              -- Extract the availability for the next 30 days
        has_availability,             -- Extract the availability status
        number_of_reviews,            -- Extract the number of reviews
        accommodates,                -- Extract the accommodation capacity
        CASE WHEN review_scores_rating BETWEEN 0 AND 100 THEN review_scores_rating ELSE NULL END AS review_scores_rating, -- Normalize the review score for rating
        CASE WHEN review_scores_accuracy BETWEEN 0 AND 100 THEN review_scores_accuracy ELSE NULL END AS review_scores_accuracy,  -- Normalize the review score for accuracy
        CASE WHEN review_scores_cleanliness BETWEEN 0 AND 100 THEN review_scores_cleanliness ELSE NULL END AS review_scores_cleanliness, -- Normalize the review score for cleanliness    
        CASE WHEN review_scores_checkin BETWEEN 0 AND 100 THEN review_scores_checkin ELSE NULL END AS review_scores_checkin,  -- Normalize the review score for check-in  
        CASE WHEN review_scores_communication BETWEEN 0 AND 100 THEN review_scores_communication ELSE NULL END AS review_scores_communication, -- Normalize the review score for value
        CASE WHEN review_scores_value BETWEEN 0 AND 100 THEN review_scores_value ELSE NULL END AS review_scores_value
    FROM source            
    
)
-- Finally, select all columns from the "filter_data" CTE, which represents the filtered and transformed data.
SELECT *
FROM filter_data

