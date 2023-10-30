
  
    

  create  table "postgres"."raw_raw"."Raw_fact__dbt_tmp"
  
  
    as
  
  (
    -- model_name.sql


-- Your raw SQL query to extract data from the source table

SELECT  SCRAPED_DATE, LISTING_ID, AVAILABILITY_30, NUMBER_OF_REVIEWS,
        REVIEW_SCORES_RATING, REVIEW_SCORES_ACCURACY, REVIEW_SCORES_CLEANLINESS,
        REVIEW_SCORES_CHECKIN, REVIEW_SCORES_COMMUNICATION, REVIEW_SCORES_VALUE,
        PRICE
FROM listing;
  );
  