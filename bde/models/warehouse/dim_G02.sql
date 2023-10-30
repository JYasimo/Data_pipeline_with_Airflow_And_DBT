--dim_G02.sql
{{
    config(
        materialized = 'table',
        unique_key='LGA_CODE'
    )
}}

SELECT
    g2.*,
    lga.Local_Government_Area
FROM {{ ref('stg_G02') }} g2
JOIN {{ ref('stg_LGA') }} lga ON g2.LGA_CODE = lga.Local_Government_Area_Code