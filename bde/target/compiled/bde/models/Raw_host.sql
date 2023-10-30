-- Raw_property.sql


-- The SQL query to extract data from the source table
SELECT  SCRAPED_DATE,HOST_NAME,HOST_ID,HOST_SINCE,HOST_IS_SUPERHOST,HOST_NEIGHBOURHOOD,LISTING_NEIGHBOURHOOD

FROM "postgres"."raw"."listing"