

WITH sorted_listings AS (
    SELECT 
        CASE 
            WHEN list.has_availability = 't' THEN list.price 
            ELSE NULL 
        END AS price_value
    FROM warehouse.fact_listing list
)

SELECT
  room.ROOM_TYPE,
  prop.PROPERTY_TYPE,
  DATE_TRUNC('month', list.scraped_date) AS month_year,
  (COUNT(DISTINCT CASE WHEN list.has_availability = 't' THEN list.listing_id END) * 1.0 / COUNT(DISTINCT list.listing_id)) * 100 AS active_listing_rate,
  MIN(CASE WHEN list.has_availability = 't' THEN list.price END) AS min_price_active_listings,
  MAX(CASE WHEN list.has_availability = 't' THEN list.price END) AS max_price_active_listings,
  AVG(CASE WHEN list.has_availability = 't' THEN list.price END) AS avg_price_active_listings,
  COUNT(DISTINCT list.host_id) AS distinct_hosts,
  (COUNT(DISTINCT CASE WHEN host.host_is_superhost = 't' THEN list.host_id END) * 1.0 / COUNT(DISTINCT list.host_id)) * 100 AS superhost_rate,
  AVG(CASE WHEN list.has_availability = 't' THEN list.review_scores_rating END) AS avg_review_scores_rating_active
FROM warehouse.fact_listing list

JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property
JOIN warehouse.dim_room room ON list.surrogate_key_room = room.surrogate_key_room
JOIN warehouse.dim_host host ON list.surrogate_key_host = host.surrogate_key_host

GROUP BY room.ROOM_TYPE, prop.PROPERTY_TYPE,DATE_TRUNC('month', list.scraped_date)