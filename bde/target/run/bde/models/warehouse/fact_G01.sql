
  
    

  create  table "postgres"."warehouse"."fact_G01__dbt_tmp"
  
  
    as
  
  (
    --dim_G01.sql


SELECT
    g1.*,
    lga.Local_Government_Area
FROM "postgres"."staging"."stg_G01" g1
JOIN "postgres"."staging"."stg_LGA" lga ON g1.LGA_CODE = lga.Local_Government_Area_Code
  );
  