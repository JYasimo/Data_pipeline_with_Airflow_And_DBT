
      
  
    

  create  table "postgres"."raw"."room_snapshot"
  
  
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
        

 



 

select  SCRAPED_DATE,HAS_AVAILABILITY,LISTING_ID,ROOM_TYPE

from "postgres"."raw"."listing"

 

    ) sbq



  );
  
  