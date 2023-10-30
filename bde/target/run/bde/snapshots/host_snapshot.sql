
      
  
    

  create  table "postgres"."raw"."host_snapshot"
  
  
    as
  
  (
    

    select *,
        md5(coalesce(cast(HOST_ID as varchar ), '')
         || '|' || coalesce(cast(SCRAPED_DATE as varchar ), '')
        ) as dbt_scd_id,
        SCRAPED_DATE as dbt_updated_at,
        SCRAPED_DATE as dbt_valid_from,
        nullif(SCRAPED_DATE, SCRAPED_DATE) as dbt_valid_to
    from (
        

 



 

select

  HOST_ID,

  SCRAPED_DATE,

  HOST_NAME,

  HOST_SINCE,

  HOST_IS_SUPERHOST,

  HOST_NEIGHBOURHOOD

from "postgres"."raw"."listing"

 

    ) sbq



  );
  
  