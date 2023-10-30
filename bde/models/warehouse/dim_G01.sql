--dim_G01.sql
{{
    config(
        materialized = 'table',
        unique_key='LGA_CODE_2016'
    )
}}

SELECT
    g1.*,
    lga.Local_Government_Area
FROM {{ ref('stg_G01') }} g1
JOIN {{ ref('stg_LGA') }} lga ON g1.LGA_CODE = lga.Local_Government_Area_Code