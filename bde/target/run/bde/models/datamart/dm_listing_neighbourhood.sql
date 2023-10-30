
  
    

  create  table "postgres"."datamart"."dm_listing_neighbourhood__dbt_tmp"
  
  
    as
  
  (
    -- Datamart dm_listing_neighbourhood view
-- Set configuration options for the materialized view

-- Create a common table expression (CTE) named sorted_listing
WITH sorted_listing AS (
    -- Select relevant columns from fact_listing and join with dimension tables
    SELECT 
        prop.listing_neighbourhood,
        TO_CHAR(list.scraped_date, 'MM/YYYY') AS month_year,     
        list.has_availability, -- Including the has_availability column
        list.listing_id, -- Including the listing_id column
        CASE 
            WHEN list.has_availability = 't' THEN list.price 
            ELSE NULL 
        END AS price,
        host.host_id,
        host.host_is_superhost,
        review_scores_rating,
        availability_30
    FROM warehouse.fact_listing list
    LEFT JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property -- Left join for dim_property
    LEFT JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host -- Left join for dim_host
)
-- Select and calculate various metrics from the sorted_listing CTE
SELECT 
    listing_neighbourhood,
    month_year,
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) > 0 THEN (COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) * 1.0 / NULLIF(COUNT(DISTINCT sorted_listing.listing_id), 0)) * 100 
            ELSE 0 
        END), 2
    ) AS active_listing_rate,
    MIN(CASE WHEN has_availability = 't' THEN price END) AS min_price_active_listing,
    MAX(CASE WHEN has_availability = 't' THEN price END) AS max_price_active_listing,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price_active_listing,
    ROUND(
        AVG(CASE WHEN has_availability = 't' THEN price END), 2
    ) AS avg_price_active_listing,
    COUNT(DISTINCT host_id) AS number_of_distinct_hosts,
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN host_is_superhost = '1' THEN host_id END) > 0 THEN (COUNT(DISTINCT CASE WHEN host_is_superhost = '1' THEN host_id END) * 1.0 / NULLIF(COUNT(DISTINCT host_id), 0)) * 100 
            ELSE 0 
        END), 2
    ) AS superhost_rate,
    ROUND(
        AVG(CASE WHEN has_availability = 't' THEN review_scores_rating END), 2
    ) AS avg_review_scores_rating_active,

    -- Calculate percentage change for active listings
    ROUND(
        ((COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) - LAG(COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END)) OVER (PARTITION BY listing_neighbourhood ORDER BY month_year)) * 1.0 / NULLIF(LAG(COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END)) OVER (PARTITION BY listing_neighbourhood ORDER BY month_year), 0)) * 100, 2
    ) AS active_listings_percentage_change,
    -- Calculate percentage change for inactive listings
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END) > 0 THEN (((COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END) - LAG(COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END)) OVER (PARTITION BY listing_neighbourhood ORDER BY month_year)) * 1.0) / NULLIF(LAG(COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END)) OVER (PARTITION BY listing_neighbourhood ORDER BY month_year), 0)) * 100
            ELSE 0
        END), 2
    ) AS inactive_listings_percentage_change,
    -- Calculate the total number of stays
    SUM(CASE WHEN has_availability = 't' THEN (30 - availability_30) END) AS number_of_stays,
    -- Calculate the average estimated revenue per active listing
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) > 0 THEN (SUM(CASE WHEN has_availability = 't' THEN (30 - availability_30) * price END) * 1.0 / NULLIF(COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END), 0))
            ELSE 0
        END), 2
    ) AS avg_estimated_revenue_per_active_listing
FROM sorted_listing
-- Group the results by listing_neighbourhood and month_year
GROUP BY listing_neighbourhood, month_year
  );
  