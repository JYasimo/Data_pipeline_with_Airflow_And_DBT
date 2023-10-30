
  
    

  create  table "postgres"."warehouse"."fact_G02__dbt_tmp"
  
  
    as
  
  (
    --dim_G02.sql


SELECT
    g2.*,
    lga.Local_Government_Area
FROM "postgres"."staging"."stg_G02" g2
JOIN "postgres"."staging"."stg_LGA" lga ON g2.LGA_CODE = lga.Local_Government_Area_Code
  );
  