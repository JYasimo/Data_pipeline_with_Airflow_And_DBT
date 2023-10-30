
      
  
    

  create  table "postgres"."raw"."property_snapshot"
  
  
    as
  
  (
    

    select *,
        md5(coalesce(cast(LISTING_ID as varchar ), '')
         || '|' || coalesce(cast(SCRAPED_DATE as varchar ), '')
        ) as dbt_scd_id,
        SCRAPED_DATE as dbt_updated_at,
        SCRAPED_DATE as dbt_valid_from,
        nullif(SCRAPED_DATE, SCRAPED_DATE) as dbt_valid_to
    from (
        

 



 

select  SCRAPED_DATE,LISTING_ID,PROPERTY_TYPE,LISTING_NEIGHBOURHOOD

from "postgres"."raw"."listing"

 

    ) sbq



  );
  
  