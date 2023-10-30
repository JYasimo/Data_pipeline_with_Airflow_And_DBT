-- stg_G01.sql

-- This SQL script is identified as 'stg_G01.sql' and it performs data transformations on census data for LGA (Local Government Area) in New South Wales, Australia.

-- Begin configuration section with the 'config' block, setting the unique key to 'LGA_CODE_2016' and this SQL script defines a materialized view.
{{
    config(
        unique_key='LGA_CODE_2016',
        materialized='view'
    )
}}

-- Define a Common Table Expression (CTE) named "source" to retrieve data from the 'census_g01_nsw_lga_2016' source.

with source as (
    select * from {{ source('raw','census_g01_nsw_lga_2016') }}
),

-- Create another CTE named "renamed" to perform data transformations and aliasing of columns.

renamed as (
    select
              cast(substring(LGA_CODE_2016, 4) as int) as LGA_CODE,-- removing 'LGA' in this columns and turn them to int only 

              -- Rename and alias various demographic data columns.
              Tot_P_M AS Total_Population_Male,
              Tot_P_F AS Total_Population_Female,
              Tot_P_P AS Total_Population,
              Age_0_4_yr_M AS Age_0_4_Male,
              Age_0_4_yr_F AS Age_0_4_Female,
              Age_0_4_yr_P AS Age_0_4_Population,
              Age_5_14_yr_M AS Age_5_14_Male,
              Age_5_14_yr_F AS Age_5_14_Female,
              Age_5_14_yr_P AS Age_5_14_Population,
              Age_15_19_yr_M AS Age_15_19_Male,
              Age_15_19_yr_F AS Age_15_19_Female,
              Age_15_19_yr_P AS Age_15_19_Population,
              Age_20_24_yr_M AS Age_20_24_Male,
              Age_20_24_yr_F AS Age_20_24_Female,
              Age_20_24_yr_P AS Age_20_24_Population,
              Age_25_34_yr_M AS Age_25_34_Male,
              Age_25_34_yr_F AS Age_25_34_Female,
              Age_25_34_yr_P AS Age_25_34_Population,
              Age_35_44_yr_M AS Age_35_44_Male,
              Age_35_44_yr_F AS Age_35_44_Female,
              Age_35_44_yr_P AS Age_35_44_Population,
              Age_45_54_yr_M AS Age_45_54_Male,
              Age_45_54_yr_F AS Age_45_54_Female,
              Age_45_54_yr_P AS Age_45_54_Population,
              Age_55_64_yr_M AS Age_55_64_Male,
              Age_55_64_yr_F AS Age_55_64_Female,
              Age_55_64_yr_P AS Age_55_64_Population,
              Age_65_74_yr_M AS Age_65_74_Male,
              Age_65_74_yr_F AS Age_65_74_Female,
              Age_65_74_yr_P AS Age_65_74_Population,
              Age_75_84_yr_M AS Age_75_84_Male,
              Age_75_84_yr_F AS Age_75_84_Female,
              Age_75_84_yr_P AS Age_75_84_Population,
              Age_85ov_M AS Age_85_and_Over_Male,
              Age_85ov_F AS Age_85_and_Over_Female,
              Age_85ov_P AS Age_85_and_Over_Population,
              Australian_citizen_M AS Male_Australian_Citizens,
              Australian_citizen_F AS Female_Australian_Citizens,
              Australian_citizen_P AS Total_Australian_Population,
              Birthplace_Australia_M AS Male_Birthplace_Australia,
              Birthplace_Australia_F AS Female_Birthplace_Australia,
              Birthplace_Australia_P AS Total_Birthplace_Australia_Population,
              Birthplace_Elsewhere_M AS Male_Birthplace_Elsewhere,
              Birthplace_Elsewhere_F AS Female_Birthplace_Elsewhere,
              Birthplace_Elsewhere_P AS Total_Birthplace_Elsewhere_Population
              
              from source
)

-- Select and return the transformed data from the "renamed" CTE.

select * from renamed
