-- stg_suburb.sql

-- This SQL script 'stg_suburb.sql' is to focus on transforming data related to suburbs within local government areas (LGAs) in New South Wales.

-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'nsw_lga_suburb' raw source.


with source as (

    select * from {{ source('raw','nsw_lga_suburb') }}

),

-- Create another CTE named "renamed" to rename and transform columns for clarity.

renamed as (

    -- Rename the 'LGA_NAME' column as 'Local_Government_Area' for clearer understanding.
    -- Rename the 'SUBURB_NAME' column as 'Local_Government_Area_SUBURB' for consistency and clarity.

    select

    LGA_NAME as Local_Government_Area , --renaming column

    SUBURB_NAME as Local_Government_Area_SUBURB --renaming column

    from source

)
-- Select and return the transformed data from the "renamed" CTE.

select * from renamed 