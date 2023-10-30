

WITH sorted_listings AS (
    SELECT 
        CASE 
            WHEN list.has_availability = 't' THEN list.price 
            ELSE NULL 
        END AS price_value,
        prop.LISTING_NEIGHBOURHOOD,
        DATE_TRUNC('month', list.scraped_date) AS month
    FROM warehouse.fact_listing list
    JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property
    JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host
)

, median_prices AS (
    SELECT
        LISTING_NEIGHBOURHOOD,
        month,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price_value) AS median_price
    FROM sorted_listings
    WHERE price_value IS NOT NULL
    GROUP BY LISTING_NEIGHBOURHOOD, month
)

SELECT * FROM median_prices