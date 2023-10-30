
  create view "postgres"."warehouse"."dim_G01__dbt_tmp"
    
    
  as (
    --dim_G01.sql


select * from "postgres"."staging"."stg_G01"
  );