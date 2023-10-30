
  create view "postgres"."staging"."stg_host__dbt_tmp"
    
    
  as (
    --dim_host.sql

-- This SQL script, 'dim_host.sql,' is designed to create a dimension table for host information, as part of an ELT process.


-- Configuration section: Specifies that this SQL script defines a materialized view.


-- Start by defining a Common Table Expression (CTE) named "source" to retrieve data from the 'host_snapshot' reference.
with source as (
    select * from "postgres"."raw"."host_snapshot"
),

-- Next, create a CTE named "cleaned_host" for data cleaning and transformation.

cleaned_host as ( 
    select 
        HOST_ID,                -- Extract host ID
        scraped_date,           -- Extract scraped date
        HOST_NAME,              -- Extract host name

         -- Convert 'host_since' column to DATE format if it matches the expected pattern (DD/MM/YYYY), otherwise set to NULL.
    
    CASE
        WHEN host_since ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(host_since, 'DD/MM/YYYY') --format host_since column to DATE
        ELSE NULL
    END AS host_since_date, 
    
    host_is_superhost, -- Extract superhost status

    -- Convert 'HOST_NEIGHBOURHOOD' to uppercase and set to NULL if it's 'NAN' ( for case-insensitive matching with LGA).

    CASE 
        WHEN UPPER(HOST_NEIGHBOURHOOD) = 'NAN' THEN NULL
        ELSE UPPER(HOST_NEIGHBOURHOOD) --MAKE IT UPPER CASE TO MATCH LGA
    END as HOST_NEIGHBOURHOOD,
    dbt_valid_to,  -- Extract 'dbt_valid_to'
    dbt_valid_from as last_updated_at -- Extract 'dbt_valid_from' as 'last_updated_at'


    from source
    where dbt_valid_to IS NULL -- Filter for current records
)

    -- Finally, select and return the cleaned host data for the dimension table.

select
    HOST_ID,
    scraped_date, 
    HOST_NAME,
    host_since_date,
    host_is_superhost,
    HOST_NEIGHBOURHOOD,
    last_updated_at

 from cleaned_host
  );