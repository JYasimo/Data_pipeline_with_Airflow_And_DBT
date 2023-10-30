--dim_suburb.sql
{{
    config(
        materialized = 'table',
        unique_key='Local_Government_Area_SUBURB'
    )
}}

select * from {{ ref('stg_suburb') }}