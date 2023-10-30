
  create view "postgres"."staging"."stg_G02__dbt_tmp"
    
    
  as (
    -- stg_G02.sql

-- This SQL script is identified as 'stg_G02.sql' and it to performs data transformations on census data for LGA (Local Government Area) in New South Wales, Australia.

-- Begin configuration section with the 'config' block, setting the unique key to 'LGA_CODE_2016' and 
--  this SQL script defines a materialized view.



-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'census_g02_nsw_lga_2016' source.

with source as (
    select * from "postgres"."raw"."census_g02_nsw_lga_2016"
),

-- Create another CTE named "renamed" to perform data transformations and aliasing of columns.

renamed as (
    select
              cast(substring(LGA_CODE_2016, 4) as int) as LGA_CODE,-- removing 'LGA' in this columns and turn them to int only 

               -- Rename and alias various demographic data columns.

                  Median_age_persons AS Median_Age,
                  Median_mortgage_repay_monthly AS Median_Mortgage_Repayment_Monthly,
                  Median_tot_prsnl_inc_weekly AS Median_Total_Personal_Income_Weekly,
                  Median_rent_weekly AS Median_Rent_Weekly,
                  Median_tot_fam_inc_weekly AS Median_Total_Family_Income_Weekly,
                  Average_num_psns_per_bedroom AS Average_Persons_Per_Bedroom,
                  Median_tot_hhd_inc_weekly AS Median_Total_Household_Income_Weekly,
                  Average_household_size AS Average_Household_Size
                  from source
)

-- Select and return the transformed data from the "renamed" CTE.

select * from renamed
  );