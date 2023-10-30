
  create view "postgres"."staging"."stg_suburb__dbt_tmp"
    
    
  as (
    -- stg_suburb.sql

with

source as (

    select * from "postgres"."raw"."nsw_lga_suburb"

),

renamed as (

    select
    -- str
    LGA_NAME as Local_Government_Area , --renaming column

    --str
    SUBURB_NAME as Local_Government_Area_SUBURB --renaming column

    from source

)

select * from renamed
  );