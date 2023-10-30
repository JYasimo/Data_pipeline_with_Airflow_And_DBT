
  
    

  create  table "postgres"."warehouse"."dim_suburb__dbt_tmp"
  
  
    as
  
  (
    --dim_room.sql


select * from "postgres"."staging"."stg_suburb"
  );
  