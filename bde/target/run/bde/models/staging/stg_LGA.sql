
  create view "postgres"."staging"."stg_LGA__dbt_tmp"
    
    
  as (
    -- stg_LGA.sql

-- Configuration section: Set the unique key to 'LGA_CODE' for this data and this SQL script defines a materialized view.



-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'nsw_lga_code' raw source.

with source as (
    select * from "postgres"."raw"."nsw_lga_code"
),

-- Create another CTE named "renamed" to rename and transform columns for clarity.


renamed as (
    select
        -- Rename the 'LGA_CODE' column as 'Local_Government_Area_Code'.
        LGA_CODE as Local_Government_Area_Code,
        -- Convert 'LGA_NAME' to uppercase for consistency,  to match it with other data.
        UPPER(LGA_NAME) as Local_Government_Area
    from source
)

-- Select and return the transformed data from the "renamed" CTE.

select * from renamed
  );