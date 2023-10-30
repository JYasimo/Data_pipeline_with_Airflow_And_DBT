
  
    

  create  table "postgres"."warehouse"."fact_listing__dbt_tmp"
  
  
    as
  
  (
    -- listings fact table


SELECT
    CONCAT(CAST(listing_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_property,
    CONCAT(CAST(listing_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_room,
    CONCAT(CAST(host_id AS VARCHAR), '_', CAST(scraped_date AS VARCHAR)) as surrogate_key_host,
    listing_id,
    scraped_date,
    host_id,
    price,
    accommodates,
    has_availability,
    availability_30,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_value,
    number_of_reviews,
    review_scores_rating

FROM "postgres"."staging"."stg_fact"
  );
  