
  
    

  create  table "postgres"."datamart"."dm_property_type__dbt_tmp"
  
  
    as
  
  (
    -- Datamart dm_property_type

-- Set the configuration for the materialized view



-- Create a Common Table Expression (CTE) called sorted_listing
-- This CTE retrieves data from multiple tables and calculates various metrics
-- It includes property_type, room_type, accommodates, and more.


WITH sorted_listing AS (
    SELECT 
        prop.property_type,-- Property type
        room.room_type,-- Room type
        list.accommodates,-- Accommodates
        TO_CHAR(list.scraped_date, 'MM/YYYY') AS month_year, -- Truncate the date to the month
        list.has_availability, -- Including the has_availability column
        list.listing_id, -- Including the listing_id column
        CASE 
            WHEN list.has_availability = 't' THEN list.price 
            ELSE NULL 
        END AS price,
        host.host_id, -- Host ID
        host.host_is_superhost,-- Host is superhost flag
        review_scores_rating,-- Review scores rating
        availability_30-- Availability for the next 30 days
    FROM warehouse.fact_listing list
    LEFT JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property -- Left join for dim_property
    LEFT JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host -- Left join for dim_host
    LEFT JOIN warehouse.dim_room room ON list.surrogate_key_room = room.surrogate_key_room -- Left join for dim_room
)
-- Select the aggregated metrics for the property_type, room_type, accommodates, and month_year
SELECT 
    property_type,-- Property type
    room_type,-- Room type
    accommodates,-- Number of accommodates
    month_year,-- Truncated month and year
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) > 0 THEN (COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) * 1.0 / NULLIF(COUNT(DISTINCT sorted_listing.listing_id), 0)) * 100 
            ELSE 0 
        END), 2
    ) AS active_listing_rate,
    MIN(CASE WHEN has_availability = 't' THEN price END) AS min_price_active_listing,-- Calculate the minimum price for active listings
    MAX(CASE WHEN has_availability = 't' THEN price END) AS max_price_active_listing,-- Calculate the maximum price for active listings
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price_active_listing, -- Calculate the median price for active listings
    ROUND(
        AVG(CASE WHEN has_availability = 't' THEN price END), 2
    ) AS avg_price_active_listing,
    COUNT(DISTINCT host_id) AS number_of_distinct_hosts, -- Count the number of distinct hosts
     -- Calculate the superhost rate
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN host_is_superhost = '1' THEN host_id END) > 0 THEN (COUNT(DISTINCT CASE WHEN host_is_superhost = '1' THEN host_id END) * 1.0 / NULLIF(COUNT(DISTINCT host_id), 0)) * 100 
            ELSE 0 
        END), 2
    ) AS superhost_rate,
     -- Calculate the average review scores rating for active listings
    ROUND(
        AVG(CASE WHEN has_availability = 't' THEN review_scores_rating END), 2
    ) AS avg_review_scores_rating_active,


     -- Calculate the percentage change for active listing
    ROUND(
        ((COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END) - LAG(COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END)) OVER (PARTITION BY property_type, room_type, accommodates, month_year ORDER BY month_year)) * 1.0 / NULLIF(LAG(COUNT(DISTINCT CASE WHEN has_availability = 't' THEN listing_id END)) OVER (PARTITION BY property_type, room_type, accommodates, month_year ORDER BY month_year), 0)) * 100, 2
    ) AS active_listings_percentage_change,
    -- Calculate percentage change for inactive listing
    ROUND(
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END) > 0 THEN (((COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END) - LAG(COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END)) OVER (PARTITION BY property_type, room_type, accommodates, month_year ORDER BY month_year)) * 1.0) / NULLIF(LAG(COUNT(DISTINCT CASE WHEN has_availability = 'f' THEN listing_id END)) OVER (PARTITION BY property_type, room_type, accommodates, month_year ORDER BY month_year), 0)) * 100
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
GROUP BY property_type, room_type, accommodates, month_year
  );
  