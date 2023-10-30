
  
    

  create  table "postgres"."warehouse"."dim_LGA__dbt_tmp"
  
  
    as
  
  (
    --dim_LGA.sql


select * from "postgres"."staging"."stg_LGA"
  );
  