

WITH median_prices AS (
    SELECT
        room.ROOM_TYPE,
        prop.PROPERTY_TYPE,
        DATE_TRUNC('month', list.scraped_date) AS month_year,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CASE WHEN list.has_availability = 't' THEN list.price END) OVER (PARTITION BY room.ROOM_TYPE, prop.PROPERTY_TYPE, DATE_TRUNC('month', list.scraped_date)) AS median_price
    FROM warehouse.fact_listing list
    JOIN warehouse.dim_property prop ON list.surrogate_key_property = prop.surrogate_key_property
    JOIN warehouse.dim_room room ON list.surrogate_key_room = room.surrogate_key_room
    WHERE list.has_availability = 't'
)

SELECT
    room.ROOM_TYPE,
    prop.PROPERTY_TYPE,
    month_year,
    median_price
FROM median_prices