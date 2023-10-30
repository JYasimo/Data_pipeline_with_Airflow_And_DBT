
  
    

  create  table "postgres"."datamart"."dm_listing_2__dbt_tmp"
  
  
    as
  
  (
    

WITH sorted_listings AS (
    SELECT 
        list.price,
        prop.LISTING_NEIGHBOURHOOD,
        DATE_TRUNC('month', list.scraped_date) AS month
    FROM warehouse.fact_listing list
    JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property
    JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host
)


SELECT 
    prop.LISTING_NEIGHBOURHOOD,
    DATE_TRUNC('month', list.scraped_date) AS month_year,
    (COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END) * 1.0 / COUNT(DISTINCT list.listing_id)) * 100 AS active_listing_rate,
    MIN(CASE WHEN list.has_availability = 't' THEN list.price END) AS min_price_active_listings,
    MAX(CASE WHEN list.has_availability = 't' THEN list.price END) AS max_price_active_listings,
    AVG(CASE WHEN list.has_availability = 't' THEN list.price END) AS avg_price_active_listings,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price_value, 
    COUNT(DISTINCT list.host_id) AS distinct_hosts,
    (COUNT(DISTINCT CASE WHEN host.host_is_superhost = 't' THEN list.host_id END) * 1.0 / COUNT(DISTINCT list.host_id)) * 100 AS superhost_rate,
    AVG(CASE WHEN list.has_availability = 't' THEN list.review_scores_rating END) AS avg_review_scores_rating_active,

   -- Calculate percentage change for active listings
    ((COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END) - LAG(COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END), 1) OVER (PARTITION BY prop.LISTING_NEIGHBOURHOOD ORDER BY DATE_TRUNC('month', list.scraped_date))) / LAG(COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END), 1) OVER (PARTITION BY prop.LISTING_NEIGHBOURHOOD ORDER BY DATE_TRUNC('month', list.scraped_date))) * 100 AS active_listing_percentage_change,

-- Calculate percentage change for inactive listings
(CASE 
    WHEN LAG(COUNT(DISTINCT CASE WHEN list.has_availability = 'f' THEN list.listing_id END), 1) OVER (PARTITION BY prop.LISTING_NEIGHBOURHOOD ORDER BY DATE_TRUNC('month', list.scraped_date)) = 0 THEN NULL
    ELSE ((COUNT(DISTINCT CASE WHEN list.has_availability = 'f' THEN list.listing_id END) - LAG(COUNT(DISTINCT CASE WHEN list.has_availability = 'f' THEN list.listing_id END), 1) OVER (PARTITION BY prop.LISTING_NEIGHBOURHOOD ORDER BY DATE_TRUNC('month', list.scraped_date))) / NULLIF(LAG(COUNT(DISTINCT CASE WHEN list.has_availability = 'f' THEN list.listing_id END), 1) OVER (PARTITION BY prop.LISTING_NEIGHBOURHOOD ORDER BY DATE_TRUNC('month', list.scraped_date)), 0)) * 100
END) AS inactive_listing_percentage_change,


    SUM(CASE WHEN list.has_availability = 't' THEN (30 - list.availability_30) END) AS total_number_of_stays,
    

    SUM(CASE WHEN list.has_availability = 't' THEN (30 - list.availability_30) * list.price END) * 1.0 / COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END) AS avg_estimated_revenue_per_active_listings
FROM warehouse.fact_listing list
JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property
JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host
GROUP BY prop.LISTING_NEIGHBOURHOOD, DATE_TRUNC('month', list.scraped_date)
  );
  