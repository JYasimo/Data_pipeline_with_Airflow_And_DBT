-- Raw_property.sql


-- The SQL query to extract data from the source table
SELECT  SCRAPED_DATE,LISTING_ID,PROPERTY_TYPE,LISTING_NEIGHBOURHOOD

FROM "postgres"."raw"."listing"