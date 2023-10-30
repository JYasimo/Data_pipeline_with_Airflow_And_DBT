
  create view "postgres"."warehouse"."dim_fact__dbt_tmp"
    
    
  as (
    -- WITH check_dimensions AS (
--     SELECT
--         SCRAPED_DATE,
--         CASE
--             WHEN a.LISTING_ID IN (SELECT DISTINCT PROPERTY_LISTING_ID FROM "postgres"."staging"."stg_property") THEN a.LISTING_ID
--             ELSE 0
--         END AS a_LISTING_ID, -- Use table aliases to disambiguate
--         CASE
--             WHEN a.LISTING_ID IN (SELECT DISTINCT ROOM_LISTING_ID FROM "postgres"."staging"."stg_room") THEN a.LISTING_ID
--             ELSE 0
--         END AS r_LISTING_ID, -- Use table aliases to disambiguate
--         CASE
--             WHEN a.HOST_ID IN (SELECT DISTINCT HOST_ID FROM "postgres"."staging"."stg_host") THEN a.HOST_ID
--             ELSE 0
--         END AS h_HOST_ID, -- Use table aliases to disambiguate
--         a.PRICE,
--         a.NUMBER_OF_REVIEWS,
--         a.REVIEW_SCORES_RATING,
--         a.REVIEW_SCORES_ACCURACY,
--         a.REVIEW_SCORES_CLEANLINESS,
--         a.REVIEW_SCORES_CHECKIN,
--         a.REVIEW_SCORES_COMMUNICATION,
--         a.REVIEW_SCORES_VALUE 
--     FROM "postgres"."staging"."stg_fact" a
-- )

-- SELECT DISTINCT
--     a.a_LISTING_ID AS LISTING_ID, -- Use aliases to disambiguate
--     d.HOST_ID,
--     a.NUMBER_OF_REVIEWS,
--     a.REVIEW_SCORES_RATING,
--     a.REVIEW_SCORES_ACCURACY,
--     a.REVIEW_SCORES_CLEANLINESS,
--     a.REVIEW_SCORES_CHECKIN,
--     a.REVIEW_SCORES_COMMUNICATION,
--     a.REVIEW_SCORES_VALUE, 
--     b.PROPERTY_TYPE,
--     b.LISTING_NEIGHBOURHOOD,
--     c.ROOM_TYPE,
--     d.HOST_NAME,
--     d.host_is_superhost,
--     d.HOST_NEIGHBOURHOOD
-- FROM check_dimensions a
-- LEFT JOIN staging.stg_property b  ON a.a_LISTING_ID = b.PROPERTY_LISTING_ID AND a.SCRAPED_DATE::timestamp >= b.dbt_valid_from 
-- LEFT JOIN staging.stg_room c  ON a.r_LISTING_ID = c.ROOM_LISTING_ID AND a.SCRAPED_DATE::timestamp >= c.dbt_valid_from
-- LEFT JOIN staging.stg_host d  ON a.h_HOST_ID = d.HOST_ID AND a.SCRAPED_DATE::timestamp >= d.dbt_valid_from
  );