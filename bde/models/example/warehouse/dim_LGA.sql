--dim_LGA.sql
{{
    config(
        materialized = 'table',
        unique_key='LGA_CODE'
    )
}}

select * from {{ ref('stg_LGA') }}