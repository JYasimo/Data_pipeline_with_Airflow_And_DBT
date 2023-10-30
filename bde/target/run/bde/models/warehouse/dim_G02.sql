
  create view "postgres"."warehouse"."dim_G02__dbt_tmp"
    
    
  as (
    --dim_G02.sql


select * from "postgres"."staging"."stg_G02"
  );