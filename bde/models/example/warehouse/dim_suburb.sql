--dim_room.sql
{{
    config(
        materialized = 'table',
        unique_key='LISTING_NAME'
    )
}}

select * from {{ ref('stg_suburb') }}